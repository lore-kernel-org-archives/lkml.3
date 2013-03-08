Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3CHGoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:44:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:53962 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab3CHGoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:44:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19TlZ0oKIdTnSe5L0OWCcxFNkEDSM3xKiswSb8SKn
	aWpAKrOLCNZq2J
Message-ID: <1362725051.31859.40.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Fri, 08 Mar 2013 07:44:11 +0100
In-Reply-To: <51394EE3.1020706@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
	 <1362645372.2606.11.camel@laptop>
	 <1362649419.4652.12.camel@marge.simpson.net>
	 <51394EE3.1020706@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 10:37 +0800, Michael Wang wrote: 
> On 03/07/2013 05:43 PM, Mike Galbraith wrote:
> > On Thu, 2013-03-07 at 09:36 +0100, Peter Zijlstra wrote: 
> >> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
> >>
> >>> wake_affine() stuff is trying to bind related tasks closely, but it doesn't
> >>> work well according to the test on 'perf bench sched pipe' (thanks to Peter).
> >>
> >> so sched-pipe is a poor benchmark for this.. 
> >>
> >> Ideally we'd write a new benchmark that has some actual data footprint
> >> and we'd measure the cost of tasks being apart on the various cache
> >> metrics and see what affine wakeup does for it.
> >>
> >> Before doing something like what you're proposing, I'd have a hard look
> >> at WF_SYNC, it is possible we should disable/fix select_idle_sibling
> >> for sync wakeups.
> > 
> > If nobody beats me to it, I'm going to try tracking shortest round trip
> > to idle, and use a multiple of that to shut select_idle_sibling() down.
> > If avg_idle approaches round trip time, there's no win to be had, we're
> > just wasting cycles.
> 
> That's great if we have it, I'm a little doubt whether it is possible to
> find a better way to replace the select_idle_sibling() (look at the way
> it locates idle cpu...) in some cases, but I'm looking forward it ;-)

I'm not going to replace it, only stop it from wasting cycles when
there's very likely nothing to gain.  Save task wakeup time, if delta
rq->clock - p->last_wakeup < N*shortest_idle or some such very cheap
metric.  Wake ultra switchers L2 affine if allowed, only go hunting for
an idle L3 if the thing is on another package.  

In general, I think things would work better if we'd just rate limit how
frequently we can wakeup migrate each individual task.  We want
jabbering tasks to share L3, but we don't really want to trash L2 at an
awesome rate.

-Mike

