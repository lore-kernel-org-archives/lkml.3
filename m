Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaBEUVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:21:17 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48554 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaBEUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:42 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Niu Yawei <yawei.niu@gmail.com>, Niu Yawei <yawei.niu@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 179/213] ext4: fix race in ext4_mb_add_n_trim()
Date: Wed, 5 Feb 2014 15:02:14 -0500
Message-ID: <1391630568-49251-180-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niu Yawei <yawei.niu@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f1167009711032b0d747ec89a632a626c901a1ad upstream.

In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
changing the lg_prealloc_list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/mballoc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f1c9a84c50a3..5e440caf82de 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4153,7 +4153,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 	/* Add the prealloc space to lg */
-	rcu_read_lock();
+	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
@@ -4177,12 +4177,12 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 	if (!added)
 		list_add_tail_rcu(&pa->pa_inode_list,
 					&lg->lg_prealloc_list[order]);
-	rcu_read_unlock();
+	spin_unlock(&lg->lg_prealloc_lock);
 
 	/* Now trim the list to be not more than 8 elements */
 	if (lg_prealloc_count > 8) {
 		ext4_mb_discard_lg_preallocations(sb, lg,
-						order, lg_prealloc_count);
+						  order, lg_prealloc_count);
 		return;
 	}
 	return ;
-- 
1.8.5.2

