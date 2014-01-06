Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaAFU4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:56:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:18420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbaAFU4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:56:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="434690625"
Message-ID: <1389041805.30730.47.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH v5 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Date: Mon, 06 Jan 2014 12:56:45 -0800
In-Reply-To: <1388696357.11119.10.camel@buesod1.americas.hpqcorp.net>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388675120-8017-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFwNPgzORGyKaziqBGqY9Uubuuo0w=rGQvcHS-Ftz4HQ9g@mail.gmail.com>
	 <1388696357.11119.10.camel@buesod1.americas.hpqcorp.net>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 12:59 -0800, Davidlohr Bueso wrote:
> On Thu, 2014-01-02 at 11:23 -0800, Linus Torvalds wrote:
> > On Thu, Jan 2, 2014 at 7:05 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > >
> > > In futex_wake() there is clearly no point in taking the hb->lock if we know
> > > beforehand that there are no tasks to be woken.
> > 
> > Btw, I think we could optimize this a bit further for the wakeup case.
> > 
> > wake_futex() does a get_task_struct(p)/put_task_struct(p) around its
> > actual waking logic, and I don't think that's necessary. The task
> > structures are RCU-delayed, and the task cannot go away until the
> > "q->lock_ptr = NULL" afaik, so you could replace that atomic inc/dec
> > with just a RCU read region.
> 
> I had originally explored making the whole plist thing more rcu aware
> but never got to anything worth sharing. What you say does make a lot of
> sense, however, I haven't been able to see any actual improvements. It
> doesn't hurt however, so I'd have no problem adding such patch to the
> lot.
> 
> > 
> > Maybe it's not a big deal ("wake_up_state()" ends up getting the task
> > struct pi_lock anyway, so it's not like we can avoid toucing the task
> > structure), but I'm getting the feeling that we're doing a lot of
> > unnecessary work here.
> 
> I passed this idea through my wakeup measuring program and didn't notice
> hardly any difference, just noise, even for large amounts of futexes.
> I believe that peterz's idea of lockless batch wakeups is the next step
> worth looking into for futexes -- even though the spurious wakeup
> problem can become a real pain.
> 
> Thanks,
> Davidlohr
> 
> 

While I love to see significant performance improvements to the futex
hot paths, I am wary of the sort of implicit improvements we've been
exploring here. At the risk of being a wimp here, this code is
incredibly complex already, so I would prefer anything along these lines
have very strong empirical justification first - as Davidlohr's changes
here have provided.

Does anyone see any reason to hold off getting them in at this point?
I've made a couple points on comments and docs to the 4/5 patch, but
otherwise, I think it's time to get them in and more broadly tested.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


