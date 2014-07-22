Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaGVJrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:47:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaGVJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:47:47 -0400
Date: Tue, 22 Jul 2014 11:47:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722094740.GJ12054@laptop.lan>
References: <53C7B247.2070309@arm.com>
 <20140717123502.GL19379@twins.programming.kicks-ass.net>
 <20140718053449.GA2039@wolff.to>
 <20140718101633.GP9918@twins.programming.kicks-ass.net>
 <20140718130126.GA2401@wolff.to>
 <20140718141648.GE20603@laptop.programming.kicks-ass.net>
 <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721165212.GO3935@laptop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 06:52:12PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 21, 2014 at 11:35:28AM -0500, Bruno Wolff III wrote:
> > Is there more I can do to help with this now? Or should I just wait for
> > patches to test?
> 
> Yeah, sorry, was wiped out today. I'll go stare harder at the P4
> topology setup code tomorrow. Something fishy there.

Does this make your machine boot again (while giving an error)?

It tries to robustify the topology setup a bit, crashing on crap input
should be avoided if possible of course.

I'll go stare at the x86/P4 topology code like promised.

---
Subject: sched: Robustify topology setup
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Jul 21 23:07:06 CEST 2014

We hard assume that higher topology levels are strict supersets of
lower levels.

Detect, warn and try to fixup when we encounter this violated.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-cgp9j2tk0qnunhtpps3udsom@git.kernel.org
---
 kernel/sched/core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6480,6 +6480,20 @@ struct sched_domain *build_sched_domain(
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
 		sd->child = child;
+
+		if (!cpumask_subset(sched_domain_span(child),
+				    sched_domain_span(sd))) {
+			pr_err("BUG: arch topology borken\n");
+#ifdef CONFIG_SCHED_DEBUG
+			pr_err("     the %s domain not a subset of the %s domain\n",
+					child->name, sd->name);
+#endif
+			/* Fixup, ensure @sd has at least @child cpus. */
+			cpumask_or(sched_domain_span(sd),
+				   sched_domain_span(sd),
+				   sched_domain_span(child));
+		}
+
 	}
 	set_domain_attribute(sd, attr);
 
