Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbbAYSp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:45:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbbAYSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.18 093/183] clk: at91: keep slow clk enabled to prevent system hang
Date: Sun, 25 Jan 2015 10:06:55 -0800
Message-Id: <20150125180814.211837208@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@free-electrons.com>

commit dca1a4b5ff6e2c25adeff366eb06270dadeab3db upstream.

All slow clk users are not properly claiming it (get + prepare + enable)
before using it.
If all users properly claiming this clock release it, the clock is
disabled, but faulty users still depends on it, and the system hangs.

This fix prevents the slow clock from being disabled, and should solve the
hanging issue, but offending drivers should be patched to properly claim
this clock.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Reported-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/at91/clk-slow.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/clk/at91/clk-slow.c
+++ b/drivers/clk/at91/clk-slow.c
@@ -70,6 +70,7 @@ struct clk_sam9x5_slow {
 
 #define to_clk_sam9x5_slow(hw) container_of(hw, struct clk_sam9x5_slow, hw)
 
+static struct clk *slow_clk;
 
 static int clk_slow_osc_prepare(struct clk_hw *hw)
 {
@@ -357,6 +358,8 @@ at91_clk_register_sam9x5_slow(void __iom
 	clk = clk_register(NULL, &slowck->hw);
 	if (IS_ERR(clk))
 		kfree(slowck);
+	else
+		slow_clk = clk;
 
 	return clk;
 }
@@ -433,6 +436,8 @@ at91_clk_register_sam9260_slow(struct at
 	clk = clk_register(NULL, &slowck->hw);
 	if (IS_ERR(clk))
 		kfree(slowck);
+	else
+		slow_clk = clk;
 
 	return clk;
 }
@@ -465,3 +470,25 @@ void __init of_at91sam9260_clk_slow_setu
 
 	of_clk_add_provider(np, of_clk_src_simple_get, clk);
 }
+
+/*
+ * FIXME: All slow clk users are not properly claiming it (get + prepare +
+ * enable) before using it.
+ * If all users properly claiming this clock decide that they don't need it
+ * anymore (or are removed), it is disabled while faulty users are still
+ * requiring it, and the system hangs.
+ * Prevent this clock from being disabled until all users are properly
+ * requesting it.
+ * Once this is done we should remove this function and the slow_clk variable.
+ */
+static int __init of_at91_clk_slow_retain(void)
+{
+	if (!slow_clk)
+		return 0;
+
+	__clk_get(slow_clk);
+	clk_prepare_enable(slow_clk);
+
+	return 0;
+}
+arch_initcall(of_at91_clk_slow_retain);


