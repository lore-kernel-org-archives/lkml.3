Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbaGOJpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:45:32 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56814 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbaGOJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:45:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 19/29] nios2: Time keeping
Date: Tue, 15 Jul 2014 11:45:17 +0200
Message-ID: <5348663.eHVXUR5shS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405413956-2772-20-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-20-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VcnHCoAP9azxvk8S3H/Dk4YvRu/P/Url1EVzKPSLKN7
 h/U7nFzoMXQib+dsIdtQ9HhL23wdtTVFPGNPviLXVDY3tN685X
 2ANT2XpGquVb9y5cwHfFkGpJdDwsoBgtHEY/i6ylAW8FaCvAeQ
 poriAX7U/NYSokZ1ic4V1ZNi04l2giW7scnc9p/MvvdiWQ2fJC
 yMfIZklYxFwAORmsBReO9SRx62aQl1AkRxcXJ7DoDcZW+KX4T8
 P+fWGb9rHeGyhUVeW/K05YmxSotsTI7QE59uwWBYIqi3NR8EYp
 Bv8jS6IFkBSBq0s8/3BDv45WP1kniLjJaUBVNxcGBK/LwY+fN5
 CD/PRud5N91qJaoAEzdM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 16:45:46 Ley Foon Tan wrote:
> +
> +static inline void __delay(unsigned long loops)
> +{
> +	int dummy;
> +
> +	__asm__ __volatile__(
> +	"1:\n\t"
> +	"    beq    %0,zero,2f\n\t"
> +	"    addi   %0, %0, -1\n\t"
> +	"    br     1b\n\t"
> +	"2:\n\t"
> +	:  "=r" (dummy)		/* Need output for optimizer */
> +	:  "0" (loops));	/* %0  Input */
> +}

Do you have a reliable clock source? If you do, it would be better
to replace the delay loop with an implementation that waits for
the exact time to pass instead. This will also avoid the loop
calibration during boot and give you better boot times.

> +#ifndef _ASM_NIOS2_TIMEX_H
> +#define _ASM_NIOS2_TIMEX_H
> +
> +/* Supply dummy tick-rate. Real value will be read from devicetree */
> +#define CLOCK_TICK_RATE		(HZ * 100000UL)
> +
> +#include <asm-generic/timex.h>
> +
> +#endif

CLOCK_TICK_RATE is no longer used anywhere, no need for this file.

> diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
> new file mode 100644
> index 0000000..111ade1
> --- /dev/null
> +++ b/arch/nios2/kernel/time.c

Maybe move this to drivers/clocksource? Same argument as for the
irqchip driver, so either move both or neither.

	Arnd
