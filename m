Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486AbbA1E2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:28:13 -0500
Received: from ozlabs.org ([103.22.144.67]:46144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965383AbbA1E2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:28:11 -0500
Message-ID: <1422419289.9646.20.camel@neuling.org>
Subject: Re: [V6,1/9] elf: Add new powerpc specifc core note sections
From: Michael Neuling <mikey@neuling.org>
To: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Cc: akpm@linux-foundation.org, avagin@openvz.org, davej@redhat.com,
        davem@davemloft.net, dhowells@redhat.com,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        james.hogan@imgtec.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, kirjanov@gmail.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, oleg@redhat.com,
        palves@redhat.com, Paul.Clothier@imgtec.com, peterz@infradead.org,
        sam.bobroff@au1.ibm.com, shuahkh@osg.samsung.com,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Date: Wed, 28 Jan 2015 15:28:09 +1100
In-Reply-To: <1421963049.30744.23.camel@neuling.org>
References: <20141203052204.9DA8F1400DD@ozlabs.org>
	 <547EB253.5050307@linux.vnet.ibm.com> <548578A8.5020901@linux.vnet.ibm.com>
	 <54947C64.4030206@linux.vnet.ibm.com> <54A50094.5070902@linux.vnet.ibm.com>
	 <1421883597.30744.3.camel@neuling.org>
	 <OFC6CFC348.C619B89D-ONC1257DD5.0056279B-C1257DD5.00577002@de.ibm.com>
	 <1421963049.30744.23.camel@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 08:44 +1100, Michael Neuling wrote:
> > > > Inside transaction both running and check pointed values can be
> > > > probed independently.
> > >
> > > Yep, that's the idea, although setting the running values won't change
> > > anything since the the translation is already doomed and will abort once
> > > the cpu starts executing it.
> > 
> > So this looks to me like the overall effect on debugging transactional
> > code should be the same on Power and z, even if some internal details
> > are different (on z, the exception will automatically abort the
> > transaction; on p, the exception itself will not abort, but *restarting*
> > user space execution will).
> 
> Yep
> 
> > From a GDB perspective, it would therefore be preferable if the ptrace
> > interface were to behave in a similar fashion on p as on z: that is,
> > if an exception interrupting a transaction results in a ptrace intercept,
> > at this point:
> 
> Agreed.
> 
> > - the "normal" ptrace register set commands should access the
> >   *checkpointed* registers (allowing both read and write access)
> 
> OK, this is a change from what we've been proposing with Anshuman's
> patch set but I'm happy to change it to make it consistent with other
> architectures.  It's relatively arbitrary which goes where, so I'm happy
> to change.
> 
> >   -- GDB will use this to display current position (already reflecting
> >   the fact that the transaction will abort), and use it when changing
> >   register values e.g. to effect an inferior function call
> 
> "Current position" depends on your perspective.  Is it the last executed
> instruction or the next executed instruction?  If it's the last executed
> instruction, then it's the running values.  If it's the next, then it's
> the check pointed.  
> 
> Anyway, I'm happy to make it the check pointed values for the sake of
> ptrace/gdb.

Uli,

Sorry, I'm rethinking this as we didn't consider user suspended
transactions.

It makes sense for normal transactions but for user suspended
transactions the running values are the ones you want to modify since
that is where you'll end up restarting from.  The hardware will only
abort/rollback once a tresume is encountered.
      * 
So we could do what you're talking about for normal transactions and
then switch them for suspended transactions.  But this just seems to be
making the kernel interface overly complicated.  

So I'm keen on just keeping it the way Anshuman has now and GDB has to
understand the program flow better to know which ones it wants to
modify.  The kernel always provides the "normal" set as running and the
new set as check pointed.  GDB then has to check the MSR to work out
what it wants to modify.

> > - a new ptrace register set should allow access (read-only) to the
> >   *running* register values
> 
> This is because changing them won't ever result in a side effect?  

For the same reason as above, we need to be able to modify the running
values when it's a user suspended transaction.  So I don't agree with
this any more in the case of user suspended transaction.  We need to be
able to modify both sets of registers.

Mikey
