Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3KRLeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:34:25 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:37967 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab3KRLeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:34:16 -0500
From: <srinivas.kandagatla@st.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH RFC 9/9] net: stmmac: notify the PM core of a wakeup event.
Date: Mon, 18 Nov 2013 11:32:28 +0000
Message-ID: <1384774348-10432-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1384774256-10039-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384774256-10039-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

In PM_SUSPEND_FREEZE and WOL(Wakeup On Lan) case, when the driver gets a
wakeup event, either the driver or platform specific PM code should notify
the pm core about it, so that the system can wakeup from low power.

In cases where there is no involvement of platform specific PM, it
becomes driver responsibility to notify the PM core to wakeup the
system.

Without this WOL with PM_SUSPEND_FREEZE does not work on STi based SOCs.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 90350e9..de9f95c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -105,6 +105,7 @@ struct stmmac_priv {
 	unsigned int default_addend;
 	u32 adv_ts;
 	int use_riwt;
+	int irq_wake;
 	spinlock_t ptp_lock;
 };
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c0b5716..2d5eea7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2309,6 +2309,9 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	if (priv->irq_wake)
+		pm_wakeup_event(priv->device, 0);
+
 	if (unlikely(!dev)) {
 		pr_err("%s: invalid dev pointer\n", __func__);
 		return IRQ_NONE;
@@ -2850,9 +2853,10 @@ int stmmac_suspend(struct net_device *ndev)
 	stmmac_clear_descriptors(priv);
 
 	/* Enable Power down mode by programming the PMT regs */
-	if (device_may_wakeup(priv->device))
+	if (device_may_wakeup(priv->device)) {
 		priv->hw->mac->pmt(priv->ioaddr, priv->wolopts);
-	else {
+		priv->irq_wake = 1;
+	} else {
 		stmmac_set_mac(priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
@@ -2880,6 +2884,7 @@ int stmmac_resume(struct net_device *ndev)
 	 */
 	if (device_may_wakeup(priv->device)) {
 		priv->hw->mac->pmt(priv->ioaddr, 0);
+		priv->irq_wake = 0;
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk prevously disabled */
-- 
1.7.6.5

