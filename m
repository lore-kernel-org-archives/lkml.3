Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaGKWwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:52:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40055 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaGKWwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:52:21 -0400
Message-ID: <53C06A94.3040702@zytor.com>
Date: Fri, 11 Jul 2014 15:52:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: konrad@kernel.org, xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen: Introduce 'xen_nopv' to disable PV extensions for
 HVM guests.
References: <1405108419-31576-1-git-send-email-konrad@kernel.org>
In-Reply-To: <1405108419-31576-1-git-send-email-konrad@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 12:53 PM, konrad@kernel.org wrote:
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c1b9aa8..5dcfa6e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3691,6 +3691,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Disables the ticketlock slowpath using Xen PV
>  			optimizations.
>  
> +	xen_nopv	[X86,XEN]
> +			Disables the PV optimizations forcing the guest to run
> +			as generic HVM guest with no PV drivers.
> +
>  	xirc2ps_cs=	[NET,PCMCIA]
>  			Format:
>  			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index ffb101e..eb82239 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1826,8 +1826,19 @@ static void __init xen_hvm_guest_init(void)
>  	xen_hvm_init_mmu_ops();
>  }
>  
> +static bool xen_nopv = false;
> +static __init int xen_parse_nopv(char *arg)
> +{
> +       xen_nopv = true;
> +       return 0;
> +}
> +early_param("xen_nopv", xen_parse_nopv);
> +
>  static uint32_t __init xen_hvm_platform(void)
>  {
> +	if (xen_nopv)
> +		return 0;
> +
>  	if (xen_pv_domain())
>  		return 0;
>  
> @@ -1836,6 +1847,8 @@ static uint32_t __init xen_hvm_platform(void)
>  
>  bool xen_hvm_need_lapic(void)
>  {
> +	if (xen_nopv)
> +		return false;
>  	if (xen_pv_domain())
>  		return false;
>  	if (!xen_hvm_domain())
> 

Any reason to not simply let xen_pv_domain() return false here?

Also, the latter seems a bit odd?

	-hpa

