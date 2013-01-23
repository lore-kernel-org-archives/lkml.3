Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3AWN5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:57:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab3AWN5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:57:31 -0500
Date: Wed, 23 Jan 2013 14:57:08 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH V3 RESEND RFC 0/2] kvm: Improving undercommit scenarios
Message-ID: <20130123135707.GA5817@hawk.usersys.redhat.com>
References: <20130122073854.24731.9426.sendpatchset@codeblue.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122073854.24731.9426.sendpatchset@codeblue.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 01:08:54PM +0530, Raghavendra K T wrote:
>  In some special scenarios like #vcpu <= #pcpu, PLE handler may
> prove very costly, because there is no need to iterate over vcpus
> and do unsuccessful yield_to burning CPU.
> 
>  The first patch optimizes all the yield_to by bailing out when there
>  is no need to continue in yield_to (i.e., when there is only one task 
>  in source and target rq).
> 
>  Second patch uses that in PLE handler. Further when a yield_to fails
>  we do not immediately go out of PLE handler instead we try thrice 
>  to have better statistical possibility of false return. Otherwise that
>  would affect moderate overcommit cases.
>  
>  Result on 3.7.0-rc6 kernel shows around 140% improvement for ebizzy 1x and
>  around 51% for dbench 1x  with 32 core PLE machine with 32 vcpu guest.
> 
> 
> base = 3.7.0-rc6 
> machine: 32 core mx3850 x5 PLE mc
> 
> --+-----------+-----------+-----------+------------+-----------+
>                ebizzy (rec/sec higher is beter)
> --+-----------+-----------+-----------+------------+-----------+
>     base        stdev       patched     stdev       %improve     
> --+-----------+-----------+-----------+------------+-----------+
> 1x   2511.3000    21.5409    6051.8000   170.2592   140.98276   
> 2x   2679.4000   332.4482    2692.3000   251.4005     0.48145
> 3x   2253.5000   266.4243    2192.1667   178.9753    -2.72169
> --+-----------+-----------+-----------+------------+-----------+
> 
> --+-----------+-----------+-----------+------------+-----------+
>         dbench (throughput in MB/sec. higher is better)
> --+-----------+-----------+-----------+------------+-----------+
>     base        stdev       patched     stdev       %improve     
> --+-----------+-----------+-----------+------------+-----------+
> 1x  6677.4080   638.5048    10098.0060   3449.7026     51.22643
> 2x  2012.6760    64.7642    2019.0440     62.6702       0.31639
> 3x  1302.0783    40.8336    1292.7517     27.0515      -0.71629
> --+-----------+-----------+-----------+------------+-----------+
> 
> Here is the refernce of no ple result.
>  ebizzy-1x_nople 7592.6000 rec/sec
>  dbench_1x_nople 7853.6960 MB/sec

I'm not sure how much we should trust ebizzy results, but even
so, the dbench results are stranger. The percent error is huge
(34%) and somehow we do much better for 1x overcommit with PLE
enabled then without (for the patched version). How does that
happen? How many guests are running in the 1x test? And are the
throughput results the combined throughput of all of them? I
wonder if this jump in throughput is just the guests' perceived
throughput, but wrong due to bad virtual time keeping. Can we
run a long-lasting benchmark and measure the elapsed time with
a clock external from the guests?

Drew

> 
> The result says we can still improve by 60% for ebizzy, but overall we are
> getting impressive performance with the patches.
> 
>  Changes Since V2:
>  - Dropped global measures usage patch (Peter Zilstra)
>  - Do not bail out on first failure (Avi Kivity)
>  - Try thrice for the failure of yield_to to get statistically more correct
>    behaviour.
> 
>  Changes since V1:
>  - Discard the idea of exporting nrrunning and optimize in core scheduler (Peter)
>  - Use yield() instead of schedule in overcommit scenarios (Rik)
>  - Use loadavg knowledge to detect undercommit/overcommit
> 
>  Peter Zijlstra (1):
>   Bail out of yield_to when source and target runqueue has one task
> 
>  Raghavendra K T (1):
>   Handle yield_to failure return for potential undercommit case
> 
>  Please let me know your comments and suggestions.
> 
>  Link for the discussion of V3 original:
>  https://lkml.org/lkml/2012/11/26/166
> 
>  Link for V2:
>  https://lkml.org/lkml/2012/10/29/287
> 
>  Link for V1:
>  https://lkml.org/lkml/2012/9/21/168
> 
>  kernel/sched/core.c | 25 +++++++++++++++++++------
>  virt/kvm/kvm_main.c | 26 ++++++++++++++++----------
>  2 files changed, 35 insertions(+), 16 deletions(-)
> 
