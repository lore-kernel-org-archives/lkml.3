Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3LSWHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:07:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3LSWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:07:28 -0500
Date: Thu, 19 Dec 2013 14:07:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Mark Rutland <mark.rutland@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7] rtc: Add support for Intersil ISL12057 I2C RTC chip
Message-Id: <20131219140726.e7d7ccf765da9b6be0ac3fa5@linux-foundation.org>
In-Reply-To: <72207bc152a06638f0e0e21a6e00d4c2054a1a71.1387489507.git.arno@natisbad.org>
References: <72207bc152a06638f0e0e21a6e00d4c2054a1a71.1387489507.git.arno@natisbad.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 22:53:16 +0100 Arnaud Ebalard <arno@natisbad.org> wrote:

> +static int isl12057_i2c_validate_chip(struct regmap *regmap)
> +{
> +	u8 regs[ISL12057_MEM_MAP_LEN];
> +	u8 mask[ISL12057_MEM_MAP_LEN] = { 0x80, 0x80, 0x80, 0xf8,
> +					  0xc0, 0x60, 0x00, 0x00,
> +					  0x00, 0x00, 0x00, 0x00,
> +					  0x00, 0x00, 0x60, 0x7c };
> +	int ret, i;
> +
> +	ret = regmap_bulk_read(regmap, 0, regs, ISL12057_MEM_MAP_LEN);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < ISL12057_MEM_MAP_LEN; ++i) {
> +		if (regs[i] & mask[i])	/* check if bits are cleared */
> +			return -ENODEV;
> +	}
> +
> +	return 0;
> +}

When I build this for x86_64, mask[] is assembled on-stack at runtime:

	leaq	-48(%rbp), %r14	#, tmp130
	xorl	%esi, %esi	#
	movl	$16, %ecx	#,
	movq	%rax, %rdi	# regmap,
	incq	.LPBX1+552(%rip)	# *.LPBX1
	movb	$-128, -64(%rbp)	#, mask
	movq	%r14, %rdx	# tmp130,
	movb	$-128, -63(%rbp)	#, mask
	movb	$-128, -62(%rbp)	#, mask
	movb	$-8, -61(%rbp)	#, mask
	movb	$-64, -60(%rbp)	#, mask
	movb	$96, -59(%rbp)	#, mask
	movb	$0, -58(%rbp)	#, mask
	movb	$0, -57(%rbp)	#, mask
	movb	$0, -56(%rbp)	#, mask
	movb	$0, -55(%rbp)	#, mask
	movb	$0, -54(%rbp)	#, mask
	movb	$0, -53(%rbp)	#, mask
	movb	$0, -52(%rbp)	#, mask
	movb	$0, -51(%rbp)	#, mask
	movb	$96, -50(%rbp)	#, mask
	movb	$124, -49(%rbp)	#, mask
	call	regmap_bulk_read	#

If we make `mask' static const, that all gets done at compile time instead:

	leaq	-48(%rbp), %r14	#, tmp134
	xorl	%esi, %esi	#
	movl	$16, %ecx	#,
	movq	%rax, %rdi	# regmap,
	incq	.LPBX1+552(%rip)	# *.LPBX1
	movq	%r14, %rdx	# tmp134,
	call	regmap_bulk_read	#

much nicer.
