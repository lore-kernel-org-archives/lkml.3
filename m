Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbbAUXkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:40:07 -0500
Received: from ozlabs.org ([103.22.144.67]:53880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbbAUXj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:39:59 -0500
Message-ID: <1421883597.30744.3.camel@neuling.org>
Subject: Re: [V6,1/9] elf: Add new powerpc specifc core note sections
From: Michael Neuling <mikey@neuling.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, peterz@infradead.org, palves@redhat.com,
        Ulrich Weigand <uweigand@de.ibm.com>, shuahkh@osg.samsung.com,
        akpm@linux-foundation.org, oleg@redhat.com, dhowells@redhat.com,
        kirjanov@gmail.com, davej@redhat.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com, davem@davemloft.net,
        sam.bobroff@au1.ibm.com
Date: Thu, 22 Jan 2015 10:39:57 +1100
In-Reply-To: <54A50094.5070902@linux.vnet.ibm.com>
References: <20141203052204.9DA8F1400DD@ozlabs.org>
	 <547EB253.5050307@linux.vnet.ibm.com> <548578A8.5020901@linux.vnet.ibm.com>
	 <54947C64.4030206@linux.vnet.ibm.com> <54A50094.5070902@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-01 at 13:38 +0530, Anshuman Khandual wrote:
> On 12/20/2014 12:58 AM, Edjunior Barbosa Machado wrote:
> > On 12/08/2014 08:08 AM, Anshuman Khandual wrote:
> >> On 12/03/2014 12:18 PM, Anshuman Khandual wrote:
> >>> On 12/03/2014 10:52 AM, Michael Ellerman wrote:
> >>>> On Tue, 2014-02-12 at 07:56:45 UTC, Anshuman Khandual wrote:
> >>>>> This patch adds four new ELF core note sections for powerpc
> >>>>> transactional memory and one new ELF core note section for
> >>>>> powerpc general miscellaneous debug registers. These addition
> >>>>> of new ELF core note sections extends the existing ELF ABI
> >>>>> without affecting it in any manner.
> >>>>>
> >>>>> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> >>>>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> >>>>> ---
> >>>>>  include/uapi/linux/elf.h | 5 +++++
> >>>>>  1 file changed, 5 insertions(+)
> >>>>>
> >>>>> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> >>>>> index ea9bf25..2260fc0 100644
> >>>>> --- a/include/uapi/linux/elf.h
> >>>>> +++ b/include/uapi/linux/elf.h
> >>>>> @@ -379,6 +379,11 @@ typedef struct elf64_shdr {
> >>>>>  #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
> >>>>>  #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
> >>>>>  #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
> >>>>> +#define NT_PPC_TM_SPR	0x103		/* PowerPC TM special registers */
> >>>>> +#define NT_PPC_TM_CGPR	0x104		/* PowerpC TM checkpointed GPR */
> >>>>> +#define NT_PPC_TM_CFPR	0x105		/* PowerPC TM checkpointed FPR */
> >>>>> +#define NT_PPC_TM_CVMX	0x106		/* PowerPC TM checkpointed VMX */
> >>>>> +#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */
> >>>>
> >>>> This is a really terrible name, "MISC".
> >>>>
> >>>> Having said that, I guess it's accurate. We have a whole bunch of regs that
> >>>> have accrued over recent years that aren't accessible via ptrace.
> >>>>
> >>>> It seems to me if we're adding a misc regset we should be adding everything we
> >>>> might want to it that is currenty architected.
> >>>
> >>> But I believe they also need to be part of the thread_struct structure to be
> >>> accessible from ptrace.
> >>
> >> Currently we dont context save/restore the PMC count registers (PMC1-PMC6)
> >> during the process context switch. So the values of PMC1..PMC6 are not
> >> thread specific in the structure. To be able to access them in ptrace
> >> when the tracee has stopped, we need to context save these counters
> >> in the thread struct. Shall we do that ? Then we can add them to the
> >> MISC regset bucket irrespective of whats the value we get in there when
> >> we probe through ptrace.
> >>
> >> The same goes for MMCRA, CFAR registers as well.
> >>
> >>>  
> >>>>
> >>>> But currently you only include the PPR, TAR & DSCR.
> >>>
> >>> Yeah, thats what we started with.
> >>>
> >>>>
> >>>> Looking at Power ISA v2.07, I see the following that could be included:
> >>>>
> >>>>   MMCR2
> >>>>   MMCRA
> >>>>   PMC1
> >>>>   PMC2
> >>>>   PMC3
> >>>>   PMC4
> >>>>   PMC5
> >>>>   PMC6
> >>>>   MMCR0
> >>>>   EBBHR
> >>>>   EBBRR
> >>>>   BESCR
> >>>>   SIAR
> >>>>   SDAR
> >>>>   CFAR?
> >>>
> >>> MMCRA, PMC[1..6], EBBHR, BESCR, EBBRR, CFAR are not part of the thread struct.
> >>
> >> Sorry. EBBRR, EBBHR, BESCR registers are part of the thread struct.
> >>
> >>>
> >>>>
> >>>> Those are all new in 2.07 except for CFAR.
> >>>>
> >>>> There might be more I missed, that was just a quick scan.
> >>>>
> >>>> Some are only accessible when EBB is in use, maybe those could be a separate
> >>>> regset.
> >>>
> >>> Yeah we can have one more regset for EBB specific registers.
> >>
> >> Should the new EBB specific regset include only EBBRR, EBBHR, BESCR registers
> >> or should it also include SIAR, SDAR, SIER, MMCR0, MMCR2 registers as well. I
> >> was thinking about putting these five registers into the MISC bucket instead.
> >> But from the perf code, it looks like these five registers are also related to
> >> the EBB context as well.
> >>
> >> Some clarity on these points would really help.
> > 
> > Hi,
> > 
> > from the provided testcase using ptrace interface, reviewing with the help
> > of Ulrich, it looks OK from GDB perspective, with the exception of a few
> > concerns:
> > 
> > The patchset seems to change the "original" ptrace requests (i.e.
> > PTRACE_GETREGS/GETFPREGS/GETVRREGS...) to return the "transactional" state, and
> > adds new register sets to return the "checkpointed" state. Considering that
> > whenever you get a debugger interception inside a transactional block, the
> > transaction will abort, we're wondering if it wouldn't make more sense to 
> > display the 'checkpointed' state as the normal registers since this is where the
> > execution will continue from.
> 
> Debugger interception (trace interrupt) in between any transaction block will abort
> it ? I doubt that.

The trace interrupt will not abort the transaction explicitly...

> The tracee process will just stop, it's context gets saved in the
> kernel so that it can again start executing from the exact same point onward when it
> resumes. 

... unfortunately, this save *will* doom the transaction.  To save, a
treclaim instruction is run which will always explicitly doom the
transaction.

> If this happens when inside any transaction block, the transaction's running
> context and check pointed context will get saved. The execution will again start from
> the running context values instead of check pointed when the process resumes. Check
> pointed values will be loaded back into the context when the transaction finishes.

Although since the transaction has been explicitly doomed, the hardware
will *always* abort at this point and start execution from the
checkpointed values.

> Inside transaction both running and check pointed values can be probed independently.

Yep, that's the idea, although setting the running values won't change
anything since the the translation is already doomed and will abort once
the cpu starts executing it.  

Mikey

> > 
> > Also, we've noticed that the 'misc' regset contains registers from different ISA
> > versions (dscr and ppr appear in ISA 2.05, tar is from 2.07). I'm not sure if
> > there is a way to detect presence/validity of such registers, but perhaps it
> > might be a good idea to separate registers from different ISAs in different
> > regsets.
> 
> Thats right, will use feature CPU_FTR_ARCH_207S (which checks whether we are v2.07
> compliant) to detect whether TAR register is available or not. 
> 
> > 
> > Regarding the inclusion of other registers along with the EBB-related ones, I'm
> > sorry but I'm not familiar with them.
> 
> Michael Ellerman mentioned that we can look into them separately sometime later
> not in this patch series.
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

