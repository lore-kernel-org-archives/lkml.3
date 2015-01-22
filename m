Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbbAVPzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:55:36 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:35182 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbAVPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:55:33 -0500
In-Reply-To: <1421883597.30744.3.camel@neuling.org>
References: <20141203052204.9DA8F1400DD@ozlabs.org>	 <547EB253.5050307@linux.vnet.ibm.com> <548578A8.5020901@linux.vnet.ibm.com>
	 <54947C64.4030206@linux.vnet.ibm.com> <54A50094.5070902@linux.vnet.ibm.com> <1421883597.30744.3.camel@neuling.org>
Subject: Re: [V6,1/9] elf: Add new powerpc specifc core note sections
X-KeepSent: C6CFC348:C619B89D-C1257DD5:0056279B;
 type=4; name=$KeepSent
To: Michael Neuling <mikey@neuling.org>
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
X-Mailer: IBM Notes Release 9.0.1FP2 August  03, 2014
Message-ID: <OFC6CFC348.C619B89D-ONC1257DD5.0056279B-C1257DD5.00577002@de.ibm.com>
From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Date: Thu, 22 Jan 2015 16:55:03 +0100
X-MIMETrack: Serialize by Router on D06ML032/06/M/IBM(Release 9.0.1FP2|August  03, 2014) at
 22/01/2015 16:55:27
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012215-0021-0000-0000-000002A49DD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> wrote on 22.01.2015 00:39:57:
> On Thu, 2015-01-01 at 13:38 +0530, Anshuman Khandual wrote:
> > On 12/20/2014 12:58 AM, Edjunior Barbosa Machado wrote:
> > > The patchset seems to change the "original" ptrace requests (i.e.
> > > PTRACE_GETREGS/GETFPREGS/GETVRREGS...) to return the
> > > "transactional" state, and adds new register sets to return
> > > the "checkpointed" state.  Considering that whenever you get
> > > a debugger interception inside a transactional block, the
> > > transaction will abort, we're wondering if it wouldn't make
> > > more sense to display the 'checkpointed' state as the normal
> > > registers since this is where the execution will continue from.
> >
> > Debugger interception (trace interrupt) in between any transaction
> > block will abort it ? I doubt that.
>
> The trace interrupt will not abort the transaction explicitly...
>
> > The tracee process will just stop, it's context gets saved in the
> > kernel so that it can again start executing from the exact same
> > point onward when it resumes.
>
> ... unfortunately, this save *will* doom the transaction.  To save, a
> treclaim instruction is run which will always explicitly doom the
> transaction.
>
> > If this happens when inside any transaction block, the transaction's
running
> > context and check pointed context will get saved. The execution
> > will again start from the running context values instead of check
> > pointed when the process resumes. Check pointed values will be loaded
> > back into the context when the transaction finishes.
>
> Although since the transaction has been explicitly doomed, the hardware
> will *always* abort at this point and start execution from the
> checkpointed values.
>
> > Inside transaction both running and check pointed values can be
> > probed independently.
>
> Yep, that's the idea, although setting the running values won't change
> anything since the the translation is already doomed and will abort once
> the cpu starts executing it.

So this looks to me like the overall effect on debugging transactional
code should be the same on Power and z, even if some internal details
are different (on z, the exception will automatically abort the
transaction; on p, the exception itself will not abort, but *restarting*
user space execution will).

>From a GDB perspective, it would therefore be preferable if the ptrace
interface were to behave in a similar fashion on p as on z: that is,
if an exception interrupting a transaction results in a ptrace intercept,
at this point:

- the "normal" ptrace register set commands should access the
  *checkpointed* registers (allowing both read and write access)

  -- GDB will use this to display current position (already reflecting
  the fact that the transaction will abort), and use it when changing
  register values e.g. to effect an inferior function call

- a new ptrace register set should allow access (read-only) to the
  *running* register values

  -- GDB can use this to display the position inside the transaction
  at the point it aborted, using new transaction-specific commands


Bye,
Ulrich

