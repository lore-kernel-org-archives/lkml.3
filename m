Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbaEMOXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:23:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbaEMOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:23:37 -0400
Date: Tue, 13 May 2014 16:23:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140513142328.GE2485@laptop.programming.kicks-ass.net>
References: <537192D3.5030907@linux.vnet.ibm.com>
 <20140513094737.GU30445@twins.programming.kicks-ass.net>
 <53721FD4.6060300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53721FD4.6060300@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 09:36:20AM -0400, Rik van Riel wrote:
> On 05/13/2014 05:47 AM, Peter Zijlstra wrote:
> > On Tue, May 13, 2014 at 11:34:43AM +0800, Michael wang wrote:
> >> During our testing, we found that the cpu.shares doesn't work as
> >> expected, the testing is:
> >>
> > 
> > /me zaps all the kvm nonsense as that's non reproducable and only serves
> > to annoy.
> > 
> > Pro-tip: never use kvm to report cpu-cgroup issues.
> > 
> >> So is this results expected (I really do not think so...)?
> >>
> >> Or that imply the cpu-cgroup got some issue to be fixed?
> > 
> > So what I did (WSM-EP 2x6x2):
> > 
> > mount none /cgroup -t cgroup -o cpu
> > mkdir -p /cgroup/a
> > mkdir -p /cgroup/b
> > mkdir -p /cgroup/c
> > 
> > echo $$ > /cgroup/a/tasks ; for ((i=0; i<12; i++)) ; do A.sh & done
> > echo $$ > /cgroup/b/tasks ; for ((i=0; i<12; i++)) ; do B.sh & done
> > echo $$ > /cgroup/c/tasks ; for ((i=0; i<12; i++)) ; do C.sh & done
> > 
> > echo 2048 > /cgroup/c/cpu.shares
> > 
> > Where [ABC].sh are spinners:
> 
> I suspect the "are spinners" is key.
> 
> Infinite loops can run all the time, while dbench spends a lot of
> its time waiting for locks. That waiting may interfere with getting
> as much CPU as it wants.

At which point it becomes an entirely different problem and the weight
things become far more 'interesting'.

The point remains though, don't use massive and awkward software stacks
that are impossible to operate.

I you want to investigate !spinners, replace the ABC with slightly more
complex loads like: https://lkml.org/lkml/2012/6/18/212
