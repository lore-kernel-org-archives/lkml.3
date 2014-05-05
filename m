Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbaEEMxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40994 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 22/50] net: ipv4: current group_info should be put after using.
Date: Mon,  5 May 2014 14:43:04 +0200
Message-Id: <95c3a5624ae783081cc9d9b0e3d24ea19b36590e.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Wang, Xiaoming" <xiaoming.wang@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b04c46190219a4f845e46a459e3102137b7f6cac upstream.

Plug a group_info refcount leak in ping_init.
group_info is only needed during initialization and
the code failed to release the reference on exit.
While here move grabbing the reference to a place
where it is actually needed.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ping.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index c482f7c7dd32..c211607b79b3 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -249,26 +249,33 @@ int ping_init_sock(struct sock *sk)
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
1.9.2

