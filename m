Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbaGPLTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:19:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14996 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbaGPLTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:19:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-53-53c65fae5707
Content-transfer-encoding: 8BIT
Message-id: <1405509550.7368.0.camel@AMDC1943>
Subject: Re: [RESEND PATCH v2] ARM: exynos4: hotplug: Fix CPU idle clock down
 after CPU off
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 16 Jul 2014 13:19:10 +0200
In-reply-to: <53C65890.8000500@samsung.com>
References: <1405499003-9975-1-git-send-email-k.kozlowski@samsung.com>
 <53C65890.8000500@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xq7rr4o8FG7yfIWOxccZ6VoveBVfZ
	LM42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F2iN32S3Wz3jN4sDp0dLcw+axeUm9R9+WVYwe
	nzfJBbBEcdmkpOZklqUW6dslcGUs6P/FVPCNu2Jixyu2Bsa1nF2MnBwSAiYSGz6eYYKwxSQu
	3FvP1sXIxSEksJRRYvOFiewgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJ
	ec1foer1JHb+Ws4MYgsLxErs6JnPCGKzCRhLbF6+hA3EFhFQkbh8ajojSDOzwCkmiT9fV4I1
	sAioSqxed5MRZBmngLbE3uUWIKaQQLpE17oCiDuVJebtP8Y0gVFgFpLrZiFcNwvJdQsYmVcx
	iqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihIT51x2MS49ZHWIU4GBU4uFlmH00WIg1say4MvcQ
	owQHs5IIr4P/sWAh3pTEyqrUovz4otKc1OJDjEwcnFINjIb7VDI3f/1gV8b2cZ1z8aF7Hy4n
	bJ/g/ymlRMviSLzHphsZl2sm8Lhc3HNDfGOm+/8zSuqijEdvFExInr2Wo9D8AbOtu2lSD8/O
	Z3P+63gulVXfzKC3yvh3zqpJq/KfKy391d9zII0z5vJUBga/XJEJOrkPnifkljhu/82yct2m
	j90rtvPtqldiKc5INNRiLipOBAClhrlaUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On śro, 2014-07-16 at 12:48 +0200, Tomasz Figa wrote:
> Hi Krzysztof,
> 
> Please see my comment below.
> 
> On 16.07.2014 10:23, Krzysztof Kozlowski wrote:
> > On Exynos4 USE_DELAYED_RESET_ASSERTION must be set in
> > ARM_COREx_OPTION register during CPU power down. This is the proper way
> > of powering down CPU on Exynos4.
> > 
> > Additionally on Exynos4212 without this the CPU clock down feature won't
> > work after powering down some CPU and the online CPUs will work at full
> > frequency chosen by CPUfreq governor.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> [snip]
> 
> > @@ -36,6 +36,14 @@ static inline void cpu_leave_lowpower(void)
> >  	  : "=&r" (v)
> >  	  : "Ir" (CR_C), "Ir" (0x40)
> >  	  : "cc");
> > +
> > +	if (soc_is_exynos4()) {
> > +		unsigned int tmp;
> > +
> > +		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
> > +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
> > +		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
> > +	}
> 
> This code is executed only if the CPU doesn't manage to power off before
> already receiving a wake-up event. Otherwise the context is lost after
> wfi(), as the core power is being cut down.
> 
> The normal wake-up path goes through platsmp's exynos_boot_secondary()
> and I believe that setting of S5P_USE_DELAYED_RESET_ASSERTION should be
> taken care there as well.

You're right. Thanks for pointing this, I'll fix it.

Best regards,
Krzysztof
> 
> Best regards,
> Tomasz

