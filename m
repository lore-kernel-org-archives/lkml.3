Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab3B1PEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:04:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3B1OtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Niu Yawei <yawei.niu@intel.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 087/139] ext4: fix race in ext4_mb_add_n_trim()
Date: Thu, 28 Feb 2013 14:43:57 +0000
Message-Id: <1362062689-2567-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niu Yawei <yawei.niu@gmail.com>

commit f1167009711032b0d747ec89a632a626c901a1ad upstream.

In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
changing the lg_prealloc_list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/mballoc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index af848bb..b5f8b5f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4123,7 +4123,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 	/* Add the prealloc space to lg */
-	rcu_read_lock();
+	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
@@ -4147,12 +4147,12 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
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
1.8.1.2

