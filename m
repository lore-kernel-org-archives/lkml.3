Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3DAVC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:02:29 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41643 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab3DAVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130401202943.GC31435@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com>
 <20130401184617.GB31435@htj.dyndns.org> <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
 <20130401202943.GC31435@htj.dyndns.org>
From: Tim Hockin <thockin@hockin.org>
Date: Mon, 1 Apr 2013 14:02:06 -0700
X-Google-Sender-Auth: DAVyLEijPzxOUJsyqRYEEwmoMKM
Message-ID: <CAAAKZwuZwN68vtk1qO08GXB_OnQNVtqqp+v_NQfP27W0P_aWZw@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 1:29 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Apr 01, 2013 at 01:09:09PM -0700, Tim Hockin wrote:
>> Pardon my ignorance, but... what?  Use kernel memory limits as a proxy
>> for process/thread counts?  That sounds terrible - I hope I am
>
> Well, the argument was that process / thread counts were a poor and
> unnecessary proxy for kernel memory consumption limit.  IIRC, Johannes
> put it as (I'm paraphrasing) "you can't go to Fry's and buy 4k thread
> worth of component".
>
>> misunderstanding?  This task counter patch had several properties that
>> mapped very well to what we want.
>>
>> Is it dead in the water?
>
> After some discussion, Frederic agreed that at least his use case can
> be served well by kmemcg, maybe even better - IIRC it was container
> fork bomb scenario, so you'll have to argue your way in why kmemcg
> isn't a suitable solution for your use case if you wanna revive this.

We run dozens of jobs from dozens users on a single machine.  We
regularly experience users who leak threads, running into the tens of
thousands.  We are unable to raise the PID_MAX significantly due to
some bad, but really thoroughly baked-in decisions that were made a
long time ago.  What we experience on a daily basis is users
complaining about getting a "pthread_create(): resource unavailable"
error because someone on the machine has leaked.

Today we use RLIMIT_NPROC to lock most users down to a smaller max.
But this is a per-user setting, not a per-container setting, and users
do not control where their jobs land.  Scheduling decisions often put
multiple thread-heavy but non-leaking jobs from one user onto the same
machine, which again causes problems.  Further, it does not help for
some of our use cases where a logical job can run as multiple UIDs for
different processes within.

>From the end-user point of view this is an isolation leak which is
totally non-deterministic for them.  They can not know what to plan
for.  Getting cgroup-level control of this limit is important for a
saner SLA for our users.

In addition, the behavior around locking-out new tasks seems like a
nice way to simplify and clean up end-life work for the administrative
system.  Admittedly, we can mostly work around this with freezer
instead.

What I really don't understand is why so much push back?  We have this
nicely structured cgroup system.  Each cgroup controller's code is
pretty well partitioned - why would we not want more complete
functionality built around it?  We accept device drivers for the most
random, useless crap on the assertion that "if you don't need it,
don't compile it in".  I can think of a half dozen more really useful,
cool things we can do with cgroups, but I know the pushback will be
tremendous, and I just don't grok why.

Tim
