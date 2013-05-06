Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3EFPA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:00:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46840 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3EFPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:00:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,622,1363132800"; 
   d="scan'208";a="22394387"
Date: Mon, 6 May 2013 16:00:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 3/4] xen/smp/pvhvm: Don't point per_cpu(xen_vpcu, 33 and
 larger) to shared_info
In-Reply-To: <1367845498-14290-4-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1305061600140.4756@kaball.uk.xensource.com>
References: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com> <1367845498-14290-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Konrad Rzeszutek Wilk wrote:
> As it will point to some data, but not event channel data (the
> shared_info has an array limited to 32).
> 
> This means that for PVHVM guests with more than 32 VCPUs without
> the usage of VCPUOP_register_info any interrupts to VCPUs
> larger than 32 would have gone unnoticed during early bootup.
> 
> That is OK, as during early bootup, in smp_init we end up calling
> the hotplug mechanism (xen_hvm_cpu_notify) which makes the
> VCPUOP_register_vcpu_info call for all VCPUs and we can receive
> interrupts on VCPUs 33 and further.
> 
> This is just a cleanup.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/enlighten.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 9b34475..18a4009 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1638,6 +1638,9 @@ void __ref xen_hvm_init_shared_info(void)
>  	 * online but xen_hvm_init_shared_info is run at resume time too and
>  	 * in that case multiple vcpus might be online. */
>  	for_each_online_cpu(cpu) {
> +		/* Leave it to be NULL. */
> +		if (cpu >= MAX_VIRT_CPUS)
> +			continue;
>  		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
>  	}
>  }
> -- 
> 1.8.1.4
> 
