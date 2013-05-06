Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3EFO7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:59:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4963 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab3EFO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:58:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,622,1363132800"; 
   d="scan'208";a="22394123"
Date: Mon, 6 May 2013 15:58:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 2/4] xen/vcpu: Document the xen_vcpu_info and xen_vcpu
In-Reply-To: <1367845498-14290-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1305061558460.4756@kaball.uk.xensource.com>
References: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com> <1367845498-14290-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Konrad Rzeszutek Wilk wrote:
> They are important structures and it is not clear at first
> look what they are for.
> 
> The xen_vcpu is a pointer. By default it points to the shared_info
> structure (at the CPU offset location). However if the
> VCPUOP_register_vcpu_info hypercall is implemented we can make the
> xen_vcpu pointer point to a per-CPU location.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  arch/x86/xen/enlighten.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 94a81f4..9b34475 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -85,7 +85,21 @@
>  
>  EXPORT_SYMBOL_GPL(hypercall_page);
>  
> +/*
> + * Pointer to the xen_vcpu_info structure or
> + * &HYPERVISOR_shared_info->vcpu_info[cpu]. See xen_hvm_init_shared_info
> + * and xen_vcpu_setup for details. By default it points to share_info->vcpu_info
> + * but if the hypervisor supports VCPUOP_register_vcpu_info then it can point
> + * to xen_vcpu_info. The pointer is used in __xen_evtchn_do_upcall to
> + * acknowledge pending events.
> + */
>  DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
> +
> +/*
> + * Per CPU pages used if hypervisor supports VCPUOP_register_vcpu_info
> + * hypercall. This can be used both in PV and PVHVM mode. The structure
> + * overrides the default per_cpu(xen_vcpu, cpu) value.
> + */
>  DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
>  
>  enum xen_domain_type xen_domain_type = XEN_NATIVE;
> @@ -187,7 +201,12 @@ static void xen_vcpu_setup(int cpu)
>  
>  	/* Check to see if the hypervisor will put the vcpu_info
>  	   structure where we want it, which allows direct access via
> -	   a percpu-variable. */
> +	   a percpu-variable.
> +	   N.B. This hypercall can _only_ be called once per CPU. Subsequent
> +	   calls will error out with -EINVAL. This is due to the fact that
> +	   hypervisor has no unregister variant and this hypercall does not
> +	   allow to over-write info.mfn and info.offset.
> +	 */
>  	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
>  
>  	if (err) {
> -- 
> 1.8.1.4
> 
