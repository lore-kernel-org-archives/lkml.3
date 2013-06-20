Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3FTSX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:23:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab3FTSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:23:55 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CP4Tl-rxqdAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9d5NqswhC6UA:10 a=r9Zhi9gsu43Pp9-QBzMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371752633.18733.96.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 14:23:53 -0400
In-Reply-To: <20130619195822.GA16489@redhat.com>
References: <20130618192147.GA19443@redhat.com>
	 <20130619121039.GA19225@twins.programming.kicks-ass.net>
	 <20130619152844.GA9176@redhat.com> <20130619175139.GA20454@redhat.com>
	 <51C1FD7F.9090606@gmail.com> <20130619195822.GA16489@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 21:58 +0200, Oleg Nesterov wrote:
> On 06/19, David Ahern wrote:
> >
> > On 6/19/13 11:51 AM, Oleg Nesterov wrote:
> >>
> >> not sure these numbers actually mean
> >> something, but still.
> 
> Yes.
> 
> >> So, the test-case:
> >>
> >> 	int pipe1[2], pipe2[2];
> >
> > Same as "perf bench sched pipe"
> 
> You just cruelly disclosed the fact that I do not use perf.
> 
> Thanks. So,
> 
> 	# perf record -e sched:sched_switch -p1 &
> 	[1] 516
> 	# perf bench sched pipe
> 
> 3 times.
> 
> before:
> 
>      Total time: 30.119 [sec]
> 
>       30.119501 usecs/op
>           33201 ops/sec
> 
>      Total time: 30.634 [sec]
> 
>       30.634105 usecs/op
>           32643 ops/sec
> 
>      Total time: 30.100 [sec]
> 
>       30.100209 usecs/op
>           33222 ops/sec
> 
> 
> after:
> 
>      Total time: 29.645 [sec]
> 
>       29.645941 usecs/op
>           33731 ops/sec
> 
>      Total time: 29.759 [sec]
> 
>       29.759075 usecs/op
>           33603 ops/sec
> 
>      Total time: 29.803 [sec]
> 
>       29.803522 usecs/op
>           33553 ops/sec
> 
> Hmm. Actually sched-pipe.c is a bit more "heavy", it does switch_mm().
> And I used taskset. But it seems that this test-case shows the similar
> results.
> 

OK, I tested this against 3.10-rc6 and then applied your patches (had to
modify a little because it didn't apply that cleanly).

I ran this:  

 perf stat --repeat 100 -- perf bench sched pipe > /tmp/perf-bench-sched.{before, after}

before:

# tail -20 perf-bench-sched.before 
      24.115329 usecs/op
          41467 ops/sec


 Performance counter stats for 'perf bench sched pipe' (100 runs):

      17851.057092 task-clock                #    0.741 CPUs utilized            ( +-  0.03% )
         1,996,681 context-switches          #    0.112 M/sec                    ( +-  0.00% )
                61 cpu-migrations            #    0.003 K/sec                    ( +-  2.13% )
             1,248 page-faults               #    0.070 K/sec                    ( +-  0.01% )
    29,738,460,230 cycles                    #    1.666 GHz                      ( +-  0.03% ) [50.91%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
    22,108,278,276 instructions              #    0.74  insns per cycle          ( +-  0.01% ) [76.35%]
     5,275,965,301 branches                  #  295.555 M/sec                    ( +-  0.00% ) [74.14%]
        69,232,340 branch-misses             #    1.31% of all branches          ( +-  0.19% ) [74.95%]

      24.089150300 seconds time elapsed                                          ( +-  0.02% )


after:

# tail -20 perf-bench-sched.after 
      24.170945 usecs/op
          41371 ops/sec


 Performance counter stats for 'perf bench sched pipe' (100 runs):

      18060.703178 task-clock                #    0.747 CPUs utilized            ( +-  0.02% )
         1,996,865 context-switches          #    0.111 M/sec                    ( +-  0.00% )
                63 cpu-migrations            #    0.003 K/sec                    ( +-  3.07% )
             1,248 page-faults               #    0.069 K/sec                    ( +-  0.01% )
    29,596,801,452 cycles                    #    1.639 GHz                      ( +-  0.02% ) [49.13%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
    22,033,684,587 instructions              #    0.74  insns per cycle          ( +-  0.01% ) [73.34%]
     5,281,256,193 branches                  #  292.417 M/sec                    ( +-  0.00% ) [75.84%]
        66,966,995 branch-misses             #    1.27% of all branches          ( +-  0.22% ) [75.04%]

      24.183738898 seconds time elapsed                                          ( +-  0.01% )



Maybe I did something wrong, but on this box, I didn't see any
significant improvement with the patches. Note, I did the test before
applying all patches, and then again after applying all patches.

-- Steve


