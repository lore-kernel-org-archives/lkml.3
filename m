Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3CRQl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:41:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3CRQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:41:25 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nGpB3NLV4dgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xnoB05DE7xsA:10 a=Sbw5BVceeHXjAbC1BoUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363624883.25967.184.camel@gandalf.local.home>
Subject: Re: workqueue code needing preemption disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 18 Mar 2013 12:41:23 -0400
In-Reply-To: <20130318162718.GB20133@mtj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
	 <20130318160652.GA20133@mtj.dyndns.org>
	 <1363623799.25967.172.camel@gandalf.local.home>
	 <20130318162718.GB20133@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 09:27 -0700, Tejun Heo wrote:

> Does that mean that a task holding gcwq->lock may be preempted?  If
> so, that sure could lead to weird problems.  Maybe gcwq->lock should
> be marked non-preemptible somehow?

If the gcwq->lock is never held for a long time (really, more than a
microsecond on today's processors is considered a long time), and it
does not nest any other spin_locks (raw locks are OK, like the rq lock).
Then we could mark the gcwq->lock as raw as well.

This would require the struct global_cwq lock to have:

	raw_spinlock_t		lock;

and then you would need to do:

s/spin_/raw_spin/ for all gcwq->lock usages.

But, I'm worried about the loops that are done while holding this lock.
Just looking at is_chained_work() that does for_each_busy_worker(), how
big can that list be? If it's bound by # of CPUs then that may be fine,
but if it can be as big as the # of workers assigned, with no real
limit, then its not fine, because that creates an unbound (non
deterministic) latency.

-- Steve


