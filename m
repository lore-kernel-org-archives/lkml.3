Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbaEEN6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:58:55 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:61812 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaEEN5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:57:40 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] clk: bcm281xx: add an initialized flag
Date: Mon,  5 May 2014 08:57:32 -0500
Message-Id: <1399298256-10965-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399298256-10965-1-git-send-email-elder@linaro.org>
References: <1399298256-10965-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag that tracks whether a clock has already been initialized.
This will be used by the next patch to avoid initializing a clock
more than once when it's listed as a prerequisite.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-kona.c | 17 +++++++++++++++--
 drivers/clk/bcm/clk-kona.h |  7 +++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index d603c4e..d8a7f38 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -27,6 +27,9 @@
 #define CCU_ACCESS_PASSWORD      0xA5A500
 #define CLK_GATE_DELAY_LOOP      2000
 
+#define clk_is_initialized(_clk)	FLAG_TEST((_clk), KONA, INITIALIZED)
+#define clk_set_initialized(_clk)	FLAG_SET((_clk), KONA, INITIALIZED)
+
 /* Bitfield operations */
 
 /* Produces a mask of set bits covering a range of a 32-bit value */
@@ -1194,13 +1197,23 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
 
 static bool __kona_clk_init(struct kona_clk *bcm_clk)
 {
+	bool ret;
+
+	if (clk_is_initialized(bcm_clk))
+		return true;
+
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
-		return __peri_clk_init(bcm_clk);
+		ret = __peri_clk_init(bcm_clk);
+		break;
 	default:
+		ret = false;
 		BUG();
 	}
-	return -EINVAL;
+	if (ret)
+		clk_set_initialized(bcm_clk);
+
+	return ret;
 }
 
 /* Set a CCU and all its clocks into their desired initial state */
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 2537b30..10e238d 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -406,6 +406,7 @@ struct kona_clk {
 	struct clk_init_data init_data;	/* includes name of this clock */
 	struct ccu_data *ccu;	/* ccu this clock is associated with */
 	enum bcm_clk_type type;
+	u32 flags;		/* BCM_CLK_KONA_FLAGS_* below */
 	union {
 		void *data;
 		struct peri_clk_data *peri;
@@ -414,6 +415,12 @@ struct kona_clk {
 #define to_kona_clk(_hw) \
 	container_of(_hw, struct kona_clk, hw)
 
+/*
+ * Kona clock flags:
+ *   INITIALIZED	clock has been initialized already
+ */
+#define BCM_CLK_KONA_FLAGS_INITIALIZED	((u32)1 << 0)	/* Clock initialized */
+
 /* Initialization macro for an entry in a CCU's kona_clks[] array. */
 #define KONA_CLK(_ccu_name, _clk_name, _type)				\
 	{								\
-- 
1.9.1

