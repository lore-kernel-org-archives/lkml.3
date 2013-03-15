Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3COKuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:50:24 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44884 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3COKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRHt=84gZ2-g-CC2jmV5_pnZ9qJA2bne_oXsLmrFhOomw@mail.gmail.com>
References: <20130226070247.GA14094@gmail.com>
	<CA+55aFxdR6_8734T9y2Edyotf0u-SgPPgjazFuQa1atSUGK9LA@mail.gmail.com>
	<CA+55aFziwaP21NVyVb_UP3okiX7fXoo4DQ7zudhxAwPM10_Tuw@mail.gmail.com>
	<CABPqkBR2HeDmuTVg5RA=5D0xXJbXxqSxMDf7MW0iCGnurQb7jw@mail.gmail.com>
	<CA+55aFzDMwHyPxqxNKRz0Y3vFhZOqtHMvPbvNXAD6C+-_=UAhg@mail.gmail.com>
	<CABPqkBTTY7RBSXJw4kqdd0c07Ykz-Wy8TFUQ+hzBSn=5v2yz2w@mail.gmail.com>
	<CABPqkBTh1Fph=GTOzN_2Q9coqLpiR3hcqVk1PBubUUEO7D=zsA@mail.gmail.com>
	<CABPqkBTQCce3ve9cP-Ajbtb7FSVggB_bL7Dmpq8KeG_7Gfx0Og@mail.gmail.com>
	<CABPqkBRuKzbxTr73LDpgLnq4WhadZf9VErjjcTMHoMWRwzhDGw@mail.gmail.com>
	<CABPqkBRvgCsZGkS=9CO_cRLBMG7XSiaxKz8moMW6Yp3CwTXEyQ@mail.gmail.com>
	<CA+55aFxhFbFmUnCVg=be_e+c_GEr9KizMt_7cGwJz__E9o7MJg@mail.gmail.com>
	<CABPqkBRHt=84gZ2-g-CC2jmV5_pnZ9qJA2bne_oXsLmrFhOomw@mail.gmail.com>
Date: Fri, 15 Mar 2013 11:50:18 +0100
Message-ID: <CABPqkBQmHK4Cxa15QLXg_e5t=1dpvaLD_NRgGCwByitYwNbxUA@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Stephane Eranian <eranian@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:01 AM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Mar 15, 2013 at 2:06 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Mar 14, 2013 at 5:24 PM, Stephane Eranian <eranian@google.com> wrote:
>>>
>>> I bet if you force the affinity of your perf record to be on
>>> a CPU other than CPU0, you will not get the crash.
>>>
>>> This is what I am seeing now. I appears on resume,
>>> CPU0 hotplug callbacks for perf_events are not invoked
>>> leaving DS_AREA MSR to 0.
>>>
>>> Can you confirm on your machine?
>>
>> I'm not even going to bother confirming it, because I think you're
>> right, and I think the reason is clear: the DS initialization code
>> uses the CPU_UP notifiers.
>>
> Ok, I instrumented the pebs_enable() function and I confirm that
> DS_AREA=0 on resume.
>
> So what seems broken here for me is that on suspend, the cpu notifier
> ends up calling fini_debug_store() to clear DS_AREA for CPU0. But
> on resume, the same notifier does NOT call the init_debug_store().
> I don't understand this asymmetry. You either do neither or you do
> both.
>
Ok, corrections. I ran some more tests. On the suspend path, the cpu
notifier is not called for CPU0. However when the machine comes back
up, DS_AREA is  0 which is the power-up default value. And given that
the notifier is not called for CPU0, that is the value we inherit later on
and which causes the crash.

>
>> And that's sufficient for CPU hotplug, which is what suspend/resume
>> ends up doing for all but the boot CPU. But the boot CPU is not
>> hotplugged.
>>
>> Using CPU_UP notifiers is wrong, and they get called too late anyway.
>>
>> The code should use a real resume method. Or, better yet, just do it
>> right, and do it from __restore_processor_state().
>>
I will produce a patch to use this function, it's simple enough.

>> Those f*cking CPU notifiers are a pain in the ass, and the tend to be
>> invariably broken, and they have their own idiotic hacks that are
>> equally broken (ie that x86_pmu_notifier() thing seems to make up its
>> own suspend/resume with
>> "x86_pmu.cpu_prepare/cpu_starting/cpu_dying/cpu_dead" things.
>>
>> I guess we could make the BP do a fake cpu notifier thing around the
>> suspend of the boot processor as well, but most of the per-CPU stuff
>> seems to be perfectly fine without it (ie mtrr, apic, etc etc all use
>> the suspend/resume infrastructure) and doesn't need that kind of
>> stuff.
>>
>>                 Linus
