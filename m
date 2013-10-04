Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3JDKJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:09:03 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35704 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3JDKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:09:02 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: provide public clk_is_enabled function
Date: Fri,  4 Oct 2013 12:08:30 +0200
Message-Id: <1380881310-24345-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To determine if a clk has been previously enabled, provide a public
clk_is_enabled function. This is especially helpful to check the state
of clk-gate without actually changing the state of the gate.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk.c   |   18 ++++++++++++++++++
 include/linux/clk.h |   13 +++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a004769..26698d3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -929,6 +929,24 @@ int clk_enable(struct clk *clk)
 EXPORT_SYMBOL_GPL(clk_enable);
 
 /**
+ * clk_is_enabled - return the enabled state of a clk
+ * @clk: the clk whose enabled state gets returned
+ *
+ * Returns true if the clock is enabled, false otherwise.
+ */
+bool clk_is_enabled(struct clk *clk)
+{
+	bool is_en;
+
+	clk_prepare_lock();
+	is_en = __clk_is_enabled(clk);
+	clk_prepare_unlock();
+
+	return is_en;
+}
+EXPORT_SYMBOL_GPL(clk_is_enabled);
+
+/**
  * __clk_round_rate - round the given rate for a clk
  * @clk: round the rate of this clock
  * @rate: the rate which is to be rounded
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9a6d045..8cbf2f7 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -187,6 +187,14 @@ int clk_enable(struct clk *clk);
 void clk_disable(struct clk *clk);
 
 /**
+ * clk_is_enabled - return the enabled state of a clk
+ * @clk: the clk whose enabled state gets returned
+ *
+ * Returns true if the clock is enabled, false otherwise.
+ */
+bool clk_is_enabled(struct clk *clk);
+
+/**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
  * @clk: clock source
@@ -299,6 +307,11 @@ static inline int clk_enable(struct clk *clk)
 
 static inline void clk_disable(struct clk *clk) {}
 
+static inline bool clk_is_enabled(struct clk *clk)
+{
+	return false;
+}
+
 static inline unsigned long clk_get_rate(struct clk *clk)
 {
 	return 0;
-- 
1.7.10.4

