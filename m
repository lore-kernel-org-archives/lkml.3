Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbbA2LfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:35:10 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33925 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbA2LfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:35:08 -0500
Date: Thu, 29 Jan 2015 11:34:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        sylvain.rochet@finsecur.com, peda@axentia.se,
        sergei.shtylyov@cogentembedded.com, linux@maxim.org.za
Subject: Re: [PATCH v2 3/3] pm: at91: add disable/enable the L1/L2 cache
 while suspend/resume
Message-ID: <20150129113450.GW26493@n2100.arm.linux.org.uk>
References: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
 <1422411844-13241-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422411844-13241-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:24:04AM +0800, Wenyou Yang wrote:
> +	/*
> +	 * Clean and invalidate the L2 cache.
> +	 * Common cache-l2x0.c functions can't be used here since it
> +	 * uses spinlocks. We are out of coherency here with data cache
> +	 * disabled. The spinlock implementation uses exclusive load/store
> +	 * instruction which can fail without data cache being enabled.
> +	 * Because of this, CPU can lead to deadlock.

We really need to stop needing platforms to create their own L2 handling
code.  Please move this to a helper function in arch/arm/mm/l2c-l...-clean.S,
replacing ... with the appropriate part for the code fragment.

> +	 */
> +	ldr	r1, at91_l2cc_base_addr
> +	ldr	r2, [r1]
> +	cmp	r2, #0
> +	beq	skip_l2disable
> +	mov	r0, #0xff
> +	str	r0, [r2, #L2X0_CLEAN_INV_WAY]
> +wait:
> +	ldr	r0, [r2, #L2X0_CLEAN_INV_WAY]
> +	mov	r1, #0xff
> +	ands	r0, r0, r1
> +	bne	wait
> +
> +	mov	r0, #0
> +	str	r0, [r2, #L2X0_CTRL]
> +
> +l2x_sync:
> +	ldr	r0, [r2, #L2X0_CACHE_SYNC]
> +	bic	r0, r0, #0x1
> +	str	r0, [r2, #L2X0_CACHE_SYNC]

I wonder whether you've actually read the documentation for this.  You
don't need to read-modify-write this register.  The C code doesn't even
do this.  A write to this register is sufficient - a write issues the
sync, a read returns the completion status.

> +sync:
> +	ldr	r0, [r2, #L2X0_CACHE_SYNC]
> +	ands	r0, r0, #0x1
> +	bne	sync

Moreover, do you actually need this - it depends on the L2C model.  Only
L2C220 needs to spin waiting for the sync operation to complete.

Also, are you sure the "clean+invalidate, disable, sync" sequence is
correct?  Should it not be "clean+invalidate, sync, disable" ?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
