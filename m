Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3A1LTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:19:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3A1LTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:19:45 -0500
Message-ID: <1359371965.5783.127.camel@marge.simpson.net>
Subject: Re: [patch] sched: minimalist select_idle_sibling() bouncing cow
 syndrome fix
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 28 Jan 2013 12:19:25 +0100
In-Reply-To: <20130128105304.GC20263@gmail.com>
References: <1359273021.5803.80.camel@marge.simpson.net>
	 <20130128105304.GC20263@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:tOU8rTuDblKA0YTb2fxRTBxA+5Ou6eJrH18w7OIh2tZ
 PPiD4aY21CXaeopy18Etwc7b2nZhpRIVIVJh1Y5mR25DKbPQH7
 T/WUhjv0WbxI4gBVBFpS1III25sMK32+CFUJC/bGxPQZ5c4TAd
 L1DWTc3Rj2G1XZqsmRpFucElqxxnUFnicPUc8kI98c7DzxQ1Nk
 rleN6UBI9rS6rJ+roelHcoTjIB3+4j5BFcnp15C5tyNNbjYZdd
 zezECZ3Iv1puy7x2bjDsSF2EZmnwdBwMhWjmSJGItoVBWB7Zhg
 b2UGmbjs9VG3x7AYFksXewdWZ0FDiRIkTyrGWxpEjDzLqGw1HE
 4g2DgKHffiFJY1CXHMeIRwtcFDlznUAIWE7qvloxkVbuO6/LP4
 3RzY1Z2cPLLWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 11:53 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <bitbucket@online.de> wrote:
> 
> > If the previous CPU is cache affine and idle, select it.
> 
> No objections in principle - but would be nice to have a 
> changelog with numbers, % of improvement included and so?

Well, that like was my changelog, guess it needs improvement.

Take 2.

sched: minimalist select_idle_sibling() bouncing cow syndrome fix

If the previous CPU is cache affine and idle, select it.

The current implementation simply traverses the sd_llc domain,
taking the first idle CPU encountered, which walks buddy pairs
hand in hand over the package, inflicting excruciating pain.

1 tbench pair (worst case) in a 10 core + SMT package:

pre   15.22 MB/sec 1 procs
post 252.01 MB/sec 1 procs

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/fair.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3270,25 +3270,18 @@ find_idlest_cpu(struct sched_group *grou
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
-	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i;
+	int i = task_cpu(p);
 
-	/*
-	 * If the task is going to be woken-up on this cpu and if it is
-	 * already idle, then it is the right target.
-	 */
-	if (target == cpu && idle_cpu(cpu))
-		return cpu;
+	if (idle_cpu(target))
+		return target;
 
 	/*
-	 * If the task is going to be woken-up on the cpu where it previously
-	 * ran and if it is currently idle, then it the right target.
+	 * If the prevous cpu is cache affine and idle, don't be stupid.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
-		return prev_cpu;
+	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
+		return i;
 
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
@@ -3302,7 +3295,7 @@ static int select_idle_sibling(struct ta
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
+				if (i == target || !idle_cpu(i))
 					goto next;
 			}
 


