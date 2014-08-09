Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaHIQ4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:56:21 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38482 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaHIQ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:56:18 -0400
Date: Sat, 9 Aug 2014 22:26:12 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] clk: st: remove null pointer dereference
Message-ID: <20140809165612.GA21631@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clk_data is NULL, it is not possible to access its clk_num field. So
if the NULL test succeeds the control sequence mush jump after the loop.
So, a new label is introduced and the labels are renamed to err0 and
err1. If clk_data is NULL, only parents need to be freed and hence the
goto now points to err0.

This problem was found using the following Coccinelle semantic match:

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested.
 drivers/clk/st/clkgen-mux.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index 79dc40b..385b3d0 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -723,14 +723,14 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 
 	clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
 	if (!clk_data)
-		goto err;
+		goto err0;
 
 	clk_data->clk_num = VCC_MAX_CHANNELS;
 	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks)
-		goto err;
+		goto err1;
 
 	for (i = 0; i < clk_data->clk_num; i++) {
 		struct clk *clk;
@@ -791,7 +791,7 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 			kfree(gate);
 			kfree(div);
 			kfree(mux);
-			goto err;
+			goto err1;
 		}
 
 		pr_debug("%s: parent %s rate %u\n",
@@ -807,7 +807,7 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
 	return;
 
-err:
+err1:
 	for (i = 0; i < clk_data->clk_num; i++) {
 		struct clk_composite *composite;
 
@@ -821,10 +821,11 @@ err:
 		kfree(container_of(composite->mux_hw, struct clk_mux, hw));
 	}
 
-	if (clk_data)
-		kfree(clk_data->clks);
+	kfree(clk_data->clks);
 
 	kfree(clk_data);
+
+err0:
 	kfree(parents);
 }
 CLK_OF_DECLARE(clkgen_vcc, "st,clkgen-vcc", st_of_clkgen_vcc_setup);
-- 
1.9.1

