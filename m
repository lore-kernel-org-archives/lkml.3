Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3JBLXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:23:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3JBLXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:23:34 -0400
Date: Wed, 2 Oct 2013 13:23:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131002112316.GP3081@twins.programming.kicks-ass.net>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <20130930161546.GG3081@twins.programming.kicks-ass.net>
 <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
 <20130930165420.GI3081@twins.programming.kicks-ass.net>
 <CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:22:58PM +0200, Stephane Eranian wrote:
> > So the problem is that we don't have a user visible address space
> > identifier; with CLONE_THREAD we have the thread group id that acts
> > like this. But for bare CLONE_VM usage there's nothing afaik.
> 
> 
> From the tool's perspective, the MMAP2 record must contain enough information
> to identify that the mapping points to the same physical pages in that
> particular
> case (multi-process + VM_CLONE). As we have it now all inode-related fields
> are zero which is useless (indicates: no info). In other words, we need to make
> up some unique number and stash it in the maj.min,ino triplet somehow.

So the only thing I can come up with is something like the below;
supposedly the sha hash mixing a boot time random seed and the mm
pointer is enough to avoid it being a data leak.

And of course there's the possibility of a collision.

---
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,11 +39,15 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/random.h>
+#include <linux/cryptohash.h>
 
 #include "internal.h"
 
 #include <asm/irq_regs.h>
 
+static u64 __perf_rand_seed;
+
 struct remote_function_call {
 	struct task_struct	*p;
 	int			(*func)(void *info);
@@ -5136,6 +5140,33 @@ static void perf_event_mmap_event(struct
 		min = MINOR(dev);
 
 	} else {
+		union {
+			struct {
+				u64 ino, gen;
+				u32 min;
+			};
+			u32 digest[SHA_DIGEST_WORDS];
+		} hash;
+		union {
+			struct {
+				u64 seed;
+				u64 ptr;
+			};
+			u8 message[SHA_MESSAGE_BYTES];
+		} data;
+		u32 workspace[SHA_WORKSPACE_WORDS];
+
+		memset(&data, 0, sizeof(data));
+		data.seed = __perf_rand_seed;
+		data.ptr = (u64)vma->vm_mm;
+
+		sha_init(hash.digest);
+		sha_transform(hash.digest, data.message, workspace);
+
+		gen = hash.gen;
+		ino = hash.ino;
+		min = hash.min;
+
 		if (arch_vma_name(mmap_event->vma)) {
 			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
 				       sizeof(tmp) - 1);
@@ -7895,6 +7926,8 @@ void __init perf_event_init(void)
 	/* do not patch jump label more than once per second */
 	jump_label_rate_limit(&perf_sched_events, HZ);
 
+	get_random_bytes(&__perf_rand_seed, sizeof(__perf_rand_seed));
+
 	/*
 	 * Build time assertion that we keep the data_head at the intended
 	 * location.  IOW, validation we got the __reserved[] size right.
