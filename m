Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3KALPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:15:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53909 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3KALPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:15:42 -0400
Date: Wed, 30 Oct 2013 23:16:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131031061602.GU4126@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110111-0928-0000-0000-00000326B11D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:52:05PM +0200, Victor Kaplansky wrote:
> Peter Zijlstra <peterz@infradead.org> wrote on 10/30/2013 01:25:26 PM:
> 
> > Also, I'm not entirely sure on C, that too seems like a dependency, we
> > simply cannot read the buffer @tail before we've read the tail itself,
> > now can we? Similarly we cannot compare tail to head without having the
> > head read completed.
> 
> No, this one we cannot omit, because our problem on consumer side is not
> with @tail, which is written exclusively by consumer, but with @head.
> 
> BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
> around
> @head read.

If you omit the ACCESS_ONCE() calls around @tail, the compiler is within
its rights to combine adjacent operations and also to invent loads and
stores, for example, in cases of register pressure.  It is also within
its rights to do piece-at-a-time loads and stores, which might sound
unlikely, but which can actually has happened when the compiler figures
out exactly what is to be stored at compile time, especially on hardware
that only allows small immediate values.

So the ACCESS_ONCE() calls are not optional, the current contents of
Documentation/circular-buffers.txt notwithstanding.

							Thanx, Paul

