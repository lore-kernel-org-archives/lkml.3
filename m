Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab3FSTjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:39:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52407 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab3FSTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:39:30 -0400
From: Mark Brown <broonie@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Wed, 19 Jun 2013 20:38:28 +0100
Message-Id: <1371670708-26161-1-git-send-email-broonie@linaro.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] dmaengine: PL08x: Avoid collisions with get_signal() macro
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Arnd Bergmann there is a get_signal macro definied in
linux/signal.h which can conflict with the platform data callback
function of the same name leading to confusing errors from the compiler
(especially if signal.h manages to get pulled into the driver itself due
to header dependencies).  Avoid such errors by renaming get_signal and
put_signal in the platform data to get_xfer_signal and put_xfer_signal.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 arch/arm/mach-lpc32xx/phy3250.c | 4 ++--
 arch/arm/mach-spear/spear3xx.c  | 4 ++--
 arch/arm/mach-spear/spear6xx.c  | 4 ++--
 drivers/dma/amba-pl08x.c        | 8 ++++----
 include/linux/amba/pl08x.h      | 8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index c1cd5a9..e54f87e 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -182,8 +182,8 @@ static void pl08x_put_signal(const struct pl08x_channel_data *cd, int ch)
 static struct pl08x_platform_data pl08x_pd = {
 	.slave_channels = &pl08x_slave_channels[0],
 	.num_slave_channels = ARRAY_SIZE(pl08x_slave_channels),
-	.get_signal = pl08x_get_signal,
-	.put_signal = pl08x_put_signal,
+	.get_xfer_signal = pl08x_get_signal,
+	.put_xfer_signal = pl08x_put_signal,
 	.lli_buses = PL08X_AHB1,
 	.mem_buses = PL08X_AHB1,
 };
diff --git a/arch/arm/mach-spear/spear3xx.c b/arch/arm/mach-spear/spear3xx.c
index 0227c97..bf3b1fd 100644
--- a/arch/arm/mach-spear/spear3xx.c
+++ b/arch/arm/mach-spear/spear3xx.c
@@ -56,8 +56,8 @@ struct pl08x_platform_data pl080_plat_data = {
 	},
 	.lli_buses = PL08X_AHB1,
 	.mem_buses = PL08X_AHB1,
-	.get_signal = pl080_get_signal,
-	.put_signal = pl080_put_signal,
+	.get_xfer_signal = pl080_get_signal,
+	.put_xfer_signal = pl080_put_signal,
 };
 
 /*
diff --git a/arch/arm/mach-spear/spear6xx.c b/arch/arm/mach-spear/spear6xx.c
index 8b0295a..da26fa5 100644
--- a/arch/arm/mach-spear/spear6xx.c
+++ b/arch/arm/mach-spear/spear6xx.c
@@ -334,8 +334,8 @@ static struct pl08x_platform_data spear6xx_pl080_plat_data = {
 	},
 	.lli_buses = PL08X_AHB1,
 	.mem_buses = PL08X_AHB1,
-	.get_signal = pl080_get_signal,
-	.put_signal = pl080_put_signal,
+	.get_xfer_signal = pl080_get_signal,
+	.put_xfer_signal = pl080_put_signal,
 	.slave_channels = spear600_dma_info,
 	.num_slave_channels = ARRAY_SIZE(spear600_dma_info),
 };
diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 8bad254..06fe45c 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -299,8 +299,8 @@ static int pl08x_request_mux(struct pl08x_dma_chan *plchan)
 	const struct pl08x_platform_data *pd = plchan->host->pd;
 	int ret;
 
-	if (plchan->mux_use++ == 0 && pd->get_signal) {
-		ret = pd->get_signal(plchan->cd);
+	if (plchan->mux_use++ == 0 && pd->get_xfer_signal) {
+		ret = pd->get_xfer_signal(plchan->cd);
 		if (ret < 0) {
 			plchan->mux_use = 0;
 			return ret;
@@ -318,8 +318,8 @@ static void pl08x_release_mux(struct pl08x_dma_chan *plchan)
 	if (plchan->signal >= 0) {
 		WARN_ON(plchan->mux_use == 0);
 
-		if (--plchan->mux_use == 0 && pd->put_signal) {
-			pd->put_signal(plchan->cd, plchan->signal);
+		if (--plchan->mux_use == 0 && pd->put_xfer_signal) {
+			pd->put_xfer_signal(plchan->cd, plchan->signal);
 			plchan->signal = -1;
 		}
 	}
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 2a5f64a..10fe2a2 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -76,11 +76,11 @@ struct pl08x_channel_data {
  * platform, all inclusive, including multiplexed channels. The available
  * physical channels will be multiplexed around these signals as they are
  * requested, just enumerate all possible channels.
- * @get_signal: request a physical signal to be used for a DMA transfer
+ * @get_xfer_signal: request a physical signal to be used for a DMA transfer
  * immediately: if there is some multiplexing or similar blocking the use
  * of the channel the transfer can be denied by returning less than zero,
  * else it returns the allocated signal number
- * @put_signal: indicate to the platform that this physical signal is not
+ * @put_xfer_signal: indicate to the platform that this physical signal is not
  * running any DMA transfer and multiplexing can be recycled
  * @lli_buses: buses which LLIs can be fetched from: PL08X_AHB1 | PL08X_AHB2
  * @mem_buses: buses which memory can be accessed from: PL08X_AHB1 | PL08X_AHB2
@@ -89,8 +89,8 @@ struct pl08x_platform_data {
 	const struct pl08x_channel_data *slave_channels;
 	unsigned int num_slave_channels;
 	struct pl08x_channel_data memcpy_channel;
-	int (*get_signal)(const struct pl08x_channel_data *);
-	void (*put_signal)(const struct pl08x_channel_data *, int);
+	int (*get_xfer_signal)(const struct pl08x_channel_data *);
+	void (*put_xfer_signal)(const struct pl08x_channel_data *, int);
 	u8 lli_buses;
 	u8 mem_buses;
 };
-- 
1.8.3.1

