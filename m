Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaHDREi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "dingtianhong" <dingtianhong@huawei.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.206973968@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 57/94] igmp: fix the problem when mc leave group
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit 52ad353a5344f1f700c5b777175bdfa41d3cd65a ]

The problem was triggered by these steps:

1) create socket, bind and then setsockopt for add mc group.
   mreq.imr_multiaddr.s_addr = inet_addr("255.0.0.37");
   mreq.imr_interface.s_addr = inet_addr("192.168.1.2");
   setsockopt(sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq));

2) drop the mc group for this socket.
   mreq.imr_multiaddr.s_addr = inet_addr("255.0.0.37");
   mreq.imr_interface.s_addr = inet_addr("0.0.0.0");
   setsockopt(sockfd, IPPROTO_IP, IP_DROP_MEMBERSHIP, &mreq, sizeof(mreq));

3) and then drop the socket, I found the mc group was still used by the dev:

   netstat -g

   Interface       RefCnt Group
   --------------- ------ ---------------------
   eth2		   1	  255.0.0.37

Normally even though the IP_DROP_MEMBERSHIP return error, the mc group still need
to be released for the netdev when drop the socket, but this process was broken when
route default is NULL, the reason is that:

The ip_mc_leave_group() will choose the in_dev by the imr_interface.s_addr, if input addr
is NULL, the default route dev will be chosen, then the ifindex is got from the dev,
then polling the inet->mc_list and return -ENODEV, but if the default route dev is NULL,
the in_dev and ifIndex is both NULL, when polling the inet->mc_list, the mc group will be
released from the mc_list, but the dev didn't dec the refcnt for this mc group, so
when dropping the socket, the mc_list is NULL and the dev still keep this group.

v1->v2: According Hideaki's suggestion, we should align with IPv6 (RFC3493) and BSDs,
	so I add the checking for the in_dev before polling the mc_list, make sure when
	we remove the mc group, dec the refcnt to the real dev which was using the mc address.
	The problem would never happened again.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/igmp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 75b0860..7f7e670 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1862,6 +1862,10 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
 	rtnl_lock();
 	in_dev = ip_mc_find_dev(net, imr);
+	if (!in_dev) {
+		ret = -ENODEV;
+		goto out;
+	}
 	ifindex = imr->imr_ifindex;
 	for (imlp = &inet->mc_list;
 	     (iml = rtnl_dereference(*imlp)) != NULL;
@@ -1879,16 +1883,14 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
 		*imlp = iml->next_rcu;
 
-		if (in_dev)
-			ip_mc_dec_group(in_dev, group);
+		ip_mc_dec_group(in_dev, group);
 		rtnl_unlock();
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
 		kfree_rcu(iml, rcu);
 		return 0;
 	}
-	if (!in_dev)
-		ret = -ENODEV;
+out:
 	rtnl_unlock();
 	return ret;
 }

