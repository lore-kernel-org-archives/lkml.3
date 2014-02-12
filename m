Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaBLIT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:19:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50297 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbaBLIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:10 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eryu Guan" <guaneryu@gmail.com>,
        "=?UTF-8?Q?Luk=C3=A1=C5=A1=20?=Czerner" <lczerner@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.31912527@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 34/79] ext4: check for overlapping extents in
 ext4_valid_extent_entries()
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eryu Guan <guaneryu@gmail.com>

commit 5946d089379a35dda0e531710b48fca05446a196 upstream.

A corrupted ext4 may have out of order leaf extents, i.e.

extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
             ^^^^ overlap with previous extent

Reading such extent could hit BUG_ON() in ext4_es_cache_extent().

	BUG_ON(end < lblk);

The problem is that __read_extent_tree_block() tries to cache holes as
well but assumes 'lblk' is greater than 'prev' and passes underflowed
length to ext4_es_cache_extent(). Fix it by checking for overlapping
extents in ext4_valid_extent_entries().

I hit this when fuzz testing ext4, and am able to reproduce it by
modifying the on-disk extent by hand.

Also add the check for (ee_block + len - 1) in ext4_valid_extent() to
make sure the value is not overflow.

Ran xfstests on patched ext4 and no regression.

Cc: Lukáš Czerner <lczerner@redhat.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -318,8 +318,10 @@ static int ext4_valid_extent(struct inod
 {
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
 	int len = ext4_ext_get_actual_len(ext);
+	ext4_lblk_t lblock = le32_to_cpu(ext->ee_block);
+	ext4_lblk_t last = lblock + len - 1;
 
-	if (len == 0)
+	if (lblock > last)
 		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
@@ -345,11 +347,26 @@ static int ext4_valid_extent_entries(str
 	if (depth == 0) {
 		/* leaf entries */
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
+		struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+		ext4_fsblk_t pblock = 0;
+		ext4_lblk_t lblock = 0;
+		ext4_lblk_t prev = 0;
+		int len = 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
+
+			/* Check for overlapping extents */
+			lblock = le32_to_cpu(ext->ee_block);
+			len = ext4_ext_get_actual_len(ext);
+			if ((lblock <= prev) && prev) {
+				pblock = ext4_ext_pblock(ext);
+				es->s_last_error_block = cpu_to_le64(pblock);
+				return 0;
+			}
 			ext++;
 			entries--;
+			prev = lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);

