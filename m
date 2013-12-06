Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422812Ab3LFWbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:31:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab3LFVw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Priebe <s.priebe@profihost.ag>,
        Veaceslav Falico <vfalico@redhat.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 42/83] net: core: Always propagate flag changes to interfaces
Date: Fri,  6 Dec 2013 13:51:32 -0800
Message-Id: <20131206214643.972908394@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4815,7 +4815,7 @@ static void dev_change_rx_flags(struct n
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
-	if ((dev->flags & IFF_UP) && ops->ndo_change_rx_flags)
+	if (ops->ndo_change_rx_flags)
 		ops->ndo_change_rx_flags(dev, flags);
 }
 


