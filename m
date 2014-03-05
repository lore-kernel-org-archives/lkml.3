Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbaCEVJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:09:16 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47881 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaCEVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:09:15 -0500
Date: Wed, 5 Mar 2014 13:09:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Liu Ping Fan <kernelfans@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Lv Zheng <lv.zheng@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Li Fei <fei.li@intel.com>, gong.chen@linux.intel.com
Subject: Re: [PATCH] x86, fix x86 fixup_irqs() error handling
In-Reply-To: <1394049854-28266-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1403051307590.22928@chino.kir.corp.google.com>
References: <1394049854-28266-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Prarit Bhargava wrote:

> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index d99f31d..55fab61 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -351,6 +351,7 @@ void fixup_irqs(void)
>  	struct irq_desc *desc;
>  	struct irq_data *data;
>  	struct irq_chip *chip;
> +	int ret;
>  
>  	for_each_irq_desc(irq, desc) {
>  		int break_affinity = 0;
> @@ -389,8 +390,12 @@ void fixup_irqs(void)
>  		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
>  			chip->irq_mask(data);
>  
> -		if (chip->irq_set_affinity)
> -			chip->irq_set_affinity(data, affinity, true);
> +		if (chip->irq_set_affinity) {
> +			ret = chip->irq_set_affinity(data, affinity, true);
> +			WARN(ret == -ENOSPC,
> +			     "IRQ %d set affinity failed with %d.  The device assigned to this IRQ is unstable.\n",
> +			     irq, ret);

Should this be WARN_ON_ONCE() to avoid filling the kernel log instead?

It doesn't make much sense to print out the negative return value, maybe 
you meant to print -ret instead?

> +		}
>  		else if (!(warned++))
>  			set_affinity = 0;
>  
