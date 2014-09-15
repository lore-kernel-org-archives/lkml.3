Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaIOKzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:55:38 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57016 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753332AbaIOKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:55:37 -0400
Date: Mon, 15 Sep 2014 11:55:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Subject: Re: [RFC Resend] arm:extend __init_end to a page align address
Message-ID: <20140915105525.GC12361@n2100.arm.linux.org.uk>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB028@CNBJMBX05.corpusers.net> <35FD53F367049845BC99AC72306C23D103D6DB4915FB@CNBJMBX05.corpusers.net> <35FD53F367049845BC99AC72306C23D103D6DB491607@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB491607@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 06:26:43PM +0800, Wang, Yalin wrote:
> this patch change the __init_end address to a page align address, so that free_initmem()
> can free the whole .init section, because if the end address is not page aligned,
> it will round down to a page align address, then the tail unligned page will not be freed.

Please wrap commit messages at or before column 72 - this makes "git log"
much easier to read once the change has been committed.

I have no objection to the arch/arm part of this patch.  However, since
different people deal with arch/arm and arch/arm64, this patch needs to
be split.

Also, it may be worth patching include/asm-generic/vmlinux.lds.h to
indicate that __initrd_end should be page aligned - this seems to be a
requirement by the (new-ish) free_reserved_area() function, otherwise
it does indeed round down.

(Added Jiang Liu as the person responsible for free_reserved_area() for
any further comments.)

> 
> Signed-off-by: Yalin wang <yalin.wang@sonymobile.com>
> ---
>  arch/arm/kernel/vmlinux.lds.S   | 2 +-
>  arch/arm64/kernel/vmlinux.lds.S | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S index 6f57cb9..8e95aa4 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -219,8 +219,8 @@ SECTIONS
>  	__data_loc = ALIGN(4);		/* location in binary */
>  	. = PAGE_OFFSET + TEXT_OFFSET;
>  #else
> -	__init_end = .;
>  	. = ALIGN(THREAD_SIZE);
> +	__init_end = .;
>  	__data_loc = .;
>  #endif
>  
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S index 97f0c04..edf8715 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -97,9 +97,9 @@ SECTIONS
>  
>  	PERCPU_SECTION(64)
>  
> +	. = ALIGN(PAGE_SIZE);
>  	__init_end = .;
>  
> -	. = ALIGN(PAGE_SIZE);
>  	_data = .;
>  	_sdata = .;
>  	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
> --
> 1.9.2.msysgit.0

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
