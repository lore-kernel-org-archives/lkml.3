Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbaGPNZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:25:54 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22518 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbaGPNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:25:52 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-d0-53c67d5d8022
Content-transfer-encoding: 8BIT
Message-id: <1405517150.15590.2.camel@AMDC1943>
Subject: Re: [PATCH v3] ARM: exynos4: hotplug: Fix CPU idle clock down after
 CPU off
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 16 Jul 2014 15:25:50 +0200
In-reply-to: <53C678B5.7080304@samsung.com>
References: <1405512467-27269-1-git-send-email-k.kozlowski@samsung.com>
 <53C678B5.7080304@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xq7qxtceCDe7cVbTYOGM9q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BbrZ7xmceD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiuGxSUnMyy1KL9O0SuDKaJr1mK5jMW3H92ynGBsbFXF2MnBwSAiYS/SeWsEHYYhIX
	7q0Hs4UEljJKNM72A7F5BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcxdjFxA5Z8ZJR7d
	amaDqNeXOLDyJCNIvbBAmMSdd5IgYTYBY4nNyyFWiQioSFw+NZ0RpJdZ4BSTxJ+vK5lBEiwC
	qhJ31y1mBbE5BbQl1tz9wApxT4bEs6ZlTBB3KkvM23+MaQKjwCwk581COG8WkvMWMDKvYhRN
	LU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ8687GJceszrEKMDBqMTDyzD7aLAQa2JZcWXuIUYJ
	DmYlEV4H/2PBQrwpiZVVqUX58UWlOanFhxiZODilGhiv5pidCPkksK9mfxnnJh2Dvu2e2udP
	nAzoVr7vsS4huGvfj4Upi0/2n7Y973Xt4xm9nH9HHqXX9s7aJbh5Qc41aW3BWpcQzc+blzn0
	Tkl44n76Rr5fS7Xe5FvdIfuXpOZIRkrab2ToXaMv6399SdkRq+WPzDWstnEoHdgu/o7x4hQb
	9sCyO5pKLMUZiYZazEXFiQAivg4nUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-07-16 at 15:05 +0200, Tomasz Figa wrote:
> Hi Krzysztof,
> 
> On 16.07.2014 14:07, Krzysztof Kozlowski wrote:
> 
> [snip]
> 
> > +#ifdef CONFIG_SMP
> > +extern void exynos_clear_delayed_reset_assertion(u32 core_id);
> > +#endif
> 
> Is the ifdef really needed? The only difference it makes if the function
> is used but not compiled in is that with it the compilation will fail,
> while without it the kernel won't link.

Hmmm... I'll take another approach - just merge hotplug.c into
platsmp.c.

> 
> > +
> >  extern void exynos_cpu_resume(void);
> >  
> >  extern struct smp_operations exynos_smp_ops;
> 
> [snip]
> 
> > +/*
> > + * Clear the USE_DELAYED_RESET_ASSERTION option, set on Exynos4 SoCs
> > + * during hot-unplugging CPUx.
> > + *
> > + * It won't harm if this is called during first boot of secondary CPU.
> > + *
> > + * Exynos4 SoCs require setting USE_DELAYED_RESET_ASSERTION so the CPU idle
> > + * clock down feature could properly detect global idle state when
> > + * CPUx is off.
> > + */
> > +void exynos_clear_delayed_reset_assertion(u32 core_id)
> > +{
> > +	if (soc_is_exynos4()) {
> > +		unsigned int tmp;
> > +
> > +		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
> > +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
> > +		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
> > +	}
> > +}
> 
> The idea to make this a helper function is quite nice, but maybe it
> could be extended into exynos_set_delayed_reset_assertion() and disable
> or enable delayed assertion depending on another argument?

Sure, I'll change it.

Best regards,
Krzysztof

> 
> Best regards,
> Tomasz

