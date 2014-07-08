Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaGHWe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:34:57 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42280 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGHWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:34:56 -0400
Message-ID: <53BC7210.1000305@gmail.com>
Date: Tue, 08 Jul 2014 17:34:56 -0500
From: Stuart Hayes <stuart.w.hayes@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com, bp@suse.de
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
References: <53B4B627.8060903@gmail.com>
In-Reply-To: <53B4B627.8060903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2014 8:47 PM, Stuart Hayes wrote:

> A page fault can crash the kernel very early if an NX bit is set in a
> page table entry, if the CPU doesn't support NX (or if NX support is
> disabled in the CPU).  Move the call to x86_configure_nx() earlier
> than parse_setup_data(), since that calls early_memremap().
> 
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> ---
> 
> --- linux-3.16-rc3/arch/x86/kernel/setup.c.orig	2014-07-02 12:14:50.196308719 -0400
> +++ linux-3.16-rc3/arch/x86/kernel/setup.c	2014-07-02 12:11:11.240301228 -0400
> @@ -940,6 +940,17 @@ void __init setup_arch(char **cmdline_p)
>  
>  	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
>  	setup_memory_map();
> +
> +	/*
> +	 * x86_configure_nx() is called before parse_setup_data() to detect
> +	 * whether hardware doesn't support NX (so that parse_setup_data()
> +	 * can safely call early_memremap() without setting the XD bit in
> +	 * the PTE, which can cause an unrecoverable page fault). It may
> +	 * then be called again from within noexec_setup() during parsing
> +	 * early parameters to honor the respective command line option.
> +	 */
> +	x86_configure_nx();
> +
>  	parse_setup_data();
>  
>  	copy_edd();
> @@ -974,15 +985,6 @@ void __init setup_arch(char **cmdline_p)
>  	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
>  	*cmdline_p = command_line;
>  
> -	/*
> -	 * x86_configure_nx() is called before parse_early_param() to detect
> -	 * whether hardware doesn't support NX (so that the early EHCI debug
> -	 * console setup can safely call set_fixmap()). It may then be called
> -	 * again from within noexec_setup() during parsing early parameters
> -	 * to honor the respective command line option.
> -	 */
> -	x86_configure_nx();
> -
>  	parse_early_param();
>  
>  	x86_report_nx();


I haven't received any responses... is there a problem with the patch?  Also CCing a couple people.

