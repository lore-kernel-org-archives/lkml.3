Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaAOVyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40825 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaAOVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 114/166] rtlwifi: pci: Fix oops on driver unload
Date: Wed, 15 Jan 2014 13:52:08 -0800
Message-Id: <1389822780-4729-115-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9278db6279e28d4d433bc8a848e10b4ece8793ed upstream.

On Fedora systems, unloading rtl8192ce causes an oops. This patch fixes the
problem reported at https://bugzilla.redhat.com/show_bug.cgi?id=852761.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 4261e8e..8fdb04c 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -677,6 +677,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
+	if (rtlpci->driver_is_goingto_unload)
+		return;
 	/*RX NORMAL PKT */
 	while (count--) {
 		/*rx descriptor */
@@ -1565,6 +1567,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	 */
 	set_hal_stop(rtlhal);
 
+	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->disable_interrupt(hw);
 	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
@@ -1582,7 +1585,6 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	ppsc->rfchange_inprogress = true;
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flags);
 
-	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->hw_disable(hw);
 	/* some things are not needed if firmware not available */
 	if (!rtlpriv->max_fw_size)
-- 
1.8.3.2

