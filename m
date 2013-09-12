Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3ILSQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:16:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3ILSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bing Zhao <bzhao@marvell.com>, Avinash Patil <patila@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 16/16] mwifiex: do not create AP and P2P interfaces upon driver loading
Date: Thu, 12 Sep 2013 11:15:08 -0700
Message-Id: <20130912181157.950776019@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 1211c961170cedb21c30d5bb7e2033c8720b38db upstream.

Bug 60747 - 1286:2044 [Microsoft Surface Pro]
    Marvell 88W8797 wifi show 3 interface under network
https://bugzilla.kernel.org/show_bug.cgi?id=60747

This issue was also reported previously by OLPC and some folks from
the community.

There are 3 network interfaces with different types being created
when mwifiex driver is loaded:

1. mlan0 (infra. STA)
2. uap0 (AP)
3. p2p0 (P2P_CLIENT)

The Network Manager attempts to use all 3 interfaces above without
filtering the managed interface type. As the result, 3 identical
interfaces are displayed under network manager. If user happens to
click on an entry under which its interface is uap0 or p2p0, the
association will fail.

Work around it by removing the creation of AP and P2P interfaces
at driver loading time. These interfaces can be added with 'iw' or
other applications manually when they are needed.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/main.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -458,20 +458,6 @@ static void mwifiex_fw_dpc(const struct
 		dev_err(adapter->dev, "cannot create default STA interface\n");
 		goto err_add_intf;
 	}
-
-	/* Create AP interface by default */
-	if (!mwifiex_add_virtual_intf(adapter->wiphy, "uap%d",
-				      NL80211_IFTYPE_AP, NULL, NULL)) {
-		dev_err(adapter->dev, "cannot create default AP interface\n");
-		goto err_add_intf;
-	}
-
-	/* Create P2P interface by default */
-	if (!mwifiex_add_virtual_intf(adapter->wiphy, "p2p%d",
-				      NL80211_IFTYPE_P2P_CLIENT, NULL, NULL)) {
-		dev_err(adapter->dev, "cannot create default P2P interface\n");
-		goto err_add_intf;
-	}
 	rtnl_unlock();
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);


