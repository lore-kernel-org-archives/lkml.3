Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab3CRVtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:49:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3CRVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 64/75] bonding: fire NETDEV_RELEASE event only on 0 slaves
Date: Mon, 18 Mar 2013 14:07:27 -0700
Message-Id: <20130318210514.871343760@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 80028ea1c0afc24d4ddeb8dd2a9992fff03616ca ]

Currently, if we set up netconsole over bonding and release a slave,
netconsole will stop logging on the whole bonding device. Change the
behavior to stop the netconsole only when the last slave is released.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1943,7 +1943,6 @@ int bond_release(struct net_device *bond
 	}
 
 	block_netpoll_tx();
-	call_netdevice_notifiers(NETDEV_RELEASE, bond_dev);
 	write_lock_bh(&bond->lock);
 
 	slave = bond_get_slave_by_dev(bond, slave_dev);
@@ -2047,8 +2046,10 @@ int bond_release(struct net_device *bond
 	write_unlock_bh(&bond->lock);
 	unblock_netpoll_tx();
 
-	if (bond->slave_cnt == 0)
+	if (bond->slave_cnt == 0) {
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, bond->dev);
+		call_netdevice_notifiers(NETDEV_RELEASE, bond->dev);
+	}
 
 	bond_compute_features(bond);
 	if (!(bond_dev->features & NETIF_F_VLAN_CHALLENGED) &&


