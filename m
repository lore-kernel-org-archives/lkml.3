Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3KDJIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:08:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55823 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3KDJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:08:14 -0500
Date: Mon, 4 Nov 2013 10:07:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131104090744.GE10651@twins.programming.kicks-ass.net>
References: <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131031043258.GQ4126@linux.vnet.ibm.com>
 <20131031090457.GU19466@laptop.lan>
 <20131031150756.GB4067@linux.vnet.ibm.com>
 <20131031151955.GY19466@laptop.lan>
 <20131101092814.GG4067@linux.vnet.ibm.com>
 <20131101103017.GF19466@laptop.lan>
 <20131102152048.GI4067@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131102152048.GI4067@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 08:20:48AM -0700, Paul E. McKenney wrote:
> On Fri, Nov 01, 2013 at 11:30:17AM +0100, Peter Zijlstra wrote:
> > Furthermore there's a gazillion parallel userspace programs.
> 
> Most of which have very unaggressive concurrency designs.

pthread_mutex_t A, B;

char data_A[x];
int  counter_B = 1;

void funA(void)
{
	pthread_mutex_lock(&A);
	memset(data_A, 0, sizeof(data_A));
	pthread_mutex_unlock(&A);
}

void funB(void)
{
	pthread_mutex_lock(&B);
	counter_B++;
	pthread_mutex_unlock(&B);
}

void funC(void)
{
	pthread_mutex_lock(&B)
	printf("%d\n", counter_B);
	pthread_mutex_unlock(&B);
}

Then run: funA, funB, funC concurrently, and end with a funC.

Then explain to userman than his unaggressive program can return:
0
1

Because the memset() thought it might be a cute idea to overwrite
counter_B and fix it up 'later'. Which if I understood you right is
valid in C/C++ :-(

Not that any actual memset implementation exhibiting this trait wouldn't
be shot on the spot.

> > > By marking "ptr" as atomic, thus telling the compiler not to mess with it.
> > > And thus requiring that all accesses to it be decorated, which in the
> > > case of RCU could be buried in the RCU accessors.
> > 
> > This seems contradictory; marking it atomic would look like:
> > 
> > struct foo {
> > 	unsigned long value;
> > 	__atomic void *ptr;
> > 	unsigned long value1;
> > };
> > 
> > Clearly we cannot hide this definition in accessors, because then
> > accesses to value* won't see the annotation.
> 
> #define __rcu __atomic

Yeah, except we don't use __rcu all that consistently; in fact I don't
know if I ever added it.
