Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LMDl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:41:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3LMDlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:41:55 -0500
Date: Thu, 12 Dec 2013 22:41:18 -0500
From: Rik van Riel <riel@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, PaX Team <pageexec@freemail.hu>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] mm: fix use-after-free in sys_remap_file_pages
Message-ID: <20131212224118.17a951c2@annuminas.surriel.com>
In-Reply-To: <20131212220757.GA14928@www.outflux.net>
References: <20131212220757.GA14928@www.outflux.net>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 14:07:57 -0800
Kees Cook <keescook@chromium.org> wrote:

> From: PaX Team <pageexec@freemail.hu>
> 
> http://lkml.org/lkml/2013/9/17/30
> 
> SyS_remap_file_pages() calls mmap_region(), which calls remove_vma_list(),
> which calls remove_vma(), which frees the vma.  Later (after out label)
> SyS_remap_file_pages() accesses the freed vma in vm_flags = vma->vm_flags.

> index 5bff08147768..afad07b85ef2 100644
> --- a/mm/fremap.c
> +++ b/mm/fremap.c
> @@ -218,6 +218,8 @@ get_write_lock:
>  				BUG_ON(addr != start);
>  				err = 0;
>  			}
> +			vm_flags = vma->vm_flags;
> +			vma = NULL;
>  			goto out;


If the vma has been freed by the time the code jumps to the
out label (because it was freed by a function called from
mmap_region), surely it will also already have been freed
by the time this patch dereferences it?

Also, setting vma = NULL to avoid the if (vma) branch at
the out: label is unnecessarily obfuscated. Lets make things
clear by documenting what is going on, and having a label
after that dereference.

Maybe something like this patch:

---8<---

Subject: [PATCH] mm: fix use-after-free in sys_remap_file_pages

remap_file_pages calls mmap_region, which may merge the VMA with other existing
VMAs, and free "vma". This can lead to a use-after-free bug. Avoid the bug by
remembering vm_flags before calling mmap_region, and not trying to dereference
vma later.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: stable@vger.kernel.org
---
 mm/fremap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 87da359..d28ede5 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -203,6 +203,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
+			vm_flags = vma->vm_flags;
 
 			addr = mmap_region(file, start, size,
 					vma->vm_flags, pgoff);
@@ -213,7 +214,8 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 				BUG_ON(addr != start);
 				err = 0;
 			}
-			goto out;
+			/* mmap_region may have freed vma */
+			goto out_freed;
 		}
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
@@ -248,6 +250,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 out:
 	if (vma)
 		vm_flags = vma->vm_flags;
+out_freed:
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else
