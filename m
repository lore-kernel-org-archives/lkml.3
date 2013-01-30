Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3A3Ixd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:53:33 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:40511 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3A3Ixc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Wed, 30 Jan 2013 03:53:32 -0500
Message-Id: <5108ED9702000078000BAA08@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 30 Jan 2013 08:53:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <olaf@aepfle.de>, <bp@alien8.de>, <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        <gregkh@linuxfoundation.org>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of
 Hyper-V
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-2-git-send-email-kys@microsoft.com>
In-Reply-To: <1359507108-26091-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.01.13 at 01:51, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> Xen emulates Hyper-V to host enlightened Windows. Looks like this
> emulation may be turned on by default even for Linux guests. Check and
> fail Hyper-V detection if we are on Xen.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
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

I'm not convinced that's the right approach - any hypervisor
could do similar emulation, and hence you either want to make
sure you run on Hyper-V (by excluding all others), or you
tolerate using the emulation (which may require syncing up with
the other guest implementations so that shared resources don't
get used by two parties).

I also wonder whether using the Hyper-V emulation (where
useful, there might not be anything right now, but this may
change going forward) when no Xen support is configured
wouldn't be better than not using anything...

Jan

