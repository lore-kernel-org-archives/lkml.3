Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3CATqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3CATqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Niu Yawei <yawei.niu@intel.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 15/30] ext4: fix race in ext4_mb_add_n_trim()
Date: Fri,  1 Mar 2013 11:45:36 -0800
Message-Id: <20130301194529.629495863@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niu Yawei <yawei.niu@gmail.com>

commit f1167009711032b0d747ec89a632a626c901a1ad upstream.

In ext4_mb_add_n_trim(), lg_prealloc_lock should be taken when
changing the lg_prealloc_list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4111,7 +4111,7 @@ static void ext4_mb_add_n_trim(struct ex
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 	/* Add the prealloc space to lg */
-	rcu_read_lock();
+	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
@@ -4135,12 +4135,12 @@ static void ext4_mb_add_n_trim(struct ex
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


