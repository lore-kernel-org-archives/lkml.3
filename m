Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaEEROn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:14:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbaEEROj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:14:39 -0400
Date: Mon, 5 May 2014 19:14:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140505171428.GU26782@laptop.programming.kicks-ass.net>
References: <20140502172731.GK30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 01:10:55PM -0400, Vince Weaver wrote:
> On Mon, 5 May 2014, Vince Weaver wrote:
> 
> > (Although often things like to crash the instant my tested-by e-mails 
> > clear the lkml list.)
> 
> This did turn up on the core2 machine.  I had been seeing this problem 
> earlier but was hoping it was part of the memory corruption issue:
> 
> [ 4918.921921] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [ 4918.925692] IP: [<ffffffff81539fa6>] mutex_lock+0x19/0x37

> [ 4918.925692] Call Trace:
> [ 4918.925692]  [<ffffffff810d10b7>] perf_event_init_context+0x7c/0x1c8
> [ 4918.925692]  [<ffffffff810d126c>] perf_event_init_task+0x69/0x6d
> [ 4918.925692]  [<ffffffff8103e1ff>] copy_process+0x5cc/0x163b
> [ 4918.925692]  [<ffffffff8103f536>] do_fork+0x74/0x1dc
> [ 4918.925692]  [<ffffffff8103f6b4>] SyS_clone+0x16/0x18
> [ 4918.925692]  [<ffffffff81542c89>] stub_clone+0x69/0x90


Cute.. does the below cure?


---
Subject: perf: Fix perf_event_init_context()
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon May  5 19:12:20 CEST 2014

perf_pin_task_context() can return NULL but perf_event_init_context()
assumes it will not, correct this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/events/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7745,6 +7745,8 @@ int perf_event_init_context(struct task_
 	 * swapped under us.
 	 */
 	parent_ctx = perf_pin_task_context(parent, ctxn);
+	if (!parent_ctx)
+		return 0;
 
 	/*
 	 * No need to check if parent_ctx != NULL here; since we saw

