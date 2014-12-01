Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaLARIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:08:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbaLARH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:07:58 -0500
Message-ID: <547CA064.5080106@suse.com>
Date: Mon, 01 Dec 2014 18:07:48 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Jan Beulich <JBeulich@suse.com>, Olaf Hering <ohering@suse.de>
Subject: Re: [PATCH] xen: privcmd: schedule() after private hypercall when
 non CONFIG_PREEMPT
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com> <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de> <547C4CEF.1010603@citrix.com> <20141201150546.GC25677@wotan.suse.de> <547C86BF.2040705@citrix.com> <CAB=NE6WPvCJnAfdbZqcw5pJtZrfxo0zQu6J2gpXp69G-UTtiUg@mail.gmail.com> <547C8F30.1010306@citrix.com> <20141201161905.GH25677@wotan.suse.de>
In-Reply-To: <20141201161905.GH25677@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 05:19 PM, Luis R. Rodriguez wrote:
> On Mon, Dec 01, 2014 at 03:54:24PM +0000, David Vrabel wrote:
>> On 01/12/14 15:44, Luis R. Rodriguez wrote:
>>> On Mon, Dec 1, 2014 at 10:18 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>>>> On 01/12/14 15:05, Luis R. Rodriguez wrote:
>>>>> On Mon, Dec 01, 2014 at 11:11:43AM +0000, David Vrabel wrote:
>>>>>> On 27/11/14 18:36, Luis R. Rodriguez wrote:
>>>>>>> On Thu, Nov 27, 2014 at 07:36:31AM +0100, Juergen Gross wrote:
>>>>>>>> On 11/26/2014 11:26 PM, Luis R. Rodriguez wrote:
>>>>>>>>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>>>>>>>>
>>>>>>>>> Some folks had reported that some xen hypercalls take a long time
>>>>>>>>> to complete when issued from the userspace private ioctl mechanism,
>>>>>>>>> this can happen for instance with some hypercalls that have many
>>>>>>>>> sub-operations, this can happen for instance on hypercalls that use
>>>>>> [...]
>>>>>>>>> --- a/drivers/xen/privcmd.c
>>>>>>>>> +++ b/drivers/xen/privcmd.c
>>>>>>>>> @@ -60,6 +60,9 @@ static long privcmd_ioctl_hypercall(void __user *udata)
>>>>>>>>>                               hypercall.arg[0], hypercall.arg[1],
>>>>>>>>>                               hypercall.arg[2], hypercall.arg[3],
>>>>>>>>>                               hypercall.arg[4]);
>>>>>>>>> +#ifndef CONFIG_PREEMPT
>>>>>>>>> + schedule();
>>>>>>>>> +#endif
>>>>>>
>>>>>> As Juergen points out, this does nothing.  You need to schedule while in
>>>>>> the middle of the hypercall.
>>>>>>
>>>>>> Remember that Xen's hypercall preemption only preempts the hypercall to
>>>>>> run interrupts in the guest.
>>>>>
>>>>> How is it ensured that when the kernel preempts on this code path on
>>>>> CONFIG_PREEMPT=n kernel that only interrupts in the guest are run?
>>>>
>>>> Sorry, I really didn't describe this very well.
>>>>
>>>> If a hypercall needs a continuation, Xen returns to the guest with the
>>>> IP set to the hypercall instruction, and on the way back to the guest
>>>> Xen may schedule a different VCPU or it will do any upcalls (as per normal).
>>>>
>>>> The guest is free to return from the upcall to the original task
>>>> (continuing the hypercall) or to a different one.
>>>
>>> OK so that addresses what Xen will do when using continuation and
>>> hypercall preemption, my concern here was that using
>>> preempt_schedule_irq() on CONFIG_PREEMPT=n kernels in the middle of a
>>> hypercall on the return from an interrupt (e.g., the timer interrupt)
>>> would still let the kernel preempt to tasks other than those related
>>> to Xen.
>>
>> Um.  Why would that be a problem?  We do want to switch to any task the
>> Linux scheduler thinks is best.
>
> Its safe but -- it technically is doing kernel preemption, unless we want
> to adjust the definition of CONFIG_PREEMPT=n to exclude hypercalls. This
> was my original concern with the use of preempt_schedule_irq() to do this.
> I am afraid of setting precedents without being clear or wider review and
> acceptance.

I wonder whether it would be more acceptable to add (or completely
switch to) another preemption model: PREEMPT_SWITCHABLE. This would be
similar to CONFIG_PREEMPT, but the "normal" value of __preempt_count
would be settable via kernel parameter (default 2):

0: preempt
1: preempt_voluntary
2: preempt_none

The kernel would run with preemption enabled. cond_sched() would
reschedule if __preempt_count <= 1. And in case of long running kernel
activities (like the hypercall case or other stuff requiring schedule()
calls to avoid hangups) we would just set __preempt_count to 0 during
these periods and restore the old value afterwards.

This would be a rather intrusive but clean change IMO.

Any thoughts?


Juergen
