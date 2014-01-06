Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaAFWkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:40:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678AbaAFWkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 105/144] rtlwifi: pci: Fix oops on driver unload
Date: Mon,  6 Jan 2014 14:37:46 -0800
Message-Id: <20140106223748.362162979@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9278db6279e28d4d433bc8a848e10b4ece8793ed upstream.

On Fedora systems, unloading rtl8192ce causes an oops. This patch fixes the
problem reported at https://bugzilla.redhat.com/show_bug.cgi?id=852761.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -741,6 +741,8 @@ static void _rtl_pci_rx_interrupt(struct
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
+	if (rtlpci->driver_is_goingto_unload)
+		return;
 	/*RX NORMAL PKT */
 	while (count--) {
 		/*rx descriptor */
@@ -1637,6 +1639,7 @@ static void rtl_pci_stop(struct ieee8021
 	 */
 	set_hal_stop(rtlhal);
 
+	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->disable_interrupt(hw);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
 
@@ -1654,7 +1657,6 @@ static void rtl_pci_stop(struct ieee8021
 	ppsc->rfchange_inprogress = true;
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flags);
 
-	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->hw_disable(hw);
 	/* some things are not needed if firmware not available */
 	if (!rtlpriv->max_fw_size)


