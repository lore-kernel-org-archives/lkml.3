Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaGVNfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:35:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaGVNfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:35:19 -0400
Date: Tue, 22 Jul 2014 15:35:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722133514.GM12054@laptop.lan>
References: <20140718141648.GE20603@laptop.programming.kicks-ass.net>
 <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
 <20140722121001.GA30631@wolff.to>
 <20140722130343.GD3935@laptop>
 <20140722132603.GL12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722132603.GL12054@laptop.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:26:03PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 03:03:43PM +0200, Peter Zijlstra wrote:
> > Oh, of course we do SMP detection and setup after the cache setup...
> > lovely.
> > 
> > /me goes bang head against wall
> 
> hpa, could we move the legacy cpuid1/cpuid4 topology detection muck up,
> preferably right after detect_extended_topology()?
> 
> I need c->phys_proc_id in init_intel_cacheinfo() for machines with
> cpuid_level < 4.

Something like so.. anything obviously broken?

---
 arch/x86/kernel/cpu/intel.c           | 22 +++++++++++-----------
 arch/x86/kernel/cpu/intel_cacheinfo.c | 12 ++++++++++++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 0fd955778f35..9483ee5b3991 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -370,6 +370,17 @@ static void init_intel(struct cpuinfo_x86 *c)
 	 */
 	detect_extended_topology(c);
 
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = intel_num_cpu_cores(c);
+#ifdef CONFIG_X86_32
+		detect_ht(c);
+#endif
+	}
+
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
@@ -438,17 +449,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_P3);
 #endif
 
-	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
-		/*
-		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
-		 * detection.
-		 */
-		c->x86_max_cores = intel_num_cpu_cores(c);
-#ifdef CONFIG_X86_32
-		detect_ht(c);
-#endif
-	}
-
 	/* Work around errata */
 	srat_detect_node(c);
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a952e9c85b6f..9c8f7394c612 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -730,6 +730,18 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
+#ifdef CONFIG_X86_HT
+	/*
+	 * If cpu_llc_id is not yet set, this means cpuid_level < 4 which in
+	 * turns means that the only possibility is SMT (as indicated in
+	 * cpuid1). Since cpuid2 doesn't specify shared caches, and we know
+	 * that SMT shares all caches, we can unconditionally set cpu_llc_id to
+	 * c->phys_proc_id.
+	 */
+	if (per_cpu(cpu_llc_id, cpu) == BAD_APICID)
+		per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+#endif
+
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
 	return l2;
