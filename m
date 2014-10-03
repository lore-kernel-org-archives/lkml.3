Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaJCXIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:08:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbaJCWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Moni Shoua <monis@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 202/238] IB/mlx4: Dont duplicate the default RoCE GID
Date: Fri,  3 Oct 2014 14:31:57 -0700
Message-Id: <20141003212920.124619735@linuxfoundation.org>
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

commit f5c4834d9328c4ed9fe5dcbec6128d6da16db69a upstream.

When reading the IPv6 addresses from the net-device, make sure to
avoid adding a duplicate entry to the GID table because of equality
between the default GID we generate and the default IPv6 link-local
address of the device.

Fixes: acc4fccf4eff ("IB/mlx4: Make sure GID index 0 is always occupied")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx4/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1622,6 +1622,7 @@ static void mlx4_ib_get_dev_addr(struct
 	struct inet6_dev *in6_dev;
 	union ib_gid  *pgid;
 	struct inet6_ifaddr *ifp;
+	union ib_gid default_gid;
 #endif
 	union ib_gid gid;
 
@@ -1642,12 +1643,15 @@ static void mlx4_ib_get_dev_addr(struct
 		in_dev_put(in_dev);
 	}
 #if IS_ENABLED(CONFIG_IPV6)
+	mlx4_make_default_gid(dev, &default_gid);
 	/* IPv6 gids */
 	in6_dev = in6_dev_get(dev);
 	if (in6_dev) {
 		read_lock_bh(&in6_dev->lock);
 		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
 			pgid = (union ib_gid *)&ifp->addr;
+			if (!memcmp(pgid, &default_gid, sizeof(*pgid)))
+				continue;
 			update_gid_table(ibdev, port, pgid, 0, 0);
 		}
 		read_unlock_bh(&in6_dev->lock);


