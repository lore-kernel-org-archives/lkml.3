Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3BVJpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:45:35 -0500
Received: from mout.gmx.net ([212.227.17.20]:58265 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab3BVJpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:45:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19zF2VZWyFzp0Q+9KjClUld4sW2FWSds+pLWO/Pl/
	TQBw+YLPa6jHzY
Message-ID: <1361526022.5817.115.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 10:40:22 +0100
In-Reply-To: <1361522197.26780.39.camel@laptop>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com>
	 <1361522197.26780.39.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 09:36 +0100, Peter Zijlstra wrote: 
> On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
> > But that's really some benefit hardly to be estimate, especially when
> > the workload is heavy, the cost of wake_affine() is very high to
> > calculated se one by one, is that worth for some benefit we could not
> > promise?
> 
> Look at something like pipe-test.. wake_affine() used to ensure both
> client/server ran on the same cpu, but then I think we added
> select_idle_sibling() and wrecked it again :/

Yeah, that's the absolute worst case for select_idle_sibling(), 100%
synchronous, absolutely nothing to be gained by cross cpu scheduling.
Fortunately, most tasks do more than that, but nonetheless,
select_idle_sibling() definitely is a two faced little b*tch.  I'd like
to see the evil b*tch die, but something needs to replace it's pretty
face.  One thing that you can do is simply don't call it when the
context switch rate is incredible.. its job is to recover overlap, if
you're scheduling near your max, there's no win worth the cost.

> $ taskset 1 perf bench sched pipe
> # Running sched/pipe benchmark...
> # Extecuted 1000000 pipe operations between two tasks
> 
>      Total time: 3.761 [sec]
> 
>        3.761725 usecs/op
>          265835 ops/sec
> 
> $ perf bench sched pipe
> # Running sched/pipe benchmark...
> # Extecuted 1000000 pipe operations between two tasks
> 
>      Total time: 29.809 [sec]
> 
>       29.809720 usecs/op
>           33546 ops/sec

Gak!  Hm, are you running a kernel without the thinko fix?  It's not
good for this extreme testcase, but it doesn't suck _that_ bad ;-)

nohz isn't exactly your friend with ultra switchers either.

Q6600:
marge:~ # taskset -c 3 perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

     Total time: 3.395 [sec]

       3.395357 usecs/op
         294519 ops/sec
marge:~ # perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

     Total time: 4.212 [sec]

       4.212413 usecs/op
         237393 ops/sec

E5620:
rtbox:~ # taskset -c 0 perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

     Total time: 2.558 [sec]

       2.558237 usecs/op
         390894 ops/sec
rtbox:~ # perf bench sched pipe
# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two tasks

     Total time: 4.588 [sec]

       4.588702 usecs/op
         217926 ops/sec

