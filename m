Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaAMO1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51278 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaAMOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Junho Ryu <jayr@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 25/96] ext4: fix use-after-free in ext4_mb_new_blocks
Date: Mon, 13 Jan 2014 14:23:48 +0000
Message-Id: <1389623099-18783-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junho Ryu <jayr@google.com>

commit 4e8d2139802ce4f41936a687f06c560b12115247 upstream.

ext4_mb_put_pa should hold pa->pa_lock before accessing pa->pa_count.
While ext4_mb_use_preallocated checks pa->pa_deleted first and then
increments pa->count later, ext4_mb_put_pa decrements pa->pa_count
before holding pa->pa_lock and then sets pa->pa_deleted.

* Free sequence
ext4_mb_put_pa (1):		atomic_dec_and_test pa->pa_count
ext4_mb_put_pa (2):		lock pa->pa_lock
ext4_mb_put_pa (3):			check pa->pa_deleted
ext4_mb_put_pa (4):			set pa->pa_deleted=1
ext4_mb_put_pa (5):		unlock pa->pa_lock
ext4_mb_put_pa (6):		remove pa from a list
ext4_mb_pa_callback:		free pa

* Use sequence
ext4_mb_use_preallocated (1):	iterate over preallocation
ext4_mb_use_preallocated (2):	lock pa->pa_lock
ext4_mb_use_preallocated (3):		check pa->pa_deleted
ext4_mb_use_preallocated (4):		increase pa->pa_count
ext4_mb_use_preallocated (5):	unlock pa->pa_lock
ext4_mb_release_context:	access pa

* Use-after-free sequence
[initial status]		<pa->pa_deleted = 0, pa_count = 1>
ext4_mb_use_preallocated (1):	iterate over preallocation
ext4_mb_use_preallocated (2):	lock pa->pa_lock
ext4_mb_use_preallocated (3):		check pa->pa_deleted
ext4_mb_put_pa (1):		atomic_dec_and_test pa->pa_count
[pa_count decremented]		<pa->pa_deleted = 0, pa_count = 0>
ext4_mb_use_preallocated (4):		increase pa->pa_count
[pa_count incremented]		<pa->pa_deleted = 0, pa_count = 1>
ext4_mb_use_preallocated (5):	unlock pa->pa_lock
ext4_mb_put_pa (2):		lock pa->pa_lock
ext4_mb_put_pa (3):			check pa->pa_deleted
ext4_mb_put_pa (4):			set pa->pa_deleted=1
[race condition!]		<pa->pa_deleted = 1, pa_count = 1>
ext4_mb_put_pa (5):		unlock pa->pa_lock
ext4_mb_put_pa (6):		remove pa from a list
ext4_mb_pa_callback:		free pa
ext4_mb_release_context:	access pa

AddressSanitizer has detected use-after-free in ext4_mb_new_blocks
Bug report: http://goo.gl/rG1On3

Signed-off-by: Junho Ryu <jayr@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/mballoc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index aaece99..82489f4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3323,6 +3323,9 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
 {
 	struct ext4_prealloc_space *pa;
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
+
+	BUG_ON(atomic_read(&pa->pa_count));
+	BUG_ON(pa->pa_deleted == 0);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
 
@@ -3336,11 +3339,13 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	ext4_group_t grp;
 	ext4_fsblk_t grp_blk;
 
-	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
-		return;
-
 	/* in this short window concurrent discard can set pa_deleted */
 	spin_lock(&pa->pa_lock);
+	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0) {
+		spin_unlock(&pa->pa_lock);
+		return;
+	}
+
 	if (pa->pa_deleted == 1) {
 		spin_unlock(&pa->pa_lock);
 		return;
-- 
1.8.3.2

