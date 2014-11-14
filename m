Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161308AbaKNQrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:47:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:54185 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934046AbaKNQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:47:33 -0500
Date: Fri, 14 Nov 2014 17:47:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: hpa@zytor.com, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 09/11] x86, mpx: on-demand kernel allocation of bounds
 tables
In-Reply-To: <20141114151829.AD4310DE@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1411141743230.3935@nanos>
References: <20141114151816.F56A3072@viggo.jf.intel.com> <20141114151829.AD4310DE@viggo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Dave Hansen wrote:
>  * move mm init-time #ifdef to mpx.h

> +static inline void arch_bprm_mm_init(struct mm_struct *mm,
> +		struct vm_area_struct *vma)
> +{
> +	mpx_mm_init(mm);
> +#ifdef CONFIG_X86_INTEL_MPX
> +	mm->bd_addr = MPX_INVALID_BOUNDS_DIR;
> +#endif

So we have a double init now :)

> +++ b/arch/x86/kernel/setup.c	2014-11-14 07:06:23.941684394 -0800
> @@ -959,6 +959,13 @@ void __init setup_arch(char **cmdline_p)
>  	init_mm.end_code = (unsigned long) _etext;
>  	init_mm.end_data = (unsigned long) _edata;
>  	init_mm.brk = _brk_end;
> +#ifdef CONFIG_X86_INTEL_MPX
> +	/*
> +	 * NULL is theoretically a valid place to put the bounds
> +	 * directory, so point this at an invalid address.
> +	 */
> +	init_mm.bd_addr = MPX_INVALID_BOUNDS_DIR;
> +#endif

And this one wants mpx_mm_init() replacement as well.
  
Thanks,

	tglx
