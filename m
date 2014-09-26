Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaIZLnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:43:00 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43837 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754487AbaIZLm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:42:57 -0400
Date: Fri, 26 Sep 2014 12:42:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 7/8] ARM: mm: allow non-text sections to be
	non-executable
Message-ID: <20140926114239.GM5182@n2100.arm.linux.org.uk>
References: <1411067949-10913-1-git-send-email-keescook@chromium.org> <1411067949-10913-8-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411067949-10913-8-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:19:08PM -0700, Kees Cook wrote:
> @@ -1373,13 +1373,24 @@ static void __init map_lowmem(void)
>  		if (start >= end)
>  			break;
>  
> -		if (end < kernel_x_start || start >= kernel_x_end) {
> +		if (end < kernel_x_start) {
>  			map.pfn = __phys_to_pfn(start);
>  			map.virtual = __phys_to_virt(start);
>  			map.length = end - start;
>  			map.type = MT_MEMORY_RWX;
>  
>  			create_mapping(&map);
> +		} else if (start >= kernel_x_end) {
> +			map.pfn = __phys_to_pfn(start);
> +			map.virtual = __phys_to_virt(start);
> +			map.length = end - start;
> +#ifdef CONFIG_ARM_KERNMEM_PERMS
> +			map.type = MT_MEMORY_RW;
> +#else
> +			map.type = MT_MEMORY_RWX;
> +#endif
> +
> +			create_mapping(&map);


I'm looking at this, and wondering two things.  Firstly, why isn't it
MT_MEMORY_RW in the first place.  Secondly, why do you need to make
this depend on CONFIG_ARM_KERNMEM_PERMS at all?

I think the first is an oversight by me (and is a case which never came
up in my testing, because most of my platforms don't have segmented
memory layouts.)

The second I think is not necessary - the memory region being considered
is not part of the kernel at all, and so should not be executable in any
shape or form.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
