Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3CDDpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:45:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab3CDDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:56 -0500
Message-Id: <20130304033709.644909876@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Niu Yawei <yawei.niu@gmail.com>,
        Niu Yawei <yawei.niu@intel.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 021/153] ext4: fix race in ext4_mb_add_n_trim()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niu Yawei <yawei.niu@gmail.com>

commit f1167009711032b0d747ec89a632a626c901a1ad upstream.

In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
changing the lg_prealloc_list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4178,7 +4178,7 @@ static void ext4_mb_add_n_trim(struct ex
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 	/* Add the prealloc space to lg */
-	rcu_read_lock();
+	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
@@ -4202,12 +4202,12 @@ static void ext4_mb_add_n_trim(struct ex
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


