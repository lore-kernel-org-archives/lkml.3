Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaBLIOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbaBLIN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.960813534@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 49/79] rtlwifi: pci: Fix oops on driver unload
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9278db6279e28d4d433bc8a848e10b4ece8793ed upstream.

On Fedora systems, unloading rtl8192ce causes an oops. This patch fixes the
problem reported at https://bugzilla.redhat.com/show_bug.cgi?id=852761.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -685,6 +685,8 @@ static void _rtl_pci_rx_interrupt(struct
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
+	if (rtlpci->driver_is_goingto_unload)
+		return;
 	/*RX NORMAL PKT */
 	while (count--) {
 		/*rx descriptor */
@@ -1563,6 +1565,7 @@ static void rtl_pci_stop(struct ieee8021
 	 */
 	set_hal_stop(rtlhal);
 
+	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->disable_interrupt(hw);
 	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
 
@@ -1580,7 +1583,6 @@ static void rtl_pci_stop(struct ieee8021
 	ppsc->rfchange_inprogress = true;
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flags);
 
-	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->hw_disable(hw);
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_OFF);
 

