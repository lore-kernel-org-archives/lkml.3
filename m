Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaIJNup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:50:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaIJNuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:50:44 -0400
Date: Wed, 10 Sep 2014 15:50:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, riel@redhat.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 04/12] sched: Allow all archs to set the capacity_orig
Message-ID: <20140910135039.GP3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
 <540204DC.5090204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540204DC.5090204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 10:37:40PM +0530, Preeti U Murthy wrote:
> > -	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
> > -		if (sched_feat(ARCH_CAPACITY))
> 
> Aren't you missing this check above? I understand that it is not
> crucial, but that would also mean removing ARCH_CAPACITY sched_feat
> altogether, wouldn't it?

Yes he's missing that, I added the below bit on top.

So the argument last time:
lkml.kernel.org/r/20140709105721.GT19379@twins.programming.kicks-ass.net
was that you cannot put sched_feat(ARCH_CAPACITY) inside a weak arch_*
function. The test has to be outside, seeing how it needs to decide to
call the arch function at all (or revert to the default implementation).

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5700,7 +5700,7 @@ unsigned long __weak arch_scale_freq_cap
 	return default_scale_capacity(sd, cpu);
 }
 
-unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
 	if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
 		return sd->smt_gain / sd->span_weight;
@@ -5708,6 +5708,11 @@ unsigned long __weak arch_scale_cpu_capa
 	return SCHED_CAPACITY_SCALE;
 }
 
+unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
+{
+	return default_scale_cpu_capacity(sd, cpu);
+}
+
 static unsigned long scale_rt_capacity(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -5747,7 +5752,10 @@ static void update_cpu_capacity(struct s
 	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	capacity *= arch_scale_cpu_capacity(sd, cpu);
+	if (sched_feat(ARCH_CAPACITY))
+		capacity *= arch_scale_cpu_capacity(sd, cpu);
+	else
+		capacity *= default_scale_cpu_capacity(sd, cpu);
 
 	capacity >>= SCHED_CAPACITY_SHIFT;
 
