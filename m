Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328Ab3HICBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:01:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278Ab3HIB7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 099/102] net/mlx4_core: Dont give VFs MAC addresses which are derived from the PF MAC
Date: Thu,  8 Aug 2013 18:58:15 -0700
Message-Id: <20130809015033.591749525@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit 0508ad646836007e6e6b62331eee7356844eac3d ]

If the user has not assigned a MAC address to a VM, then don't give it MAC which
is based on the PF one. The current derivation scheme is wrong and leads to VM
MAC collisions when the number of cards/hypervisors becomes big enough.

Instead, just give it zeros and let them figure out what to do with that.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -840,16 +840,7 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_
 			   MLX4_CMD_NATIVE);
 
 	if (!err && dev->caps.function != slave) {
-		/* if config MAC in DB use it */
-		if (priv->mfunc.master.vf_oper[slave].vport[vhcr->in_modifier].state.mac)
-			def_mac = priv->mfunc.master.vf_oper[slave].vport[vhcr->in_modifier].state.mac;
-		else {
-			/* set slave default_mac address */
-			MLX4_GET(def_mac, outbox->buf, QUERY_PORT_MAC_OFFSET);
-			def_mac += slave << 8;
-			priv->mfunc.master.vf_admin[slave].vport[vhcr->in_modifier].mac = def_mac;
-		}
-
+		def_mac = priv->mfunc.master.vf_oper[slave].vport[vhcr->in_modifier].state.mac;
 		MLX4_PUT(outbox->buf, def_mac, QUERY_PORT_MAC_OFFSET);
 
 		/* get port type - currently only eth is enabled */


