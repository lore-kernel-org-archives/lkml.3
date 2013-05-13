Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3EMJiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:38:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41584 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3EMJiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:38:10 -0400
Date: Mon, 13 May 2013 11:36:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130513093624.GC3708@dyad.programming.kicks-ass.net>
References: <20130510092741.GE3039@dyad.programming.kicks-ass.net>
 <20130510094053.GF1040@krava.brq.redhat.com>
 <20130510095345.GG3039@dyad.programming.kicks-ass.net>
 <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
 <20130510103436.GC31235@dyad.programming.kicks-ass.net>
 <20130510105536.GA18805@gmail.com>
 <20130510112756.GH31235@dyad.programming.kicks-ass.net>
 <20130511075008.GC24435@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130511075008.GC24435@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 09:50:08AM +0200, Ingo Molnar wrote:
> That's really a red herring: there's absolutely no reason why the 
> kernel could not pass back the level of precision it provided.

All I've been saying is that doing random precision without feedback is
confusing.

We also don't really have a good feedback channel for this kind of thing. The
best I can come up with is tagging each and every sample with the quality it
represents. I think we can do with only one extra PERF_RECORD_MISC bit, but it
looks like we're quickly running out of those things.

But I think the biggest problem is PEBS's inability do deal with REP prefixes;
see this email from Stephane: https://lkml.org/lkml/2011/2/1/177

It is really unfortunate for PEBS to have such a side-effect; but it makes all
memset/memcpy/memmove things appear like they have no cost. I'm very sure that
will surprise a number of people.

---
 arch/x86/include/asm/perf_event.h         | 4 +++-
 arch/x86/kernel/cpu/perf_event.c          | 2 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 4 +++-
 include/uapi/linux/perf_event.h           | 1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 57cb634..6908838 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -205,14 +205,16 @@ static inline u32 get_ibs_caps(void) { return 0; }
 extern void perf_events_lapic_init(void);
 
 /*
- * Abuse bits {3,5} of the cpu eflags register. These flags are otherwise
+ * Abuse bits {3,5,15} of the cpu eflags register. These flags are otherwise
  * unused and ABI specified to be 0, so nobody should care what we do with
  * them.
  *
+ * CONSTANT - the IP has constant skid.
  * EXACT - the IP points to the exact instruction that triggered the
  *         event (HW bugs exempt).
  * VM    - original X86_VM_MASK; see set_linear_ip().
  */
+#define PERF_EFLAGS_CONSTANT	(1UL << 15)
 #define PERF_EFLAGS_EXACT	(1UL << 3)
 #define PERF_EFLAGS_VM		(1UL << 5)
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1025f3c..ca1f7dc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2078,6 +2078,8 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 	if (regs->flags & PERF_EFLAGS_EXACT)
 		misc |= PERF_RECORD_MISC_EXACT_IP;
+	else if (regs->flags & PERF_EFLAGS_CONSTANT)
+		misc |= PERF_RECORD_MISC_CONSTANT_SKID;
 
 	return misc;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 60250f6..757ecd4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -753,10 +753,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
+	regs.flags &= ~(PERF_EFLAGS_CONSTANT | PERF_EFLAGS_EXACT);
+
 	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
 	else
-		regs.flags &= ~PERF_EFLAGS_EXACT;
+		regs.flags |= PERF_EFLAGS_CONSTANT;
 
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..cb1f70f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -451,6 +451,7 @@ struct perf_event_mmap_page {
  * the actual instruction that triggered the event. See also
  * perf_event_attr::precise_ip.
  */
+#define PERF_RECORD_MISC_CONSTANT_SKID		(1 << 12)
 #define PERF_RECORD_MISC_EXACT_IP		(1 << 14)
 /*
  * Reserve the last bit to indicate some extended misc field

