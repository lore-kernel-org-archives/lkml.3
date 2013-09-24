Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3IXSSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:18:23 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34160 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877Ab3IXSSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:18:22 -0400
Message-ID: <5241D767.6020809@hurleysoftware.com>
Date: Tue, 24 Sep 2013 14:18:15 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: disassociate_ctty() sends the extra SIGCONT
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com> <5238BDEC.1070400@hurleysoftware.com> <20130921183436.GA13418@redhat.com> <523E00A3.5050507@hurleysoftware.com> <20130922200354.GA4865@redhat.com>
In-Reply-To: <20130922200354.GA4865@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 04:03 PM, Oleg Nesterov wrote:
> On 09/21, Peter Hurley wrote:
>>
>> On 09/21/2013 02:34 PM, Oleg Nesterov wrote:
>>>
>>> 		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
>>> 			spin_lock_irq(&p->sighand->siglock);
>>> 			if (p->signal->tty == tty) {
>>> 				p->signal->tty = NULL;
>>> 				/* We defer the dereferences outside fo
>>> 				   the tasklist lock */
>>> 				refs++;
>>> 			}
>>> 			if (!p->signal->leader) {
>>> 				spin_unlock_irq(&p->sighand->siglock);
>>> 				continue;
>>> 			}
>>> 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
>>> 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
>>> 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
>>> 			spin_lock(&tty->ctrl_lock);
>>> 			tty_pgrp = get_pid(tty->pgrp);
>>>
>>> I guess this can happen only once, so we could even add WARN_ON(tty_pgrp)
>>> before get_pid(). But this look confusing, as if we can do get_pid()
>>> multiple times and leak tty->pgrp.
>>>
>>> 			if (tty->pgrp)
>>> 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
>>>
>>> else? We already did put_pid(tty_old_pgrp), we should clear it.
>>>
>>> IOW, do you think the patch below makes sense or I missed something?
>>> Just curious.
>>
>> The code block you're referring to only executes once because there is
>> only one session leader.
>
> I understand, and I even mentioned this above.

Ah, ok. I didn't realize the earlier patch was a cleanup attempt and
not fixing something.

> My point was, this _looks_ confusing, and the patch I sent makes it
> more clean.

I agree that this looks confusing, but I'm not sure I agree that your earlier
patch makes it cleaner; maybe a code comment stating that the block only
executes once for the session leader would be more appropriate.

Also, I put the get_pid() in the siglock critical section to prevent
unsafe racing between hangup and ioctl(TIOCSCTTY).

> And what about ->tty_old_pgrp? I still think that at least the patch
> below makes sense. If tty->pgrp == NULL is not possible here (I do
> not know), then why do we check?

tty->pgrp can be NULL here if the session leader is dropping the
controlling terminal association via no_tty(). But in this
case ->tty_old_pgrp will also be NULL.

This race should probably be eliminated by claiming the tty_lock()
in no_tty(), so that it doesn't race with __tty_hangup() at all.

[NB: The other possibility, a second hangup, is no longer possible.]

> Otherwise ->tty_old_pgrp != NULL looks  certainly wrong after put_pid().

I agree this looks fairly suspect; so does

    			put_pid(p->signal->tty_old_pgrp);  /* A noop */

not because of the comment, but because tty_old_pgrp cannot be non-NULL
here:
1. The session leader's tty_old_pgrp is only assigned non-NULL if its
    controlling terminal is hung up.
2. The tty cannot be hung up more than once.
3. If the session leader changes the controlling tty via ioctl(TIOCSCTTY),
    __proc_set_tty() will put_pid(tty_old_pgrp) and reset it to NULL.
    [so tty_old_pgrp is NULL on a subsequent hangup of the new controlling tty].
4. If the session leader drops the controlling terminal association
    via ioctl(TIOCNOTTY), disassociate_tty() will put_pid(tty_old_pgrp)
    and reset it to NULL. [Assuming the race mentioned above is fixed,
    then there is no controlling tty to hangup.]

What about replacing
    			put_pid(p->signal->tty_old_pgrp);  /* A noop */
with
			WARN_ON(p->signal->tty_old_pgrp);
?

And fixing the FIXME in no_tty()?

Regards,
Peter Hurley

> --- x/drivers/tty/tty_io.c
> +++ x/drivers/tty/tty_io.c
> @@ -569,8 +569,7 @@ static int tty_signal_session_leader(str
>   			put_pid(p->signal->tty_old_pgrp);  /* A noop */
>   			spin_lock(&tty->ctrl_lock);
>   			tty_pgrp = get_pid(tty->pgrp);
> -			if (tty->pgrp)
> -				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
> +			p->signal->tty_old_pgrp = get_pid(tty->pgrp);
>   			spin_unlock(&tty->ctrl_lock);
>   			spin_unlock_irq(&p->sighand->siglock);
>   		} while_each_pid_task(tty->session, PIDTYPE_SID, p);


