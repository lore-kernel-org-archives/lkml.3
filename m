Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbaJCXIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:08:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbaJCWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Moni Shoua <monis@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 201/238] IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
Date: Fri,  3 Oct 2014 14:31:56 -0700
Message-Id: <20141003212920.094193557@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moni Shoua <monis@mellanox.com>

commit e381835cf1b8e3b2857277dbc3b77d8c5350f70a upstream.

When Ethernet netdev is not present for a port (e.g. when the link
layer type of the port is InfiniBand) it's possible to dereference a
null pointer when we do netdevice scanning.

To fix that, we move a section of code that needs to run only when
netdev is present to a proper if () statement.

Fixes: ad4885d279b6 ("IB/mlx4: Build the port IBoE GID table properly under bonding")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx4/main.c |   49 ++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1723,31 +1723,34 @@ static void mlx4_ib_scan_netdevs(struct
 			port_state = (netif_running(curr_netdev) && netif_carrier_ok(curr_netdev)) ?
 						IB_PORT_ACTIVE : IB_PORT_DOWN;
 			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-		} else {
-			reset_gid_table(ibdev, port);
-		}
-		/* if using bonding/team and a slave port is down, we don't the bond IP
-		 * based gids in the table since flows that select port by gid may get
-		 * the down port.
-		 */
-		if (curr_master && (port_state == IB_PORT_DOWN)) {
-			reset_gid_table(ibdev, port);
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-		}
-		/* if bonding is used it is possible that we add it to masters
-		 * only after IP address is assigned to the net bonding
-		 * interface.
-		*/
-		if (curr_master && (old_master != curr_master)) {
-			reset_gid_table(ibdev, port);
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-			mlx4_ib_get_dev_addr(curr_master, ibdev, port);
-		}
+			/* if using bonding/team and a slave port is down, we
+			 * don't the bond IP based gids in the table since
+			 * flows that select port by gid may get the down port.
+			 */
+			if (curr_master && (port_state == IB_PORT_DOWN)) {
+				reset_gid_table(ibdev, port);
+				mlx4_ib_set_default_gid(ibdev,
+							curr_netdev, port);
+			}
+			/* if bonding is used it is possible that we add it to
+			 * masters only after IP address is assigned to the
+			 * net bonding interface.
+			*/
+			if (curr_master && (old_master != curr_master)) {
+				reset_gid_table(ibdev, port);
+				mlx4_ib_set_default_gid(ibdev,
+							curr_netdev, port);
+				mlx4_ib_get_dev_addr(curr_master, ibdev, port);
+			}
 
-		if (!curr_master && (old_master != curr_master)) {
+			if (!curr_master && (old_master != curr_master)) {
+				reset_gid_table(ibdev, port);
+				mlx4_ib_set_default_gid(ibdev,
+							curr_netdev, port);
+				mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
+			}
+		} else {
 			reset_gid_table(ibdev, port);
-			mlx4_ib_set_default_gid(ibdev, curr_netdev, port);
-			mlx4_ib_get_dev_addr(curr_netdev, ibdev, port);
 		}
 	}
 


