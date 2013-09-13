Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3IMLCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:02:35 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:64107 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3IMLCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:02:32 -0400
Subject: [PATCH] shmem: fixup memory reservation during truncating
To: Hugh Dickins <hughd@google.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Sep 2013 15:02:24 +0400
Message-ID: <20130913110224.20826.74479.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shared anon mappings created without MAP_NORESERVE may hold reservation of
memory commitment for whole size of shmem segment. There was no way to change
that size, but recently introduced 'map_files' in proc allows to do that.
This patch adjust memory reservation in shmem_setattr() during truncating.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/shmem.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ff08920..a15c8dd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -148,6 +148,19 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
 		vm_unacct_memory(VM_ACCT(size));
 }
 
+static inline int shmem_reacct_size(unsigned long flags,
+		loff_t oldsize, loff_t newsize)
+{
+	if (!(flags & VM_NORESERVE)) {
+		if (VM_ACCT(newsize) > VM_ACCT(oldsize))
+			return security_vm_enough_memory_mm(current->mm,
+					VM_ACCT(newsize) - VM_ACCT(oldsize));
+		else if (VM_ACCT(newsize) < VM_ACCT(oldsize))
+			vm_unacct_memory(VM_ACCT(oldsize) - VM_ACCT(newsize));
+	}
+	return 0;
+}
+
 /*
  * ... whereas tmpfs objects are accounted incrementally as
  * pages are allocated, in order to allow huge sparse files.
@@ -607,6 +620,10 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 		loff_t newsize = attr->ia_size;
 
 		if (newsize != oldsize) {
+			error = shmem_reacct_size(SHMEM_I(inode)->flags,
+					oldsize, newsize);
+			if (error)
+				return error;
 			i_size_write(inode, newsize);
 			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 		}

