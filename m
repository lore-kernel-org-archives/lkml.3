Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaBKU2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:28:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaBKTGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Bastian Hougaard <gnome@rvzt.net>, Mel Gorman <mgorman@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 017/107] mm: ignore VM_SOFTDIRTY on VMA merging
Date: Tue, 11 Feb 2014 11:04:43 -0800
Message-Id: <20140211184748.694664560@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrill Gorcunov <gorcunov@gmail.com>

commit 34228d473efe764d4db7c0536375f0c993e6e06a upstream.

The VM_SOFTDIRTY bit affects vma merge routine: if two VMAs has all bits
in vm_flags matched except dirty bit the kernel can't longer merge them
and this forces the kernel to generate new VMAs instead.

It finally may lead to the situation when userspace application reaches
vm.max_map_count limit and get crashed in worse case

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

Initial problem came from missed VM_SOFTDIRTY in do_brk() routine but
even if we would set up VM_SOFTDIRTY here, there is still a way to
prevent VMAs from merging: one can call

 | echo 4 > /proc/$PID/clear_refs

and clear all VM_SOFTDIRTY over all VMAs presented in memory map, then
new do_brk() will try to extend old VMA and finds that dirty bit doesn't
match thus new VMA will be generated.

As discussed with Pavel, the right approach should be to ignore
VM_SOFTDIRTY bit when we're trying to merge VMAs and if merge successed
we mark extended VMA with dirty bit where needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reported-by: Bastian Hougaard <gnome@rvzt.net>
Reported-by: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -895,7 +895,15 @@ again:			remove_next = 1 + (end > next->
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
@@ -1084,7 +1092,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC|VM_SOFTDIRTY)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 


