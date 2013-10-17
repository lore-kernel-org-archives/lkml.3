Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3JQVMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:12:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3JQVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:11:49 -0400
Date: Thu, 17 Oct 2013 23:11:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131017211138.GF26785@twins.programming.kicks-ass.net>
References: <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016205227.GJ7456@tassilo.jf.intel.com>
 <20131016210319.GI10651@twins.programming.kicks-ass.net>
 <20131016230712.GC26785@twins.programming.kicks-ass.net>
 <20131017094145.GE3364@laptop.programming.kicks-ass.net>
 <20131017160034.GO227855@redhat.com>
 <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017210816.GY10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017210816.GY10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:08:16PM +0200, Peter Zijlstra wrote:
> I did a patch that avoids the page count mucking about, Don didn't see
> any significant improvements from it.

On top of which there's another patch -- which could as easily be done
without it, that adds some state to the copy_from_user_nmi() and avoids
re-doing the page walk and memcpy().

Don also tried a vraiant of the below for the pebs fixup code; that
turned out to be slower than the single copy all at once.

The below -- as stated in the changelog -- might still improve the
frame-pointer chase, but I've no numbers what so ever atm.

---
Subject: perf, x86: Optimize copy_from_user_nmi()
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 17 Oct 2013 11:41:45 +0200

In an attempt to speed up the frame-pointer chase we introduce a new
copy_from_user_nmi() interface:

  struct copy_from_user_nmi_state;

  void *copy_from_user_nmi_iter(void *to, void __user *from, int s,
				struct copy_from_user_nmi_state *state);
  void copy_from_user_nmi_end(struct copy_from_user_nmi_state *state);

The _iter() method returns a pointer to the memory requested; if this
is entirely contained within one page it simply returns a pointer into
the kmap and avoids the copy. Otherwise it will copy into the buffer
provided in the @to argument and return a pointer thereto.

Because we potentially need to keep the kmap alive, we need the
closing _end() function and the @state variable.

Since we keep state, we also avoid the page-table walk for consecutive
accesses to the same page.

Using this we (hopefully) reduce the number of page-table walks (and
kmap on i386) operations.

Cc: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com
Cc: eranian@google.com
Cc: jmario@redhat.com
Cc: acme@infradead.org
Cc: mingo@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131017094145.GE3364@laptop.programming.kicks-ass.net
---
 arch/x86/include/asm/uaccess.h   |   13 ++++++
 arch/x86/kernel/cpu/perf_event.c |   32 ++++++---------
 arch/x86/lib/usercopy.c          |   79 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -516,6 +516,19 @@ struct __large_struct { unsigned long bu
 
 extern unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+
+struct copy_from_user_nmi_state {
+	void *map;
+	unsigned long address;
+	unsigned long flags;
+};
+
+extern void *
+copy_from_user_nmi_iter(void *to, const void __user *from,
+			unsigned long n, struct copy_from_user_nmi_state *state);
+extern void
+copy_from_user_nmi_end(struct copy_from_user_nmi_state *state);
+
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1979,8 +1979,9 @@ static inline int
 perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	/* 32-bit process in 64-bit kernel. */
+	struct copy_from_user_nmi_state state = { NULL };
 	unsigned long ss_base, cs_base;
-	struct stack_frame_ia32 frame;
+	struct stack_frame_ia32 frame, *f;
 	const void __user *fp;
 
 	if (!test_thread_flag(TIF_IA32))
@@ -1991,20 +1992,17 @@ perf_callchain_user32(struct pt_regs *re
 
 	fp = compat_ptr(ss_base + regs->bp);
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
-		unsigned long bytes;
-		frame.next_frame     = 0;
-		frame.return_address = 0;
-
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-		if (bytes != sizeof(frame))
+		f = copy_from_user_nmi_iter(&frame, fp, sizeof(frame), &state);
+		if (!f)
 			break;
 
 		if (!valid_user_frame(fp, sizeof(frame)))
 			break;
 
-		perf_callchain_store(entry, cs_base + frame.return_address);
-		fp = compat_ptr(ss_base + frame.next_frame);
+		perf_callchain_store(entry, cs_base + f->return_address);
+		fp = compat_ptr(ss_base + f->next_frame);
 	}
+	copy_from_user_nmi_end(&state);
 	return 1;
 }
 #else
@@ -2018,7 +2016,8 @@ perf_callchain_user32(struct pt_regs *re
 void
 perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
-	struct stack_frame frame;
+	struct copy_from_user_nmi_state state = { NULL };
+	struct stack_frame frame, *f;
 	const void __user *fp;
 
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
@@ -2043,20 +2042,17 @@ perf_callchain_user(struct perf_callchai
 		return;
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
-		unsigned long bytes;
-		frame.next_frame	     = NULL;
-		frame.return_address = 0;
-
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-		if (bytes != sizeof(frame))
+		f = copy_from_user_nmi_iter(&frame, fp, sizeof(frame), &state);
+		if (!f)
 			break;
 
 		if (!valid_user_frame(fp, sizeof(frame)))
 			break;
 
-		perf_callchain_store(entry, frame.return_address);
-		fp = frame.next_frame;
+		perf_callchain_store(entry, f->return_address);
+		fp = f->next_frame;
 	}
+	copy_from_user_nmi_end(&state);
 }
 
 /*
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -53,3 +53,82 @@ copy_from_user_nmi(void *to, const void
 	return len;
 }
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
+
+void *copy_from_user_nmi_iter(void *to, const void __user *from,
+		unsigned long n, struct copy_from_user_nmi_state *state)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	unsigned long size, len = 0;
+	unsigned long flags;
+	struct page *page;
+	void *map, *_to = to;
+	int ret;
+
+	if (__range_not_ok(from, n, TASK_SIZE))
+		return NULL;
+
+	if (state->map) {
+		if ((state->address >> PAGE_SHIFT) ==
+		    (addr >> PAGE_SHIFT)) {
+			flags = state->flags;
+			map = state->map;
+			goto got_page;
+		}
+		kunmap_atomic(state->map);
+		local_irq_restore(state->flags);
+	}
+
+	for (;;) {
+		local_irq_save(flags);
+		ret = ___get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret) {
+			local_irq_restore(flags);
+			state->map = NULL;
+			return NULL;
+		}
+
+		map = kmap_atomic(page);
+
+got_page:
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		/*
+		 * If the entire desired range falls within the one page
+		 * avoid the copy and return a pointer into the kmap.
+		 */
+		if (size == n) {
+			_to = map + offset;
+			break;
+		}
+
+		memcpy(to, map+offset, size);
+		len += size;
+
+		if (len == n)
+			break;
+
+		to   += size;
+		addr += size;
+
+		kunmap_atomic(map);
+		local_irq_restore(flags);
+	}
+
+	state->address = addr;
+	state->flags = flags;
+	state->map = map;
+
+	return _to;
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi_iter);
+
+void copy_from_user_nmi_end(struct copy_from_user_nmi_state *state)
+{
+	if (state->map) {
+		kunmap_atomic(state->map);
+		local_irq_restore(state->flags);
+		state->map = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi_end);
