Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3FGR2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:28:47 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43749 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3FGR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:28:44 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH v2 2/2] mmc: dw_mmc: Add the ability to set the ciu clock frequency
Date: Fri,  7 Jun 2013 10:28:30 -0700
Message-Id: <1370626110-1731-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370626110-1731-1-git-send-email-dianders@chromium.org>
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
 <1370626110-1731-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now we rely on code outside of the driver to set the ciu clock
frequency.  There's no reason to do that.  Add support for setting up
the clock in the driver during probe.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
---
Changes in v2:
- Added example as per Jaehoon.

 .../devicetree/bindings/mmc/synopsis-dw-mshc.txt        | 16 ++++++++++++++++
 drivers/mmc/host/dw_mmc.c                               | 17 +++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
index d5cc94e..dd31b00 100644
--- a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
+++ b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
@@ -39,6 +39,19 @@ Required Properties:
 
 Optional properties:
 
+* clocks: from common clock binding: handle to biu and ciu clocks for the
+  bus interface unit clock and the card interface unit clock.
+
+* clock-names: from common clock binding: Shall be "biu" and "ciu".
+  If the biu clock is missing we'll simply skip enabling it.  If the
+  ciu clock is missing we'll just assume that the clock is running at
+  clock-frequency.  It is an error to omit both the ciu clock and the
+  clock-frequency.
+
+* clock-frequency: should be the frequency (in Hz) of the ciu clock.  If this
+  is specified and the ciu clock is specified then we'll try to set the ciu
+  clock to this at probe time.
+
 * num-slots: specifies the number of slots supported by the controller.
   The number of physical slots actually used could be equal or less than the
   value specified by num-slots. If this property is not specified, the value
@@ -70,6 +83,8 @@ board specific portions as listed below.
 
 	dwmmc0@12200000 {
 		compatible = "snps,dw-mshc";
+		clocks = <&clock 351>, <&clock 132>;
+		clock-names = "biu", "ciu";
 		reg = <0x12200000 0x1000>;
 		interrupts = <0 75 0>;
 		#address-cells = <1>;
@@ -77,6 +92,7 @@ board specific portions as listed below.
 	};
 
 	dwmmc0@12200000 {
+		clock-frequency = <400000000>;
 		num-slots = <1>;
 		supports-highspeed;
 		broken-cd;
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index ab5642d..b8a2f16 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2107,6 +2107,7 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
 	struct device_node *np = dev->of_node;
 	const struct dw_mci_drv_data *drv_data = host->drv_data;
 	int idx, ret;
+	u32 clock_frequency;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
@@ -2133,6 +2134,9 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
 
 	of_property_read_u32(np, "card-detect-delay", &pdata->detect_delay_ms);
 
+	if (!of_property_read_u32(np, "clock-frequency", &clock_frequency))
+		pdata->bus_hz = clock_frequency;
+
 	if (drv_data && drv_data->parse_dt) {
 		ret = drv_data->parse_dt(host);
 		if (ret)
@@ -2190,18 +2194,23 @@ int dw_mci_probe(struct dw_mci *host)
 	host->ciu_clk = devm_clk_get(host->dev, "ciu");
 	if (IS_ERR(host->ciu_clk)) {
 		dev_dbg(host->dev, "ciu clock not available\n");
+		host->bus_hz = host->pdata->bus_hz;
 	} else {
 		ret = clk_prepare_enable(host->ciu_clk);
 		if (ret) {
 			dev_err(host->dev, "failed to enable ciu clock\n");
 			goto err_clk_biu;
 		}
-	}
 
-	if (IS_ERR(host->ciu_clk))
-		host->bus_hz = host->pdata->bus_hz;
-	else
+		if (host->pdata->bus_hz) {
+			ret = clk_set_rate(host->ciu_clk, host->pdata->bus_hz);
+			if (ret)
+				dev_warn(host->dev,
+					 "Unable to set bus rate to %ul\n",
+					 host->pdata->bus_hz);
+		}
 		host->bus_hz = clk_get_rate(host->ciu_clk);
+	}
 
 	if (drv_data && drv_data->setup_clock) {
 		ret = drv_data->setup_clock(host);
-- 
1.8.3

