Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3AXI3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:29:53 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36669 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3AXI3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:29:47 -0500
Message-ID: <5100F060.7050908@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2013 13:57:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
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
References: <20130122073854.24731.9426.sendpatchset@codeblue.in.ibm.com> <20130123135707.GA5817@hawk.usersys.redhat.com>
In-Reply-To: <20130123135707.GA5817@hawk.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012408-5490-0000-0000-000002DE1F1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 07:27 PM, Andrew Jones wrote:
> On Tue, Jan 22, 2013 at 01:08:54PM +0530, Raghavendra K T wrote:
>>   In some special scenarios like #vcpu <= #pcpu, PLE handler may
>> prove very costly, because there is no need to iterate over vcpus
>> and do unsuccessful yield_to burning CPU.
>>
>>   The first patch optimizes all the yield_to by bailing out when there
>>   is no need to continue in yield_to (i.e., when there is only one task
>>   in source and target rq).
>>
>>   Second patch uses that in PLE handler. Further when a yield_to fails
>>   we do not immediately go out of PLE handler instead we try thrice
>>   to have better statistical possibility of false return. Otherwise that
>>   would affect moderate overcommit cases.
>>
>>   Result on 3.7.0-rc6 kernel shows around 140% improvement for ebizzy 1x and
>>   around 51% for dbench 1x  with 32 core PLE machine with 32 vcpu guest.
>>
>>
>> base = 3.7.0-rc6
>> machine: 32 core mx3850 x5 PLE mc
>>
>> --+-----------+-----------+-----------+------------+-----------+
>>                 ebizzy (rec/sec higher is beter)
>> --+-----------+-----------+-----------+------------+-----------+
>>      base        stdev       patched     stdev       %improve
>> --+-----------+-----------+-----------+------------+-----------+
>> 1x   2511.3000    21.5409    6051.8000   170.2592   140.98276
>> 2x   2679.4000   332.4482    2692.3000   251.4005     0.48145
>> 3x   2253.5000   266.4243    2192.1667   178.9753    -2.72169
>> --+-----------+-----------+-----------+------------+-----------+
>>
>> --+-----------+-----------+-----------+------------+-----------+
>>          dbench (throughput in MB/sec. higher is better)
>> --+-----------+-----------+-----------+------------+-----------+
>>      base        stdev       patched     stdev       %improve
>> --+-----------+-----------+-----------+------------+-----------+
>> 1x  6677.4080   638.5048    10098.0060   3449.7026     51.22643
>> 2x  2012.6760    64.7642    2019.0440     62.6702       0.31639
>> 3x  1302.0783    40.8336    1292.7517     27.0515      -0.71629
>> --+-----------+-----------+-----------+------------+-----------+
>>
>> Here is the refernce of no ple result.
>>   ebizzy-1x_nople 7592.6000 rec/sec
>>   dbench_1x_nople 7853.6960 MB/sec
>
> I'm not sure how much we should trust ebizzy results,

Infact in my box ebizzy is giving very consistent result.

but even
> so, the dbench results are stranger. The percent error is huge
> (34%) and somehow we do much better for 1x overcommit with PLE
> enabled then without (for the patched version). How does that
> happen? How many guests are running in the 1x test?

Yes, dbench 1x result has big variance. I was running 4 guests
with 3 guests idle for 1x case.

  And are the
> throughput results the combined throughput of all of them? I
> wonder if this jump in throughput is just the guests' perceived
> throughput, but wrong due to bad virtual time keeping.  Can we
> run a long-lasting benchmark and measure the elapsed time with
> a clock external from the guests?

Are you saying guest time keeping is not reliable and hence resulting
in high variance.  dbench tests are 3 minute + 30sec warmup tests, and
look very consistent in 2x,3x,4x cases..

I am happy to go ahead and test with whatever you suggest.

But in general I am seeing undercommit cases improve very well
especially for large guests. Vinod had posted Aim7 benchmark results
which had supported that for lower overcommits. However for near 1x
cases he saw variations but definite improvements around 100-200%
IIRC against base PLE.

