Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3FGXmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:42:00 -0400
Received: from mb2i1mx.ns.pitt.edu ([136.142.11.142]:55626 "EHLO
	mb2i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752746Ab3FGXl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:41:58 -0400
Date: Fri, 07 Jun 2013 16:41:56 -0700
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
In-reply-to: <51B17A6A.7060709@linux.vnet.ibm.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jiannan Ouyang <ouyang@cs.pitt.edu>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        x86@kernel.org, konrad.wilk@oracle.com,
        "H. Peter Anvin" <hpa@zytor.com>, pbonzini@redhat.com,
        linux-doc@vger.kernel.org,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com, Peter Zijlstra <peterz@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        andi@firstfloor.org, attilio.rao@citrix.com, gregkh@suse.de,
        Alexander Graf <agraf@suse.de>, chegu vinod <chegu_vinod@hp.com>,
        torvalds@linux-foundation.org, Avi Kivity <avi.kivity@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stephan.diestelhorst@amd.com,
        Rik van Riel <riel@redhat.com>, Andrew Jones <drjones@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Message-id: <CAJocwcdwkaV-u1VkZhw3YAfXq_UrWL_Z=aQqRMGaqBN5hXYjNA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130602080739.GA24773@redhat.com>
 <CAJocwcf0oykyLv4B22pBf1A3H7+Cs6qu0vmTWp46Z=KwrTkXyQ@mail.gmail.com>
 <51ABF410.4090109@linux.vnet.ibm.com> <51AC35F0.4010400@linux.vnet.ibm.com>
 <51B17A6A.7060709@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raghu, thanks for you input. I'm more than glad to work together with
you to make this idea work better.

-Jiannan

On Thu, Jun 6, 2013 at 11:15 PM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
> On 06/03/2013 11:51 AM, Raghavendra K T wrote:
>>
>> On 06/03/2013 07:10 AM, Raghavendra K T wrote:
>>>
>>> On 06/02/2013 09:50 PM, Jiannan Ouyang wrote:
>>>>
>>>> On Sun, Jun 2, 2013 at 1:07 AM, Gleb Natapov <gleb@redhat.com> wrote:
>>>>
>>>>> High level question here. We have a big hope for "Preemptable Ticket
>>>>> Spinlock" patch series by Jiannan Ouyang to solve most, if not all,
>>>>> ticketing spinlocks in overcommit scenarios problem without need for
>>>>> PV.
>>>>> So how this patch series compares with his patches on PLE enabled
>>>>> processors?
>>>>>
>>>>
>>>> No experiment results yet.
>>>>
>>>> An error is reported on a 20 core VM. I'm during an internship
>>>> relocation, and will start work on it next week.
>>>
>>>
>>> Preemptable spinlocks' testing update:
>>> I hit the same softlockup problem while testing on 32 core machine with
>>> 32 guest vcpus that Andrew had reported.
>>>
>>> After that i started tuning TIMEOUT_UNIT, and when I went till (1<<8),
>>> things seemed to be manageable for undercommit cases.
>>> But I still see degradation for undercommit w.r.t baseline itself on 32
>>> core machine (after tuning).
>>>
>>> (37.5% degradation w.r.t base line).
>>> I can give the full report after the all tests complete.
>>>
>>> For over-commit cases, I again started hitting softlockups (and
>>> degradation is worse). But as I said in the preemptable thread, the
>>> concept of preemptable locks looks promising (though I am still not a
>>> fan of  embedded TIMEOUT mechanism)
>>>
>>> Here is my opinion of TODOs for preemptable locks to make it better ( I
>>> think I need to paste in the preemptable thread also)
>>>
>>> 1. Current TIMEOUT UNIT seem to be on higher side and also it does not
>>> scale well with large guests and also overcommit. we need to have a
>>> sort of adaptive mechanism and better is sort of different TIMEOUT_UNITS
>>> for different types of lock too. The hashing mechanism that was used in
>>> Rik's spinlock backoff series fits better probably.
>>>
>>> 2. I do not think TIMEOUT_UNIT itself would work great when we have a
>>> big queue (for large guests / overcommits) for lock.
>>> one way is to add a PV hook that does yield hypercall immediately for
>>> the waiters above some THRESHOLD so that they don't burn the CPU.
>>> ( I can do POC to check if  that idea works in improving situation
>>> at some later point of time)
>>>
>>
>> Preemptable-lock results from my run with 2^8 TIMEOUT:
>>
>> +-----------+-----------+-----------+------------+-----------+
>>                   ebizzy (records/sec) higher is better
>> +-----------+-----------+-----------+------------+-----------+
>>      base        stdev        patched    stdev        %improvement
>> +-----------+-----------+-----------+------------+-----------+
>> 1x  5574.9000   237.4997    3484.2000   113.4449   -37.50202
>> 2x  2741.5000   561.3090     351.5000   140.5420   -87.17855
>> 3x  2146.2500   216.7718     194.8333    85.0303   -90.92215
>> 4x  1663.0000   141.9235     101.0000    57.7853   -93.92664
>> +-----------+-----------+-----------+------------+-----------+
>> +-----------+-----------+-----------+------------+-----------+
>>                 dbench  (Throughput) higher is better
>> +-----------+-----------+-----------+------------+-----------+
>>       base        stdev        patched    stdev        %improvement
>> +-----------+-----------+-----------+------------+-----------+
>> 1x  14111.5600   754.4525   3930.1602   2547.2369    -72.14936
>> 2x  2481.6270    71.2665      181.1816    89.5368    -92.69908
>> 3x  1510.2483    31.8634      104.7243    53.2470    -93.06576
>> 4x  1029.4875    16.9166       72.3738    38.2432    -92.96992
>> +-----------+-----------+-----------+------------+-----------+
>>
>> Note we can not trust on overcommit results because of softlock-ups
>>
>
> Hi, I tried
> (1) TIMEOUT=(2^7)
>
> (2) having yield hypercall that uses kvm_vcpu_on_spin() to do directed yield
> to other vCPUs.
>
> Now I do not see any soft-lockup in overcommit cases and results are better
> now (except ebizzy 1x). and for dbench I see now it is closer to base and
> even improvement in 4x
>
>
> +-----------+-----------+-----------+------------+-----------+
>                ebizzy (records/sec) higher is better
> +-----------+-----------+-----------+------------+-----------+
>   base        stdev        patched    stdev        %improvement
> +-----------+-----------+-----------+------------+-----------+
>   5574.9000   237.4997     523.7000     1.4181   -90.60611
>   2741.5000   561.3090     597.8000    34.9755   -78.19442
>   2146.2500   216.7718     902.6667    82.4228   -57.94215
>   1663.0000   141.9235    1245.0000    67.2989   -25.13530
>
> +-----------+-----------+-----------+------------+-----------+
> +-----------+-----------+-----------+------------+-----------+
>                 dbench  (Throughput) higher is better
> +-----------+-----------+-----------+------------+-----------+
>    base        stdev        patched    stdev        %improvement
> +-----------+-----------+-----------+------------+-----------+
>  14111.5600   754.4525     884.9051    24.4723   -93.72922
>   2481.6270    71.2665    2383.5700   333.2435    -3.95132
>   1510.2483    31.8634    1477.7358    50.5126    -2.15279
>   1029.4875    16.9166    1075.9225    13.9911     4.51050
> +-----------+-----------+-----------+------------+-----------+
>
>
> IMO hash based timeout is worth a try further.
> I think little more tuning will get more better results.
>
> Jiannan, When you start working on this, I can also help
> to get best of preemptable lock idea if you wish and share
> the patches I tried.
>
>
>
