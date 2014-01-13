Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaAMQCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaAMQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/208] rtlwifi: pci: Fix oops on driver unload
Date: Mon, 13 Jan 2014 15:58:25 +0000
Message-Id: <1389628849-1614-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9278db6279e28d4d433bc8a848e10b4ece8793ed upstream.

On Fedora systems, unloading rtl8192ce causes an oops. This patch fixes the
problem reported at https://bugzilla.redhat.com/show_bug.cgi?id=852761.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 703f839..bb3b72e 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -741,6 +741,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
+	if (rtlpci->driver_is_goingto_unload)
+		return;
 	/*RX NORMAL PKT */
 	while (count--) {
 		/*rx descriptor */
@@ -1637,6 +1639,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	 */
 	set_hal_stop(rtlhal);
 
+	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->disable_interrupt(hw);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
 
@@ -1654,7 +1657,6 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	ppsc->rfchange_inprogress = true;
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flags);
 
-	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->hw_disable(hw);
 	/* some things are not needed if firmware not available */
 	if (!rtlpriv->max_fw_size)
-- 
1.8.3.2

