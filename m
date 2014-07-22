Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaGVQTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:19:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:8294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbaGVQTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:19:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="547261845"
Message-ID: <53CE8EEC.2090402@intel.com>
Date: Tue, 22 Jul 2014 09:18:52 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com> <1405921124-4230-4-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1405921124-4230-4-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2014 10:38 PM, Qiaowei Ren wrote:
> +#ifdef CONFIG_X86_INTEL_MPX
> +#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
> +#else
> +#define cpu_has_mpx 0
> +#endif /* CONFIG_X86_INTEL_MPX */

Is this enough checking?  Looking at the extension reference, it says:

> 9.3.3
> Enabling of Intel MPX States
> An OS can enable Intel MPX states to support software operation using bounds registers with the following steps:
> • Verify the processor supports XSAVE/XRSTOR/XSETBV/XGETBV instructions and XCR0 by checking
> CPUID.1.ECX.XSAVE[bit 26]=1.

That, I assume the xsave code is already doing.

> • Verify the processor supports both Intel MPX states by checking CPUID.(EAX=0x0D, ECX=0):EAX[4:3] is 11b.

I see these bits _attempting_ to get set in pcntxt_mask via XCNTXT_MASK.
 But, I don't see us ever actually checking that they _do_ get set.  For
instance, we do this for:

>         if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
>                 pr_err("FP/SSE not shown under xsave features 0x%llx\n",
>                        pcntxt_mask);
>                 BUG();
>         }

