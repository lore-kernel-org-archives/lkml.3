Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab3GCSwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:52:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab3GCSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:58 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6C8l3DIK6zAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=7eXZtQmfIM4A:10 a=wofhx-goAAAA:8 a=xNf9USuDAAAA:8 a=wCmvBT1CAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=O_yJVddqQ4Dbivp_pXsA:9 a=8HaUlT0CE8IA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=8mtiZQvladvyp_aR:21 a=-M1kUBe57bGTxWaE:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184049.201399069@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Anthony Doggett <Anthony2486@interfaces.org.uk>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [028/141] nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0028-nilfs2-fix-issue-of-nilfs_set_page_dirty-for-page-at.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

[ Upstream commit 136e8770cd5d1fe38b3c613100dd6dc4db6d4fa6 ]

nilfs2: fix issue of nilfs_set_page_dirty for page at EOF boundary

DESCRIPTION:
 There are use-cases when NILFS2 file system (formatted with block size
lesser than 4 KB) can be remounted in RO mode because of encountering of
"broken bmap" issue.

The issue was reported by Anthony Doggett <Anthony2486@interfaces.org.uk>:
 "The machine I've been trialling nilfs on is running Debian Testing,
  Linux version 3.2.0-4-686-pae (debian-kernel@lists.debian.org) (gcc
  version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.35-2), but I've
  also reproduced it (identically) with Debian Unstable amd64 and Debian
  Experimental (using the 3.8-trunk kernel).  The problematic partitions
  were formatted with "mkfs.nilfs2 -b 1024 -B 8192"."

SYMPTOMS:
(1) System log contains error messages likewise:

    [63102.496756] nilfs_direct_assign: invalid pointer: 0
    [63102.496786] NILFS error (device dm-17): nilfs_bmap_assign: broken bmap (inode number=28)
    [63102.496798]
    [63102.524403] Remounting filesystem read-only

(2) The NILFS2 file system is remounted in RO mode.

REPRODUSING PATH:
(1) Create volume group with name "unencrypted" by means of vgcreate utility.
(2) Run script (prepared by Anthony Doggett <Anthony2486@interfaces.org.uk>):

----------------[BEGIN SCRIPT]--------------------

VG=unencrypted
lvcreate --size 2G --name ntest $VG
mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
mkdir /var/tmp/n
mkdir /var/tmp/n/ntest
mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
mkdir /var/tmp/n/ntest/thedir
cd /var/tmp/n/ntest/thedir
sleep 2
date
darcs init
sleep 2
dmesg|tail -n 5
date
darcs whatsnew || true
date
sleep 2
dmesg|tail -n 5
----------------[END SCRIPT]--------------------

REPRODUCIBILITY: 100%

INVESTIGATION:
As it was discovered, the issue takes place during segment
construction after executing such sequence of user-space operations:

  open("_darcs/index", O_RDWR|O_CREAT|O_NOCTTY, 0666) = 7
  fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
  ftruncate(7, 60)

The error message "NILFS error (device dm-17): nilfs_bmap_assign: broken
bmap (inode number=28)" takes place because of trying to get block
number for third block of the file with logical offset #3072 bytes.  As
it is possible to see from above output, the file has 60 bytes of the
whole size.  So, it is enough one block (1 KB in size) allocation for
the whole file.  Trying to operate with several blocks instead of one
takes place because of discovering several dirty buffers for this file
in nilfs_segctor_scan_file() method.

The root cause of this issue is in nilfs_set_page_dirty function which
is called just before writing to an mmapped page.

When nilfs_page_mkwrite function handles a page at EOF boundary, it
fills hole blocks only inside EOF through __block_page_mkwrite().

The __block_page_mkwrite() function calls set_page_dirty() after filling
hole blocks, thus nilfs_set_page_dirty function (=
a_ops->set_page_dirty) is called.  However, the current implementation
of nilfs_set_page_dirty() wrongly marks all buffers dirty even for page
at EOF boundary.

As a result, buffers outside EOF are inconsistently marked dirty and
queued for write even though they are not mapped with nilfs_get_block
function.

FIX:
This modifies nilfs_set_page_dirty() not to mark hole blocks dirty.

Thanks to Vyacheslav Dubeyko for his effort on analysis and proposals
for this issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Reported-by: Anthony Doggett <Anthony2486@interfaces.org.uk>
Reported-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nilfs2/inode.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6e2c3db..cbda0a4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -202,13 +202,32 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 
 static int nilfs_set_page_dirty(struct page *page)
 {
-	int ret = __set_page_dirty_buffers(page);
+	int ret = __set_page_dirty_nobuffers(page);
 
-	if (ret) {
+	if (page_has_buffers(page)) {
 		struct inode *inode = page->mapping->host;
-		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+		unsigned nr_dirty = 0;
+		struct buffer_head *bh, *head;
 
-		nilfs_set_file_dirty(inode, nr_dirty);
+		/*
+		 * This page is locked by callers, and no other thread
+		 * concurrently marks its buffers dirty since they are
+		 * only dirtied through routines in fs/buffer.c in
+		 * which call sites of mark_buffer_dirty are protected
+		 * by page lock.
+		 */
+		bh = head = page_buffers(page);
+		do {
+			/* Do not mark hole blocks dirty */
+			if (buffer_dirty(bh) || !buffer_mapped(bh))
+				continue;
+
+			set_buffer_dirty(bh);
+			nr_dirty++;
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (nr_dirty)
+			nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
-- 
1.7.10.4


