Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab3FMUsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:48:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53743 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab3FMUsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:48:24 -0400
Message-ID: <51BA2FF4.6000604@zytor.com>
Date: Thu, 13 Jun 2013 13:47:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86: Fix /proc/mtrr with base/size more than 44bits
References: <1371149617-17880-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1371149617-17880-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 11:53 AM, Yinghai Lu wrote:
>  
> -	if (base & size_or_mask || size & size_or_mask) {
> +	if (base >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT) ||
> +	    base > (base + size) ||
> +	    (base + size - 1) >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)) {
>  		pr_warning("mtrr: base or size exceeds the MTRR width\n");
>  		return -EINVAL;
>  	}

Most of this patch looks good as far as being a minimal patch, but I'm
really confused about this bit.  Could you explain the reason for why
the original doesn't work?  (To be fair: I am not even sure the original
does anything useful so it could just be a "this is just too broken to
live" kind of thing.)

The first and third clause of the test can be simplified, however:

	(base | (base + size - 1)) >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)

... although it would be cleaner to put boot_cpu_data.x86_phys_bits -
PAGE_SHIFT into a variable.

A lot of the mask_hi/mask_lo stuff should just get removed by using
rdmsrl/wrmsrl, but that is not stable material obviously.

	-hpa


