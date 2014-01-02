Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaABPcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:32:36 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44728 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaABPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:32:35 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="87065090"
Message-ID: <52C58691.4040502@citrix.com>
Date: Thu, 2 Jan 2014 15:32:33 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code (v2).
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-4-git-send-email-konrad.wilk@oracle.com>
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
> In the bootup code for PVH we can trap cpuid via vmexit, so don't
> need to use emulated prefix call. We also check for vector callback
> early on, as it is a required feature. PVH also runs at default kernel
> IOPL.
> 
> Finally, pure PV settings are moved to a separate function that are
> only called for pure PV, ie, pv with pvmmu. They are also #ifdef
> with CONFIG_XEN_PVMMU.
[...]
> @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  		break;
>  	}
>  
> -	asm(XEN_EMULATE_PREFIX "cpuid"
> -		: "=a" (*ax),
> -		  "=b" (*bx),
> -		  "=c" (*cx),
> -		  "=d" (*dx)
> -		: "0" (*ax), "2" (*cx));
> +	if (xen_pvh_domain())
> +		native_cpuid(ax, bx, cx, dx);
> +	else
> +		asm(XEN_EMULATE_PREFIX "cpuid"
> +			: "=a" (*ax),
> +			"=b" (*bx),
> +			"=c" (*cx),
> +			"=d" (*dx)
> +			: "0" (*ax), "2" (*cx));

For this one off cpuid call it seems preferrable to me to use the
emulate prefix rather than diverge from PV.

> @@ -1431,13 +1449,18 @@ asmlinkage void __init xen_start_kernel(void)
>  
>  	xen_domain_type = XEN_PV_DOMAIN;
>  
> +	xen_setup_features();
> +	xen_pvh_early_guest_init();
>  	xen_setup_machphys_mapping();
>  
>  	/* Install Xen paravirt ops */
>  	pv_info = xen_info;
>  	pv_init_ops = xen_init_ops;
> -	pv_cpu_ops = xen_cpu_ops;
>  	pv_apic_ops = xen_apic_ops;
> +	if (xen_pvh_domain())
> +		pv_cpu_ops.cpuid = xen_cpuid;
> +	else
> +		pv_cpu_ops = xen_cpu_ops;

If cpuid is trapped for PVH guests why does PVH need non-native cpuid op?

David
