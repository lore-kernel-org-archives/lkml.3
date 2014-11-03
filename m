Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaKCVrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:47:40 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37682 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKCVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:47:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141030190841.GI23531@worktop.programming.kicks-ass.net>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org> <20141030190841.GI23531@worktop.programming.kicks-ass.net>
From: Robert Bragg <robert@sixbynine.org>
Date: Mon, 3 Nov 2014 21:47:17 +0000
X-Google-Sender-Auth: DxDYEjJKD_T7XtD1jtvizRXiWEI
Message-ID: <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 7:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Oct 22, 2014 at 04:28:48PM +0100, Robert Bragg wrote:
>> Our desired permission model seems consistent with perf's current model
>> whereby you would need privileges if you want to profile across all gpu
>> contexts but not need special permissions to profile your own context.
>>
>> The awkward part is that it doesn't make sense for us to have userspace
>> open a perf event with a specific pid as the way to avoid needing root
>> permissions because a side effect of doing this is that the events will
>> be dynamically added/deleted so as to only monitor while that process is
>> scheduled and that's not really meaningful when we're monitoring the
>> gpu.
>
> There is precedent in PERF_FLAG_PID_CGROUP to replace the pid argument
> with a fd to your object.

Ah ok, interesting.

>
> And do I take it right that if you're able/allowed/etc.. to open/have
> the fd to the GPU/DRM/DRI whatever context you have the right
> credentials to also observe these counters?

Right and in particular since we want to allow OpenGL clients to be
able the profile their own gpu context with out any special privileges
my current pmu driver accepts a device file descriptor via config1 + a
context id via attr->config, both for checking credentials and
uniquely identifying which context should be profiled. (A single
client can open multiple contexts via one drm fd)

That said though; when running as root it is not currently a
requirement to pass any fd when configuring an event to profile across
all gpu contexts. I'm just mentioning this because although I think it
should be ok for us to use an fd to determine credentials and help
specify a gpu context, an fd might not be necessary for system wide
profiling cases.

>
>> Conceptually I suppose we want to be able to open an event that's not
>> associated with any cpu or process, but to keep things simple and fit
>> with perf's current design, the pmu I have a.t.m expects an event to be
>> opened for a specific cpu and unspecified process.
>
> There are no actual scheduling ramifications right? Let me ponder his
> for a little while more..

Ok, I can't say I'm familiar enough with the core perf infrastructure
to entirely sure about this.

I recall looking at how some of the uncore perf drivers were working
and it looked like they had a similar issue where conceptually the pmu
doesn't belong to a specific cpu and so the id would internally get
mapped to some package state, shared by multiple cpus.

My understanding had been that being associated with a specific cpu
did have the side effect that most of the pmu methods for that event
would then be invoked on that cpu through inter-process interrupts. At
one point that had seemed slightly problematic because there weren't
many places within my pmu driver where I could assume I was in process
context and could sleep. This was a problem with an earlier version
because the way I read registers had a slim chance of needing to sleep
waiting for the gpu to come out of RC6, but isn't a problem any more.

One thing that does come to mind here though is that I am overloading
pmu->read() as a mechanism for userspace to trigger a flush of all
counter snapshots currently in the gpu circular buffer to userspace as
perf events. Perhaps it would be best if that work (which might be
relatively costly at times) were done in the context of the process
issuing the flush(), instead of under an IPI (assuming that has some
effect on scheduler accounting).

Regards,
- Robert
