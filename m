Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaDDOx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:53:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12709 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaDDOx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:53:57 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-80-533ec783b45b
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: t.figa@samsung.com, mturquette@linaro.org, kgene.kim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, a.hajda@samsung.com, kishon@ti.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/4] clk: propagate parent change up one level
Date: Fri, 04 Apr 2014 16:53:18 +0200
Message-id: <1396623201-26000-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd3m43bBBnu2aFvcWneO1aL33Ekm
	i/lHgKwrX9+zWUy6P4HFonfBVTaLC0972CzONr1ht9j0+BqrxeVdc9gsZpzfx2TxdMJFNovD
	Kw4wWcyY/JLNYt7nnUwW62e8ZrGY1/6S1UHQY8HnK+weO2fdZfe4c20Pm8f2bw9YPe53H2fy
	2Lyk3qNvyypGj+M3tjN5fN4kF8AZxWWTkpqTWZZapG+XwJXx/ApbwTn+iskbrrM1MF7k6WLk
	5JAQMJFY93waK4QtJnHh3nq2LkYuDiGB6YwSV7deY4Zwupgklly4zwhSxQbUcWzJZ0aQhIjA
	KkaJif+fsoM4zAKbmCR2NnazdDFycAgL2En0//QFaWARUJXY86eLFSTMK+AhsXKKGcQ2RYnu
	ZxPYQGxOAU+J3iXfmUFsIaCS7jULWCYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	ERzez6R2MK5ssDjEKMDBqMTD27HDLliINbGsuDL3EKMEB7OSCG/dBKAQb0piZVVqUX58UWlO
	avEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGRp5Tn084zi5eW7zd6i/PJNV7ji/W
	3vPXKOGrnCDntshaZM6t4mgJth8mYuFzLitmV2v/PDBn2s3eixMl2FQaPCtV79vMY7q5vmJR
	jtUlMZbjurrHrV3mu/Fv/7+ia8Zc7U/Xr6yt73XZtHd361v/oLBwxd+nvxVuMjz4qu/k8SIe
	xnOv5a5pHVFiKc5INNRiLipOBABuav0CawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for propagation of setup of clock's parent one level
up.

This feature is helpful when a driver changes topology of its clocks using
clk_set_parent().  The problem occurs when on one platform/SoC driver's clock
is located at MUX output but on the other platform/SoC there is a gated proxy
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
index dff0373..53bbfda 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1737,6 +1737,12 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 
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
 		if (p_index < 0) {
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5119174..daa0b03 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -30,6 +30,7 @@
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
 #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
 #define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
+#define CLK_SET_PARENT_PARENT	BIT(9) /* propagate parent change up one level */
 
 struct clk_hw;
 struct dentry;
-- 
1.7.9.5

