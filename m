Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaEOHc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:32:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:49841 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaEOHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:32:56 -0400
Message-ID: <53746D32.4000708@huawei.com>
Date: Thu, 15 May 2014 15:30:58 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Simon Horman <horms@verge.net.au>,
        "Mika Westerberg" <ext-mika.1.westerberg@nokia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Geng Hui <hui.geng@huawei.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH] crash_dump: arm: crash dump kernel should use strict
 pfn_valid
References: <1400138070-24046-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1400138070-24046-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kexec@lists.infradead.org to cc list.

On 2014/5/15 15:14, Wang Nan wrote:
> This patch makes crash dump kernel use arch pfn_valid defined in
> arch/arm/mm/init.c instead of the one in include/linux/mmzone.h.
> The goal of this patch is to remove some limitation when kexec loading
> crash kernel while SPARSEMEM is enabled.
> 
> Before this patch, if second kernel selects both CRASH_DUMP and
> SPARSEMEM, the second kernel will recongnize memorys at the same section
> with itself as valid memory, and prevents ioremap (see arm ioremap code,
> arm doesn't allow valid memory to be ioremapped again). Which introduces
> some limitations on positioning the crash kernel. For example:
> 
>   For a platform with SECTION_SIZE_BITS == 28 (256MiB) and
>   crashkernel=128M@0x28000000 in kernel cmdline, the second
>   kernel is loaded at 0x28000000. Kexec puts elfcorehdr at
>   0x2ff00000, and passes 'elfcorehdr=0x2ff00000 mem=130048K' to
>   second kernel. When second kernel start, it tries to use
>   ioremap to retrive its elfcorehrd. In this case, elfcodehdr is at the
>   same section of the second kernel, pfn_valid will recongnize
>   the page as valid, so ioremap will refuse to map it.
> 
> Even if we put crash kernel at the boundary of two sections (such as
> 129MB@0x0x28000000 in the above situation), 0x20000000-0x28000000 used
> by old kernel is still unable to retrived by crash kernel because they
> are at the same section.
> 
> This patch makes crash dump kernel use strict (and slow) version of
> pfn_valid(), which makes crash kernel recongnize memory correctly.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Geng Hui <hui.geng@huawei.com>
> Cc: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> Cc: Simon Horman <horms@verge.net.au>
> ---
>  arch/arm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index db3c541..795b1d4 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1800,7 +1800,7 @@ config ARCH_SELECT_MEMORY_MODEL
>  	def_bool ARCH_SPARSEMEM_ENABLE
>  
>  config HAVE_ARCH_PFN_VALID
> -	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
> +	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM || CRASH_DUMP
>  
>  config HIGHMEM
>  	bool "High Memory Support"
> 


