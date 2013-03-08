Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab3CHHQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:16:40 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47750 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3CHHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:16:38 -0500
Message-ID: <51398F84.5060808@linux.vnet.ibm.com>
Date: Fri, 08 Mar 2013 12:43:08 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
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
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com> <20130307191059.GC15854@amt.cnet>
In-Reply-To: <20130307191059.GC15854@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030807-5140-0000-0000-000002DC982B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 12:40 AM, Marcelo Tosatti wrote:
> On Mon, Mar 04, 2013 at 11:31:46PM +0530, Raghavendra K T wrote:
>>   This patch series further filters better vcpu candidate to yield to
>> in PLE handler. The main idea is to record the preempted vcpus using
>> preempt notifiers and iterate only those preempted vcpus in the
>> handler. Note that the vcpus which were in spinloop during pause loop
>> exit are already filtered.
>>
>> Thanks Jiannan, Avi for bringing the idea and Gleb, PeterZ for
>> precious suggestions during the discussion.
>> Thanks Srikar for suggesting to avoid rcu lock while checking task state
>> that has improved overcommit cases.
>>
>> There are basically two approches for the implementation.
>>
>> Method 1: Uses per vcpu preempt flag (this series).
>>
>> Method 2: We keep a bitmap of preempted vcpus. using this we can easily
>> iterate over preempted vcpus.
>>
>> Note that method 2 needs an extra index variable to identify/map bitmap to
>> vcpu and it also needs static vcpu allocation.
>>
>> I am also posting Method 2 approach for reference in case it interests.
>>
>> Result: decent improvement for kernbench and ebizzy.
>>
>> base = 3.8.0 + undercommit patches
>> patched = base + preempt patches
>>
>> Tested on 32 core (no HT) mx3850 machine with 32 vcpu guest 8GB RAM
>>
>> --+-----------+-----------+-----------+------------+-----------+
>>                 kernbench (exec time in sec lower is beter)
>> --+-----------+-----------+-----------+------------+-----------+
>>        base       stdev       patched       stdev      %improve
>> --+-----------+-----------+-----------+------------+-----------+
>> 1x    47.0383     4.6977     44.2584     1.2899	    5.90986
>> 2x    96.0071     7.1873     91.2605     7.3567	    4.94401
>> 3x   164.0157    10.3613    156.6750    11.4267	    4.47561
>> 4x   212.5768    23.7326    204.4800    13.2908	    3.80888
>> --+-----------+-----------+-----------+------------+-----------+
>> no ple kernbench 1x result for reference: 46.056133
>>
>> --+-----------+-----------+-----------+------------+-----------+
>>                 ebizzy (record/sec higher is better)
>> --+-----------+-----------+-----------+------------+-----------+
>>        base       stdev       patched       stdev      %improve
>> --+-----------+-----------+-----------+------------+-----------+
>> 1x  5609.2000    56.9343    6263.7000    64.7097     11.66833
>> 2x  2071.9000   108.4829    2653.5000   181.8395     28.07085
>> 3x  1557.4167   109.7141    1993.5000   166.3176     28.00043
>> 4x  1254.7500    91.2997    1765.5000   237.5410     40.70532
>> --+-----------+-----------+-----------+------------+-----------+
>> no ple ebizzy 1x result for reference : 7394.9 rec/sec
>>
>> Please let me know if you have any suggestions and comments.
>>
>> Raghavendra K T (2):
>>     kvm: Record the preemption status of vcpus using preempt notifiers
>>     kvm: Iterate over only vcpus that are preempted
>
> Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
>

Thank you Marcelo.

