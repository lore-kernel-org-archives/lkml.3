Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3LMOnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:43:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3LMOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:43:50 -0500
Date: Fri, 13 Dec 2013 09:43:20 -0500
From: Rik van Riel <riel@redhat.com>
To: pageexec@freemail.hu
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH -v2] mm: fix use-after-free in sys_remap_file_pages
Message-ID: <20131213094320.2291c210@annuminas.surriel.com>
In-Reply-To: <52AAEB19.27706.CCB8B7D@pageexec.freemail.hu>
References: <20131212220757.GA14928@www.outflux.net>
	<20131212224118.17a951c2@annuminas.surriel.com>
	<52AAEB19.27706.CCB8B7D@pageexec.freemail.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 12:10:17 +0100
"PaX Team" <pageexec@freemail.hu> wrote:

> pass in vm_flags instead of vma->vm_flags just to prevent someone
> from 'optimizing' away the read in the future?

In that case, we should probably also use ACCESS_ONCE, if
only to be explicit about it.
 
> perhaps {copy,move} this comment above the previous hunk since that's
> where the relevant action is?

See the new version below:

---8<---
Subject: mm: fix use-after-free in sys_remap_file_pages

remap_file_pages calls mmap_region, which may merge the VMA with other existing
VMAs, and free "vma". This can lead to a use-after-free bug. Avoid the bug by
remembering vm_flags before calling mmap_region, and not trying to dereference
vma later.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: stable@vger.kernel.org
---
 mm/fremap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 87da359..c85e2ec 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -203,9 +203,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
+			/* mmap_region may free vma; grab the info now */
+			vm_flags = ACCESS_ONCE(vma->vm_flags);
 
-			addr = mmap_region(file, start, size,
-					vma->vm_flags, pgoff);
+			addr = mmap_region(file, start, size, vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
@@ -213,7 +214,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 				BUG_ON(addr != start);
 				err = 0;
 			}
-			goto out;
+			goto out_freed;
 		}
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
@@ -248,6 +249,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 out:
 	if (vma)
 		vm_flags = vma->vm_flags;
+out_freed:
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else

