Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaFXUQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:16:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:65467 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaFXUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:16:15 -0400
Subject: [PATCH 2/3] shmem: update memory reservation on truncate
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 00:16:10 +0400
Message-ID: <20140624201610.18273.93645.stgit@zurg>
In-Reply-To: <20140624201606.18273.44270.stgit@zurg>
References: <20140624201606.18273.44270.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shared anonymous mapping created without MAP_NORESERVE holds memory
reservation for whole range of shmem segment. Usually there is no way to
change its size, but /proc/<pid>/map_files/...
(available if CONFIG_CHECKPOINT_RESTORE=y) allows to do that.

This patch adjust memory reservation in shmem_setattr().

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

---

exploit:

#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	unsigned long addr;
	char path[100];

	/* charge 4KiB */
	addr = (unsigned long)mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
	sprintf(path, "/proc/self/map_files/%lx-%lx", addr, addr + 4096);
	truncate(path, 1 << 30);
	/* uncharge 1GiB */
}
---
 mm/shmem.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0aabcbd..a3c49d6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -149,6 +149,19 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
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
@@ -543,6 +556,10 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 		loff_t newsize = attr->ia_size;
 
 		if (newsize != oldsize) {
+			error = shmem_reacct_size(SHMEM_I(inode)->flags,
+					oldsize, newsize);
+			if (error)
+				return error;
 			i_size_write(inode, newsize);
 			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 		}

