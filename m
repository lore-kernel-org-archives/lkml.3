Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaDGGa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 02:30:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17112 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDGGax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 02:30:53 -0400
Date: Mon, 7 Apr 2014 09:30:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Turquette <mturquette@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Pankaj Dev <pankaj.dev@st.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] clk: st: NULL dereference on error in
 st_of_clkgen_vcc_setup()
Message-ID: <20140407063036.GA11581@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two allocations where, if they fail, then we end up
dereferencing the NULL pointer in the error handling code.

Fixes: 94885faf9dbc ('clk: st: Support for DIVMUX and PreDiv Clocks')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index a329906..10899bc 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -714,14 +714,14 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 
 	clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
 	if (!clk_data)
-		goto err;
+		goto err_free_parents;
 
 	clk_data->clk_num = VCC_MAX_CHANNELS;
 	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks)
-		goto err;
+		goto err_free_data;
 
 	for (i = 0; i < clk_data->clk_num; i++) {
 		struct clk *clk;
@@ -811,10 +811,11 @@ err:
 		kfree(container_of(composite->mux_hw, struct clk_mux, hw));
 	}
 
-	if (clk_data)
-		kfree(clk_data->clks);
+	kfree(clk_data->clks);
 
+err_free_data:
 	kfree(clk_data);
+err_free_parents:
 	kfree(parents);
 }
 CLK_OF_DECLARE(clkgen_vcc, "st,clkgen-vcc", st_of_clkgen_vcc_setup);
