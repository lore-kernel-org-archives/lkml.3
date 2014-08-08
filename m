Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaHHUqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:46:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825AbaHHUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 247/259] igmp: fix the problem when mc leave group
Date: Fri,  8 Aug 2014 13:41:10 -0700
Message-Id: <1407530482-4483-248-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/igmp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7defdc9..9fa5c09 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1952,6 +1952,10 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
 	rtnl_lock();
 	in_dev = ip_mc_find_dev(net, imr);
+	if (!in_dev) {
+		ret = -ENODEV;
+		goto out;
+	}
 	ifindex = imr->imr_ifindex;
 	for (imlp = &inet->mc_list;
 	     (iml = rtnl_dereference(*imlp)) != NULL;
@@ -1969,16 +1973,14 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
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
-- 
1.9.1

