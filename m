Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbaE3UxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:53:15 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51920 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaE3UxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:53:13 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] clk: kona: allow nested ccu_write_enable() requests
Date: Fri, 30 May 2014 15:53:02 -0500
Message-Id: <1401483188-5395-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401483188-5395-1-git-send-email-elder@linaro.org>
References: <1401483188-5395-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a counter rather than a Boolean to track whether write access to
a CCU has been enabled or not.  This will allow more than one of
these requests to be nested.

Note that __ccu_write_enable() and __ccu_write_disable() calls all
come in pairs, and they are always surrounded immediately by calls
to ccu_lock() and ccu_unlock().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c | 14 ++++----------
 drivers/clk/bcm/clk-kona.h |  2 +-
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 95af2e6..ee8e988 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -170,13 +170,8 @@ static inline void ccu_unlock(struct ccu_data *ccu, unsigned long flags)
  */
 static inline void __ccu_write_enable(struct ccu_data *ccu)
 {
-	if (ccu->write_enabled) {
-		pr_err("%s: access already enabled for %s\n", __func__,
-			ccu->name);
-		return;
-	}
-	ccu->write_enabled = true;
-	__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
+	if (!ccu->write_enabled++)
+		__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD | 1);
 }
 
 static inline void __ccu_write_disable(struct ccu_data *ccu)
@@ -186,9 +181,8 @@ static inline void __ccu_write_disable(struct ccu_data *ccu)
 			ccu->name);
 		return;
 	}
-
-	__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
-	ccu->write_enabled = false;
+	if (!--ccu->write_enabled)
+		__ccu_write(ccu, 0, CCU_ACCESS_PASSWORD);
 }
 
 /*
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 2537b30..e9a8466 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -478,7 +478,7 @@ struct ccu_policy {
 struct ccu_data {
 	void __iomem *base;	/* base of mapped address space */
 	spinlock_t lock;	/* serialization lock */
-	bool write_enabled;	/* write access is currently enabled */
+	u32 write_enabled;	/* write access enable count */
 	struct ccu_policy policy;
 	struct list_head links;	/* for ccu_list */
 	struct device_node *node;
-- 
1.9.1

