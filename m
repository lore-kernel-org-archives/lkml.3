Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaDAOPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaDAOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:15:41 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        hadi@mojatatu.com, davem@davemloft.net
Subject: [PATCH 3/3] netlink: implement unbind to netlink_setsockopt NETLINK_DROP_MEMBERSHIP
Date: Tue,  1 Apr 2014 10:14:58 -0400
Message-Id: <c050da1200ba5811b94bd1543728c7b90aafdb0f.1396317747.git.rgb@redhat.com>
In-Reply-To: <20140324183406.GE28666@madcap2.tricolour.ca>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
In-Reply-To: <cover.1396317747.git.rgb@redhat.com>
References: <cover.1396317747.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the per-protocol unbind function rather than bind function on
NETLINK_DROP_MEMBERSHIP in netlink_setsockopt().

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netlink/af_netlink.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9ae6e0f..3938138 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2109,7 +2109,7 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 			return err;
 		if (!val || val - 1 >= nlk->ngroups)
 			return -EINVAL;
-		if (nlk->netlink_bind) {
+		if (optname == NETLINK_ADD_MEMBERSHIP && nlk->netlink_bind) {
 			err = nlk->netlink_bind(val);
 			if (err)
 				return err;
@@ -2118,6 +2118,8 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 		netlink_update_socket_mc(nlk, val,
 					 optname == NETLINK_ADD_MEMBERSHIP);
 		netlink_table_ungrab();
+		if (optname == NETLINK_DROP_MEMBERSHIP && nlk->netlink_unbind)
+			nlk->netlink_unbind(val);
 
 		err = 0;
 		break;
-- 
1.7.1

