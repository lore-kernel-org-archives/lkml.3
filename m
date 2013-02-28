Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319Ab3B1UjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:39:18 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:8812 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3B1UjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:39:17 -0500
Message-ID: <512FC071.3050409@hp.com>
Date: Thu, 28 Feb 2013 15:39:13 -0500
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com> <20130221233818.GM26694@dastard> <m2bobdxl1i.fsf@firstfloor.org> <5126F067.4040707@hp.com> <20130222230048.GP26694@dastard> <20130223001332.GA30494@two.firstfloor.org>
In-Reply-To: <20130223001332.GA30494@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 07:13 PM, Andi Kleen wrote:
>> That seems to me like an application problem - poking at what the
>> kernel is doing via diagnostic interfaces so often that it gets in
>> the way of the kernel actually doing stuff is not a problem the
>> kernel can solve.
> I agree with you that the application shouldn't be doing that, but
> if there is a cheap way to lower the d_path overhead that is also
> attractive.  There will be always applications doing broken things.
> Any scaling problem less in the kernel is good.
>
> But the real fix in this case is to fix the application.
>
> -Andi
Further investigation into the d_path() bottleneck revealed some
interesting facts about Oracle. First of all, the invocation of the
d_path() kernel function is concentrated in a few processes only
rather than distributed across many of them.  On a 1 minute test run,
the following three standard long-running Oracle processes will call
indo d_path():

1. MMNL - Memory monitor light (gathers and stores AWR statistics) [272]
2. CKPT - Checkpoint process [17]
3. DBRM - DB resource manager (new in 11g) [16]

The numbers within [] are the number of times d_path() will be
called, which are not much for a 1-minutes interval. Beyond those
standard processes, Oracle also seems to spawn transient processes
(last a few seconds) periodically to issue a bunch of d_path() calls
(about 1000) within a short time before they die. I am not sure what
the purpose of those processes are.  In an one minute interval, 2-7
of those transient processes may be spawned depending probably on the
activity level. Most of the d_path() call last for about 1ms. There
are a couple of those that last for more than 10ms.

Other system daemons that call into d_open() include irqbalance and
automount. irqbalance issues about 2000 d_path() call in a minute in
a bursty fashion. The contribution of automount is only about 50 in
the same time period which is not really significant. Regular commands
like cp, ps may also issue a couple of d_path() calls per invocation.

As I was using "perf record --call-graph" command to profile the Oracle
application, I found out that another major user of the d_path()
function happens to be perf_event_mmap_event() of the perf-event
subsystem. It took about 10% of the total d_path() calls. So the
metrics that I collected were skewed a bit because of that.

I am thinking that the impact of my patch on Oracle write performance
is probably due to its impact on the open() system call which has
to update the reference counts on dentry. On the collected perf
traces, a certain portion of the spinlock time was consumed by
dput() and path_get().  The 2 major consumers of those calls are
the d_path() and the open() system call. On test run with no writer,
I saw significantly less open() call in the perf trace and hence much
less impact on Oracle performance.

I do agree that Oracle should probably fix the application to issue less
calls to the d_path() function. However, I would argue that my patch will
still be useful for the following reasons:

1. Changing how the reference counting works (patch 1 of 4) will certainly
    help in situation when processes are issuing intensive batches of file
    system operations as is the case here.
2. Changing the rename_lock to use a sequence r/w lock (patches 2-4 of 4)
    will help to minimize the overhead of the perf-event subsystem when it
    is activated with the call-graph feature which is pretty common.

Regards,
Longman

