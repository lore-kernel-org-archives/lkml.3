Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbaGROuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:50:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:45368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbaGROun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:50:43 -0400
Date: Fri, 18 Jul 2014 16:50:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140718145040.GG12054@laptop.lan>
References: <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
 <20140717090452.GH19379@twins.programming.kicks-ass.net>
 <53C7B247.2070309@arm.com>
 <20140717123502.GL19379@twins.programming.kicks-ass.net>
 <20140718053449.GA2039@wolff.to>
 <20140718101633.GP9918@twins.programming.kicks-ass.net>
 <20140718130126.GA2401@wolff.to>
 <20140718141648.GE20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718141648.GE20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:16:48PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 18, 2014 at 08:01:26AM -0500, Bruno Wolff III wrote:
> > build_sched_domain: cpu: 0 level: SMT cpu_map: 0-3 tl->mask: 0,2
> > [    0.254433] build_sched_domain: cpu: 0 level: MC cpu_map: 0-3 tl->mask: 0
> > [    0.254516] build_sched_domain: cpu: 0 level: DIE cpu_map: 0-3 tl->mask: 0-3
> > [    0.254600] build_sched_domain: cpu: 1 level: SMT cpu_map: 0-3 tl->mask: 1,3
> > [    0.254683] build_sched_domain: cpu: 1 level: MC cpu_map: 0-3 tl->mask: 1
> > [    0.254766] build_sched_domain: cpu: 1 level: DIE cpu_map: 0-3 tl->mask: 0-3
> > [    0.254850] build_sched_domain: cpu: 2 level: SMT cpu_map: 0-3 tl->mask: 0,2
> > [    0.254932] build_sched_domain: cpu: 2 level: MC cpu_map: 0-3 tl->mask: 2
> > [    0.255005] build_sched_domain: cpu: 2 level: DIE cpu_map: 0-3 tl->mask: 0-3
> > [    0.255091] build_sched_domain: cpu: 3 level: SMT cpu_map: 0-3 tl->mask: 1,3
> > [    0.255176] build_sched_domain: cpu: 3 level: MC cpu_map: 0-3 tl->mask: 3
> > [    0.255260] build_sched_domain: cpu: 3 level: DIE cpu_map: 0-3 tl->mask: 0-3
> 
> *blink*...
> 
> That's, shall we say, unexpected. Let me ponder that a bit. HPA any clue
> why a machine might report such a weird topology? AFAIK threads _always_
> share cache.  So how can cpu_coregroup_mask be a subset (instead of a
> superset) of topology_thread_cpumask?
> 
> Let me go stare at the x86 topology mask setup code.

Possibly something like so, but I'm not too sure. Anybody?

---
 arch/x86/kernel/smpboot.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798930ef..5eefa9abc2a9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -338,9 +338,15 @@ static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
-	if (per_cpu(cpu_llc_id, cpu1) != BAD_APICID &&
-	    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2))
+	if (cpu_has_topoext) {
+		if (per_cpu(cpu_llc_id, cpu1) != BAD_APICID &&
+		    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2))
+			return topology_sane(c, o, "llc");
+
+	} else if (c->phys_proc_id == o->phys_proc_id &&
+		   c->cpu_core_id == o->cpu_core_id) {
 		return topology_sane(c, o, "llc");
+	}
 
 	return false;
 }
