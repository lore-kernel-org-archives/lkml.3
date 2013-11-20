Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3KTOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:09:27 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62961 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KTOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:09:26 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-27-528cc2951989
Message-id: <528CC27D.2000100@samsung.com>
Date: Wed, 20 Nov 2013 15:09:01 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: mturquette@linaro.org, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] clk: propagate parent change up one level
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7pTD/UEGTx+LWCx6fE1VovLu+aw
	WTydcJHNYv2M1ywOLB53ru1h89i8pN6jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mj51vmQs
	OMJfsWnyD5YGxpM8XYycHBICJhJr3z5khbDFJC7cW8/WxcjFISSwlFHi5bJTrBDOZ0aJhstf
	wap4BbQk+hoaGUFsFgFViXnzesHibECTji35DBYXFYiQOLr6GVS9oMSPyfdYQGwRATeJG40d
	TCA2s4C1xM7355hBbGEBK4nZe76wQsR1JPa3TmODsOUlNq95yzyBkW8WklGzkJTNQlK2gJF5
	FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIMH7Zwbj4mNUhRgEORiUeXokF3UFCrIllxZW5
	hxglOJiVRHi79vYECfGmJFZWpRblxxeV5qQWH2Jk4uCUamDUyZ84NSxSgOnchUhm0xUtZYf3
	TP2a45j17PmLv2+mZ97oihBeUvH0DVvHJBGGnxEMvv+OlTwXzBQQeKdg9PXQTQ8V192P1D+q
	rFZxEO3aqJm38YycZ4Tivdsfw6/0XSjk6GyLTTnZwSEgEZYZf+Vgw91tnEo7veYUus+YdiX6
	tuPR7533C7YqsRRnJBpqMRcVJwIAHA6bViQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for propagation of setup of clock's parent one level
up.

This feature is helpful when a driver changes topology of its clocks using
clk_set_parent().  The problem occurs when driver's clock is located at MUX
output on one platform/SoC but on the other platform/SoC there is a gated proxy
clock between the MUX and driver's clock.  In such a case, driver's code has to
be modified to use one clock for enabling and the other clock for setup of a
parent.

The code updates are avoided by propagating setup of a parent up one level.

Additionally, this patch adds CLK_SET_PARENT_PARENT (sorry for naming) flag to
inform clk-core that clk_set_parent() should be propagated.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/clk/clk.c            |    6 ++++++
 include/linux/clk-provider.h |    1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a004769..14eda80 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1595,6 +1595,12 @@ int clk_set_parent(struct clk *clk, struct clk *parent)

 	/* try finding the new parent index */
 	if (parent) {
+		if ((clk->flags & CLK_SET_PARENT_PARENT)
+		    && clk->num_parents == 1) {
+			ret = clk_set_parent(clk->parent, parent);
+			goto out;
+		}
+
 		p_index = clk_fetch_parent_index(clk, parent);
 		p_rate = parent->rate;
 		if (p_index == clk->num_parents) {
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 73bdb69..83c98d5 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -29,6 +29,7 @@
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
 #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
+#define CLK_SET_PARENT_PARENT	BIT(8) /* propagate parent change up one level */

 struct clk_hw;

-- 
1.7.9.5


