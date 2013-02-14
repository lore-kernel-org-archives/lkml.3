Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab3BNOZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:25:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4095 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab3BNOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:25:29 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=amwdYq58fXoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z7SmUxEbSGQA:10 a=iWVzkWt1XPaGRwkVm3MA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360851926.23152.43.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] sched: Move idle_balance() to post_schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Thu, 14 Feb 2013 09:25:26 -0500
In-Reply-To: <1360780981.8957.3.camel@laptop>
References: <20130212225412.781044738@goodmis.org>
	 <20130212230017.625583020@goodmis.org> <1360780981.8957.3.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 19:43 +0100, Peter Zijlstra wrote:

> How does that follow? We can have to-idle switches _far_ more often than
> we balance.

I ran "perf stat -a -r 100 hackbench 500" on an i7 4 core hyperthreaded
box, and got the following results:

With no patches applied:

 Performance counter stats for '/work/c/hackbench 500' (100 runs):

     199820.045583 task-clock                #    8.016 CPUs utilized            ( +-  5.29% ) [100.00%]
         3,594,264 context-switches          #    0.018 M/sec                    ( +-  5.94% ) [100.00%]
           352,240 cpu-migrations            #    0.002 M/sec                    ( +-  3.31% ) [100.00%]
         1,006,732 page-faults               #    0.005 M/sec                    ( +-  0.56% )
   293,801,912,874 cycles                    #    1.470 GHz                      ( +-  4.20% ) [100.00%]
   261,808,125,109 stalled-cycles-frontend   #   89.11% frontend cycles idle     ( +-  4.38% ) [100.00%]
   <not supported> stalled-cycles-backend  
   135,521,344,089 instructions              #    0.46  insns per cycle        
                                             #    1.93  stalled cycles per insn  ( +-  4.37% ) [100.00%]
    26,198,116,586 branches                  #  131.109 M/sec                    ( +-  4.59% ) [100.00%]
       115,326,812 branch-misses             #    0.44% of all branches          ( +-  4.12% )

      24.929136087 seconds time elapsed                                          ( +-  5.31% )


With the two idle_balance patches applied:

 Performance counter stats for '/work/c/hackbench 500' (100 runs):

     178619.929457 task-clock                #    8.011 CPUs utilized            ( +-  4.16% ) [100.00%]
         3,171,229 context-switches          #    0.018 M/sec                    ( +-  3.30% ) [100.00%]
           323,115 cpu-migrations            #    0.002 M/sec                    ( +-  2.47% ) [100.00%]
           994,506 page-faults               #    0.006 M/sec                    ( +-  0.52% )
   269,744,391,573 cycles                    #    1.510 GHz                      ( +-  2.12% ) [100.00%]
   238,589,242,461 stalled-cycles-frontend   #   88.45% frontend cycles idle     ( +-  2.26% ) [100.00%]
   <not supported> stalled-cycles-backend  
   124,298,251,712 instructions              #    0.46  insns per cycle        
                                             #    1.92  stalled cycles per insn  ( +-  1.99% ) [100.00%]
    23,918,305,712 branches                  #  133.906 M/sec                    ( +-  2.13% ) [100.00%]
       105,863,415 branch-misses             #    0.44% of all branches          ( +-  2.14% )

      22.296151996 seconds time elapsed                                          ( +-  4.18% )


And finally with the patch at the bottom of this email applied:

 Performance counter stats for '/work/c/hackbench 500' (100 runs):

     170170.547682 task-clock                #    8.021 CPUs utilized            ( +-  5.59% ) [100.00%]
         3,118,923 context-switches          #    0.018 M/sec                    ( +-  4.82% ) [100.00%]
           318,479 cpu-migrations            #    0.002 M/sec                    ( +-  2.58% ) [100.00%]
           988,187 page-faults               #    0.006 M/sec                    ( +-  0.62% )
   271,343,352,987 cycles                    #    1.595 GHz                      ( +-  3.84% ) [100.00%]
   240,599,089,430 stalled-cycles-frontend   #   88.67% frontend cycles idle     ( +-  4.24% ) [100.00%]
   <not supported> stalled-cycles-backend  
   125,888,645,748 instructions              #    0.46  insns per cycle        
                                             #    1.91  stalled cycles per insn  ( +-  3.97% ) [100.00%]
    24,219,147,811 branches                  #  142.323 M/sec                    ( +-  4.22% ) [100.00%]
       105,077,636 branch-misses             #    0.43% of all branches          ( +-  3.70% )

      21.214840224 seconds time elapsed                                          ( +-  5.61% )

Yeah, it seems the extra check for rq empty helps. But even without
that, the current idle patches still seem pretty good.

-- Steve

diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 66b5220..025350b 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -16,7 +16,9 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 
 static void post_schedule_idle(struct rq *rq)
 {
-	idle_balance(smp_processor_id(), rq);
+	/* rq lock was released, make sure system is still idle */
+	if (likely(!rq->nr_running))
+		idle_balance(smp_processor_id(), rq);
 }
 #endif /* CONFIG_SMP */
 /*


