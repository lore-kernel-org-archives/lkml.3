Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaAPK6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:58:39 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:50915 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbaAPK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:58:34 -0500
From: <srinivas.kandagatla@st.com>
To: <netdev@vger.kernel.org>
Cc: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@st.com>
Subject: [PATCH v2 8/9] net: stmmac: restore pinstate in pm resume.
Date: Thu, 16 Jan 2014 10:52:52 +0000
Message-ID: <1389869572-28340-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389869450-28003-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389869450-28003-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds code to restore default pinstate of the pins when it
comes back from low power state. Without this patch the state of the
pins would be unknown and the driver would not work.

This patch also adds code to put the pins in to sleep state when the
driver enters low power state.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c1298a0..df7d8d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -43,6 +43,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/prefetch.h>
+#include <linux/pinctrl/consumer.h>
 #ifdef CONFIG_STMMAC_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -2864,6 +2865,7 @@ int stmmac_suspend(struct net_device *ndev)
 		priv->hw->mac->pmt(priv->ioaddr, priv->wolopts);
 	else {
 		stmmac_set_mac(priv->ioaddr, false);
+		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->stmmac_clk);
 	}
@@ -2890,6 +2892,7 @@ int stmmac_resume(struct net_device *ndev)
 	if (device_may_wakeup(priv->device)) {
 		priv->hw->mac->pmt(priv->ioaddr, 0);
 	} else {
+		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk prevously disabled */
 		clk_prepare_enable(priv->stmmac_clk);
 		/* reset the phy so that it's ready */
-- 
1.7.6.5

