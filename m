Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025Ab3JKU1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:27:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab3JKTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 082/110] mwifiex: fix PCIe hs_cfg cancel cmd timeout
Date: Fri, 11 Oct 2013 12:39:02 -0700
Message-Id: <20131011193816.757131687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit b7be1522def9a9988b67afd0be999c50a96394b5 upstream.

For pcie8897, the hs_cfg cancel command (0xe5) times out when host
comes out of suspend. This is caused by an incompleted host sleep
handshake between driver and firmware.

Like SDIO interface, PCIe also needs to go through firmware power
save events to complete the handshake for host sleep configuration.
Only USB interface doesn't require power save events for hs_cfg.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cmdevt.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1154,7 +1154,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwi
 	uint32_t conditions = le32_to_cpu(phs_cfg->params.hs_config.conditions);
 
 	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE) &&
-	    adapter->iface_type == MWIFIEX_SDIO) {
+	    adapter->iface_type != MWIFIEX_USB) {
 		mwifiex_hs_activated_event(priv, true);
 		return 0;
 	} else {
@@ -1166,8 +1166,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwi
 	}
 	if (conditions != HS_CFG_CANCEL) {
 		adapter->is_hs_configured = true;
-		if (adapter->iface_type == MWIFIEX_USB ||
-		    adapter->iface_type == MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			mwifiex_hs_activated_event(priv, true);
 	} else {
 		adapter->is_hs_configured = false;


