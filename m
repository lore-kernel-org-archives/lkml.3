Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3IERFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:05:04 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47679 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3IERFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:05:01 -0400
Date: Thu, 5 Sep 2013 19:04:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com
Subject: Re: perf, x86: Add parts of the remaining haswell PMU functionality
Message-ID: <20130905170457.GA27741@gmail.com>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <20130902065512.GA29060@gmail.com>
 <20130905131502.GA26387@gmail.com>
 <20130905151034.GP19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905151034.GP19750@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Sep 05, 2013 at 03:15:02PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > One thing I'm not seeing in the current Haswell code is the config set 
> > > up for PERF_COUNT_HW_STALLED_CYCLES_FRONTEND/BACKEND. Both SB and IB has 
> > > them configured.
> > 
> > Ping? Consider this a regression report.
> 
> AFAIK they don't work. You only get the correct answer in some 
> situations, but in others it either overestimates frontend or 
> underestimates backend badly.

Well, at least the front-end side is still documented in the SDM as being 
usable to count stalled cycles.

AFAICS backend stall cycles are documented to work on Ivy Bridge.

On Haswell there's only UOPS_EXECUTED.CORE (0xb1 0x02) - this will 
over-count but could still be useful if we halved its value and considered 
it only statistically correct.

For perf stat -a alike system-wide workloads it should still produce 
usable results that way.

I.e. something like the patch below (it does not solve the double counting 
yet).

Thanks,

	Ingo

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0abf674..a61dd79 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2424,6 +2424,10 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 
+		/* UOPS_EXECUTED.THREAD,c=1,i=1 to count stall cycles*/
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
+
 		pr_cont("IvyBridge events, ");
 		break;
 
@@ -2450,6 +2454,15 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.cpu_events = hsw_events_attrs;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+
+		/* UOPS_EXECUTED.CORE,c=1,i=1 to count stall cycles*/
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x02, .inv=1, .cmask=1);
+
 		pr_cont("Haswell events, ");
 		break;
 
