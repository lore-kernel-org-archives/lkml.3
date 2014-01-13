Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaAMQDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaAMQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rik van Riel <riel@redhat.com>, PaX Team <pageexec@freemail.hu>,
        Kees Cook <keescook@chromium.org>,
        Michel Lespinasse <walken@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 098/208] mm: fix use-after-free in sys_remap_file_pages
Date: Mon, 13 Jan 2014 15:58:59 +0000
Message-Id: <1389628849-1614-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@redhat.com>

commit 4eb919825e6c3c7fb3630d5621f6d11e98a18b3a upstream.

remap_file_pages calls mmap_region, which may merge the VMA with other
existing VMAs, and free "vma".  This can lead to a use-after-free bug.
Avoid the bug by remembering vm_flags before calling mmap_region, and
not trying to dereference vma later.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/fremap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 5bff081..bbc4d66 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -208,9 +208,10 @@ get_write_lock:
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
+			/* mmap_region may free vma; grab the info now */
+			vm_flags = vma->vm_flags;
 
-			addr = mmap_region(file, start, size,
-					vma->vm_flags, pgoff);
+			addr = mmap_region(file, start, size, vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
@@ -218,7 +219,7 @@ get_write_lock:
 				BUG_ON(addr != start);
 				err = 0;
 			}
-			goto out;
+			goto out_freed;
 		}
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
@@ -253,6 +254,7 @@ get_write_lock:
 out:
 	if (vma)
 		vm_flags = vma->vm_flags;
+out_freed:
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else
-- 
1.8.3.2

