Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJGDAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 23:00:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:23415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaJGDAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 23:00:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,666,1406617200"; 
   d="scan'208";a="482411762"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: RE: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Thread-Topic: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Thread-Index: AQHPzQDkPZQyOKBBqke6qipRRbb+cpwP48SAgBQxgmA=
Date: Tue, 7 Oct 2014 03:00:00 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770160F98C@SHSMSX103.ccr.corp.intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-12-git-send-email-kan.liang@intel.com>
 <20140924141507.GF2805@worktop.programming.kicks-ass.net>
In-Reply-To: <20140924141507.GF2805@worktop.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, September 24, 2014 10:15 AM
> To: Liang, Kan
> Cc: eranian@google.com; linux-kernel@vger.kernel.org; mingo@redhat.com;
> paulus@samba.org; acme@kernel.org; ak@linux.intel.com; Yan, Zheng
> Subject: Re: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
> perf_callchain()
> 
> On Wed, Sep 10, 2014 at 10:09:08AM -0400, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > Haswell has a new feature that utilizes the existing Last Branch
> > Record facility to record call chains. When the feature is enabled,
> > function call will be collected as normal, but as return instructions
> > are executed the last captured branch record is popped from the
> > on-chip LBR registers.
> > The LBR call stack facility can help perf to get call chains of progam
> > without frame pointer.
> >
> > This patch modifies various architectures' perf_callchain() to accept
> > perf sample data. Later patch will add code that use the sample data
> > to get call chains.
> 
> So I don't like this. Why not use the regular PERF_SAMPLE_BRANCH_STACK
> output to generate the stuff from? We already have two different means,
> with different transport, for callchains anyhow, so a third really won't matter.

I'm not sure what you mean by using the regular PERF_SAMPLE_BRANCH_STACK output to generate the stuff from.
But we don't need to modify various architectures' perf_callchain_user, if that's your concern. 
An alternative way is to generate the callchain output in a higher level, like perf_callchain.
If there is no frame pointer, the entry->nr will be set to MAX+1. So  the perf_callchain knows that we need to try LBR callstack if possible.
In perf_callchain, it resets entry->nr to old value, and call perf_callchain_lbr_callstack to check and fill the callchain struct if possible. 
The patch is as below.

What do you think?
 

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index f2a88de..677f8af 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -156,11 +156,28 @@ put_callchain_entry(int rctx)
        put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }

+static inline void
+perf_callchain_lbr_callstack(struct perf_callchain_entry *entry,
+                            struct perf_sample_data *data)
+{
+       struct perf_branch_stack *br_stack = data->br_stack;
+
+       if (br_stack && br_stack->user_callstack) {
+               int i = 0;
+               while (i < br_stack->nr && entry->nr < PERF_MAX_STACK_DEPTH) {
+                       perf_callchain_store(entry, br_stack->entries[i].from);
+                       i++;
+               }
+       }
+}
+
 struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs)
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+               struct perf_sample_data *data)
 {
        int rctx;
        struct perf_callchain_entry *entry;
+       __u64 old_nr;

        int kernel = !event->attr.exclude_callchain_kernel;
        int user   = !event->attr.exclude_callchain_user;
@@ -198,7 +215,13 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
                                goto exit_put;

                        perf_callchain_store(entry, PERF_CONTEXT_USER);
+                       old_nr = entry->nr;
                        perf_callchain_user(entry, regs);
+                       if (entry->nr == (PERF_MAX_STACK_DEPTH + 1)) {
+                               entry->nr = old_nr;
+                               perf_callchain_lbr_callstack(entry, data);
+                       } else
+                               entry->nr = old_nr;
                }
        }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 185fa03..0439c8f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2061,6 +2061,15 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
                perf_callchain_store(entry, cs_base + frame.return_address);
                fp = compat_ptr(ss_base + frame.next_frame);
        }
+
+       /*
+        * try LBR callstack if there is no frame pointer
+        * Set entry->nr to MAX + 1 to notify the perf_callchain.
+        * perf_callchain finally try LBR callstack and reset entry->nr
+        */
+       if (fp == compat_ptr(regs->bp))
+               entry->nr = PERF_MAX_STACK_DEPTH + 1;
+
        return 1;
 }
 #else
@@ -2113,6 +2122,14 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
                perf_callchain_store(entry, frame.return_address);
                fp = frame.next_frame;
        }
+
+       /*
+        * try LBR callstack if there is no frame pointer
+        * Set entry->nr to MAX + 1 to notify the perf_callchain.
+        * perf_callchain finally try LBR callstack and reset entry->nr
+        */
+       if (fp == (void __user *)regs->bp)
+               entry->nr = PERF_MAX_STACK_DEPTH + 1;
 }

 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 50bb51d..2808267 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1533,7 +1533,7 @@ again:

                perf_sample_data_init(&data, 0, event->hw.last_period);

-               if (has_branch_stack(event))
+               if (needs_branch_stack(event))
                        data.br_stack = &cpuc->lbr_stack;

                if (perf_event_overflow(event, &data, regs))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 8e6c88f..6c995b7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -758,6 +758,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
        int i, j, type;
        bool compress = false;

+       cpuc->lbr_stack.user_callstack = branch_user_callstack(br_sel);
+
        /* if sampling all branches, then nothing to filter */
        if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
                return;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 285776a..84840cc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -75,6 +75,7 @@ struct perf_raw_record {
  * recent branch.
  */
 struct perf_branch_stack {
+       bool                            user_callstack;
        __u64                           nr;
        struct perf_branch_entry        entries[0];
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4dd5700..825b487 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4915,7 +4915,7 @@ void perf_prepare_sample(struct perf_event_header *header,
        if (sample_type & PERF_SAMPLE_CALLCHAIN) {
                int size = 1;

-               data->callchain = perf_callchain(event, regs);
+               data->callchain = perf_callchain(event, regs, data);

                if (data->callchain)
                        size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b2187..3a0239e 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -147,7 +147,8 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)

 /* Callchain handling */
 extern struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs);
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+               struct perf_sample_data *data);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
