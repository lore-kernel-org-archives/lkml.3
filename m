Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3AOBkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:40:33 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:50950 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3AOBkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<20130114154914.6d69eb27.akpm@linux-foundation.org>
	<CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
Date: Mon, 14 Jan 2013 17:40:28 -0800
X-Google-Sender-Auth: ORD7PxoGDVkIcv8cvzTuQ-W-87c
Message-ID: <CAMbhsRQ9orwuHYo4CwFUYnBqSyTnQX458xCr9xJfwc2Y2WVmVw@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 4:19 PM, Colin Cross <ccross@android.com> wrote:
> On Mon, Jan 14, 2013 at 3:49 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Fri, 11 Jan 2013 13:51:48 -0800
>> Colin Cross <ccross@android.com> wrote:
>>
>>> Emulate NMIs on systems where they are not available by using timer
>>> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
>>> to check that the next cpu is processing hrtimer interrupts by
>>> verifying that a counter is increasing.
>>
>> Seems sensible.
>>
>>> This patch is useful on systems where the hardlockup detector is not
>>> available due to a lack of NMIs, for example most ARM SoCs.
>>> Without this patch any cpu stuck with interrupts disabled can
>>> cause a hardware watchdog reset with no debugging information,
>>> but with this patch the kernel can detect the lockup and panic,
>>> which can result in useful debugging info.
>>
>> But we don't get the target cpu's stack, yes?  That's a pretty big loss.
>
> It's a huge loss, but its still useful.  For one, it can separate
> "linux locked up one cpu" bugs from "the whole cpu complex stopped
> responding" bugs, which are much more common than you would hope on
> ARM cpus.  Also, as a separate patch I'm hoping to add reading the
> DBGPCSR register of both cpus during panic, which will at least give
> you the PC of the cpu that is stuck.
>
>>>
>>> ...
>>>
>>> +#ifdef CONFIG_HARDLOCKUP_DETECTOR_OTHER_CPU
>>> +static unsigned int watchdog_next_cpu(unsigned int cpu)
>>> +{
>>> +     cpumask_t cpus = watchdog_cpus;
>>
>> cpumask_t can be tremendously huge and putting one on the stack is
>> risky.  Can we use watchdog_cpus directly here?  Perhaps with a lock?
>> or take a copy into a static local, with a lock?
>
> Sure, I can use a lock around it.  I'm used to very small numbers of cpus.
>

On second thought, I'm just going to remove the local copy and read
the global directly.  watchdog_cpus is updated with atomic bitmask
operations, so there is no erroneous value that could be returned when
referencing the global directly that couldn't also occur with a
slightly different order of updates.  The local copy is also not
completely atomic, since the bitmask could span multiple words.  All
intermediate values during multiple sequential updates should already
be handled by setting watchdog_nmi_touch on the appropriate cpus
during watchdog_nmi_enable and watchdog_nmi_disable.
