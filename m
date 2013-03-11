Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3CKJi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3CKJiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:38:25 -0400
Date: Mon, 11 Mar 2013 11:38:08 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Better yield_to candidate using preemption
 notifiers
Message-ID: <20130311093808.GB31619@redhat.com>
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:31:46PM +0530, Raghavendra K T wrote:
>  This patch series further filters better vcpu candidate to yield to
> in PLE handler. The main idea is to record the preempted vcpus using
> preempt notifiers and iterate only those preempted vcpus in the
> handler. Note that the vcpus which were in spinloop during pause loop
> exit are already filtered.
> 
> Thanks Jiannan, Avi for bringing the idea and Gleb, PeterZ for
> precious suggestions during the discussion. 
> Thanks Srikar for suggesting to avoid rcu lock while checking task state
> that has improved overcommit cases.
> 
> There are basically two approches for the implementation.
> 
> Method 1: Uses per vcpu preempt flag (this series).
> 
> Method 2: We keep a bitmap of preempted vcpus. using this we can easily
> iterate over preempted vcpus.
> 
> Note that method 2 needs an extra index variable to identify/map bitmap to
> vcpu and it also needs static vcpu allocation.
> 
> I am also posting Method 2 approach for reference in case it interests.
> 
> Result: decent improvement for kernbench and ebizzy.
> 
> base = 3.8.0 + undercommit patches 
> patched = base + preempt patches
> 
> Tested on 32 core (no HT) mx3850 machine with 32 vcpu guest 8GB RAM
> 
> --+-----------+-----------+-----------+------------+-----------+
>                kernbench (exec time in sec lower is beter) 
> --+-----------+-----------+-----------+------------+-----------+
>       base       stdev       patched       stdev      %improve 
> --+-----------+-----------+-----------+------------+-----------+
> 1x    47.0383     4.6977     44.2584     1.2899	    5.90986
> 2x    96.0071     7.1873     91.2605     7.3567	    4.94401
> 3x   164.0157    10.3613    156.6750    11.4267	    4.47561
> 4x   212.5768    23.7326    204.4800    13.2908	    3.80888
> --+-----------+-----------+-----------+------------+-----------+
> no ple kernbench 1x result for reference: 46.056133
> 
> --+-----------+-----------+-----------+------------+-----------+
>                ebizzy (record/sec higher is better)
> --+-----------+-----------+-----------+------------+-----------+
>       base       stdev       patched       stdev      %improve 
> --+-----------+-----------+-----------+------------+-----------+
> 1x  5609.2000    56.9343    6263.7000    64.7097     11.66833
> 2x  2071.9000   108.4829    2653.5000   181.8395     28.07085
> 3x  1557.4167   109.7141    1993.5000   166.3176     28.00043
> 4x  1254.7500    91.2997    1765.5000   237.5410     40.70532
> --+-----------+-----------+-----------+------------+-----------+
> no ple ebizzy 1x result for reference : 7394.9 rec/sec
> 
> Please let me know if you have any suggestions and comments.
> 
> Raghavendra K T (2):
>    kvm: Record the preemption status of vcpus using preempt notifiers
>    kvm: Iterate over only vcpus that are preempted
> 	
Applied, thanks!

--
			Gleb.
