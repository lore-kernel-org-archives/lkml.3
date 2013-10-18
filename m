Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3JRXdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:33:25 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:18679
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757564Ab3JRXdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:33:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zcb8kz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382139147.7979.934.camel@snotra.buserror.net>
Subject: Re: [v5][PATCH 6/6] book3e/kgdb: Fix a single stgep case of lazy IRQ
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 18:32:27 -0500
In-Reply-To: <1371724110-8250-7-git-send-email-tiejun.chen@windriver.com>
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
	 <1371724110-8250-7-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
> When we're in kgdb_singlestep(), we have to work around to get
> thread_info by copying from the kernel stack before calling
> kgdb_handle_exception(), then copying it back afterwards.
> 
> But for PPC64, we have a lazy interrupt implementation. So after
> copying thread info frome kernle stack, if we need to replay an
> interrupt, we shouldn't restore that previous backup thread info
> to make sure we can replay an interrupt lately with a proper
> thread info.

Explain why copying it would be a problem.

> This patch use __check_irq_replay() to guarantee this process.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/irq.c  |   10 ++++++++++
>  arch/powerpc/kernel/kgdb.c |    3 ++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index ea185e0..3625453 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -339,7 +339,17 @@ bool prep_irq_for_idle(void)
>  	return true;
>  }
>  
> +notrace unsigned int check_irq_replay(void)
> +{
> +	return __check_irq_replay();
> +}
> +#else
> +notrace unsigned int check_irq_replay(void)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_PPC64 */
> +EXPORT_SYMBOL(check_irq_replay);
>  
>  int arch_show_interrupts(struct seq_file *p, int prec)
>  {
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index cde7818..5b30408 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -152,6 +152,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>  }
>  
>  static DEFINE_PER_CPU(struct thread_info, kgdb_thread_info);
> +extern notrace unsigned int check_irq_replay(void);

Please put prototypes in headers rather than C files.  Also, "extern" is
unnecessary on function prototypes.

>  static int kgdb_singlestep(struct pt_regs *regs)
>  {
>  	struct thread_info *thread_info, *exception_thread_info;
> @@ -181,7 +182,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>  
>  	kgdb_handle_exception(0, SIGTRAP, 0, regs);
>  
> -	if (thread_info != exception_thread_info)
> +	if ((thread_info != exception_thread_info) && (!check_irq_replay()))

Unnecessary parentheses.

Are you sure it's safe to call this here?  Won't __check_irq_replay()
clear the pending event and PACA_IRQ_HARD_DIS?

-Scott



