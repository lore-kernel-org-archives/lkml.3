Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3AUEj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:39:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3AUEjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:39:25 -0500
Message-ID: <1358743128.4994.33.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 05:38:48 +0100
In-Reply-To: <50FCACE3.5000706@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:UMImqVbcMLPCOZQn8R3+vptbcyIURnJL+fwXueURoBh
 rx3TlURX2+eHbtkvRiAM3oDeNgdUYR6B3eM0wPHAxdZBryFN9u
 VTlE7wEtOSvlw+OjJ3IQP/yJXLCPc7ZJFdPQ0FSaKsku7H/Ohv
 rtYXNZkXIs/BEBfsVEmClVYVhZ1xDnLABfDgnDI19x25Tw3Byb
 rRsn+wdLtVereGevm+2mm9UPqTqWSGMzq6yYb72+X+y3zvKgHm
 x//8SvbnLGMircid6c43hTZ0jlY6RkY8XcGL7SzZGpdETnwVzy
 n9QAQcmvEGbdMcBpeLtijIF6+uD/8Nl7eQUJCLSGgiSVV+vyoA
 WP2bMpQS5gbKqhLx6Hek+FNyuV5BPe/GojsGybML2GXvOrAeA9
 ixFgdDF1RsrIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 10:50 +0800, Michael Wang wrote: 
> On 01/20/2013 12:09 PM, Mike Galbraith wrote:
> > On Thu, 2013-01-17 at 13:55 +0800, Michael Wang wrote: 
> >> Hi, Mike
> >>
> >> I've send out the v2, which I suppose it will fix the below BUG and
> >> perform better, please do let me know if it still cause issues on your
> >> arm7 machine.
> > 
> > s/arm7/aim7
> > 
> > Someone swiped half of CPUs/ram, so the box is now 2 10 core nodes vs 4.
> > 
> > stock scheduler knobs
> > 
> > 3.8-wang-v2                                 avg     3.8-virgin                          avg    vs wang
> > Tasks    jobs/min
> >     1      436.29    435.66    435.97    435.97        437.86    441.69    440.09    439.88      1.008
> >     5     2361.65   2356.14   2350.66   2356.15       2416.27   2563.45   2374.61   2451.44      1.040
> >    10     4767.90   4764.15   4779.18   4770.41       4946.94   4832.54   4828.69   4869.39      1.020
> >    20     9672.79   9703.76   9380.80   9585.78       9634.34   9672.79   9727.13   9678.08      1.009
> >    40    19162.06  19207.61  19299.36  19223.01      19268.68  19192.40  19056.60  19172.56       .997
> >    80    37610.55  37465.22  37465.22  37513.66      37263.64  37120.98  37465.22  37283.28       .993
> >   160    69306.65  69655.17  69257.14  69406.32      69257.14  69306.65  69257.14  69273.64       .998
> >   320   111512.36 109066.37 111256.45 110611.72     108395.75 107913.19 108335.20 108214.71       .978
> >   640   142850.83 148483.92 150851.81 147395.52     151974.92 151263.65 151322.67 151520.41      1.027
> >  1280    52788.89  52706.39  67280.77  57592.01     189931.44 189745.60 189792.02 189823.02      3.295
> >  2560    75403.91  52905.91  45196.21  57835.34     217368.64 217582.05 217551.54 217500.74      3.760
> > 
> > sched_latency_ns = 24ms
> > sched_min_granularity_ns = 8ms
> > sched_wakeup_granularity_ns = 10ms
> > 
> > 3.8-wang-v2                                 avg     3.8-virgin                          avg    vs wang
> > Tasks    jobs/min
> >     1      436.29    436.60    434.72    435.87        434.41    439.77    438.81    437.66      1.004
> >     5     2382.08   2393.36   2451.46   2408.96       2451.46   2453.44   2425.94   2443.61      1.014
> >    10     5029.05   4887.10   5045.80   4987.31       4844.12   4828.69   4844.12   4838.97       .970
> >    20     9869.71   9734.94   9758.45   9787.70       9513.34   9611.42   9565.90   9563.55       .977
> >    40    19146.92  19146.92  19192.40  19162.08      18617.51  18603.22  18517.95  18579.56       .969
> >    80    37177.91  37378.57  37292.31  37282.93      36451.13  36179.10  36233.18  36287.80       .973
> >   160    70260.87  69109.05  69207.71  69525.87      68281.69  68522.97  68912.58  68572.41       .986
> >   320   114745.56 113869.64 114474.62 114363.27     114137.73 114137.73 114137.73 114137.73       .998
> >   640   164338.98 164338.98 164618.00 164431.98     164130.34 164130.34 164130.34 164130.34       .998
> >  1280   209473.40 209134.54 209473.40 209360.44     210040.62 210040.62 210097.51 210059.58      1.003
> >  2560   242703.38 242627.46 242779.34 242703.39     244001.26 243847.85 243732.91 243860.67      1.004
> > 
> > As you can see, the load collapsed at the high load end with stock
> > scheduler knobs (desktop latency).  With knobs set to scale, the delta
> > disappeared.
> 
> Thanks for the testing, Mike, please allow me to ask few questions.
> 
> What are those tasks actually doing? what's the workload?

It's the canned aim7 compute load, mixed bag load weighted toward
compute.  Below is the workfile, should give you an idea.

# @(#) workfile.compute:1.3 1/22/96 00:00:00
# Compute Server Mix
FILESIZE: 100K
POOLSIZE: 250M
50  add_double
30  add_int
30  add_long
10  array_rtns
10  disk_cp
30  disk_rd
10  disk_src
20  disk_wrt
40  div_double
30  div_int
50  matrix_rtns
40  mem_rtns_1
40  mem_rtns_2
50  mul_double
30  mul_int
30  mul_long
40  new_raph
40  num_rtns_1
50  page_test
40  series_1
10  shared_memory
30  sieve
20  stream_pipe
30  string_rtns
40  trig_rtns
20  udp_test

> And I'm confusing about how those new parameter value was figured out
> and how could them help solve the possible issue?

Oh, that's easy.  I set sched_min_granularity_ns such that last_buddy
kicks in when a third task arrives on a runqueue, and set
sched_wakeup_granularity_ns near minimum that still allows wakeup
preemption to occur.  Combined effect is reduced over-scheduling.
> Do you have any idea about which part in this patch set may cause the issue?

Nope, I'm as puzzled by that as you are.  When the box had 40 cores,
both virgin and patched showed over-scheduling effects, but not like
this.  With 20 cores, symptoms changed in a most puzzling way, and I
don't see how you'd be directly responsible.

> One change by designed is that, for old logical, if it's a wake up and
> we found affine sd, the select func will never go into the balance path,
> but the new logical will, in some cases, do you think this could be a
> problem?

Since it's the high load end, where looking for an idle core is most
likely to be a waste of time, it makes sense that entering the balance
path would hurt _some_, it isn't free.. except for twiddling preemption
knobs making the collapse just go away.  We're still going to enter that
path if all cores are busy, no matter how I twiddle those knobs.
  
> > I thought perhaps the bogus (shouldn't exist) CPU domain in mainline
> > somehow contributes to the strange behavioral delta, but killing it made
> > zero difference.  All of these numbers for both trees were logged with
> > the below applies, but as noted, it changed nothing. 
> 
> The patch set was supposed to do accelerate by reduce the cost of
> select_task_rq(), so it should be harmless for all the conditions.

Yeah, it should just save some cycles, but I like to eliminate known
bugs when testing, just in case.

-Mike

