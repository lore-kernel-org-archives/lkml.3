Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaDMNk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 09:40:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:41087 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754492AbaDMNk0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 09:40:26 -0400
Date: Sun, 13 Apr 2014 09:40:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/cpupri: fix cpupri_find() for high priority tasks
Message-ID: <20140413094023.47c762fd@gandalf.local.home>
In-Reply-To: <1397015410.5212.13.camel@marge.simpson.net>
References: <1397015410.5212.13.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014 05:50:10 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> Hi Steven,
> 
> Seems c92211d9b7727 introduced a buglet.
> 
> --snip--
> 
> Bail on task_pri >= MAX_RT_PRIO excludes userspace prio 98 and 99 tasks,
> which map to 100 and 101 respectively.
> 
> A user reported that given two SCHED_RR tasks, one hog, one light, the light
> task may be stacked on top of the hog iff prio >= 98, latency hit follows.
> 
> Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c92211d9b7727 sched/cpupri: Remove the vec->lock
> ---
>  kernel/sched/cpupri.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- a/kernel/sched/cpupri.c
> +++ b/kernel/sched/cpupri.c
> @@ -70,9 +70,6 @@ int cpupri_find(struct cpupri *cp, struc
>  	int idx = 0;
>  	int task_pri = convert_prio(p->prio);
>  
> -	if (task_pri >= MAX_RT_PRIO)
> -		return 0;

task_pri is used as an index into pri_to_cpu. Although I don't see how
this can be called for a non RT task, the safer solution is below.

-- Steve

> -
>  	for (idx = 0; idx < task_pri; idx++) {
>  		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
>  		int skip = 0;
> 

>From 606aa467c9a51c09ce4efa320db45eee59a9bd06 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Sun, 13 Apr 2014 09:34:53 -0400
Subject: [PATCH] sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in
 cpupri check

The check at the beginning of cpupri_find() makes sure that the task_pri
variable does not exceed the cp->pri_to_cpu array length. But that length
is CPUPRI_NR_PRIORITIES not MAX_RT_PRIO, where it will miss the last two
priorities in that array.

Link: http://lkml.kernel.org/r/1397015410.5212.13.camel@marge.simpson.net

Cc: stable@vger.kernel.org
Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/cpupri.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 8b836b3..557356a 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -70,7 +70,7 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 	int idx = 0;
 	int task_pri = convert_prio(p->prio);
 
-	if (task_pri >= MAX_RT_PRIO)
+	if (task_pri >= CPUPRI_NR_PRIORITIES)
 		return 0;
 
 	for (idx = 0; idx < task_pri; idx++) {
-- 
1.8.1.4

