Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaG2W2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:28:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:63908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaG2W2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:28:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,760,1400050800"; 
   d="scan'208";a="580867883"
Subject: Re: [PATCH v5 2/7] crypto: SHA1 multibuffer crypto hash
 infrastructure
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1406305521.2970.851.camel@schen9-DESK>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
	 <1406066972.2970.804.camel@schen9-DESK>  <20140725070800.GS3935@laptop>
	 <1406305521.2970.851.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jul 2014 15:28:25 -0700
Message-ID: <1406672905.2970.940.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 09:25 -0700, Tim Chen wrote:
> On Fri, 2014-07-25 at 09:08 +0200, Peter Zijlstra wrote:
> > On Tue, Jul 22, 2014 at 03:09:32PM -0700, Tim Chen wrote:
> > > +/* Called in workqueue context, do one real cryption work (via
> > > + * req->complete) and reschedule itself if there are more work to
> > > + * do. */
> > 
> > You seem to manage the 'normal' comment style in other places, this one
> > 'special' for a reason?
> 
> Yes, I'll need to correct it.
> 
> > 
> > > +static void mcryptd_queue_worker(struct work_struct *work)
> > > +{
> > > +	struct mcryptd_cpu_queue *cpu_queue;
> > > +	struct crypto_async_request *req, *backlog;
> > > +	int i;
> > > +
> > > +	/*
> > > +	 * Need to loop through more than once for multi-buffer to
> > > +	 * be effective.
> > > +	 */
> > > +
> > > +	cpu_queue = container_of(work, struct mcryptd_cpu_queue, work);
> > > +	i = 0;
> > > +	while (i < MCRYPTD_BATCH || single_task_running()) {
> > > +		/*
> > > +		 * preempt_disable/enable is used to prevent
> > > +		 * being preempted by mcryptd_enqueue_request()
> > > +		 */
> > > +		local_bh_disable();
> > > +		preempt_disable();
> > > +		backlog = crypto_get_backlog(&cpu_queue->queue);
> > > +		req = crypto_dequeue_request(&cpu_queue->queue);
> > > +		preempt_enable();
> > > +		local_bh_enable();
> > > +
> > > +		if (!req)
> > > +			return;
> > > +
> > > +		if (backlog)
> > > +			backlog->complete(backlog, -EINPROGRESS);
> > > +		req->complete(req, 0);
> > > +		if (!cpu_queue->queue.qlen)
> > > +			return;
> > > +		++i;
> > > +	}
> > > +	if (cpu_queue->queue.qlen)
> > > +		queue_work(kcrypto_wq, &cpu_queue->work);
> > > +}
> > 
> > Right, so I don't think you need that single_task_running() thing for
> > this. Also its a rather inconclusive test, a task can come in while
> > processing the request, preempt the processing, complete and by the time
> > we're back to check if we want to continue the loop its only us again.
> > 
> > So its actually misleading..
> > 
> > You could do that, but then you have to keep preemption disabled across
> > the entire thing, and break out on need_resched(), that would entirely
> > obviate the need for single_task_running(), but would increase the
> > preemption latency by however long the req processing takes, so that's
> > bad too.
> > 
> > But you can get similar 'fuzzy' semantics as above by using something
> > like:
> > 
> > static inline bool did_context_switch(unsigned long *nivcs)
> > {
> > 	if (*nivcs != current->nivcs) {
> > 		*nivcs = current->nivcs;
> > 		return true;
> > 	}
> > 	return false;
> > }
> > 
> > static void mcryptd_queue_worker()
> > {
> > 	...
> > 	unsigned long nivcs = current->nivcs;
> > 
> > 	...
> > 
> > 	while (!did_context_switch(&nivcs) || i < MCRYPTD_BATCH)
> 
> Won't I need something like 
> 
> while ((!did_context_switch(&nivcs) && single_task_running()) 
> 	|| i < MCRYPTD_BATCH)
> 
> in case I got some new task in my run queue but I did not get
> pre-empted?  I should not continue to run in that case.
> 
> > 
> > 	...
> > }
> > 
> > It'll terminate earlier I suppose, its the inverse test. But I think you
> > want to terminate early if there's any activity.
> 
> I have some doubts here.
> If I'm still the only task running, why not continue, even if I've been
> pre-empted?  Since there's nothing else to run, why not take
> advantage of the cpu?
> 

Peter,

Is my explanation adequate or you still have objection to the implementation?  I'm
trying to decide here whether to extend our batch processing by
the crypto daemon (prolong our busy period) 
based on whether there are other tasks to run.  Pre-emption and
resuming the crypto daemon is okay. Even if there's a pre-emption and
context switch in between, we can still do extended processing if
there's nothing else to run. Otherwise the cpu will go idle. 

Tim

