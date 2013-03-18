Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3CREq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:46:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33460 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab3CREaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:21 -0400
Message-Id: <20130318042151.713976199@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:23:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Laszlo Ersek <lersek@redhat.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 77/82] xen-netfront: delay gARP until backend switches to Connected
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laszlo Ersek <lersek@redhat.com>

commit 08e34eb14fe4cfd934b5c169a7682a969457c4ea upstream.

After a guest is live migrated, the xen-netfront driver emits a gratuitous
ARP message, so that networking hardware on the target host's subnet can
take notice, and public routing to the guest is re-established. However,
if the packet appears on the backend interface before the backend is added
to the target host's bridge, the packet is lost, and the migrated guest's
peers become unable to talk to the guest.

A sufficient two-parts condition to prevent the above is:

(1) ensure that the backend only moves to Connected xenbus state after its
hotplug scripts completed, ie. the netback interface got added to the
bridge; and

(2) ensure the frontend only queues the gARP when it sees the backend move
to Connected.

These two together provide complete ordering. Sub-condition (1) is already
satisfied by commit f942dc2552b8 in Linus' tree, based on commit
6b0b80ca7165 from [1].

In general, the full condition is sufficient, not necessary, because,
according to [2], live migration has been working for a long time without
satisfying sub-condition (2). However, after 6b0b80ca7165 was backported
to the RHEL-5 host to ensure (1), (2) still proved necessary in the RHEL-6
guest. This patch intends to provide (2) for upstream.

The Reviewed-by line comes from [3].

[1] git://xenbits.xen.org/people/ianc/linux-2.6.git#upstream/dom0/backend/netback-history
[2] http://old-list-archives.xen.org/xen-devel/2011-06/msg01969.html
[3] http://old-list-archives.xen.org/xen-devel/2011-07/msg00484.html

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netfront.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1707,7 +1707,6 @@ static void netback_changed(struct xenbu
 	case XenbusStateInitialised:
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
-	case XenbusStateConnected:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
@@ -1718,6 +1717,9 @@ static void netback_changed(struct xenbu
 		if (xennet_connect(netdev) != 0)
 			break;
 		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
 		netif_notify_peers(netdev);
 		break;
 


