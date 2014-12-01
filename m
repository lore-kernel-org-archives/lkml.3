Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaLAPpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:45:15 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:49364 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaLAPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:45:13 -0500
MIME-Version: 1.0
In-Reply-To: <547C86BF.2040705@citrix.com>
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com>
 <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de>
 <547C4CEF.1010603@citrix.com> <20141201150546.GC25677@wotan.suse.de> <547C86BF.2040705@citrix.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Mon, 1 Dec 2014 10:44:50 -0500
X-Google-Sender-Auth: CzGAbo1oTtTvGZJX7F4TQh0xGao
Message-ID: <CAB=NE6WPvCJnAfdbZqcw5pJtZrfxo0zQu6J2gpXp69G-UTtiUg@mail.gmail.com>
Subject: Re: [PATCH] xen: privcmd: schedule() after private hypercall when non CONFIG_PREEMPT
To: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Jan Beulich <JBeulich@suse.com>, Olaf Hering <ohering@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 10:18 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> On 01/12/14 15:05, Luis R. Rodriguez wrote:
>> On Mon, Dec 01, 2014 at 11:11:43AM +0000, David Vrabel wrote:
>>> On 27/11/14 18:36, Luis R. Rodriguez wrote:
>>>> On Thu, Nov 27, 2014 at 07:36:31AM +0100, Juergen Gross wrote:
>>>>> On 11/26/2014 11:26 PM, Luis R. Rodriguez wrote:
>>>>>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>>>>>
>>>>>> Some folks had reported that some xen hypercalls take a long time
>>>>>> to complete when issued from the userspace private ioctl mechanism,
>>>>>> this can happen for instance with some hypercalls that have many
>>>>>> sub-operations, this can happen for instance on hypercalls that use
>>> [...]
>>>>>> --- a/drivers/xen/privcmd.c
>>>>>> +++ b/drivers/xen/privcmd.c
>>>>>> @@ -60,6 +60,9 @@ static long privcmd_ioctl_hypercall(void __user *udata)
>>>>>>                              hypercall.arg[0], hypercall.arg[1],
>>>>>>                              hypercall.arg[2], hypercall.arg[3],
>>>>>>                              hypercall.arg[4]);
>>>>>> +#ifndef CONFIG_PREEMPT
>>>>>> + schedule();
>>>>>> +#endif
>>>
>>> As Juergen points out, this does nothing.  You need to schedule while in
>>> the middle of the hypercall.
>>>
>>> Remember that Xen's hypercall preemption only preempts the hypercall to
>>> run interrupts in the guest.
>>
>> How is it ensured that when the kernel preempts on this code path on
>> CONFIG_PREEMPT=n kernel that only interrupts in the guest are run?
>
> Sorry, I really didn't describe this very well.
>
> If a hypercall needs a continuation, Xen returns to the guest with the
> IP set to the hypercall instruction, and on the way back to the guest
> Xen may schedule a different VCPU or it will do any upcalls (as per normal).
>
> The guest is free to return from the upcall to the original task
> (continuing the hypercall) or to a different one.

OK so that addresses what Xen will do when using continuation and
hypercall preemption, my concern here was that using
preempt_schedule_irq() on CONFIG_PREEMPT=n kernels in the middle of a
hypercall on the return from an interrupt (e.g., the timer interrupt)
would still let the kernel preempt to tasks other than those related
to Xen.

My gripe was that if this was being done it'd be a bit abusive of the
API even if its safe.

  Luis
