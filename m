Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaJMCnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:43:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaJMC2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 35/55] net/mlx4: Correctly configure single ported VFs from the host
Date: Mon, 13 Oct 2014 04:24:49 +0200
Message-Id: <20141013022445.300112214@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matan Barak <matanb@mellanox.com>

[ Upstream commit a91c772fa0275163508e1078ff6d474d423244fb ]

Single port VFs are seen PCI wise on both ports of the PF (we don't have
single port PFs with ConnectX). With this in mind, it's possible for
virtualization tools to try and configure a single ported VF through
the "wrong" PF port.

To handle that, we use the PF driver mapping of single port VFs to NIC
ports and adjust the port value before calling into the low level
code that does the actual VF configuration

Fixes: 449fc48 ('net/mlx4: Adapt code for N-Port VF')
Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2380,6 +2380,22 @@ struct mlx4_slaves_pport mlx4_phys_to_sl
 }
 EXPORT_SYMBOL_GPL(mlx4_phys_to_slaves_pport_actv);
 
+static int mlx4_slaves_closest_port(struct mlx4_dev *dev, int slave, int port)
+{
+	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(dev, slave);
+	int min_port = find_first_bit(actv_ports.ports, dev->caps.num_ports)
+			+ 1;
+	int max_port = min_port +
+		bitmap_weight(actv_ports.ports, dev->caps.num_ports);
+
+	if (port < min_port)
+		port = min_port;
+	else if (port >= max_port)
+		port = max_port - 1;
+
+	return port;
+}
+
 int mlx4_set_vf_mac(struct mlx4_dev *dev, int port, int vf, u64 mac)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -2393,6 +2409,7 @@ int mlx4_set_vf_mac(struct mlx4_dev *dev
 	if (slave < 0)
 		return -EINVAL;
 
+	port = mlx4_slaves_closest_port(dev, slave, port);
 	s_info = &priv->mfunc.master.vf_admin[slave].vport[port];
 	s_info->mac = mac;
 	mlx4_info(dev, "default mac on vf %d port %d to %llX will take afect only after vf restart\n",
@@ -2419,6 +2436,7 @@ int mlx4_set_vf_vlan(struct mlx4_dev *de
 	if (slave < 0)
 		return -EINVAL;
 
+	port = mlx4_slaves_closest_port(dev, slave, port);
 	vf_admin = &priv->mfunc.master.vf_admin[slave].vport[port];
 
 	if ((0 == vlan) && (0 == qos))
@@ -2446,6 +2464,7 @@ bool mlx4_get_slave_default_vlan(struct
 	struct mlx4_priv *priv;
 
 	priv = mlx4_priv(dev);
+	port = mlx4_slaves_closest_port(dev, slave, port);
 	vp_oper = &priv->mfunc.master.vf_oper[slave].vport[port];
 
 	if (MLX4_VGT != vp_oper->state.default_vlan) {
@@ -2473,6 +2492,7 @@ int mlx4_set_vf_spoofchk(struct mlx4_dev
 	if (slave < 0)
 		return -EINVAL;
 
+	port = mlx4_slaves_closest_port(dev, slave, port);
 	s_info = &priv->mfunc.master.vf_admin[slave].vport[port];
 	s_info->spoofchk = setting;
 
@@ -2526,6 +2546,7 @@ int mlx4_set_vf_link_state(struct mlx4_d
 	if (slave < 0)
 		return -EINVAL;
 
+	port = mlx4_slaves_closest_port(dev, slave, port);
 	switch (link_state) {
 	case IFLA_VF_LINK_STATE_AUTO:
 		/* get current link state */


