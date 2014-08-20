Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaHTXvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:51:09 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:38856 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaHTXvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:51:07 -0400
Date: Thu, 21 Aug 2014 02:45:43 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] mm: softdirty: write protect PTEs created for read
 faults after VM_SOFTDIRTY cleared
Message-ID: <20140820234543.GA7987@node.dhcp.inet.fi>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408571182-28750-1-git-send-email-pfeiner@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 05:46:22PM -0400, Peter Feiner wrote:
> In readable+writable+shared VMAs, PTEs created for read faults have
> their write bit set. If the read fault happens after VM_SOFTDIRTY is
> cleared, then the PTE's softdirty bit will remain clear after
> subsequent writes.
> 
> Here's a simple code snippet to demonstrate the bug:
> 
>   char* m = mmap(NULL, getpagesize(), PROT_READ | PROT_WRITE,
>                  MAP_ANONYMOUS | MAP_SHARED, -1, 0);
>   system("echo 4 > /proc/$PPID/clear_refs"); /* clear VM_SOFTDIRTY */
>   assert(*m == '\0');     /* new PTE allows write access */
>   assert(!soft_dirty(x));
>   *m = 'x';               /* should dirty the page */
>   assert(soft_dirty(x));  /* fails */
> 
> With this patch, new PTEs created for read faults are write protected
> if the VMA has VM_SOFTDIRTY clear.
> 
> Signed-off-by: Peter Feiner <pfeiner@google.com>
> ---
>  mm/memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ab3537b..282a959 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2755,6 +2755,8 @@ void do_set_pte(struct vm_area_struct *vma, unsigned long address,
>  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  	else if (pte_file(*pte) && pte_file_soft_dirty(*pte))
>  		entry = pte_mksoft_dirty(entry);
> +	else if (!(vma->vm_flags & VM_SOFTDIRTY))
> +		entry = pte_wrprotect(entry);

It basically means VM_SOFTDIRTY require writenotify on the vma.

What about patch below? Untested. And it seems it'll introduce bug similar
to bug fixed by c9d0bf241451, *but* IIUC we have it already in mprotect()
code path.

I'll look more careful tomorrow.

Not-signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dfc791c42d64..67d509a15969 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -851,8 +851,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
                        if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
                                continue;
                        if (type == CLEAR_REFS_SOFT_DIRTY) {
-                               if (vma->vm_flags & VM_SOFTDIRTY)
-                                       vma->vm_flags &= ~VM_SOFTDIRTY;
+                               vma->vm_flags &= ~VM_SOFTDIRTY;
+                               vma->vm_page_prot = vm_get_page_prot(
+                                               vma->vm_flags & ~VM_SHARED);
                        }
                        walk_page_range(vma->vm_start, vma->vm_end,
                                        &clear_refs_walk);
-- 
 Kirill A. Shutemov
