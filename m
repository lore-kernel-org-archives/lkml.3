Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3LJK6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:58:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45680 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3LJK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:58:37 -0500
Date: Tue, 10 Dec 2013 11:58:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
Message-ID: <20131210105820.GC12849@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
 <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
 <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
 <20131121150344.GG10022@twins.programming.kicks-ass.net>
 <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
 <CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
 <alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
 <CAE9FiQUVLT3PL3ON_VRrNB6p9TxFU_-X_dkcb6dLvzonmmW7ag@mail.gmail.com>
 <CAE9FiQW53FvCUGnax0CVdrWL8wqd4wweEfQVZgJciivAYaD1yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW53FvCUGnax0CVdrWL8wqd4wweEfQVZgJciivAYaD1yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 10:24:25PM -0800, Yinghai Lu wrote:
> ---
>  kernel/sched/core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -5737,6 +5737,9 @@ static int __sdt_alloc(const struct cpum
>  			if (!sgp)
>  				return -ENOMEM;
>  
> +			/* avoid divide-by-zero in sg_capacity() */
> +			sgp->power_orig = 1;
> +
>  			*per_cpu_ptr(sdd->sgp, j) = sgp;
>  		}
>  	}


Ooh, sg_capacity() is generating the /0.. 

Does the below work too?

---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 87c3bc47d99d..40b185f5a3ec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5115,6 +5115,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * die on a /0 trap.
 		 */
 		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
+		sg->sgp->power_orig = sg->sgp->power;
 
 		/*
 		 * Make sure the first group of this domain contains the
