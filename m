Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3APAdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:33:15 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:59492 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab3APAdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <1357731938-8417-1-git-send-email-glommer@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Date: Tue, 15 Jan 2013 16:33:10 -0800
Message-ID: <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
From: Colin Cross <ccross@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 3:45 AM, Glauber Costa <glommer@parallels.com> wrote:
> [ update: I thought I posted this already before leaving for holidays. However,
>   now that I am checking for replies, I can't find nor replies nor the original
>   mail in my boxes or archives. I am posting again for safety sake, but sorry
>   you are getting this twice by any chance ]
>
> Hi all,
>
> This is an attempt to provide userspace with enough information to reconstruct
> per-container version of files like "/proc/stat". In particular, we are
> interested in knowing the per-cgroup slices of user time, system time, wait
> time, number of processes, and a variety of statistics.
>
> This task is made more complicated by the fact that multiple controllers are
> involved in collecting those statistics: cpu and cpuacct. So the first thing I
> am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.
>
> This is one of the major differences from earlier attempts: all data is provided
> by the cpu controller, resulting in greater simplicity.

Android userspace is currently using both cpu and cpuacct, and not
co-mounting them.  They are used for fundamentally different uses such
that creating a single hierarchy for both of them while maintaining
the existing behavior is not possible.

We use the cpu cgroup primarily as a priority container.  A simple
view is that each thread is assigned to a foreground cgroup when it is
user-visible, and a background cgroup when it is not.  The foreground
cgroup is assigned a significantly higher cpu.shares value such that
when each group is fully loaded the background group will get 5% and
the foreground group will get 95%.

We use the cpuacct cgroup to measure cpu usage per uid, primarily to
estimate one cause of battery usage.  Each uid gets a cgroup, and when
spawning a task for a new uid we put it in the appropriate cgroup.

We could create a new uid cgroup for cpuacct inside the foreground and
background cgroups used for scheduling, but that would drastically
change the way scheduling works when multiple uids have active
threads.  With separate cpu and cpuacct mounts, every active
foreground thread will get equal cpu time.  With co-mounted cpu and
cpuacct cgroups, cpu time will be shared between each accounting
group, and then sub-shared inside that group.

A concrete example:
Two uids, 1 and 2.  Uid 1 has one thread A, uid 2 has two threads B
and C.  All threads are foreground and running continuously.

With separate cpu and cpuacct mounts, we have:
/cpu/foreground/tasks:
A
B
C
/cpuacct/uid/1/tasks:
A
/cpuacct/uid/2/tasks:
B
C

A, B, and C each will get 33% of the cpu time.

With co-mounted cpu and cpuacct mounts:
/cpu/foreground/1/tasks:
A
/cpu/foreground/2/tasks
B
C

A will get 50% of the cpu time, B and C will get 25% of the cpu time.
I don't see any way to add new subgroups for accounting without
partitioning the cpu time for each subgroup.
