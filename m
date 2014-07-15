Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaGOSl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:41:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:44620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbaGOSlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:41:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,667,1400050800"; 
   d="scan'208";a="573588385"
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
In-Reply-To: <20140715095045.GV9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
	 <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
	 <1405364908.2970.729.camel@schen9-DESK>
	 <20140714191504.GO9918@twins.programming.kicks-ass.net>
	 <1405367450.2970.750.camel@schen9-DESK>
	 <20140715095045.GV9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jul 2014 11:40:51 -0700
Message-ID: <1405449651.2970.796.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 11:50 +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 12:50:50PM -0700, Tim Chen wrote:
> 
> > There is a generic multi-buffer infrastructure portion that manages
> > pulling and queuing jobs on the crypto workqueue, and it is separated out
> > in patch 1 of the patchset.
> 
> There's one very weird multi-line comment in that patch.
> 
> > The other portions are algorithm specific that defines
> > algorithm specific data structure and  does the crypto computation 
> > for a particular algorithm, mostly in
> > assemblies and C glue code.  The infrastructure code is 
> > meant to be reused for other similar 
> > multi-buffer algorithms.
> 
> The flushing part that uses the sched thing is sha1 specific, even
> though it strikes me as not being so. Flushing buffers on idle seems
> like a 'generic' thing.
> 
> > We use nr_running_cpu to check whether there are other tasks running on
> > the *current* cpu, (not for another cpu),
> 
> And yet, the function allows you do to exactly that..

How about a function "single_task_running()"?  Something like

bool single_task_running()
{
	if (cpu_rq(smp_processor_id())->nr_running == 1)
		return true;
	else
		return false;
}

> 
> > to decide if we should flush
> > and compute crypto jobs accumulated.  If there's nobody else running,
> > we can take advantage of available cpu cycles on the cpu we are running 
> > on to do computation on the existing jobs in a SIMD mannner. 
> > Waiting a bit longer may accumulate more jobs to process in parallel
> > in a single SIMD instruction, but will have more delay.  
> 
> So you already have an idle notifier (which is x86 only, we should fix
> that I suppose), and you then double check there really isn't anything
> else running.
> 
> How much, if anything, does that second check buy you? There's just not
> a single word on that.
> 
> Also, there is not a word on the latency vs throughput tradeoff you
> make. I can imagine that for very short idle durations you loose, not
> win with this thing.

I am not crazy about the idle_notifier implementation either.  Thinking
a bit more, I can probably achieve most of what I need in the code path
that pull jobs from the work queue.  I'll flush the remaining
partially processed jobs if I don't have any more jobs to process and no
other tasks are running (i.e. single_task_running() is true).
I'll try to move this logic into the generic multi-buffer job handler
path and out of the idle_notifier.

> 
> So for now I still see no reason for doing this.
> 
> Also, I wonder about SMT, the point of this is to make best use of the
> SIMD pipelines, does it still make sense to use siblings at the same
> time even though you're running hand crafted ASM to stuff the pipelines
> to the brim? Should this thing be SMT aware and not gather queues for
> both siblings?

I am processing the crypto job on the same cpu that the crypto 
jobs originate from to get best cache utilization.  
It will be the scheduler's decision to move the task that's
generating a lot crypto jobs to another cpu, if the sibling
is also very busy.

Thanks for your comments and reviews.
 
Tim

