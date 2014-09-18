Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaIRSMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:12:46 -0400
Received: from gw1.transmode.se ([195.58.98.146]:60682 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaIRSMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:12:45 -0400
In-Reply-To: <541B0B66.8030405@c-s.fr>
References: <20140917163657.7737D1AB032@localhost.localdomain> <OF3CC96BF2.DF7CB060-ONC1257D57.00533ED7-C1257D57.0053CADF@transmode.se> <541B0B66.8030405@c-s.fr>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH v3 03/21] powerpc/8xx: exception InstructionAccess does not
 exist on MPC8xx
X-KeepSent: B7DFC74D:65FC1C31-C1257D57:00632BC3;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OFB7DFC74D.65FC1C31-ONC1257D57.00632BC3-C1257D57.00640A0B@transmode.se>
Date: Thu, 18 Sep 2014 20:12:41 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 18/09/2014 20:12:41,
	Serialize complete at 18/09/2014 20:12:41
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

leroy christophe <christophe.leroy@c-s.fr> wrote on 2014/09/18 18:42:14:

> 
> Le 18/09/2014 17:15, Joakim Tjernlund a écrit :
> > Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/09/17 
18:36:57:
> >> Exception InstructionAccess does not exist on MPC8xx. No need to 
branch
> > there from somewhere else.
> >> Handling can be done directly in InstructionTLBError Exception.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> ---
> >> Changes in v2:
> >> - None
> >>
> >> Changes in v3:
> >> - arch/powerpc/mm/fault.c uses the vector number, so make sure it
> > understand
> >> the new ones.
> >>
> >>   arch/powerpc/kernel/head_8xx.S | 17 +++++++----------
> >>   arch/powerpc/mm/fault.c        |  1 +
> >>   2 files changed, 8 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/arch/powerpc/kernel/head_8xx.S
> > b/arch/powerpc/kernel/head_8xx.S
> >> index 3af6db1..fbe5d10 100644
> >> --- a/arch/powerpc/kernel/head_8xx.S
> >> +++ b/arch/powerpc/kernel/head_8xx.S
> >> @@ -234,15 +234,9 @@ DataAccess:
> >>      EXC_XFER_LITE(0x300, handle_page_fault)
> >>
> >>   /* Instruction access exception.
> >> - * This is "never generated" by the MPC8xx.  We jump to it for other
> >> - * translation errors.
> >> + * This is "never generated" by the MPC8xx.
> >>    */
> >> -   . = 0x400
> >> -InstructionAccess:
> >> -   EXCEPTION_PROLOG
> >> -   mr   r4,r12
> >> -   mr   r5,r9
> >> -   EXC_XFER_LITE(0x400, handle_page_fault)
> >> +   EXCEPTION(0x400, InstructionAccess, unknown_exception, 
EXC_XFER_STD)
> >>
> >>   /* External interrupt */
> >>      EXCEPTION(0x500, HardwareInterrupt, do_IRQ, EXC_XFER_LITE)
> >> @@ -382,7 +376,7 @@ InstructionTLBMiss:
> >>   #endif
> >>      mfspr   r10, SPRN_SPRG_SCRATCH2
> >>      EXCEPTION_EPILOG_0
> >> -   b   InstructionAccess
> >> +   b   InstructionTLBError
> >>
> >>      . = 0x1200
> >>   DataStoreTLBMiss:
> >> @@ -477,7 +471,10 @@ DataStoreTLBMiss:
> >>    */
> >>      . = 0x1300
> >>   InstructionTLBError:
> >> -   b   InstructionAccess
> >> +   EXCEPTION_PROLOG
> >> +   mr   r4,r12
> >> +   mr   r5,r9
> >> +   EXC_XFER_LITE(0x1300, handle_page_fault)
> > Still don't like that you change the vector number, every other ppc 
uses
> > the
> > standard number.
> >
> > Can you not just lie here(EXC_XFER_LITE(0x400, handle_page_fault))?
> > Move the code to InstructionAccess too and let TLBError branch there.
> My issue was that if I do EXC_XFER_LITE(0x400, handle_page_fault), I 
> can't leave the
>      EXCEPTION(0x400, InstructionAccess, unknown_exception, 
> EXC_XFER_STD) at address .400
> Otherwise, I get twice the same label.
> 
> What about the following patch then ? Would this be acceptable ?
> 
> @@ -234,15 +234,13 @@ DataAccess:
>       EXC_XFER_LITE(0x300, handle_page_fault)
> 
>   /* Instruction access exception.
> - * This is "never generated" by the MPC8xx.  We jump to it for other
> - * translation errors.
> + * This is "never generated" by the MPC8xx.
>    */
>       . = 0x400
>   InstructionAccess:
>       EXCEPTION_PROLOG
> -    mr    r4,r12
> -    mr    r5,r9
> -    EXC_XFER_LITE(0x400, handle_page_fault)
> +    addi    r3,r1,STACK_FRAME_OVERHEAD
> +    EXC_XFER_STD(0x401, unknown_exception)

Since this is never generated I think it is OK. Nedds some more commenst
though, why the 401 etc.


> 
>   /* External interrupt */
>       EXCEPTION(0x500, HardwareInterrupt, do_IRQ, EXC_XFER_LITE)
> @@ -382,7 +380,7 @@ InstructionTLBMiss:
>   #endif
>       mfspr    r10, SPRN_SPRG_SCRATCH2
>       EXCEPTION_EPILOG_0
> -    b    InstructionAccess
> +    b    InstructionTLBError
> 
>       . = 0x1200
>   DataStoreTLBMiss:
> @@ -477,7 +475,11 @@ DataStoreTLBMiss:
>    */
>       . = 0x1300
>   InstructionTLBError:
> -    b    InstructionAccess
> +    EXCEPTION_PROLOG
> +    mr    r4,r12
> +    mr    r5,r9
> +    /* 0x400 is InstructionAccess exception, needed by bad_page_fault() 
*/
> +    EXC_XFER_LITE(0x400, handle_page_fault)

You should have the code in TLBMiss and have the TLBError branch there as
that is the common case. 

> 
>   /* This is the data TLB error on the MPC8xx.  This could be due to
>    * many reasons, including a dirty update to a pte.  We can catch that
> 
> 
> >
> > If not I think you should keep the old/current way?
> >
> > Same for DataTLB Miss/Error
> >
> >>   /* This is the data TLB error on the MPC8xx.  This could be due to
> >>    * many reasons, including a dirty update to a pte.  We can catch 
that
> >> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> >> index 51ab9e7..4d63c96 100644
> >> --- a/arch/powerpc/mm/fault.c
> >> +++ b/arch/powerpc/mm/fault.c
> >> @@ -526,6 +526,7 @@ void bad_page_fault(struct pt_regs *regs, 
unsigned
> > long address, int sig)
> >>         break;
> >>      case 0x400:
> >>      case 0x480:
> >> +   case 0x1300:
> >>         printk(KERN_ALERT "Unable to handle kernel paging request for 
"
> >>            "instruction fetch\n");
> >>         break;
> >> -- 
> >> 2.1.0
> >>
> 

