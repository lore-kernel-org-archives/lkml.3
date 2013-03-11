Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3CKVPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:15:50 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33593 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3CKVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 29/44] tty: Add lock/unlock ldisc pair functions
Date: Mon, 11 Mar 2013 16:44:49 -0400
Message-Id: <1363034704-28036-30-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as the tty pair must be locked in a stable sequence
(ie, independent of which is consider the 'other' tty), so must
the ldisc pair be locked in a stable sequence as well.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 1afe192..ae0287f 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -31,6 +31,13 @@
 #define tty_ldisc_debug(tty, f, args...)
 #endif
 
+/* lockdep nested classes for tty->ldisc_sem */
+enum {
+	LDISC_SEM_NORMAL,
+	LDISC_SEM_OTHER,
+};
+
+
 /*
  *	This guards the refcounted line discipline lists. The lock
  *	must be taken with irqs off because there are hangup path
@@ -351,6 +358,86 @@ void tty_ldisc_deref(struct tty_ldisc *ld)
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_deref);
 
+
+static inline int __lockfunc
+tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
+{
+	return ldsem_down_write(&tty->ldisc_sem, timeout);
+}
+
+static inline int __lockfunc
+tty_ldisc_lock_nested(struct tty_struct *tty, unsigned long timeout)
+{
+	return ldsem_down_write_nested(&tty->ldisc_sem,
+				       LDISC_SEM_OTHER, timeout);
+}
+
+static inline void tty_ldisc_unlock(struct tty_struct *tty)
+{
+	return ldsem_up_write(&tty->ldisc_sem);
+}
+
+static int __lockfunc
+tty_ldisc_lock_pair_timeout(struct tty_struct *tty, struct tty_struct *tty2,
+			    unsigned long timeout)
+{
+	int ret;
+
+	if (tty < tty2) {
+		ret = tty_ldisc_lock(tty, timeout);
+		if (ret) {
+			ret = tty_ldisc_lock_nested(tty2, timeout);
+			if (!ret)
+				tty_ldisc_unlock(tty);
+		}
+	} else {
+		/* if this is possible, it has lots of implications */
+		WARN_ON_ONCE(tty == tty2);
+		if (tty2 && tty != tty2) {
+			ret = tty_ldisc_lock(tty2, timeout);
+			if (ret) {
+				ret = tty_ldisc_lock_nested(tty, timeout);
+				if (!ret)
+					tty_ldisc_unlock(tty2);
+			}
+		} else
+			ret = tty_ldisc_lock(tty, timeout);
+	}
+
+	if (!ret)
+		return -EBUSY;
+
+	set_bit(TTY_LDISC_HALTED, &tty->flags);
+	if (tty2)
+		set_bit(TTY_LDISC_HALTED, &tty2->flags);
+	return 0;
+}
+
+static void __lockfunc
+tty_ldisc_lock_pair(struct tty_struct *tty, struct tty_struct *tty2)
+{
+	tty_ldisc_lock_pair_timeout(tty, tty2, MAX_SCHEDULE_TIMEOUT);
+}
+
+static void __lockfunc tty_ldisc_unlock_pair(struct tty_struct *tty,
+					     struct tty_struct *tty2)
+{
+	tty_ldisc_unlock(tty);
+	if (tty2)
+		tty_ldisc_unlock(tty2);
+}
+
+static void __lockfunc tty_ldisc_enable_pair(struct tty_struct *tty,
+					     struct tty_struct *tty2)
+{
+	clear_bit(TTY_LDISC_HALTED, &tty->flags);
+	if (tty2)
+		clear_bit(TTY_LDISC_HALTED, &tty2->flags);
+
+	tty_ldisc_unlock_pair(tty, tty2);
+}
+
+
 /**
  *	tty_ldisc_enable	-	allow ldisc use
  *	@tty: terminal to activate ldisc on
-- 
1.8.1.2

