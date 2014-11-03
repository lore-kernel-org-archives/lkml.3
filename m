Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKCL5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:57:10 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:58348 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaKCL5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:57:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-sh@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V3 00/14] genirq endian fixes; bcm7120/brcmstb IRQ updates
Date: Mon, 03 Nov 2014 12:56:52 +0100
Message-ID: <2217077.1aQXS9nJph@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
References: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Ya7OO2ASSLYRNEh+Et/+QbLcLu1KV/+ph8Mj/t9jHsw1vCsK/Dh
 aGxTNLJlIhNsxOmBICV4teWkvuOHeZ6giAooI4J49IEDXM/KH4y+xuViieCc0WhgP0Bzkan
 OTkeovMuq4sNH7KeYJ/JqbCEuhRaqi0Dig+1B4g6Dv6Fhu1FJY97syjr3yRqXnM4E6SaZ+S
 7jocWIFhYBhh4PqiMAmkw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 November 2014 18:03:47 Kevin Cernekee wrote:
> V2->V3:
> 
>  - Move updated irq_reg_{readl,writel} functions back into <linux/irq.h>
>    so they can be called by irqchip drivers
> 
>  - Add gc->reg_{readl,writel} function pointers so that irqchip
>    drivers like arch/sh/boards/mach-se/{7343,7722}/irq.c can override them
> 
>  - CC: linux-sh list in lieu of Paul's defunct linux-sh.org email address
> 
>  - Fix handling of zero L2 status in bcm7120-l2.c
> 
>  - Rebase on Linus' head of tree

Looks all great. I also looked at the series now and am very happy
about how it turned out.

>  - Drop GENERIC_CHIP / GENERIC_CHIP_BE compile-time optimizations
> 
> For the latter item, I ran a quick benchmark to see if the extra
> indirection in irq_reg_{readl,write} had any perceptible effect on
> register access times.  The MIPS BE case did show a small performance
> hit from using the read wrapper, but on ARM LE the only differences
> were attributed to the presence/absence of a barrier:
>
>
> BCM3384 (UBUS architecture, MIPS BE, IRQ_GC_BE_IO):
> 
> irq_reg_readl       : 207 ns
> readl               : 186 ns
> __raw_readl         : 186 ns
> ioread32be          : 195 ns
> 
> irq_reg_writel      : 177 ns
> writel              : 177 ns
> __raw_writel        : 177 ns
> iowrite32be         : 177 ns
> 
> 
> BCM7445 (GISB architecture, ARM LE, standard LE readl):
> 
> irq_reg_readl       : 519 ns
> readl               : 519 ns
> __raw_readl         : 482 ns
> ioread32be          : 519 ns
> 
> irq_reg_writel      : 500 ns
> writel              : 500 ns
> __raw_writel        : 482 ns
> iowrite32be         : 500 ns
> 

Yes, good idea to check this. 43ns is probably not significant to
warrant optimizing this, but if we wanted to, a driver could now
override the accessors using readl_relaxed()/writel_relaxed().

Note that the cost of the barriers can depend a lot on the hardware
setup and on the state of the system. I believe synchronizing the
L2 cache on some Cortex-A9 machines can be particularly expensive.

Anyway, the existing code doesn't do it, so we can leave that as
a possible optimization.

	Arnd
