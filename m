Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab3DPKQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:16:32 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:50195 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3DPKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:16:26 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/7] tty: Add lock/unlock ldisc pair functions
Date: Tue, 16 Apr 2013 06:15:51 -0400
Message-Id: <1366107356-7699-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366107356-7699-1-git-send-email-peter@hurleysoftware.com>
References: <20130415201411.GA27360@kroah.com>
 <1366107356-7699-1-git-send-email-peter@hurleysoftware.com>
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

