Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaBLIgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:36:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50088 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaBLINv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:51 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Curt Brune" <curt@cumulusnetworks.com>,
        "Scott Feldman" <sfeldma@cumulusnetworks.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.19997116@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 14/79] bridge: use spin_lock_bh() in br_multicast_set_hash_max
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Curt Brune <curt@cumulusnetworks.com>

[ Upstream commit fe0d692bbc645786bce1a98439e548ae619269f5 ]

br_multicast_set_hash_max() is called from process context in
net/bridge/br_sysfs_br.c by the sysfs store_hash_max() function.

br_multicast_set_hash_max() calls spin_lock(&br->multicast_lock),
which can deadlock the CPU if a softirq that also tries to take the
same lock interrupts br_multicast_set_hash_max() while the lock is
held .  This can happen quite easily when any of the bridge multicast
timers expire, which try to take the same lock.

The fix here is to use spin_lock_bh(), preventing other softirqs from
executing on this CPU.

Steps to reproduce:

1. Create a bridge with several interfaces (I used 4).
2. Set the "multicast query interval" to a low number, like 2.
3. Enable the bridge as a multicast querier.
4. Repeatedly set the bridge hash_max parameter via sysfs.

  # brctl addbr br0
  # brctl addif br0 eth1 eth2 eth3 eth4
  # brctl setmcqi br0 2
  # brctl setmcquerier br0 1

  # while true ; do echo 4096 > /sys/class/net/br0/bridge/hash_max; done

Signed-off-by: Curt Brune <curt@cumulusnetworks.com>
Signed-off-by: Scott Feldman <sfeldma@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_multicast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index a06deca..2157984 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1743,7 +1743,7 @@ int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val)
 	u32 old;
 	struct net_bridge_mdb_htable *mdb;
 
-	spin_lock(&br->multicast_lock);
+	spin_lock_bh(&br->multicast_lock);
 	if (!netif_running(br->dev))
 		goto unlock;
 
@@ -1775,7 +1775,7 @@ rollback:
 	}
 
 unlock:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock_bh(&br->multicast_lock);
 
 	return err;
 }

