Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbaJ3JVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:21:20 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49552 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaJ3JVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:21:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V2 05/15] genirq: Generic chip: Add big endian I/O accessors
Date: Thu, 30 Oct 2014 10:21:12 +0100
Message-ID: <14243833.KJsSScVrGS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414635488-14137-6-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-6-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iGl9KGp6Vdq4t+Tvsv5XbZgFUCigZzvXZzLkhNS9a+6
 twWHe/TX7CkeSA2inSjrA37RzubSKmX/aay2D1JIYznmwmhJoi
 e1lzsa+YJ50OOY5dd85zp2QKU08Jl7yZok7PxUHAt2T2s6ZnGM
 8mnLpRud/3UISa0IqVBOj/RLyXLSAbBPZ2XmFhujKWEGph7Dvb
 ZgInjrRI8z3EOtKlDwz7C67eF30WfxEVS7FA/APOWBHIWVZ0vk
 99CnTb+vCVEiW3Y2cymPMosYYisuRxViUFMULHpygaKlEzWiYt
 zI/uqYrg+vAnSN/OPwCiLDdyd3NA1hjws0kcdkfi//71aOoXEv
 WNDIMiN5CzyCVFrLwi4A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 19:17:58 Kevin Cernekee wrote:
>  static LIST_HEAD(gc_list);
>  static DEFINE_RAW_SPINLOCK(gc_lock);
>  
> +static int is_big_endian(struct irq_chip_generic *gc)
> +{
> +       return !!(gc->domain->gc->gc_flags & IRQ_GC_BE_IO);
> +}
> +
>  static void irq_reg_writel(struct irq_chip_generic *gc,
>                            u32 val, int reg_offset)
>  {
> -       writel(val, gc->reg_base + reg_offset);
> +       if (is_big_endian(gc))
> +               iowrite32be(val, gc->reg_base + reg_offset);
> +       else
> +               writel(val, gc->reg_base + reg_offset);
>  }
>  

What I had in mind was to use indirect function calls instead, like

#ifndef irq_reg_writel
static inline void irq_reg_writel_le(u32 val, void __iomem *addr)
{
	return writel(val, addr);
}
#endif

#ifndef irq_reg_writel_be
static inline void irq_reg_writel_be(u32 val, void __iomem *addr)
{
	return iowrite32_be(val, addr);
}
#endif


static inline void irq_reg_writel(struct irq_chip_generic *gc, u32 val, int reg_offset)
{
       if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) &&
           !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
		return irq_reg_writel_le(val, gc->reg_base + reg_offset);

       if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) &&
           !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
		return irq_reg_writel_be(val, gc->reg_base + reg_offset);

	return gc->writel(val, gc->reg_base + reg_offset);
}

This would take the condition out of the callers.

	Arnd
