Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbaGNRFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:05:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:34346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbaGNRFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="572946280"
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140714161432.GC9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
	 <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jul 2014 10:05:34 -0700
Message-ID: <1405357534.2970.701.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 18:14 +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 09:10:14AM -0700, Tim Chen wrote:
> > On Mon, 2014-07-14 at 12:16 +0200, Peter Zijlstra wrote:
> > > On Fri, Jul 11, 2014 at 01:33:04PM -0700, Tim Chen wrote:
> > > > This function will help a thread decide if it wants to to do work
> > > > that can be delayed, to accumulate more tasks for more efficient
> > > > batch processing later.
> > > > 
> > > > However, if no other tasks are running on the cpu, it can take
> > > > advantgae of the available cpu cycles to complete the tasks
> > > > for immediate processing to minimize delay, otherwise it will yield.
> > > 
> > > Ugh.. and ignore topology and everything else.
> > > 
> > > Yet another scheduler on top of the scheduler.
> > > 
> > > We have the padata muck, also only ever used by crypto.
> > > We have the workqueue nonsense, used all over the place
> > > And we have btrfs doing their own padata like muck.
> > > And I'm sure there's at least one more out there, just because.
> > > 
> > > Why do we want yet another thing?
> > > 
> > > I'm inclined to go NAK and get people to reduce the amount of async
> > > queueing and processing crap.
> > 
> > The mult-buffer class of crypto algorithms is by nature
> > asynchronous.  The algorithm gathers several crypto jobs, and
> > put the buffer from each job in a data lane of the SIMD register.
> > This allows for parallel processing and increases throughput.
> > The gathering of the crypto jobs is an async process and
> > queuing is necessary for this class of algorithm.
> 
> How is that related to me saying we've got too much of this crap
> already?

I was trying to explain why the algorithm is implemented this way
because of its batching nature.

There is a whole class of async algorithm that can provide
substantial speedup by doing batch processing and uses workqueue.
The multi-buffer sha1 version has 2.2x speedup over existing
AVX2 version, and can have even more speedup when AVX3 
comes round.  Workqueue is a natural way to implement 
this.  I don't think a throughput speedup of 2.2x is "crap".

We are not inventing anything new, but ask for a 
very simple helper function to know if there's something else
running on our cpu to help us make a better decision 
of whether we should flush the batched jobs immediately.

And also asynchronous crypto interface is already used substantially
in crypto and has a well established infrastructure.  

Thanks.

Tim


