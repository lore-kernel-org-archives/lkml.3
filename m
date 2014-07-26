Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaGZTNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:13:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaGZTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Felipe Balbi <balbi@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 042/109] drivers: net: cpsw: fix dual EMAC stall when connected to same switch
Date: Sat, 26 Jul 2014 12:02:04 -0700
Message-Id: <20140726190225.119980278@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mugunthan V N <mugunthanvnm@ti.com>

[ Upstream commit e6afea0bbf129f88dc3fc39fd0d769f9ff064172 ]

In commit 629c9a8fd0bbdfc6d702526b327470166ec39c6b (drivers: net: cpsw: Add
default vlan for dual emac case also), api cpsw_add_default_vlan() also
changes the port vlan which is required to seperate the ports which results
in the following behavior

In Dual EMAC mode, when both the Etnernet connected is connected to same
switch, it creates a loop in the switch and when a broadcast packet is
received it is forwarded to the other port which stalls the whole switch
and needs a reset/power cycle to the switch to recover. So intead of using
the api, add only the default VLAN entry in dual EMAC case.

Cc: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Tested-by: Yegor Yefremov <yegorslists@googlemail.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1201,7 +1201,12 @@ static int cpsw_ndo_open(struct net_devi
 	for_each_slave(priv, cpsw_slave_open, priv);
 
 	/* Add default VLAN */
-	cpsw_add_default_vlan(priv);
+	if (!priv->data.dual_emac)
+		cpsw_add_default_vlan(priv);
+	else
+		cpsw_ale_add_vlan(priv->ale, priv->data.default_vlan,
+				  ALE_ALL_PORTS << priv->host_port,
+				  ALE_ALL_PORTS << priv->host_port, 0, 0);
 
 	if (!cpsw_common_res_usage_state(priv)) {
 		/* setup tx dma to fixed prio and zero offset */


