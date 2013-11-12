Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3KLOXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:23:02 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:38225 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3KLOW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:22:59 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
	<alpine.LFD.2.10.1311092357090.2314@knanqh.ubzr>
	<528193A0.7050505@codeaurora.org>
	<alpine.LFD.2.10.1311120839310.9667@knanqh.ubzr>
Date: Tue, 12 Nov 2013 14:22:55 +0000
In-Reply-To: <alpine.LFD.2.10.1311120839310.9667@knanqh.ubzr> (Nicolas Pitre's
	message of "Tue, 12 Nov 2013 09:01:16 -0500 (EST)")
Message-ID: <yw1xhabhvgw0.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nicolas.pitre@linaro.org> writes:

> What about this patch which I think is currently your best option.  Note 
> it would need to use the facilities from asm/opcodes.h to make it endian 
> agnostic.
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 6a1b8a81b1..379cffe4ab 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -383,6 +383,34 @@ static void __init cpuid_init_hwcaps(void)
>  		elf_hwcap |= HWCAP_IDIVT;
>  	}
>
> +	/*
> +	 * Patch our division routines with the corresponding opcode
> +	 * if the hardware supports it.
> +	 */
> +	if (IS_ENABLED(CONFIG_THUMB2_KERNEL) && (elf_hwcap & HWCAP_IDIVT)) {
> +		extern char __aeabi_uidiv, __aeabi_idiv;

It would be safer to declare these as arrays of unspecified size.
Otherwise the compiler might do evil things with what to it looks like
out of bounds indexing.

There should also be some cache maintenance after this patching, or is
that already happening for some other reason?

-- 
Måns Rullgård
mans@mansr.com
