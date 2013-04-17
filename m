Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966038Ab3DQIFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965954Ab3DQIFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:05:34 -0400
Date: Wed, 17 Apr 2013 10:06:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130417070616.GA4487@redhat.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359940959-32168-2-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 05:22:38PM -0800, K. Y. Srinivasan wrote:
> Xen emulates Hyper-V to host enlightened Windows. Looks like this
> emulation may be turned on by default even for Linux guests. Check and
> fail Hyper-V detection if we are on Xen.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

I'm very curious what's the specific bug that is fixed here?
I went over the original discussion in
https://patchwork.kernel.org/patch/2064331/
and that's still not clear to me. Is there a configuration
that is broken without this patch but starts working with
this patch?

It seems that one might want to use hyper-v emulation e.g. to test
hyper-v code without using windows, so the functionality
that this patch disables is not completely useless,
so there should be a good reason for disabling it.

Could you enlighten me please? :)

> ---
>  arch/x86/kernel/cpu/mshyperv.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 646d192..4dab317 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -30,6 +30,13 @@ static bool __init ms_hyperv_platform(void)
>  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
>  		return false;
>  
> +	/*
> +	 * Xen emulates Hyper-V to support enlightened Windows.
> +	 * Check to see first if we are on a Xen Hypervisor.
> +	 */
> +	if (xen_cpuid_base())
> +		return false;
> +
>  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
>  	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
>  
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
