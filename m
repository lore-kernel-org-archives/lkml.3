Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbaAFXbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:31:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbaAFWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Junho Ryu <jayr@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.10 030/129] ext4: fix use-after-free in ext4_mb_new_blocks
Date: Mon,  6 Jan 2014 14:37:39 -0800
Message-Id: <20140106223900.468443410@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3423,6 +3423,9 @@ static void ext4_mb_pa_callback(struct r
 {
 	struct ext4_prealloc_space *pa;
 	pa = container_of(head, struct ext4_prealloc_space, u.pa_rcu);
+
+	BUG_ON(atomic_read(&pa->pa_count));
+	BUG_ON(pa->pa_deleted == 0);
 	kmem_cache_free(ext4_pspace_cachep, pa);
 }
 
@@ -3436,11 +3439,13 @@ static void ext4_mb_put_pa(struct ext4_a
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


