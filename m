Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3LJCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:09:26 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9294 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3LJCJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:09:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Dec 2013 18:02:29 -0800
Date: Mon, 9 Dec 2013 18:09:22 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH] thermal: ti-soc-thermal: clk_round_rate() can return a zero
 upon error
Message-ID: <alpine.DEB.2.02.1312091803260.4127@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Treat both negative and zero return values from clk_round_rate() as
errors.  This is needed since subsequent patches will convert
clk_round_rate()'s return value to be an unsigned type, rather than a
signed type, since some clock sources can generate rates higher than
(2^31)-1 Hz.

Eventually, when calling clk_round_rate(), only a return value of zero
will be considered a error.  All other values will be considered valid
rates.  The comparison against values less than 0 is kept to preserve
the correct behavior in the meantime.

This patch also gets rid of a comparison between unsigned and signed 
values; a side-benefit.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>
---
Applies on v3.13-rc3.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  drivers/thermal/ti-soc-thermal/ti-bandgap.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 74c0e3474d6e..8fe46dbc0c6f 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1248,7 +1248,7 @@ int ti_bandgap_probe(struct platform_device *pdev)
  	clk_rate = clk_round_rate(bgp->div_clk,
  				  bgp->conf->sensors[0].ts_data->max_freq);
  	if (clk_rate < bgp->conf->sensors[0].ts_data->min_freq ||
-	    clk_rate == 0xffffffff) {
+	    clk_rate <= 0) {
  		ret = -ENODEV;
  		dev_err(&pdev->dev, "wrong clock rate (%d)\n", clk_rate);
  		goto put_clks;
