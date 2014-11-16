Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaKPWHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:07:05 -0500
Received: from 1wt.eu ([62.212.114.60]:47956 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaKPWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:08 -0500
Message-Id: <20141116215329.308351319@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:44 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 16/48] igmp: fix the problem when mc leave group
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/igmp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index c07be7c..04d40ab 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1841,6 +1841,10 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
 	rtnl_lock();
 	in_dev = ip_mc_find_dev(net, imr);
+	if (!in_dev) {
+		ret = -ENODEV;
+		goto out;
+	}
 	ifindex = imr->imr_ifindex;
 	for (imlp = &inet->mc_list; (iml = *imlp) != NULL; imlp = &iml->next) {
 		if (iml->multi.imr_multiaddr.s_addr != group)
@@ -1856,14 +1860,12 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
 		*imlp = iml->next;
 
-		if (in_dev)
-			ip_mc_dec_group(in_dev, group);
+		ip_mc_dec_group(in_dev, group);
 		rtnl_unlock();
 		sock_kfree_s(sk, iml, sizeof(*iml));
 		return 0;
 	}
-	if (!in_dev)
-		ret = -ENODEV;
+ out:
 	rtnl_unlock();
 	return ret;
 }
-- 
1.7.12.2.21.g234cd45.dirty



