Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3FDXDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:03:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35634 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab3FDWnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:01 -0400
Message-Id: <20130604172135.613514601@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Niu Yawei <yawei.niu@intel.com>, "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 128/184] ext4: fix race in ext4_mb_add_n_trim()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Niu Yawei <yawei.niu@gmail.com>

commit f1167009711032b0d747ec89a632a626c901a1ad upstream.

In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
changing the lg_prealloc_list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/mballoc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 42bac1b..c7e8bdb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4163,7 +4163,7 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 	/* Add the prealloc space to lg */
-	rcu_read_lock();
+	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
@@ -4187,12 +4187,12 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
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
1.7.12.2.21.g234cd45.dirty



