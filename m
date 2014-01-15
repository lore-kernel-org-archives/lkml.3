Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaAOB1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:27:35 -0500
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:51375
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbaAOB1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:27:31 -0500
Date: Tue, 14 Jan 2014 19:27:13 -0600
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v6,2/5] powerpc/book3e: store crit/mc/dbg exception thread info
Message-ID: <20140115012121.GA11229@home.buserror.net>
References: <1382520685-11609-3-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382520685-11609-3-git-send-email-tiejun.chen@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR06CA004.namprd06.prod.outlook.com (10.242.217.142)
 To BY2PR03MB396.namprd03.prod.outlook.com (10.141.141.26)
X-Forefront-PRVS: 00922518D8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(679001)(689001)(779001)(51704005)(189002)(199002)(24454002)(83506001)(50466002)(74876001)(47736001)(47976001)(46406003)(49866001)(4396001)(59766001)(80976001)(74706001)(19580405001)(83322001)(81542001)(92566001)(56816005)(90146001)(93516001)(92726001)(81816001)(76786001)(77096001)(53416003)(33656001)(54316002)(79102001)(51856001)(23726002)(46102001)(74366001)(53806001)(87976001)(42186004)(65816001)(80022001)(85852003)(50986001)(19580395003)(77982001)(81342001)(47446002)(76796001)(85306002)(83072002)(74502001)(54356001)(56776001)(31966008)(74662001)(93136001)(81686001)(87266001)(63696002)(69226001)(47776003)(76482001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB396;H:home.buserror.net;CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 05:31:22PM +0800, Tiejun Chen wrote:
> We need to store thread info to these exception thread info like something
> we already did for PPC32.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> 
> ---
> arch/powerpc/kernel/exceptions-64e.S |   22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 68d74b4..a55cf62 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -36,6 +36,19 @@
>   */
>  #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
>  
> +/* Now we only store something to exception thread info */

Now as opposed to when?  Only as opposed to what else?

> +#define	EXC_LEVEL_EXCEPTION_PROLOG(type)				\

I'd prefer .macro over #define.

> +	ld	r14,PACAKSAVE(r13);					\
> +	CURRENT_THREAD_INFO(r14, r14);					\
> +	CURRENT_THREAD_INFO(r15, r1);					\
> +	ld	r10,TI_FLAGS(r14);		     			\
> +	std	r10,TI_FLAGS(r15);			     		\
> +	ld	r10,TI_PREEMPT(r14);		     			\
> +	std	r10,TI_PREEMPT(r15);		     			\
> +	ld	r10,TI_TASK(r14);			     		\
> +	std	r10,TI_TASK(r15);

This is a start, but we'll also need to save some more context to allow
TLB misses from within the exception (e.g. if a machine check handler or
GDB stub writes to a serial port, and the I/O registers aren't in the
TLB).  At a minimum I think we need to save SRR0, SRR1,
SPRN_SPRG_GEN_SCRATCH, SPRN_SPRG_TLB_SCRATCH, and the MAS registers. 
We'll also need to make the bolted TLB miss handlers capable of pointing
to different extables (though they won't need to auto-advance as the
original TLB miss handlers do -- we would advance SPRN_SPRG_TLB_EXFRAME
from this code), and the original TLB miss handlers will now need to
support more than 3 levels of nesting.

For the e6500 tablewalk TLB miss handler, we'll need to do something
special if we interrupt it when the lock is held, to revoke the lock and
return to code that retries.

Is there anything else I'm missing?

-Scott
