Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3FCVNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:13:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48166 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3FCVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:13:40 -0400
Message-ID: <51AD0703.6050408@codeaurora.org>
Date: Mon, 03 Jun 2013 14:13:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the decompressor
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org>
In-Reply-To: <20130524220539.GB599@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending due to rmk's vacation.

On 05/24/13 15:05, Stephen Boyd wrote:
> I've noticed another problem now that our caches are used. On MSM
> we have TEXT_OFFSET set to at least 0x208000 if we've built-in
> support for MSM8x60/8960. If I boot a kernel with the MSM code
> built-in that requires the higher text offset, but I load my
> compressed kernel below that address (such as 0x0) the
> decompression fails.
>
> This happens because the page tables are written into the
> compressed data region before we relocate ourself to a higher
> location.
>
> Here's some ascii art to show the problem
>
> We start off at 0x0
>
>  0x000000 +---------+
>           |         |
>           | zImage  |
>  0x208000 |---------| <- r4 (zreladdr)
>           | zImage  |
>  0x300000 +---------+ <- _edata
>
> Then we run far enough to call cache_on which goes ahead and
> calls __setup_mmu and sets up our page tables.
>
>  0x008000 +---------+
>           |         |
>           | zImage  |
>           |         |
>  0x204000 |---------|
>           |  pgdir  |
>  0x208000 |---------| <- r4 (zreladdr)
>           |         |
>           | zImage  |
>           |         |
>  0x300000 +---------+ <- _edata
>
> This is bad because we just wrote our page tables into the
> compressed data. Nobody notices though and we finish relocating
> ourselves and then we call decompress_kernel() which fails
> randomly. (BTW, why does error() sit in a while loop forever? We
> can't get any information about why the decompression failed if
> we have debug_ll enabled. I had to patch the error() routine to
> not while loop forever to get that print after do_decompress to
> be useful.)
>
> I see a few solutions.
>
>  1) Relocate with caches off and then turn on caches after we're
>     running in a location where we won't overwrite ourselves.
>
>  2) Have temporary page tables for the relocation phase that live
>     just below the location we're going to relocate to.
>
>  3) Force bootloaders loading these types of images to load the
>     zImage at least as high as the TEXT_OFFSET is compiled to.
>
> I don't think we can convince everyone that #3 is ok to do. I'm
> leaning towards #2 since we get all the benefits of the cache
> during the relocation phase but #1 is the obviously simple fix.
>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

