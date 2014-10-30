Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbaJ3ERF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:17:05 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63869 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaJ3ERD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:17:03 -0400
Date: Wed, 29 Oct 2014 21:16:58 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH V2 06/15] genirq: Generic chip: Optimize for fixed-endian
 systems
Message-ID: <20141030041658.GB29070@brian-ubuntu>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
 <1414635488-14137-7-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414635488-14137-7-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 07:17:59PM -0700, Kevin Cernekee wrote:
> @@ -19,7 +20,14 @@ static DEFINE_RAW_SPINLOCK(gc_lock);
>  
>  static int is_big_endian(struct irq_chip_generic *gc)
>  {
> -	return !!(gc->domain->gc->gc_flags & IRQ_GC_BE_IO);
> +	if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) &&
> +	    !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
> +		return 0;
> +	else if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE) &&
> +		 !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP))
> +		return 1;

Would XOR make this any easier to read? e.g.:

	if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) ^
	    IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
		return IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE);
	else
		...

> +	else
> +		return !!(gc->domain->gc->gc_flags & IRQ_GC_BE_IO);
>  }
>  
>  static void irq_reg_writel(struct irq_chip_generic *gc,

Brian
