Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaJUTKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:10:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57497 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbaJUTKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:10:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,763,1406592000"; 
   d="scan'208";a="183577651"
Message-ID: <5446AF91.8070907@citrix.com>
Date: Tue, 21 Oct 2014 20:10:09 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/pci: Use APIC directly when APIC
 virtualization is supported by hardware
References: <1413918075-26146-1-git-send-email-boris.ostrovsky@oracle.com> <1413918075-26146-3-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1413918075-26146-3-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/14 20:01, Boris Ostrovsky wrote:
> When hardware supports APIC/x2APIC virtualization we don't need to use pirqs
> for MSI handling and instead use APIC since most APIC accesses (MMIO or MSR)
> will now be processed without VMEXITs.
>
> As an example, netperf on the original code produces this profile
> (collected wih 'xentrace -e 0x0008ffff -T 5'):
>
>     342 cpu_change
>     260 CPUID
>   34638 HLT
>   64067 INJ_VIRQ
>   28374 INTR
>   82733 INTR_WINDOW
>      10 NPF
>   24337 TRAP
>  370610 vlapic_accept_pic_intr
>  307528 VMENTRY
>  307527 VMEXIT
>  140998 VMMCALL
>     127 wrap_buffer
>
> After applying this patch the same test shows
>
>     230 cpu_change
>     260 CPUID
>   36542 HLT
>     174 INJ_VIRQ
>   27250 INTR
>     222 INTR_WINDOW
>      20 NPF
>   24999 TRAP
>  381812 vlapic_accept_pic_intr
>  166480 VMENTRY
>  166479 VMEXIT
>   77208 VMMCALL
>      81 wrap_buffer
>
> ApacheBench results (ab -n 10000 -c 200) improve by about 10%
>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/include/asm/xen/cpuid.h | 81 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/pci/xen.c               |  9 +++++
>  2 files changed, 90 insertions(+)
>  create mode 100644 arch/x86/include/asm/xen/cpuid.h
>
> diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
> new file mode 100644
> index 0000000..e57a457
> --- /dev/null
> +++ b/arch/x86/include/asm/xen/cpuid.h
> @@ -0,0 +1,81 @@
> +/******************************************************************************
> + * arch-x86/cpuid.h
> + * 
> + * CPUID interface to Xen.
> + * 
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + * 
> + * Copyright (c) 2007 Citrix Systems, Inc.
> + * 
> + * Authors:
> + *    Keir Fraser <keir@xen.org>
> + */
> +
> +#ifndef __XEN_PUBLIC_ARCH_X86_CPUID_H__
> +#define __XEN_PUBLIC_ARCH_X86_CPUID_H__
> +
> +/* Xen identification leaves start at 0x40000000. */

On reading this, I notice that the Xen header files are wrong.  I will
submit a correction.

~Andrew
