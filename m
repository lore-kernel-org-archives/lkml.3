Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3H1NAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:00:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3H1NAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:00:00 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=MkLg_yf6oqsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Xf-hRFNtRvAA:10 a=JfrnYn6hAAAA:8 a=-Hruq60_mDZDeuMr8VIA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 08:59:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Fyodorov <halcy@yandex.ru>, Waiman Long <waiman.long@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue
 spinlock implementation
Message-ID: <20130828085957.728a5375@gandalf.local.home>
In-Reply-To: <20130828081937.GH10002@twins.programming.kicks-ass.net>
References: <15321377012704@web8h.yandex.ru>
	<52142D6C.6000400@hp.com>
	<336901377100289@web16f.yandex.ru>
	<5215638E.5020702@hp.com>
	<169431377178121@web21f.yandex.ru>
	<521BB71F.6080300@hp.com>
	<66111377605355@web12m.yandex.ru>
	<20130827091436.3d5971a0@gandalf.local.home>
	<20130827135309.GF10002@twins.programming.kicks-ass.net>
	<20130828012128.GT3871@linux.vnet.ibm.com>
	<20130828081937.GH10002@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 10:19:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:


> > An unlock followed by a lock needs to act like a full barrier, but there
> > is no requirement that a lock or unlock taken separately act like a
> > full barrier.
> 
> But that is already a property of the acquisition/release barrier.

As I mentioned in my fixes for the -rt swait barrier patches I sent.
Spin locks only prevent leaks out of the critical section. It does not
guarantee leaks into the critical section, thus:


	A = 1

	spin_lock()



	spin_unlock()

	B = C

Can turn into:


	(A = 1)

	spin_lock()

	load C

	store 1 into A

	spin_unlock()

	B = C

This shows that a spin_lock()/unlock() combo is not equivalent to a
mb(). But as Paul has mentioned, if we had:

	A = 1

	spin_unlock()

	spin_lock()

	B = C

That would be equivalent to

	A = 1

	mb()

	B = C

as the unlock prevents leaks going past it, and lock prevents leaks
going before it.

-- Steve
