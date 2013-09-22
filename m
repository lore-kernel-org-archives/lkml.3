Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3IVUKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:10:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3IVUKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:10:20 -0400
Date: Sun, 22 Sep 2013 22:03:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: disassociate_ctty() sends the extra SIGCONT
Message-ID: <20130922200354.GA4865@redhat.com>
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com> <5238BDEC.1070400@hurleysoftware.com> <20130921183436.GA13418@redhat.com> <523E00A3.5050507@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523E00A3.5050507@hurleysoftware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21, Peter Hurley wrote:
>
> On 09/21/2013 02:34 PM, Oleg Nesterov wrote:
>>
>> 		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
>> 			spin_lock_irq(&p->sighand->siglock);
>> 			if (p->signal->tty == tty) {
>> 				p->signal->tty = NULL;
>> 				/* We defer the dereferences outside fo
>> 				   the tasklist lock */
>> 				refs++;
>> 			}
>> 			if (!p->signal->leader) {
>> 				spin_unlock_irq(&p->sighand->siglock);
>> 				continue;
>> 			}
>> 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
>> 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
>> 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
>> 			spin_lock(&tty->ctrl_lock);
>> 			tty_pgrp = get_pid(tty->pgrp);
>>
>> I guess this can happen only once, so we could even add WARN_ON(tty_pgrp)
>> before get_pid(). But this look confusing, as if we can do get_pid()
>> multiple times and leak tty->pgrp.
>>
>> 			if (tty->pgrp)
>> 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
>>
>> else? We already did put_pid(tty_old_pgrp), we should clear it.
>>
>> IOW, do you think the patch below makes sense or I missed something?
>> Just curious.
>
> The code block you're referring to only executes once because there is
> only one session leader.

I understand, and I even mentioned this above.

My point was, this _looks_ confusing, and the patch I sent makes it
more clean.

And what about ->tty_old_pgrp? I still think that at least the patch
below makes sense. If tty->pgrp == NULL is not possible here (I do
not know), then why do we check? Otherwise ->tty_old_pgrp != NULL looks
certainly wrong after put_pid().

Oleg.

--- x/drivers/tty/tty_io.c
+++ x/drivers/tty/tty_io.c
@@ -569,8 +569,7 @@ static int tty_signal_session_leader(str
 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
 			spin_lock(&tty->ctrl_lock);
 			tty_pgrp = get_pid(tty->pgrp);
-			if (tty->pgrp)
-				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
+			p->signal->tty_old_pgrp = get_pid(tty->pgrp);
 			spin_unlock(&tty->ctrl_lock);
 			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_pid_task(tty->session, PIDTYPE_SID, p);

