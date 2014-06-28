Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaF1Ruw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaF1Rup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 104/110] btrfs: fix lockdep warning with reclaim lock inversion
Date: Sat, 28 Jun 2014 10:47:41 -0700
Message-Id: <20140628174551.558185207@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit ed55b6ac077fe7f9c6490ff55172c4b563562d7c upstream.

When encountering memory pressure, testers have run into the following
lockdep warning. It was caused by __link_block_group calling kobject_add
with the groups_sem held. kobject_add calls kvasprintf with GFP_KERNEL,
which gets us into reclaim context. The kobject doesn't actually need
to be added under the lock -- it just needs to ensure that it's only
added for the first block group to be linked.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.14.0-rc8-default #1 Not tainted
---------------------------------------------------------
kswapd0/169 just changed the state of lock:
 (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa018baea>] __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
but this lock took another, RECLAIM_FS-unsafe lock in the past:
 (&found->groups_sem){+++++.}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&found->groups_sem);
                               local_irq_disable();
                               lock(&delayed_node->mutex);
                               lock(&found->groups_sem);
  <Interrupt>
    lock(&delayed_node->mutex);

 *** DEADLOCK ***
2 locks held by kswapd0/169:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81159e8a>] shrink_slab+0x3a/0x160
 #1:  (&type->s_umount_key#27){++++..}, at: [<ffffffff811bac6f>] grab_super_passive+0x3f/0x90

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8344,9 +8344,15 @@ static void __link_block_group(struct bt
 			       struct btrfs_block_group_cache *cache)
 {
 	int index = get_block_group_index(cache);
+	bool first = false;
 
 	down_write(&space_info->groups_sem);
-	if (list_empty(&space_info->block_groups[index])) {
+	if (list_empty(&space_info->block_groups[index]))
+		first = true;
+	list_add_tail(&cache->list, &space_info->block_groups[index]);
+	up_write(&space_info->groups_sem);
+
+	if (first) {
 		struct kobject *kobj = &space_info->block_group_kobjs[index];
 		int ret;
 
@@ -8358,8 +8364,6 @@ static void __link_block_group(struct bt
 			kobject_put(&space_info->kobj);
 		}
 	}
-	list_add_tail(&cache->list, &space_info->block_groups[index]);
-	up_write(&space_info->groups_sem);
 }
 
 static struct btrfs_block_group_cache *


