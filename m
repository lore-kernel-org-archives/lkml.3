Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3KAKag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:30:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46067 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KAKaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:30:35 -0400
Date: Fri, 1 Nov 2013 11:30:17 +0100
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
Message-ID: <20131101103017.GF19466@laptop.lan>
References: <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131031043258.GQ4126@linux.vnet.ibm.com>
 <20131031090457.GU19466@laptop.lan>
 <20131031150756.GB4067@linux.vnet.ibm.com>
 <20131031151955.GY19466@laptop.lan>
 <20131101092814.GG4067@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101092814.GG4067@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 02:28:14AM -0700, Paul E. McKenney wrote:
> > This is a completely untenable position.
> 
> Indeed it is!
> 
> C/C++ never was intended to be used for parallel programming, 

And yet pretty much all kernels ever written for SMP systems are written
in it; what drugs are those people smoking?

Furthermore there's a gazillion parallel userspace programs.

> and this is
> but one of the problems that can arise when we nevertheless use it for
> parallel programming.  As compilers get smarter (for some definition of
> "smarter") and as more systems have special-purpose hardware (such as
> vector units) that are visible to the compiler, we can expect more of
> this kind of trouble.
> 
> This was one of many reasons that I decided to help with the C/C++11
> effort, whatever anyone might think about the results.

Well, I applaud your efforts, but given the results I think the C/C++
people are all completely insane.

> > How do the C/C++ people propose to deal with this?
> 
> By marking "ptr" as atomic, thus telling the compiler not to mess with it.
> And thus requiring that all accesses to it be decorated, which in the
> case of RCU could be buried in the RCU accessors.

This seems contradictory; marking it atomic would look like:

struct foo {
	unsigned long value;
	__atomic void *ptr;
	unsigned long value1;
};

Clearly we cannot hide this definition in accessors, because then
accesses to value* won't see the annotation.

That said; mandating we mark all 'shared' data with __atomic is
completely untenable and is not backwards compatible.

To be safe we must assume all data shared unless indicated otherwise.
