Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaFEFPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:15:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaFEEUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>,
        xiaoming wang <xiaoming.wang@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 021/214] net: ipv4: current group_info should be put after using.
Date: Wed,  4 Jun 2014 21:16:24 -0700
Message-Id: <20140605041642.628323580@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Wang, Xiaoming" <xiaoming.wang@intel.com>

[ Upstream commit b04c46190219a4f845e46a459e3102137b7f6cac ]

Plug a group_info refcount leak in ping_init.
group_info is only needed during initialization and
the code failed to release the reference on exit.
While here move grabbing the reference to a place
where it is actually needed.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -203,26 +203,33 @@ static int ping_init_sock(struct sock *s
 	struct net *net = sock_net(sk);
 	gid_t group = current_egid();
 	gid_t range[2];
-	struct group_info *group_info = get_current_groups();
-	int i, j, count = group_info->ngroups;
+	struct group_info *group_info;
+	int i, j, count;
+	int ret = 0;
 
 	inet_get_ping_group_range_net(net, range, range+1);
 	if (range[0] <= group && group <= range[1])
 		return 0;
 
+	group_info = get_current_groups();
+	count = group_info->ngroups;
 	for (i = 0; i < group_info->nblocks; i++) {
 		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
 
 		for (j = 0; j < cp_count; j++) {
 			group = group_info->blocks[i][j];
 			if (range[0] <= group && group <= range[1])
-				return 0;
+				goto out_release_group;
 		}
 
 		count -= cp_count;
 	}
 
-	return -EACCES;
+	ret = -EACCES;
+
+out_release_group:
+	put_group_info(group_info);
+	return ret;
 }
 
 static void ping_close(struct sock *sk, long timeout)


