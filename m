Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaBLIWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:22:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50286 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbaBLIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:09 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Junho Ryu" <jayr@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.473428542@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 33/79] ext4: fix use-after-free in ext4_mb_new_blocks
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3378,6 +3378,9 @@ static void ext4_mb_pa_callback(struct r
 {
 	struct ext4_prealloc_space *pa;
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
+
+	BUG_ON(atomic_read(&pa->pa_count));
+	BUG_ON(pa->pa_deleted == 0);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
 
@@ -3391,11 +3394,13 @@ static void ext4_mb_put_pa(struct ext4_a
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

