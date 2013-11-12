Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3KLOOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:14:18 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:53591 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3KLOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131111161631.GA21461@twins.programming.kicks-ass.net>
References: <1383939963-7750-1-git-send-email-eranian@google.com>
	<1383939963-7750-4-git-send-email-eranian@google.com>
	<20131111155905.GM19203@twins.programming.kicks-ass.net>
	<CABPqkBRZ84Hc9oAU6zFxNWMv9hT+zMu3Od7_b5fhHRgbG3MXPA@mail.gmail.com>
	<20131111161631.GA21461@twins.programming.kicks-ass.net>
Date: Tue, 12 Nov 2013 15:14:12 +0100
Message-ID: <CABPqkBQB-35ZN_w2HNgFyWwnKaBWnCtpbxFOgMW2PKZxsdgPQw@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,


I spent some time trying to understand the hotplug code in kernel/cpu.c.
I still see this cpu_hotplug_begin()/cpu_hotplug_done() pair which
serializes access. So it seems that hotplug is still serialized.
That appears to be true also for the CPU_STARTING phase of
hiotplug.

I don't know where Andi got that cpu starting was parallel now.
Andi?

If hotplug is not parallel, then we can drop that RAPL hotplug_lock
I added.



On Mon, Nov 11, 2013 at 5:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Nov 11, 2013 at 05:07:22PM +0100, Stephane Eranian wrote:
>> On Mon, Nov 11, 2013 at 4:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Nov 08, 2013 at 08:46:02PM +0100, Stephane Eranian wrote:
>> >
>> >
>> >> +static DEFINE_SPINLOCK(rapl_hotplug_lock);
>> >
>> > What is this thing protecting?
>> >
>> > Like last time it appears to be used only from hotplug notifier
>> > callbacks and those are already fully serialized.
>> >
>> I thought you or somebody else had said, that hotplug in now parallel.
>
> There's a little something about hotplug here I think:
>
>  http://marc.info/?l=linux-kernel&m=138118235612441
>
> But I'm not entirely sure that's the origin of this lock.
>
> Andi seems worried about the IPI vs hotplug/migrate. I'm not entrely
> sure the lock as proposed actually fixes that.
>
> The 'easy' way would be to put a synchronize_sched() right after the
> migrate code, that forces all CPUs to have scheduled once and thus also
> ensures all pending/running interrupts are serviced.
>
> But I don't think that's strictly required as I seem to recall hotplug
> actually already does something like this -- it pretty much has to.
