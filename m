Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3CEMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:40:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3CEMkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:40:53 -0500
Date: Tue, 5 Mar 2013 13:40:13 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 0/2] kvm: Better yield_to candidate using preemption
 notifiers
Message-ID: <20130305124012.GA2287@hawk.usersys.redhat.com>
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
 <20130305095307.GA11728@hawk.usersys.redhat.com>
 <5135E3E9.3020608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5135E3E9.3020608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 05:54:09PM +0530, Raghavendra K T wrote:
> On 03/05/2013 03:23 PM, Andrew Jones wrote:
> >On Mon, Mar 04, 2013 at 11:31:46PM +0530, Raghavendra K T wrote:
> >>  This patch series further filters better vcpu candidate to yield to
> >>in PLE handler. The main idea is to record the preempted vcpus using
> >>preempt notifiers and iterate only those preempted vcpus in the
> >>handler. Note that the vcpus which were in spinloop during pause loop
> >>exit are already filtered.
> >
> >The %improvement and patch series look good.
> >
> 
> Thank you for the review.
> 
> >>
> >>Thanks Jiannan, Avi for bringing the idea and Gleb, PeterZ for
> >>precious suggestions during the discussion.
> >>Thanks Srikar for suggesting to avoid rcu lock while checking task state
> >>that has improved overcommit cases.
> >>
> >>There are basically two approches for the implementation.
> >>
> >>Method 1: Uses per vcpu preempt flag (this series).
> >>
> >>Method 2: We keep a bitmap of preempted vcpus. using this we can easily
> >>iterate over preempted vcpus.
> >>
> >>Note that method 2 needs an extra index variable to identify/map bitmap to
> >>vcpu and it also needs static vcpu allocation.
> >
> >We definitely don't want something that requires static vcpu allocation.
> >I think it'd be better to add another counter for the vcpu bit assignment.
> >
> 
> So do you mean some thing parallel to online_vcpus?

Yes, one that only grows. However, then, if a vcpu is unplugged, its bit
would have to be skipped over.

> 
> >>
> >>I am also posting Method 2 approach for reference in case it interests.
> >
> >I guess the interest in Method2 would come from perf numbers. Did you try
> >comparing Method1 vs. Method2?
> >
> 
> Yes I did. Performance wise method2 is almost equal to method1. But I
> believe if there is any difference it may show when we have large vcpu
> guest. (Currently I have only 32 core host).
> 

OK, probably not worth it at this point then.

thanks,
drew
