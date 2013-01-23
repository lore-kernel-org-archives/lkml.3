Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3AWWly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:41:54 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53548 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AWWls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:41:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130123165657.GC2373@mtj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
	<50FD3123.6090003@parallels.com>
	<20130123010226.GF5359@htj.dyndns.org>
	<CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
	<20130123165657.GC2373@mtj.dyndns.org>
Date: Wed, 23 Jan 2013 14:41:46 -0800
Message-ID: <CAMbhsRRj9svWubn01wb+f=jSwVWC5u7DqJ5c8P23vAp0E2L8Rg@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
From: Colin Cross <ccross@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 8:56 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Collin.
>
> On Tue, Jan 22, 2013 at 05:53:59PM -0800, Colin Cross wrote:
>> I understand why it makes sense from a code perspective to combine cpu
>> and cpuacct, but by combining them you are enforcing a strange
>> requirement that to measure the cpu usage of a group of processes you
>
> Well, "strange" is in the eyes of the beholder.  The thing is that
> cgroup, as its name suggests, is a facility to control and enforce
> resources to groups of tasks.  As accounting is often a part of
> resource control, it happens as part of it too, but at least I think
> cpuacct becoming a separate controller wasn't a technically sound
> choice and intend to stop growth of usages outside resource control.
>
> An over-arching theme of the problems in cgroup is having too much
> unorganized flexibility to the extent where it impededs the original
> intended goals.  The braindead hierarchy implementations make the
> whole hierarchy completely meaningless.  Multiple hierarchies make it
> impossible to tag and control resources in any sane way when a
> resource exists across different resource and thus controller
> boundaries.
>
> So, well, that's the direction cgroup is headed.  Narrower focus on
> actual resource control and actively shutting out misuses of cgroup as
> generic task grouping mechanism.
>
>> force them to be treated as a single scheduling entity by their parent
>> group, effectively splitting their time as if they were a single task.
>>  That doesn't make any sense to me.
>
>
>> > We are not gonna break multiple hierarchies but won't go extra miles
>> > to optimize or enable new features on it, so it would be best to move
>> > away from it.
>>
>> I don't see how I can move away from it with the current design.
>
> What I don't get is why you don't put each applications into their
> cgroups and tune their config variables, which is the intended usage
> anyway.  You say that that would make the scheduler not give more cpu
> time to applications with more threads, but isn't that the right thing
> to do?  Why does the number of threads an application uses have any
> bearing on how much CPU time it gets?  One is an implementation detail
> while the other is a policy decision.  Also, if you wanna factor in
> the number of threads into the policy decision for whatever reason,
> you can easily do so by factoring in that number into the decision,
> right?  That way, at least the decision would be explicit.

I think some of it is just historic, we previously did not group
application threads in the scheduler, so it would cause a change in
behavior if we started grouping them.  I will investigate switching to
a co-mounted hierarchy so hopefully you can deprecate cpuacct in the
future.

We can't factor the number of threads into the policy decision,
because it depends on how many threads are runnable at any time in any
particular application, and we have no way to track that.  It would
have to be a cgroup scheduler feature.
