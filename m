Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3AXABA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:01:00 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58902 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3AXAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:00:54 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 19:00:53 EST
MIME-Version: 1.0
In-Reply-To: <20130123230608.GJ2373@mtj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
	<50FD3123.6090003@parallels.com>
	<20130123010226.GF5359@htj.dyndns.org>
	<CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
	<20130123165657.GC2373@mtj.dyndns.org>
	<CAMbhsRRj9svWubn01wb+f=jSwVWC5u7DqJ5c8P23vAp0E2L8Rg@mail.gmail.com>
	<20130123230608.GJ2373@mtj.dyndns.org>
Date: Wed, 23 Jan 2013 15:53:30 -0800
Message-ID: <CAMbhsRSAPL3P-EhD4HBChsgr66xYuEg4o2JtbFX=tz9w7RCeGQ@mail.gmail.com>
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

On Wed, Jan 23, 2013 at 3:06 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Collin.
>
> On Wed, Jan 23, 2013 at 02:41:46PM -0800, Colin Cross wrote:
>> I think some of it is just historic, we previously did not group
>> application threads in the scheduler, so it would cause a change in
>> behavior if we started grouping them.  I will investigate switching to
>> a co-mounted hierarchy so hopefully you can deprecate cpuacct in the
>> future.
>
> Yeah, it's gonna be many years, if ever, before we can actually
> deprecate cpuacct and multiple hierarchies but it would be really nice
> to move at least popular uses away from them sooner than later.
>
> Also, maybe I'm misunderstanding what you were saying but isn't it the
> case that only single application is "foreground" in at least vanilla
> android?  Maybe multi-window support is scheduled for future releases
> but it wouldn't count as behavior change in that case, right?

Not exactly.  Only one "app" is ever foreground, but there are
numerous other app-like things in their own process containers that
the user is aware of, and therefore gets foreground resources.  For
example, a service that is playing music in the background may get
treated like a foreground app.  Also, a foreground app may spawn
threads and request that they run in the background, so a single
container for an app is not sufficient.

> At any rate, IMHO, it's simply the better and correct to not depend on
> the number of threads in use as a measure of CPU resource
> distribution.
>
>> We can't factor the number of threads into the policy decision,
>> because it depends on how many threads are runnable at any time in any
>> particular application, and we have no way to track that.  It would
>> have to be a cgroup scheduler feature.
>
> My understanding of android is very limited but the number of threads
> in dalvik apps are controlled by the base system rather than
> application itself, no?  If so, factoring that into scheduling params
> shouldn't be difficult.  For native processes, if the number of
> threads just *have* to be factored in some way, we can resort to
> sampling.  That said, as native apps can easily thread-bomb out of
> fairness, there are way more reasons to avoid basing the resource
> policy decision on the number of threads in use.

A pure-dalvik app will spawn threads through a controlled interface
that could count threads (but still could not count threads that are
runnable vs. sleeping), but any app can use JNI to link to a native
library and use pthreads directly if it wants to.  I agree per-app
containers may have some fairness advantages between multiple apps, I
just have to figure out what it will mean for apps vs. system
services, etc

> Thanks.
>
> --
> tejun
