Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaFGB0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:26:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbaFGBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chuansheng Liu" <chuansheng.liu@intel.com>,
        "Zhang Dongxing" <dongxing.zhang@intel.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.70997805@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 11/92] net: ipv4: current group_info should be put
 after  using.
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ping.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 00975b6..d495d4b 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -203,26 +203,33 @@ static int ping_init_sock(struct sock *sk)
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

