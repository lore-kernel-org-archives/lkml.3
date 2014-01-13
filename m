Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaAMRGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:06:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaAMQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>,
        Eryu Guan <guaneryu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/208] ext4: check for overlapping extents in ext4_valid_extent_entries()
Date: Mon, 13 Jan 2014 15:57:50 +0000
Message-Id: <1389628849-1614-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 72ba470..f2eace4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -360,8 +360,10 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
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
@@ -387,11 +389,26 @@ static int ext4_valid_extent_entries(struct inode *inode,
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
-- 
1.8.3.2

