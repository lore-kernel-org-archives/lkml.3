Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790Ab3JPUQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761436Ab3JPUQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:16:31 -0400
Date: Wed, 16 Oct 2013 22:09:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131016200924.GA23214@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014102426.GX3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

you know, I was going to forget about this, but then I looked at
perf_event_mmap_event() again and I am even more puzzled.

I believe it asks for cleanups.

On 10/14, Peter Zijlstra wrote:
>
> On Sat, Oct 12, 2013 at 09:22:03PM +0200, Oleg Nesterov wrote:
> >
> > But please ignore, the only question is that I can't understand
> > this
> >
> > 	if (!vma->vm_mm) {
> > 		name = strncpy(tmp, "[vdso]", sizeof(tmp));
> > 		goto got_name;
> > 	}
> >
> > code in perf_event_mmap_event() and I am just curious. How it is
> > possible that vma->vm_mm == NULL ? perf_event_mmap(vma) is never
> > called with, say, vma == gate_vma. And even if it was possible
> > arch_vma_name() should handle this case?
>
> Uuuhhhh... I wrote that didn't I ;-)
>
> So I think that was due to the x86_32 gate_vma, but yes I don't think
> we'd ever call perf_event_mmap() (perf_counter_mmap at the time) on it.

OK, so I think this code should die, it only adds the confusion.

Note also that at least on x86_64 "[vdso]" is not correct (if !vma_mm
was possible), this adds more confusion.

> Also, the x86_32 arch_vma_name() didn't deal with the gate_vma (it still
> doesn't appear to do so) as opposed to x86_64 which does.

Hmm... I am looking into arch/x86/vdso/vdso32-setup.c, it seems it does.
But probably I missed something, this doesn't matter.

> But the main reason I added it was because task_mmu.c:show_map_vma() did
> so too; I just wanted to be extra careful.

Yes, but this code can actually hit gate_vma. (and I'd say that if some
arch/ has the global gate_vma-like vma's, it should implement arch_vma_name
correctly, but this is off-topic).

---------------------------------------------------------------------------
Please look at these 2 simple patches. Initially I was going to send
the 3rd patch, but I simply can't understand the "align" logic.

First of all, we surely do not need __GFP_ZERO for kzalloc(PATH_MAX),
even if we need to nullify the alignment. So I am going to send another
patch in any case.

But do we really need to nullify the extra bytes after strlen()? If yes,
for what? If no, we can simply do s/kzalloc/kmalloc/ and kill that
memset(tmp, 0, sizeof(tmp)) at the start.

Otoh. Why do we need the temporary string buffer (char tmp[16]) at all?
We either use the result from d_path() (which has a room), or we use a
string literal (may be returned by arch_vma_name), in the latter case
it is safe to assume we can read the extra 7 bytes from .data?

IOW. Could you explain why the patch below (on top of 1-2) is wrong?

Thanks,

Oleg.

--- x/kernel/events/core.c
+++ x/kernel/events/core.c
@@ -5098,19 +5098,16 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	int maj = 0, min = 0;
 	u64 ino = 0, gen = 0;
 	unsigned int size;
-	char tmp[16];
 	char *buf = NULL;
 	const char *name;
 
-	memset(tmp, 0, sizeof(tmp));
-
 	if (file) {
 		struct inode *inode;
 		dev_t dev;
 
-		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		buf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
-			name = strncpy(tmp, "//enomem", sizeof(tmp));
+			name = "//enomem";
 			goto got_name;
 		}
 		/*
@@ -5120,7 +5117,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		 */
 		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
-			name = strncpy(tmp, "//toolong", sizeof(tmp));
+			name = "//toolong";
 			goto got_name;
 		}
 		inode = file_inode(vma->vm_file);
@@ -5133,23 +5130,21 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	} else {
 		name = arch_vma_name(vma);
 		if (name) {
-			name = strncpy(tmp, name, sizeof(tmp) - 1);
-			tmp[sizeof(tmp) - 1] = '\0';
 			goto got_name;
 		}
 
 		if (vma->vm_start <= vma->vm_mm->start_brk &&
 				vma->vm_end >= vma->vm_mm->brk) {
-			name = strncpy(tmp, "[heap]", sizeof(tmp));
+			name = "[heap]";
 			goto got_name;
 		}
 		if (vma->vm_start <= vma->vm_mm->start_stack &&
 				vma->vm_end >= vma->vm_mm->start_stack) {
-			name = strncpy(tmp, "[stack]", sizeof(tmp));
+			name = "[stack]";
 			goto got_name;
 		}
 
-		name = strncpy(tmp, "//anon", sizeof(tmp));
+		name = "//anon";
 		goto got_name;
 	}
 

