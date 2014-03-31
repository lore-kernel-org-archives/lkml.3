Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaCaHaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:30:17 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33614 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaCaHaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:30:15 -0400
Date: Mon, 31 Mar 2014 09:30:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/UV: Set n_lshift based on GAM_GR_CONFIG MMR for UV3
Message-ID: <20140331073011.GB2004@gmail.com>
References: <20140320191354.GA30582@sgi.com>
 <20140321075416.GA23556@gmail.com>
 <20140321141649.GA14917@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321141649.GA14917@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Fri, Mar 21, 2014 at 08:54:16AM +0100, Ingo Molnar wrote:
> > Please use the customary changelog style we use in the kernel:
> > 
> >   " Current code does (A), this has a problem when (B).
> >     We can improve this doing (C), because (D)."
> > 
> > (Of if it's a cleanup only with no functional effects then please 
> > state it so in the title and changelog.)
> >
>  
> The value of n_lshift for UV is currently set based on the socket m_val.
> 
> For UV3, set the n_lshift value based on the GAM_GR_CONFIG MMR.  This will
> allow bios to control the n_lshift value independent of the socket m_val.
> Then n_lshift can be assigned a fixed value across a multi-partition system,
> allowing for a fixed common global physical address format that is independent
> of socket m_val.
> 
> Cleanup unneeded macros.
>
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  arch/x86/include/asm/uv/uv_hub.h   |   12 ---------
>  arch/x86/include/asm/uv/uv_mmrs.h  |   42 ++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/apic/x2apic_uv_x.c |   15 +++++++++--
>  3 files changed, 54 insertions(+), 15 deletions(-)
> 
> Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -5,7 +5,7 @@
>   *
>   * SGI UV APIC functions (note: not an Intel compatible APIC)
>   *
> - * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
> + * Copyright (C) 2007-2014 Silicon Graphics, Inc. All rights reserved.
>   */
>  #include <linux/cpumask.h>
>  #include <linux/hardirq.h>
> @@ -843,12 +843,14 @@ void uv_cpu_init(void)
>  void __init uv_system_init(void)
>  {
>  	union uvh_rh_gam_config_mmr_u  m_n_config;
> +	union uv3h_gr0_gam_gr_config_u m_gr_config;
>  	union uvh_node_id_u node_id;
>  	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
>  	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
>  	int gnode_extra, min_pnode = 999999, max_pnode = -1;
>  	unsigned long mmr_base, present, paddr;
>  	unsigned short pnode_mask;
> +	unsigned char n_lshift;
>  	char *hub = (is_uv1_hub() ? "UV1" :
>  		    (is_uv2_hub() ? "UV2" :
>  				    "UV3"));
> @@ -859,6 +861,14 @@ void __init uv_system_init(void)
>  	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
>  	m_val = m_n_config.s.m_skt;
>  	n_val = m_n_config.s.n_skt;
> +	if (is_uv1_hub())
> +		n_lshift = m_val;
> +	else if (is_uv2_hub())
> +		n_lshift = m_val == 40 ? 40 : 39;
> +	else {
> +		m_gr_config.v = uv_read_local_mmr(UV3H_GR0_GAM_GR_CONFIG);
> +		n_lshift = m_gr_config.s3.m_skt;
> +	}

This too should be in a helper inline, uv_system_init() is too large 
already.

The asymmetric curly braces are also non-standard.

Thanks,

	Ingo
