Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaHQNSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:18:12 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:59279 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaHQNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:18:10 -0400
Date: Sun, 17 Aug 2014 16:18:02 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] mac80211: Replace rcu_dereference() with rcu_access_pointer()
Message-ID: <20140817131801.GA24286@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "rcu_dereference()" calls are used directly in conditions.
Since their return values are never dereferenced it is recommended to
use "rcu_access_pointer()" instead of "rcu_dereference()".
Therefore, this patch makes the replacements.

The following Coccinelle semantic patch was used:
@@
@@

(
 if(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
|
 while(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 net/mac80211/mesh_pathtbl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index cf032a8..a6699dc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -729,7 +729,7 @@ void mesh_plink_broken(struct sta_info *sta)
 	tbl = rcu_dereference(mesh_paths);
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
-		if (rcu_dereference(mpath->next_hop) == sta &&
+		if (rcu_access_pointer(mpath->next_hop) == sta &&
 		    mpath->flags & MESH_PATH_ACTIVE &&
 		    !(mpath->flags & MESH_PATH_FIXED)) {
 			spin_lock_bh(&mpath->state_lock);
@@ -794,7 +794,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	tbl = resize_dereference_mesh_paths();
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
-		if (rcu_dereference(mpath->next_hop) == sta) {
+		if (rcu_access_pointer(mpath->next_hop) == sta) {
 			spin_lock(&tbl->hashwlock[i]);
 			__mesh_path_del(tbl, node);
 			spin_unlock(&tbl->hashwlock[i]);
-- 
1.9.1

