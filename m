Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3E3LwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:52:02 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57078 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3E3Lvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:51:52 -0400
Message-ID: <51A73E5C.4010608@linux.vnet.ibm.com>
Date: Thu, 30 May 2013 17:26:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop> <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop> <5175E71F.8070307@linux.vnet.ibm.com>
In-Reply-To: <5175E71F.8070307@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053011-5564-0000-0000-0000082373FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 07:12 AM, Raghavendra K T wrote:
> On 04/23/2013 01:19 AM, Peter Zijlstra wrote:
>> On Mon, 2013-04-22 at 08:52 -0400, Rik van Riel wrote:
>>> On 04/22/2013 07:51 AM, Peter Zijlstra wrote:
>>>> On Sun, 2013-04-21 at 17:12 -0400, Rik van Riel wrote:
>>>>>
>>>>> If we always incremented the ticket number by 2 (instead of 1), then
>>>>> we could use the lower bit of the ticket number as the spinlock.
>>>>
>>>> ISTR that paravirt ticket locks already do that and use the lsb to
>>>> indicate the unlock needs to perform wakeups.
>>>>
>>>> Also, since all of this is virt nonsense, shouldn't it live in the
>>>> paravirt ticket lock code and leave the native code as is?
>>>
>>> Sure, but that is still no reason not to have the virt
>>> implementation be as fast as possible, and share the same
>>> data type as the non-virt implementation.
>>
>> It has to share the same data-type..
>>
>>> Also, is it guaranteed that the native spin_lock code has
>>> not been called yet before we switch over to the paravirt
>>> functions?
>>>
>>> If the native spin_lock code has been called already at
>>> that time, the native code would still need to be modified
>>> to increment the ticket number by 2, so we end up with a
>>> compatible value in each spin lock's .tickets field, and
>>> prevent a deadlock after we switch over to the paravirt
>>> variant.
>>
>> I thought the stuff already made it upstream, but apparently not; the
>> lastest posting I'm aware of is here:
>>
>>    https://lkml.org/lkml/2012/5/2/105
>>
>> That stuff changes the normal ticket increment as well..
>>
>
> pv-ticket spinlock went on hold state, after Avi acked because of:
>
> though on non-PLE, we get a huge advantage, on PLE machine the benefit
> was not as impressive (~10% as you stated in email chain) compared to
> the complexity of the patches.
> So Avi suggested to try PLE improvements first, so they are going upstream.
>
> https://lkml.org/lkml/2012/7/18/247
> https://lkml.org/lkml/2013/1/22/104
> https://lkml.org/lkml/2013/2/6/345 (on the way in kvm tree)
>
> Current status of PV spinlock:
> I have the rebased patches of pv spinlocks and experimenting with latest
> kernel.I have
> Gleb's irq delivery incorporated into the patch series. But I am
> thinknig whether I can
> improve some guest side logic in unlock.
> I will probably setup a githup and post the link soon.

Sorry for late reply.

Here is the branch with pvpspinlock V9 version in github reabsed to  3.10-rc

https://github.com/ktraghavendra/linux/tree/pvspinlock_v9

planning post a formal email in a separate thread with link a to this
branch (instead of spamming with 19 patches)

Main changes w.r.t v8 are
- Changed spin_threshold to 32k to avoid excess halt exits that are 
causing undercommit degradation (after PLE handler improvement).
- Added  kvm_irq_delivery_to_apic (suggested by Gleb)
- optimized halt exit path to use PLE handler

