Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab3CNRyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:54:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:1032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934560Ab3CNRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="270892713"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 03/30] mm: drop actor argument of do_generic_file_read()
Date: Thu, 14 Mar 2013 19:50:08 +0200
Message-Id: <1363283435-7666-4-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

There's only one caller of do_generic_file_read() and the only actor is
file_read_actor(). No reason to have a callback parameter.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4ebaf95..2d99191 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1075,7 +1075,6 @@ static void shrink_readahead_size_eio(struct file *filp,
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
- * @actor:	read method
  *
  * This is a generic file read routine, and uses the
  * mapping->a_ops->readpage() function for the actual low-level stuff.
@@ -1084,7 +1083,7 @@ static void shrink_readahead_size_eio(struct file *filp,
  * of the logic when it comes to error handling etc.
  */
 static void do_generic_file_read(struct file *filp, loff_t *ppos,
-		read_descriptor_t *desc, read_actor_t actor)
+		read_descriptor_t *desc)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1185,13 +1184,14 @@ page_ok:
 		 * Ok, we have the page, and it's up-to-date, so
 		 * now we can copy it to user space...
 		 *
-		 * The actor routine returns how many bytes were actually used..
+		 * The file_read_actor routine returns how many bytes were
+		 * actually used..
 		 * NOTE! This may not be the same as how much of a user buffer
 		 * we filled up (we may be padding etc), so we can only update
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = actor(desc, page, offset, nr);
+		ret = file_read_actor(desc, page, offset, nr);
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
@@ -1464,7 +1464,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		if (desc.count == 0)
 			continue;
 		desc.error = 0;
-		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		do_generic_file_read(filp, ppos, &desc);
 		retval += desc.written;
 		if (desc.error) {
 			retval = retval ?: desc.error;
-- 
1.7.10.4

