Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3IUUZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 16:25:16 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43864 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751742Ab3IUUZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 16:25:13 -0400
Message-ID: <523E00A3.5050507@hurleysoftware.com>
Date: Sat, 21 Sep 2013 16:25:07 -0400
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
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com> <5238BDEC.1070400@hurleysoftware.com> <20130921183436.GA13418@redhat.com>
In-Reply-To: <20130921183436.GA13418@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 02:34 PM, Oleg Nesterov wrote:
> Peter, sorry for delay, I was sick.
>
> On 09/17, Peter Hurley wrote:
>>
>> On 09/15/2013 11:50 AM, Oleg Nesterov wrote:
>>
>>> Put the "!on_exit" check back to restore the old behaviour.
>>>
>>> Cc: stable@vger.kernel.org # v3.10+
>>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>>> Reported-by: Karel Srot <ksrot@redhat.com>
>>
>> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
>
> Thanks!
>
> Can I ask the question? tty_signal_session_leader() is probably fine,
> but it _looks_ buggy or at least confusing to me.
>
> 		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
> 			spin_lock_irq(&p->sighand->siglock);
> 			if (p->signal->tty == tty) {
> 				p->signal->tty = NULL;
> 				/* We defer the dereferences outside fo
> 				   the tasklist lock */
> 				refs++;
> 			}
> 			if (!p->signal->leader) {
> 				spin_unlock_irq(&p->sighand->siglock);
> 				continue;
> 			}
> 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
> 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
> 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
> 			spin_lock(&tty->ctrl_lock);
> 			tty_pgrp = get_pid(tty->pgrp);
>
> I guess this can happen only once, so we could even add WARN_ON(tty_pgrp)
> before get_pid(). But this look confusing, as if we can do get_pid()
> multiple times and leak tty->pgrp.
>
> 			if (tty->pgrp)
> 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
>
> else? We already did put_pid(tty_old_pgrp), we should clear it.
>
> IOW, do you think the patch below makes sense or I missed something?
> Just curious.

The code block you're referring to only executes once because there is
only one session leader.

Regards,
Peter Hurley

