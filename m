Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3COBGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:06:43 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57893 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3COBGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRvgCsZGkS=9CO_cRLBMG7XSiaxKz8moMW6Yp3CwTXEyQ@mail.gmail.com>
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
Date: Thu, 14 Mar 2013 18:06:41 -0700
X-Google-Sender-Auth: q9ExkV5fRgSrDcOpU_1Oukg8E5E
Message-ID: <CA+55aFxhFbFmUnCVg=be_e+c_GEr9KizMt_7cGwJz__E9o7MJg@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephane Eranian <eranian@google.com>
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

On Thu, Mar 14, 2013 at 5:24 PM, Stephane Eranian <eranian@google.com> wrote:
>
> I bet if you force the affinity of your perf record to be on
> a CPU other than CPU0, you will not get the crash.
>
> This is what I am seeing now. I appears on resume,
> CPU0 hotplug callbacks for perf_events are not invoked
> leaving DS_AREA MSR to 0.
>
> Can you confirm on your machine?

I'm not even going to bother confirming it, because I think you're
right, and I think the reason is clear: the DS initialization code
uses the CPU_UP notifiers.

And that's sufficient for CPU hotplug, which is what suspend/resume
ends up doing for all but the boot CPU. But the boot CPU is not
hotplugged.

Using CPU_UP notifiers is wrong, and they get called too late anyway.

The code should use a real resume method. Or, better yet, just do it
right, and do it from __restore_processor_state().

Those f*cking CPU notifiers are a pain in the ass, and the tend to be
invariably broken, and they have their own idiotic hacks that are
equally broken (ie that x86_pmu_notifier() thing seems to make up its
own suspend/resume with
"x86_pmu.cpu_prepare/cpu_starting/cpu_dying/cpu_dead" things.

I guess we could make the BP do a fake cpu notifier thing around the
suspend of the boot processor as well, but most of the per-CPU stuff
seems to be perfectly fine without it (ie mtrr, apic, etc etc all use
the suspend/resume infrastructure) and doesn't need that kind of
stuff.

                Linus
