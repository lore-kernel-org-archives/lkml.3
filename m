Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIZEdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:33:12 -0400
Received: from ozlabs.org ([103.22.144.67]:49685 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaIZEdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:33:11 -0400
Date: Fri, 26 Sep 2014 14:33:09 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 10/15] powerpc/mm: Add hooks for cxl
Message-ID: <20140926143309.33c0eeac@kryten>
In-Reply-To: <1411028820-29933-11-git-send-email-mikey@neuling.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	<1411028820-29933-11-git-send-email-mikey@neuling.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This add a hook into tlbie() so that we use global invalidations when
> there are cxl contexts active.
> 
> Normally cxl snoops broadcast tlbie.  cxl can have TLB entries
> invalidated via MMIO, but we aren't doing that yet.  So for now we
> are just disabling local tlbies when cxl contexts are active.  In
> future we can make tlbie() local mode smarter so that it invalidates
> cxl contexts explicitly when it needs to.
> 
> This also adds a hooks for when SLBs are invalidated to ensure any
> corresponding SLBs in cxl are also invalidated at the same time.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>

> +	use_local = local && mmu_has_feature(MMU_FTR_TLBIEL) && !cxl_ctx_in_use();

Seems reasonable until we can get the MMIO based optimisation in.

Will all CAPI cached translations be invalidated before we finish using
a CAPI context? And conversely, could CAPI cache any translations when a
context isn't active? I'm mostly concerned that we can't have a
situation where badly behaving userspace could result in a stale
translation.

>  	spu_flush_all_slbs(mm);
>  #endif
> +	cxl_slbia(mm);

>  			spu_flush_all_slbs(mm);
>  #endif
> +			cxl_slbia(mm);

>  	spu_flush_all_slbs(mm);
>  #endif
> +	cxl_slbia(mm);

>  	spu_flush_all_slbs(mm);
>  #endif
> +	cxl_slbia(mm);

Should we combine the SPU vs CXL callouts into something common -
perhaps copro_flush_all_slbs()?

Anton
