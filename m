Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaFQWxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:53:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490AbaFQVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>,
        xiaoming wang <xiaoming.wang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 012/212] net: ipv4: current group_info should be put after using.
Date: Tue, 17 Jun 2014 14:41:46 -0700
Message-Id: <1403041506-13646-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ping.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 242e7f4..3ef2919 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -248,26 +248,33 @@ int ping_init_sock(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 	kgid_t group = current_egid();
-	struct group_info *group_info = get_current_groups();
-	int i, j, count = group_info->ngroups;
+	struct group_info *group_info;
+	int i, j, count;
 	kgid_t low, high;
+	int ret = 0;
 
 	inet_get_ping_group_range_net(net, &low, &high);
 	if (gid_lte(low, group) && gid_lte(group, high))
 		return 0;
 
+	group_info = get_current_groups();
+	count = group_info->ngroups;
 	for (i = 0; i < group_info->nblocks; i++) {
 		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
 		for (j = 0; j < cp_count; j++) {
 			kgid_t gid = group_info->blocks[i][j];
 			if (gid_lte(low, gid) && gid_lte(gid, high))
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
 EXPORT_SYMBOL_GPL(ping_init_sock);
 
-- 
1.9.1

