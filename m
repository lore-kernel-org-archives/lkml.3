Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3KHQsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:48:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53661 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3KHQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:48:42 -0500
Message-ID: <527D15E8.6070802@codeaurora.org>
Date: Fri, 08 Nov 2013 11:48:40 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 11/07/2013 02:20 PM, Stephen Boyd wrote:
> If we're running on a v7 ARM CPU, detect if the CPU supports the
> sdiv/udiv instructions and replace the signed and unsigned
> division library functions with an sdiv/udiv instruction.

[...]

> +++ b/arch/arm/lib/div-v7.c
> @@ -0,0 +1,58 @@
> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/static_key.h>
> +
> +extern int ___aeabi_idiv(int, int);
> +extern unsigned ___aeabi_uidiv(int, int);

Why are the input parameters signed?

> +extern struct static_key cpu_has_idiv;
> +
> +int __aeabi_idiv(int numerator, int denominator)
> +{
> +	if (static_key_false(&cpu_has_idiv)) {
> +		int ret;
> +
> +		asm volatile (
> +		".arch_extension idiv\n"
> +		"sdiv %0, %1, %2"
> +		: "=&r" (ret)
> +		: "r" (numerator), "r" (denominator));
> +
> +		return ret;
> +	}
> +
> +	return ___aeabi_idiv(numerator, denominator);
> +}
> +
> +int __divsi3(int numerator, int denominator)
> +	__attribute__((alias("__aeabi_idiv")));
> +
> +unsigned __aeabi_uidiv(int numerator, int denominator)

Unsigned inputs?

> +{
> +	if (static_key_false(&cpu_has_idiv)) {
> +		int ret;
> +
> +		asm volatile (
> +		".arch_extension idiv\n"
> +		"udiv %0, %1, %2"
> +		: "=&r" (ret)
> +		: "r" (numerator), "r" (denominator));
> +
> +		return ret;
> +	}
> +
> +	return ___aeabi_uidiv(numerator, denominator);
> +}
> +
> +unsigned __udivsi3(int numerator, int denominator)
> +	__attribute__((alias("__aeabi_uidiv")));

Unsigned inputs?

[...]

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
