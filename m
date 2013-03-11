Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3CKV2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:28:53 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33376 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3CKVPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:18 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 21/44] tty: Document unsafe ldisc reference acquire
Date: Mon, 11 Mar 2013 16:44:41 -0400
Message-Id: <1363034704-28036-22-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge get_ldisc() into its only call site.
Note how, after merging, the unsafe acquire of an ldisc reference
is obvious.

   CPU 0 in tty_ldisc_try()         |  CPU 1 in tty_ldisc_halt()
                                    |
test_bit(TTY_LDISC, &tty_flags)     |
if (true)                           |  clear_bit(TTY_LDISC, &tty_flags)
  tty->ldisc != 0?                  |  atomic_read(&tty->ldisc->users)
  if (true)                         |  ret_val == 1?
    atomic_inc(&tty->ldisc->users)  |  if (false)
                                    |    wait
                                    |
<goes on assuming safe ldisc use>   |  <doesn't wait - proceeds w/ close>
                                    |

The spin lock in tty_ldisc_try() does nothing wrt synchronizing
the ldisc halt since it's not acquired as part of halting.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9362a10..5ee0b2b 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -42,13 +42,6 @@ static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
-static inline struct tty_ldisc *get_ldisc(struct tty_ldisc *ld)
-{
-	if (ld)
-		atomic_inc(&ld->users);
-	return ld;
-}
-
 /**
  *	tty_register_ldisc	-	install a line discipline
  *	@disc: ldisc number
@@ -269,10 +262,13 @@ static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
 	unsigned long flags;
 	struct tty_ldisc *ld;
 
+	/* FIXME: this allows reference acquire after TTY_LDISC is cleared */
 	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
 	ld = NULL;
-	if (test_bit(TTY_LDISC, &tty->flags))
-		ld = get_ldisc(tty->ldisc);
+	if (test_bit(TTY_LDISC, &tty->flags) && tty->ldisc) {
+		ld = tty->ldisc;
+		atomic_inc(&ld->users);
+	}
 	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 	return ld;
 }
-- 
1.8.1.2

