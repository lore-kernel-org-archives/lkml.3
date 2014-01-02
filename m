Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaABQHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:07:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15326 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaABQHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:07:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="89267418"
Message-ID: <52C58EA7.2090107@citrix.com>
Date: Thu, 2 Jan 2014 16:07:03 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 09/18] xen/pvh: Secondary VCPU bringup (non-bootup
 CPUs)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-10-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-10-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> The VCPU bringup protocol follows the PV with certain twists.
> From xen/include/public/arch-x86/xen.h:
> 
> Also note that when calling DOMCTL_setvcpucontext and VCPU_initialise
> for HVM and PVH guests, not all information in this structure is updated:
> 
>  - For HVM guests, the structures read include: fpu_ctxt (if
>  VGCT_I387_VALID is set), flags, user_regs, debugreg[*]
> 
>  - PVH guests are the same as HVM guests, but additionally use ctrlreg[3] to
>  set cr3. All other fields not used should be set to 0.
> 
> This is what we do. We piggyback on the 'xen_setup_gdt' - but modify
> a bit - we need to call 'load_percpu_segment' so that 'switch_to_new_gdt'
> can load per-cpu data-structures. It has no effect on the VCPU0.
> 
> We also piggyback on the %rdi register to pass in the CPU number - so
> that when we bootup a new CPU, the cpu_bringup_and_idle will have
> passed as the first parameter the CPU number (via %rdi for 64-bit).
[...]
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1413,14 +1413,19 @@ static void __init xen_boot_params_init_edd(void)
>   * Set up the GDT and segment registers for -fstack-protector.  Until
>   * we do this, we have to be careful not to call any stack-protected
>   * function, which is most of the kernel.
> + *
> + * Note, that it is refok - b/c the only caller of this after init

Please spell out 'because' in full.  b/c is too hard to read.  Also list
the callers (cpu_bringup_and_idle() I guess).

> + * is PVH which is not going to use xen_load_gdt_boot or other
> + * __init functions.
>   */
> -static void __init xen_setup_gdt(void)
> +void __init_refok xen_setup_gdt(int cpu)

__ref seems to be the correct section marker for this.

David
