Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3KDKH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:07:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45287 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3KDKH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:07:57 -0500
Date: Mon, 4 Nov 2013 02:00:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131104100042.GK3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131031043258.GQ4126@linux.vnet.ibm.com>
 <20131031090457.GU19466@laptop.lan>
 <20131031150756.GB4067@linux.vnet.ibm.com>
 <20131031151955.GY19466@laptop.lan>
 <20131101092814.GG4067@linux.vnet.ibm.com>
 <20131101103017.GF19466@laptop.lan>
 <20131102152048.GI4067@linux.vnet.ibm.com>
 <20131104090744.GE10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104090744.GE10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110410-1542-0000-0000-000002E396C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 10:07:44AM +0100, Peter Zijlstra wrote:
> On Sat, Nov 02, 2013 at 08:20:48AM -0700, Paul E. McKenney wrote:
> > On Fri, Nov 01, 2013 at 11:30:17AM +0100, Peter Zijlstra wrote:
> > > Furthermore there's a gazillion parallel userspace programs.
> > 
> > Most of which have very unaggressive concurrency designs.
> 
> pthread_mutex_t A, B;
> 
> char data_A[x];
> int  counter_B = 1;
> 
> void funA(void)
> {
> 	pthread_mutex_lock(&A);
> 	memset(data_A, 0, sizeof(data_A));
> 	pthread_mutex_unlock(&A);
> }
> 
> void funB(void)
> {
> 	pthread_mutex_lock(&B);
> 	counter_B++;
> 	pthread_mutex_unlock(&B);
> }
> 
> void funC(void)
> {
> 	pthread_mutex_lock(&B)
> 	printf("%d\n", counter_B);
> 	pthread_mutex_unlock(&B);
> }
> 
> Then run: funA, funB, funC concurrently, and end with a funC.
> 
> Then explain to userman than his unaggressive program can return:
> 0
> 1
> 
> Because the memset() thought it might be a cute idea to overwrite
> counter_B and fix it up 'later'. Which if I understood you right is
> valid in C/C++ :-(
> 
> Not that any actual memset implementation exhibiting this trait wouldn't
> be shot on the spot.

Even without such a malicious memcpy() implementation I must still explain
about false sharing when the developer notices that the unaggressive
program isn't running as fast as expected.

> > > > By marking "ptr" as atomic, thus telling the compiler not to mess with it.
> > > > And thus requiring that all accesses to it be decorated, which in the
> > > > case of RCU could be buried in the RCU accessors.
> > > 
> > > This seems contradictory; marking it atomic would look like:
> > > 
> > > struct foo {
> > > 	unsigned long value;
> > > 	__atomic void *ptr;
> > > 	unsigned long value1;
> > > };
> > > 
> > > Clearly we cannot hide this definition in accessors, because then
> > > accesses to value* won't see the annotation.
> > 
> > #define __rcu __atomic
> 
> Yeah, except we don't use __rcu all that consistently; in fact I don't
> know if I ever added it.

There are more than 300 of them in the kernel.  Plus sparse can be
convinced to yell at you if you don't use them.  So lack of __rcu could
be fixed without too much trouble.

The C/C++11 need to annotate functions that take arguments or return
values taken from rcu_dereference() is another story.  But the compilers
have to get significantly more aggressive or developers have to be doing
unusual things that result in rcu_dereference() returning something whose
value the compiler can predict exactly.

							Thanx, Paul

