Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3LRCpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:45:23 -0500
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:24052
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188Ab3LRCpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:45:21 -0500
Message-ID: <1387334713.3140.8.camel@snotra.buserror.net>
Subject: Re: [v6][PATCH 5/5] powerpc/book3e/kgdb: Fix a single stgep case of
 lazy IRQ
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 20:45:13 -0600
In-Reply-To: <1382520685-11609-6-git-send-email-tiejun.chen@windriver.com>
References: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
	 <1382520685-11609-6-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR09CA005.namprd09.prod.outlook.com (10.255.226.45) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(377424004)(24454002)(51704005)(199002)(189002)(81342001)(47446002)(31966008)(81542001)(80022001)(74662001)(74502001)(74876001)(62966002)(33646001)(74706001)(50226001)(50466002)(77156001)(76796001)(79102001)(49866001)(65816001)(47736001)(4396001)(47976001)(81686001)(83322001)(19580405001)(63696002)(47776003)(81816001)(50986001)(23676002)(19580395003)(56816005)(80976001)(85306002)(89996001)(51856001)(76482001)(90146001)(53806001)(42186004)(54316002)(77982001)(87286001)(77096001)(87266001)(76786001)(83072002)(74366001)(56776001)(59766001)(46102001)(87976001)(69226001)(85852003)(88136002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 17:31 +0800, Tiejun Chen wrote:
> In lazy EE magic, we may have a lazy interrupt occured while
> entering kgdb, but we really don't want to replay that interrupt
> for kgdb, so we have to clear the PACA_IRQ_HARD_DIS force to
> make sure we can exit directly from this debug exception.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>

s/stgep/step/ in subject

> ---
>  arch/powerpc/kernel/kgdb.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 447c14b..9872f58 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -185,6 +185,14 @@ static int kgdb_singlestep(struct pt_regs *regs)
>  		/* Restore current_thread_info lastly. */
>  		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
>  
> +#ifdef CONFIG_PPC64
> +	/*
> +	 * Clear the PACA_IRQ_HARD_DIS from the pending mask
> +	 * since we are about to exit this directly from debug
> +	 * exception without any replay interrupt in lazy EE case.
> +	 */
> +	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
> +#endif
>  	return 1;
>  }
>  

What happens to those interrupts you discarded once we get back to a
state when they can be safely replayed?  I don't think just dropping
them is the answer.

I'm not sure what the actual problem is.  I can understand not wanting
kgdb to cause interrupts to appear to run when the interrupted context
has external interrupts disabled, but the replay code in entry_64.S
doesn't run if interrupts are soft-disabled in the context to be
returned to.  What harm does it cause to run the interrupts if we're
returning to an EE=1 context?

Does KGDB enable interrupts in its handler?  If not, how do we even get
into the situation where there are interrupts pending when the
interrupted context has EE soft-enabled (i.e. we went directly from a
context where the interrupt handler should have run, to a hard-disabled
context)?

-Scott


