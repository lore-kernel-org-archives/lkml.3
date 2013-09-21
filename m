Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3IUSlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 14:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3IUSlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 14:41:03 -0400
Date: Sat, 21 Sep 2013 20:34:36 +0200
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
Message-ID: <20130921183436.GA13418@redhat.com>
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com> <5238BDEC.1070400@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5238BDEC.1070400@hurleysoftware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, sorry for delay, I was sick.

On 09/17, Peter Hurley wrote:
>
> On 09/15/2013 11:50 AM, Oleg Nesterov wrote:
>
>> Put the "!on_exit" check back to restore the old behaviour.
>>
>> Cc: stable@vger.kernel.org # v3.10+
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>> Reported-by: Karel Srot <ksrot@redhat.com>
>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

Thanks!

Can I ask the question? tty_signal_session_leader() is probably fine,
but it _looks_ buggy or at least confusing to me.

		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
			spin_lock_irq(&p->sighand->siglock);
			if (p->signal->tty == tty) {
				p->signal->tty = NULL;
				/* We defer the dereferences outside fo
				   the tasklist lock */
				refs++;
			}
			if (!p->signal->leader) {
				spin_unlock_irq(&p->sighand->siglock);
				continue;
			}
			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
			put_pid(p->signal->tty_old_pgrp);  /* A noop */
			spin_lock(&tty->ctrl_lock);
			tty_pgrp = get_pid(tty->pgrp);

I guess this can happen only once, so we could even add WARN_ON(tty_pgrp)
before get_pid(). But this look confusing, as if we can do get_pid()
multiple times and leak tty->pgrp.

			if (tty->pgrp)
				p->signal->tty_old_pgrp = get_pid(tty->pgrp);

else? We already did put_pid(tty_old_pgrp), we should clear it.

IOW, do you think the patch below makes sense or I missed something?
Just curious.

Oleg.

--- x/drivers/tty/tty_io.c
+++ x/drivers/tty/tty_io.c
@@ -548,7 +548,7 @@ static int tty_signal_session_leader(str
 {
 	struct task_struct *p;
 	int refs = 0;
-	struct pid *tty_pgrp = NULL;
+	struct pid *tty_pgrp = tty_get_pgrp(tty);
 
 	read_lock(&tasklist_lock);
 	if (tty->session) {
@@ -560,18 +560,12 @@ static int tty_signal_session_leader(str
 				   the tasklist lock */
 				refs++;
 			}
-			if (!p->signal->leader) {
-				spin_unlock_irq(&p->sighand->siglock);
-				continue;
+			if (p->signal->leader) {
+				__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
+				__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
+				put_pid(p->signal->tty_old_pgrp);  /* A noop */
+				p->signal->tty_old_pgrp = get_pid(tty_pgrp);
 			}
-			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
-			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
-			put_pid(p->signal->tty_old_pgrp);  /* A noop */
-			spin_lock(&tty->ctrl_lock);
-			tty_pgrp = get_pid(tty->pgrp);
-			if (tty->pgrp)
-				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
-			spin_unlock(&tty->ctrl_lock);
 			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
 	}

