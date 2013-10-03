Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3JCLCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:02:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:02:43 -0400
Date: Thu, 3 Oct 2013 13:02:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
Message-ID: <20131003110224.GD3081@twins.programming.kicks-ass.net>
References: <20131002132308.GB20396@krava.brq.redhat.com>
 <524C23D3.6020300@intel.com>
 <20131003081737.GB993@krava.brq.redhat.com>
 <524D2E06.5020801@intel.com>
 <20131003085625.GA3081@twins.programming.kicks-ass.net>
 <524D4359.2060801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D4359.2060801@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:13:45PM +0300, Adrian Hunter wrote:
> > Anyway; looking at this, why does time_zero have these different checks
> > from the other time bits?
> > 
> > @@ -1897,6 +1898,11 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> >         userpg->time_mult = this_cpu_read(cyc2ns);
> >         userpg->time_shift = CYC2NS_SCALE_FACTOR;
> >         userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
> > +
> > +       if (sched_clock_stable && !check_tsc_disabled()) {
> > +               userpg->cap_usr_time_zero = 1;
> > +               userpg->time_zero = this_cpu_read(cyc2ns_offset);
> > +       }
> >  }
> > 
> > That doesn't make any kind of sense.. why is cyc2ns_offset differently
> > tested from cyc2ns itself?
> 
> I am afraid I don't understand the scaling calculations
> so I don't know if they make any sense.
> 
> cap_usr_time_zero (now cap_user_time_zero) means you can convert
> perf time to / from TSC.  That only works if TSC is not disabled
> and sched_clock is stable (and you have constant, non-stop TSC)
> 
> As far as I can tell, assuming the hardware is not broken,
> sched_clock will be stable unless something (BIOS) or someone
> (meddling user) has changed TSC manually.

Well all the scaling mess only applies to TSC.. furthermore note how
time_offset even uses cyc2ns_offset.

So I don't see any point in cap_user_time and cap_user_time_zero having
different conditions.

Also, I don't think that a cpu without cap_tsc will ever run perf code
so I don't see the point of testing tsc_disabled; if someone is mad
enough to boot with that he can bloody well keep the pieces.

Arguably the CONSTANT && NONSTOP test was to test the same thing as
sched_clock_stable, but I suppose we can use that.

Which reminds me; I should go and fix the transition for
sched_clock_stable: 1->0.

---
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 897783b3302a..9db2b361a63d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1888,21 +1888,16 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		return;
-
-	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
-		return;
+	if (!sched_clock_stable)
+		return
 
 	userpg->cap_user_time = 1;
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 
-	if (sched_clock_stable && !check_tsc_disabled()) {
-		userpg->cap_user_time_zero = 1;
-		userpg->time_zero = this_cpu_read(cyc2ns_offset);
-	}
+	userpg->cap_user_time_zero = 1;
+	userpg->time_zero = this_cpu_read(cyc2ns_offset);
 }
 
 /*
