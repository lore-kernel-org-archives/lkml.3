Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaAOVyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaAOVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Curt Brune <curt@cumulusnetworks.com>,
        Scott Feldman <sfeldma@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 166/166] bridge: use spin_lock_bh() in br_multicast_set_hash_max
Date: Wed, 15 Jan 2014 13:53:00 -0800
Message-Id: <1389822780-4729-167-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_multicast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4a51874..fda703b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1812,7 +1812,7 @@ int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val)
 	u32 old;
 	struct net_bridge_mdb_htable *mdb;
 
-	spin_lock(&br->multicast_lock);
+	spin_lock_bh(&br->multicast_lock);
 	if (!netif_running(br->dev))
 		goto unlock;
 
@@ -1844,7 +1844,7 @@ rollback:
 	}
 
 unlock:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock_bh(&br->multicast_lock);
 
 	return err;
 }
-- 
1.8.3.2

