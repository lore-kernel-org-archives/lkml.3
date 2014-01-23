Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaAWPOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:14:51 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55141 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaAWPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:14:49 -0500
Date: Thu, 23 Jan 2014 19:14:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        gnome@rvzt.net, grawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
Message-ID: <20140123151445.GX1574@moon>
References: <20140122190816.GB4963@suse.de>
 <20140122191928.GQ1574@moon>
 <20140122223325.GA30637@moon>
 <20140123095541.GD4963@suse.de>
 <20140123103606.GU1574@moon>
 <20140123121555.GV1574@moon>
 <20140123125543.GW1574@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123125543.GW1574@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 04:55:43PM +0400, Cyrill Gorcunov wrote:
> On Thu, Jan 23, 2014 at 04:15:55PM +0400, Cyrill Gorcunov wrote:
> > > 
> > > Thanks a lot, Mel! I'm testing the patch as well (manually though :).
> > > I'll send the final fix today.
> > 
> > The patch below should fix the problem. I would really appreaciate
> > some additional testing.
> 
> Forgot to refresh the patch, sorry.
> ---

I think setting up dirty bit inside vma_merge() body is a big hammer
which should not be used, but it's up to caller of vma_merge() to figure
out if dirty bit should be set or not if merge successed. Thus softdirty
vma bit should be (and it already is) set at the end of mmap_region and do_brk
routines. So patch could be simplified (below). Pavel, what do you think?
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2

VM_SOFTDIRTY bit affects vma merge routine: if two VMAs has all
bits in vm_flags matched except dirty bit the kernel can't longer
merge them and this forces the kernel to generate new VMAs instead.

It finally may lead to the situation when userspace application
reaches vm.max_map_count limit and get crashed in worse case

 | (gimp:11768): GLib-ERROR **: gmem.c:110: failed to allocate 4096 bytes
 |
 | (file-tiff-load:12038): LibGimpBase-WARNING **: file-tiff-load: gimp_wire_read(): error
 | xinit: connection to X server lost
 |
 | waiting for X server to shut down
 | /usr/lib64/gimp/2.0/plug-ins/file-tiff-load terminated: Hangup
 | /usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup
 | /usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup

https://bugzilla.kernel.org/show_bug.cgi?id=67651
https://bugzilla.gnome.org/show_bug.cgi?id=719619#c0

Initial problem came from missed VM_SOFTDIRTY in do_brk() routine
but even if we would set up VM_SOFTDIRTY here, there is still a way to
prevent VMAs from merging: one can call

 | echo 4 > /proc/$PID/clear_refs

and clear all VM_SOFTDIRTY over all VMAs presented in memory map,
then new do_brk() will try to extend old VMA and finds that dirty
bit doesn't match thus new VMA will be generated.

As discussed to Pavel, the right approach should be to ignore
VM_SOFTDIRTY bit when we're trying to merge VMAs and if merge
successed we mark extended VMA with dirty bit where needed.

v2: Don't mark VMA as dirty inside vma_merge() body, it's up
    to calling code to set up dirty bit where needed.

Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.git/mm/mmap.c
===================================================================
--- linux-2.6.git.orig/mm/mmap.c
+++ linux-2.6.git/mm/mmap.c
@@ -893,7 +893,15 @@ again:			remove_next = 1 + (end > next->
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 			struct file *file, unsigned long vm_flags)
 {
-	if (vma->vm_flags ^ vm_flags)
+	/*
+	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
+	 * match the flags but dirty bit -- the caller should mark
+	 * merged VMA as dirty. If dirty bit won't be excluded from
+	 * comparison, we increase pressue on the memory system forcing
+	 * the kernel to generate new VMAs when old one could be
+	 * extended instead.
+	 */
+	if ((vma->vm_flags ^ vm_flags) & ~VM_SOFTDIRTY)
 		return 0;
 	if (vma->vm_file != file)
 		return 0;
@@ -1082,7 +1090,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC|VM_SOFTDIRTY)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
