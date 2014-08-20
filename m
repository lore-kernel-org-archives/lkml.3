Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaHTLpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:45:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59017 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbaHTLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/104] igbvf: integer wrapping bug setting the mtu
Date: Wed, 20 Aug 2014 13:43:52 +0200
Message-Id: <7a502609e5e92f4744eda6472246d9af1964dc48.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3de9e65f011b95235a789b12abc4730570cdb737 upstream.

If new_mtu is very large then "new_mtu + ETH_HLEN + ETH_FCS_LEN" can
wrap and the check on the next line can underflow. This is one of those
bugs which can be triggered by the user if you have namespaces
configured.

Also since this is something the user can trigger then we don't want to
have dev_err() message.

This is a static checker fix and I'm not sure what the impact is.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Sibai Li Sibai.li@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 4e6b02fbe652..0c0b8f6855a2 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2343,10 +2343,9 @@ static int igbvf_change_mtu(struct net_device *netdev, int new_mtu)
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
 
-	if ((new_mtu < 68) || (max_frame > MAX_JUMBO_FRAME_SIZE)) {
-		dev_err(&adapter->pdev->dev, "Invalid MTU setting\n");
+	if (new_mtu < 68 || new_mtu > INT_MAX - ETH_HLEN - ETH_FCS_LEN ||
+	    max_frame > MAX_JUMBO_FRAME_SIZE)
 		return -EINVAL;
-	}
 
 #define MAX_STD_JUMBO_FRAME_SIZE 9234
 	if (max_frame > MAX_STD_JUMBO_FRAME_SIZE) {
-- 
2.0.4

