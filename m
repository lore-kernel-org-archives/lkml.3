Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3GQKog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:44:36 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57730 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3GQKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:44:34 -0400
Message-ID: <51E67414.7070606@linux.vnet.ibm.com>
Date: Wed, 17 Jul 2013 16:08:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, agraf@suse.de,
        chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624124342.27508.44656.sendpatchset@codeblue.in.ibm.com> <20130714131241.GA11772@redhat.com> <51E3C5CE.7000009@linux.vnet.ibm.com> <20130715103648.GN11772@redhat.com> <51E4C011.4060803@linux.vnet.ibm.com> <20130716060215.GE11772@redhat.com> <51E5941B.3090300@linux.vnet.ibm.com> <20130717093420.GU11772@redhat.com> <51E66C71.6020605@linux.vnet.ibm.com>
In-Reply-To: <51E66C71.6020605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071710-5490-0000-0000-000003D6365B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 03:35 PM, Raghavendra K T wrote:
> On 07/17/2013 03:04 PM, Gleb Natapov wrote:
>> On Wed, Jul 17, 2013 at 12:12:35AM +0530, Raghavendra K T wrote:
>>>> I do not think it is very rare to get interrupt between
>>>> local_irq_restore() and halt() under load since any interrupt that
>>>> occurs between local_irq_save() and local_irq_restore() will be
>>>> delivered
>>>> immediately after local_irq_restore(). Of course the chance of no
>>>> other
>>>> random interrupt waking lock waiter is very low, but waiter can sleep
>>>> for much longer then needed and this will be noticeable in
>>>> performance.
>>>
>>> Yes, I meant the entire thing. I did infact turned WARN on
>>> w->lock==null before halt() [ though we can potentially have irq right
>>> after that ], but did not hit so far.
>> Depends on your workload of course. To hit that you not only need to get
>> interrupt in there, but the interrupt handler needs to take contended
>> spinlock.
>>
>
> Yes. Agree.
>
>>>
>>>> BTW can NMI handler take spinlocks? If it can what happens if NMI is
>>>> delivered in a section protected by
>>>> local_irq_save()/local_irq_restore()?
>>>>
>>>
>>> Had another idea if NMI, halts are causing problem until I saw
>>> PeterZ's reply similar to V2 of pvspinlock posted  here:
>>>
>>>   https://lkml.org/lkml/2011/10/23/211
>>>
>>> Instead of halt we started with a sleep hypercall in those
>>>   versions. Changed to halt() once Avi suggested to reuse existing
>>> sleep.
>>>
>>> If we use older hypercall with few changes like below:
>>>
>>> kvm_pv_wait_for_kick_op(flags, vcpu, w->lock )
>>> {
>>>   // a0 reserved for flags
>>> if (!w->lock)
>>> return;
>>> DEFINE_WAIT
>>> ...
>>> end_wait
>>> }
>>>
>> How would this help if NMI takes lock in critical section. The thing
>> that may happen is that lock_waiting->want may have NMI lock value, but
>> lock_waiting->lock will point to non NMI lock. Setting of want and lock
>> have to be atomic.
>
> True. so we are here
>
>          non NMI lock(a)
>          w->lock = NULL;
>          smp_wmb();
>          w->want = want;
>                                 NMI
>                           <---------------------
>                            NMI lock(b)
>                            w->lock = NULL;
>                            smp_wmb();
>                            w->want = want;
>                            smp_wmb();
>                            w->lock = lock;
>                           ---------------------->
>          smp_wmb();
>          w->lock = lock;
>
> so how about fixing like this?
>
> again:
>          w->lock = NULL;
>          smp_wmb();
>          w->want = want;
>          smp_wmb();
>          w->lock = lock;
>
> if (!lock || w->want != want) goto again;
>
Sorry,
I meant if (!w->lock || w->want !=want) here


[...]

