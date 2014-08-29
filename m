Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaH2N4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:56:17 -0400
Received: from gw1.transmode.se ([195.58.98.146]:55084 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbaH2N4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:56:16 -0400
In-Reply-To: <20140829091437.B3FE71ABD63@localhost.localdomain>
References: <20140829091437.B3FE71ABD63@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH v2 03/19] powerpc/8xx: exception InstructionAccess does not
 exist on MPC8xx
X-KeepSent: BEBB868D:99139E7F-C1257D43:004BF814;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OFBEBB868D.99139E7F-ONC1257D43.004BF814-C1257D43.004C8EB9@transmode.se>
Date: Fri, 29 Aug 2014 15:56:12 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 29/08/2014 15:56:12,
	Serialize complete at 29/08/2014 15:56:12
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/08/29 11:14:37:
> 
> Exception InstructionAccess does not exist on MPC8xx. No need to branch 
there from somewhere else. 
> Handling can be done directly in InstructionTLBError Exception.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
>  arch/powerpc/kernel/head_8xx.S |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/head_8xx.S 
b/arch/powerpc/kernel/head_8xx.S
> index 3af6db1..fbe5d10 100644
> --- a/arch/powerpc/kernel/head_8xx.S
> +++ b/arch/powerpc/kernel/head_8xx.S
> @@ -234,15 +234,9 @@ DataAccess:
>     EXC_XFER_LITE(0x300, handle_page_fault)
> 
>  /* Instruction access exception.
> - * This is "never generated" by the MPC8xx.  We jump to it for other
> - * translation errors.
> + * This is "never generated" by the MPC8xx.
>   */
> -   . = 0x400
> -InstructionAccess:
> -   EXCEPTION_PROLOG
> -   mr   r4,r12
> -   mr   r5,r9
> -   EXC_XFER_LITE(0x400, handle_page_fault)
> +   EXCEPTION(0x400, InstructionAccess, unknown_exception, EXC_XFER_STD)
> 
>  /* External interrupt */
>     EXCEPTION(0x500, HardwareInterrupt, do_IRQ, EXC_XFER_LITE)
> @@ -382,7 +376,7 @@ InstructionTLBMiss:
>  #endif
>     mfspr   r10, SPRN_SPRG_SCRATCH2
>     EXCEPTION_EPILOG_0
> -   b   InstructionAccess
> +   b   InstructionTLBError
> 
>     . = 0x1200
>  DataStoreTLBMiss:
> @@ -477,7 +471,10 @@ DataStoreTLBMiss:
>   */
>     . = 0x1300
>  InstructionTLBError:
> -   b   InstructionAccess
> +   EXCEPTION_PROLOG
> +   mr   r4,r12
> +   mr   r5,r9
> +   EXC_XFER_LITE(0x1300, handle_page_fault)

This changes trap nr from 0x400 to 0x1300 for InstuctionAccess which I 
think bad as
Linux uses the trap nr in arch/powerpc/mm/fault.c

Same comment for patch 7

 Jocke



