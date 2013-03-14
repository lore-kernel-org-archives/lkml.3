Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3CNJ05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:26:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12144 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CNJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:26:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Mar 2013 02:26:50 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <mturquette@linaro.org>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Bill Huang <bilhuang@nvidia.com>
Subject: [RFC v2 1/1] clk: Add notifier support in clk_prepare/clk_unprepare
Date: Thu, 14 Mar 2013 02:31:04 -0700
Message-ID: <1363253464-3200-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the below two notifier events so drivers which are interested in
knowing the clock status can act accordingly. This is extremely useful
in some of the DVFS (Dynamic Voltage Frequency Scaling) design.

CLK_PREPARED
CLK_UNPREPARED

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/clk/clk.c   |    3 +++
 include/linux/clk.h |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..3292cec 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -550,6 +550,7 @@ void clk_unprepare(struct clk *clk)
 {
 	mutex_lock(&prepare_lock);
 	__clk_unprepare(clk);
+	__clk_notify(clk, CLK_UNPREPARED, clk->rate, clk->rate);
 	mutex_unlock(&prepare_lock);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
@@ -598,6 +599,8 @@ int clk_prepare(struct clk *clk)
 
 	mutex_lock(&prepare_lock);
 	ret = __clk_prepare(clk);
+	if (!ret)
+		__clk_notify(clk, CLK_PREPARED, clk->rate, clk->rate);
 	mutex_unlock(&prepare_lock);
 
 	return ret;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..16c1d92 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -43,6 +43,8 @@ struct clk;
 #define PRE_RATE_CHANGE			BIT(0)
 #define POST_RATE_CHANGE		BIT(1)
 #define ABORT_RATE_CHANGE		BIT(2)
+#define CLK_PREPARED			BIT(3)
+#define CLK_UNPREPARED			BIT(4)
 
 /**
  * struct clk_notifier - associate a clk with a notifier
-- 
1.7.9.5

