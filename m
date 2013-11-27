Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3K0NXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:23:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3K0NXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:23:09 -0500
Date: Wed, 27 Nov 2013 14:22:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>, svaidy@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, bitbucket@online.de,
        benh@kernel.crashing.org, anton@samba.org, Morten.Rasmussen@arm.com,
        pjt@google.com, mikey@neuling.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] in sched fair on v3.13-rc1+ doing hotplug
Message-ID: <20131127132243.GD10022@twins.programming.kicks-ass.net>
References: <20131127081345.0cab8b15@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127081345.0cab8b15@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 08:13:45AM -0500, Steven Rostedt wrote:
>         atomic_inc(&sd->groups->sgp->nr_busy_cpus);  <<---- BUG
> unlock:
>         rcu_read_unlock();
> }

tip/sched/urgent has this one:

---
commit 42eb088ed246a5a817bb45a8b32fe234cf1c0f8b
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Tue Nov 19 16:41:49 2013 +0100

    sched: Avoid NULL dereference on sd_busy
    
    Commit 37dc6b50cee9 ("sched: Remove unnecessary iteration over sched
    domains to update nr_busy_cpus") forgot to clear 'sd_busy' under some
    conditions leading to a possible NULL deref in set_cpu_sd_state_idle().
    
    Reported-by: Anton Blanchard <anton@samba.org>
    Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/20131118113701.GF3866@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1808606ee5f..a1591ca7eb5a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4910,8 +4910,9 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
-		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
+		sd = sd->parent; /* sd_busy */
 	}
+	rcu_assign_pointer(per_cpu(sd_busy, cpu), sd);
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_size, cpu) = size;
