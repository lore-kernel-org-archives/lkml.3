Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3GDVFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:05:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52264 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab3GDVFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:05:39 -0400
From: Luciano Coelho <coelho@ti.com>
To: <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <coelho@ti.com>
Subject: [RFC] clk: add flags to distinguish xtal clocks
Date: Fri, 5 Jul 2013 00:05:12 +0300
Message-ID: <1372971912-10877-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag that indicate whether the clock is a crystal or not.  Since
no clocks set this flag right now, include an additional flag that
indicates whether the type is set or not.  If the CLK_IS_TYPE_DEFINED
flag is not set, the value of the CLK_IS_TYPE_XTAL flag is undefined.
This ensures backwards compatibility.

Additionally, parse a new device tree binding in clk-fixed-rate to set
this flag.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

I'm not  familiar with the common clock framework and I'm not
entirely sure the flags can be used in such a way, but to me it looks
reasonable, since some clock consumers may need to know what type of
clock is being provided.

Specifically, the wl12xx firmware needs to know if the clock is XTAL
or not to handle the stabilization and boosts properly.

My main idea is that I need to pass this information in the device
tree definition of the clocks, so that the driver can pass this
information on to the firmware.

Please let me know if this looks ok or not.  If not, please let me
know if you have any other ideas on how to solve my problem (of
knowing whether the clock attached to the WiLink chip is XTAL or not).




 drivers/clk/clk-fixed-rate.c |    6 +++++-
 include/linux/clk-provider.h |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index dc58fbd..4003a82 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -90,13 +90,17 @@ void of_fixed_clk_setup(struct device_node *node)
 	struct clk *clk;
 	const char *clk_name = node->name;
 	u32 rate;
+	unsigned long flags = CLK_IS_ROOT;
 
 	if (of_property_read_u32(node, "clock-frequency", &rate))
 		return;
 
+	if (of_property_read_bool(node, "clock-xtal"))
+		flags |= CLK_IS_TYPE_DEFINED | CLK_IS_TYPE_XTAL;
+
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
-	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT, rate);
+	clk = clk_register_fixed_rate(NULL, clk_name, NULL, flags, rate);
 	if (!IS_ERR(clk))
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1186098..034320b 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -27,6 +27,8 @@
 #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
+#define CLK_IS_TYPE_DEFINED	BIT(7) /* the clock type is defined */
+#define CLK_IS_TYPE_XTAL	BIT(8) /* this is a crystal clock */
 
 struct clk_hw;
 
-- 
1.7.10.4

