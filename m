Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaCLW75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:59:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57668 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaCLW74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:59:56 -0400
Message-ID: <5320E689.7060607@zytor.com>
Date: Wed, 12 Mar 2014 15:58:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
References: <1394664680-17799-1-git-send-email-stefani@seibold.net> <1394664680-17799-4-git-send-email-stefani@seibold.net>
In-Reply-To: <1394664680-17799-4-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 03:51 PM, Stefani Seibold wrote:
> This patch enables 32 bit vDSO which are larger than a page. Currently
> two pages are reserved, this should be enough for future improvements.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/include/asm/fixmap.h |  4 +++-
>  arch/x86/vdso/vdso32-setup.c  | 29 +++++++++++++++++++----------
>  2 files changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 094d0cc..f513f14 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -43,6 +43,8 @@ extern unsigned long __FIXADDR_TOP;
>  
>  #define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
>  #define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
> +
> +#define MAX_VDSO_PAGES	2
>  #else
>  #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
>  
> @@ -74,7 +76,7 @@ extern unsigned long __FIXADDR_TOP;
>  enum fixed_addresses {
>  #ifdef CONFIG_X86_32
>  	FIX_HOLE,
> -	FIX_VDSO,
> +	FIX_VDSO = MAX_VDSO_PAGES,
>  	VVAR_PAGE,
>  	VSYSCALL_HPET,

Can we make this FIX_HOLE + MAX_VDSO_PAGES or at least a comment
explaning the constraint here... otherwise I fear random breakage.

> +	for(i = 0; i != vdso32_size; ++i)
> +		vdso32_pages[i] = virt_to_page(vdso_pages + VDSO_OFFSET(i));

Stylistic note:

	for (i = 0; i < vdso32_size; i++)

Otherwise it really seems simple enough.

