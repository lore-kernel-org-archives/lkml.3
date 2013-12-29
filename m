Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3L2C4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:56:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55009 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901Ab3L2CKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stefan Priebe" <s.priebe@profihost.ag>,
        "David S. Miller" <davem@davemloft.net>,
        "Veaceslav Falico" <vfalico@redhat.com>,
        "Vlad Yasevich" <vyasevic@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.467882501@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 165/185] net: core: Always propagate flag changes to
 interfaces
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit d2615bf450694c1302d86b9cc8a8958edfe4c3a4 ]

The following commit:
    b6c40d68ff6498b7f63ddf97cf0aa818d748dee7
    net: only invoke dev->change_rx_flags when device is UP

tried to fix a problem with VLAN devices and promiscuouse flag setting.
The issue was that VLAN device was setting a flag on an interface that
was down, thus resulting in bad promiscuity count.
This commit blocked flag propagation to any device that is currently
down.

A later commit:
    deede2fabe24e00bd7e246eb81cd5767dc6fcfc7
    vlan: Don't propagate flag changes on down interfaces

fixed VLAN code to only propagate flags when the VLAN interface is up,
thus fixing the same issue as above, only localized to VLAN.

The problem we have now is that if we have create a complex stack
involving multiple software devices like bridges, bonds, and vlans,
then it is possible that the flags would not propagate properly to
the physical devices.  A simple examle of the scenario is the
following:

  eth0----> bond0 ----> bridge0 ---> vlan50

If bond0 or eth0 happen to be down at the time bond0 is added to
the bridge, then eth0 will never have promisc mode set which is
currently required for operation as part of the bridge.  As a
result, packets with vlan50 will be dropped by the interface.

The only 2 devices that implement the special flag handling are
VLAN and DSA and they both have required code to prevent incorrect
flag propagation.  As a result we can remove the generic solution
introduced in b6c40d68ff6498b7f63ddf97cf0aa818d748dee7 and leave
it to the individual devices to decide whether they will block
flag propagation or not.

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Suggested-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8e455b8..ecf5ea2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4515,7 +4515,7 @@ static void dev_change_rx_flags(struct net_device *dev, int flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
-	if ((dev->flags & IFF_UP) && ops->ndo_change_rx_flags)
+	if (ops->ndo_change_rx_flags)
 		ops->ndo_change_rx_flags(dev, flags);
 }
 

