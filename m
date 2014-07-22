Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaGVOL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:11:28 -0400
Received: from wolff.to ([98.103.208.27]:57140 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754462AbaGVOL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:11:27 -0400
Date: Tue, 22 Jul 2014 09:09:12 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722140912.GA23406@wolff.to>
References: <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
 <20140722121001.GA30631@wolff.to>
 <20140722130343.GD3935@laptop>
 <20140722132603.GL12054@laptop.lan>
 <20140722133514.GM12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140722133514.GM12054@laptop.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 15:35:14 +0200,
  Peter Zijlstra <peterz@infradead.org> wrote:
>On Tue, Jul 22, 2014 at 03:26:03PM +0200, Peter Zijlstra wrote:
>
>Something like so.. anything obviously broken?

Do you want me to test this change instead of, or combined with the other 
patch you wanted tested earlier?

>
>---
> arch/x86/kernel/cpu/intel.c           | 22 +++++++++++-----------
> arch/x86/kernel/cpu/intel_cacheinfo.c | 12 ++++++++++++
> 2 files changed, 23 insertions(+), 11 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>index 0fd955778f35..9483ee5b3991 100644
>--- a/arch/x86/kernel/cpu/intel.c
>+++ b/arch/x86/kernel/cpu/intel.c
>@@ -370,6 +370,17 @@ static void init_intel(struct cpuinfo_x86 *c)
> 	 */
> 	detect_extended_topology(c);
>
>+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
>+		/*
>+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
>+		 * detection.
>+		 */
>+		c->x86_max_cores = intel_num_cpu_cores(c);
>+#ifdef CONFIG_X86_32
>+		detect_ht(c);
>+#endif
>+	}
>+
> 	l2 = init_intel_cacheinfo(c);
> 	if (c->cpuid_level > 9) {
> 		unsigned eax = cpuid_eax(10);
>@@ -438,17 +449,6 @@ static void init_intel(struct cpuinfo_x86 *c)
> 		set_cpu_cap(c, X86_FEATURE_P3);
> #endif
>
>-	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
>-		/*
>-		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
>-		 * detection.
>-		 */
>-		c->x86_max_cores = intel_num_cpu_cores(c);
>-#ifdef CONFIG_X86_32
>-		detect_ht(c);
>-#endif
>-	}
>-
> 	/* Work around errata */
> 	srat_detect_node(c);
>
>diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
>index a952e9c85b6f..9c8f7394c612 100644
>--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
>+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
>@@ -730,6 +730,18 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
> #endif
> 	}
>
>+#ifdef CONFIG_X86_HT
>+	/*
>+	 * If cpu_llc_id is not yet set, this means cpuid_level < 4 which in
>+	 * turns means that the only possibility is SMT (as indicated in
>+	 * cpuid1). Since cpuid2 doesn't specify shared caches, and we know
>+	 * that SMT shares all caches, we can unconditionally set cpu_llc_id to
>+	 * c->phys_proc_id.
>+	 */
>+	if (per_cpu(cpu_llc_id, cpu) == BAD_APICID)
>+		per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
>+#endif
>+
> 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
>
> 	return l2;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
