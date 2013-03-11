Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3CKV2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:28:34 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33387 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3CKVPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:19 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 23/44] tty: Locate get/put ldisc functions together
Date: Mon, 11 Mar 2013 16:44:43 -0400
Message-Id: <1363034704-28036-24-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index f26ef1a..4e46c17 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -179,6 +179,29 @@ static struct tty_ldisc *tty_ldisc_get(int disc)
 	return ld;
 }
 
+/**
+ *	tty_ldisc_put		-	release the ldisc
+ *
+ *	Complement of tty_ldisc_get().
+ */
+static inline void tty_ldisc_put(struct tty_ldisc *ld)
+{
+	unsigned long flags;
+
+	if (WARN_ON_ONCE(!ld))
+		return;
+
+	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+
+	/* unreleased reader reference(s) will cause this WARN */
+	WARN_ON(!atomic_dec_and_test(&ld->users));
+
+	ld->ops->refcount--;
+	module_put(ld->ops->owner);
+	kfree(ld);
+	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+}
+
 static void *tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
 {
 	return (*pos < NR_LDISCS) ? pos : NULL;
@@ -329,29 +352,6 @@ void tty_ldisc_deref(struct tty_ldisc *ld)
 EXPORT_SYMBOL_GPL(tty_ldisc_deref);
 
 /**
- *	tty_ldisc_put		-	release the ldisc
- *
- *	Complement of tty_ldisc_get().
- */
-static inline void tty_ldisc_put(struct tty_ldisc *ld)
-{
-	unsigned long flags;
-
-	if (WARN_ON_ONCE(!ld))
-		return;
-
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
-
-	/* unreleased reader reference(s) will cause this WARN */
-	WARN_ON(!atomic_dec_and_test(&ld->users));
-
-	ld->ops->refcount--;
-	module_put(ld->ops->owner);
-	kfree(ld);
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-}
-
-/**
  *	tty_ldisc_enable	-	allow ldisc use
  *	@tty: terminal to activate ldisc on
  *
-- 
1.8.1.2

