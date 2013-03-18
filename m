Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3CRQ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:27:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3CRQ1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:27:02 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nGpB3NLV4dgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xnoB05DE7xsA:10 a=poVp_puX6PWgUAkBSwwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363624020.25967.175.camel@gandalf.local.home>
Subject: Re: workqueue code needing preemption disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 18 Mar 2013 12:27:00 -0400
In-Reply-To: <1363623799.25967.172.camel@gandalf.local.home>
References: <1363617383.25967.152.camel@gandalf.local.home>
	 <20130318160652.GA20133@mtj.dyndns.org>
	 <1363623799.25967.172.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 12:23 -0400, Steven Rostedt wrote:

> > Maybe I'm confused but I can't really see how the above would be a
> > problem to workqueue in itself.  Both rq->lock and gcwq->lock are
> > irq-safe, so spin_lock() not disabling preemption shouldn't be a
> > problem.  Are CPU hotplug operations involved?
> 
> No CPU hotplug is involved here. But I will note that gcwq->lock in -rt
> is not irq -safe. That is, in rt the spin_lock_irq(&gcwq->lock) really
> becomes a special "mutex_lock(&gcwq->lock)".

IOW, what can happen in -rt here is:

	spin_lock_irq(&gcwq->lock);
	[...]
	<interrupt>
		-> preempt_schedule();
		   schedule();
		   try_to_wake_up_local();

	[...]
	spin_unlock_irq(&gcwq->lock);

Again, with -rt, spin_lock_irq() does not prevent interrupts nor
preemption.

-- Steve


