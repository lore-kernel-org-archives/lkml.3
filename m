Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3CRQar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:30:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3CRQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:30:45 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nGpB3NLV4dgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xnoB05DE7xsA:10 a=SYGBA_oH5YZLNx8tZboA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363624243.25967.178.camel@gandalf.local.home>
Subject: Re: workqueue code needing preemption disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 18 Mar 2013 12:30:43 -0400
In-Reply-To: <1363624020.25967.175.camel@gandalf.local.home>
References: <1363617383.25967.152.camel@gandalf.local.home>
	 <20130318160652.GA20133@mtj.dyndns.org>
	 <1363623799.25967.172.camel@gandalf.local.home>
	 <1363624020.25967.175.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 12:27 -0400, Steven Rostedt wrote:

> IOW, what can happen in -rt here is:
> 
> 	spin_lock_irq(&gcwq->lock);
> 	[...]
> 	<interrupt>
> 		-> preempt_schedule();
> 		   schedule();
> 		   try_to_wake_up_local();
> 
> 	[...]
> 	spin_unlock_irq(&gcwq->lock);
> 
> Again, with -rt, spin_lock_irq() does not prevent interrupts nor
> preemption.

If you happen to know the critical areas that require preemption to be
disabled for real, we can encapsulate them with:

	preempt_disable_rt();

	preempt_enable_rt();

These are currently only in the -rt patch, but it annotates locations
that require preemption to be disabled even when -rt converts spin_locks
into mutexes. These obviously can not contain spin_locks() as
spin_locks() can block and schedule out.

-- Steve


