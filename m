Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbaEFJyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:54:15 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:44423 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558AbaEFJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <5361982F.3080307@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
	<20140424162029.GV11096@twins.programming.kicks-ass.net>
	<5361982F.3080307@linaro.org>
Date: Tue, 6 May 2014 15:24:13 +0530
Message-ID: <CAM4v1pPH54OHehb1i-esXTMsGJ-n7ck3V8yDK_rwajVCSmdU1A@mail.gmail.com>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Alex Shi <alex.shi@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: mingo@redhat.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <efault@gmx.de>, wangyun@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten, Peter, Alex,

In a similar context, I noticed that /proc/loadavg makes use of
avenrun[] array which keeps track of the history of the global
load average. This however makes use of the sum of
nr_running + nr_uninterruptible per cpu. Why are we not
using the cpu_load[] array here which also keeps track
of the history of per-cpu load and then return a sum of it?
Of course with this patchset this might not be possible, but
I have elaborated my point  below.

Using nr_running to show the global load average would
be misleading when entire load balancing is being done on the
basis of the history of cfs_rq->runnable_load_avg/cpu_load[]
right? IOW, to the best of my understanding we do not use
nr_running anywhere to directly determine cpu load in the kernel.

My idea was that the global/per_cpu load that we reflect via
proc/sys interfaces must be consistent. I haven't really
looked at what /proc/schedstat, /proc/stat, top are all reading
from. But /proc/loadavg is reading out global nr_running +
waiting tasks when this will not give us the accurate picture
of the system load especially when there are many short running
tasks.

I observed this when looking at tuned. Tuned sets the cpu_dma_latency
depending on what it reads from /proc/loadavg. This would mean
for a small number of short running tasks also this metric could
reflect a number which makes it look like the system is loaded
reasonably. It then disables deep idle states by setting a high
pm_qos latency requirement for system. This is bad because
it disables power savings even on a lightly loaded system. This
is just an example of how users of /proc/loadavg could make
the wrong decisions based on an inaccurate measure of system
load.

Do you think we must take a look again at the avenrun[] array
and update it to reflect the right cpu load average?

Regards
Preeti U Murthy
