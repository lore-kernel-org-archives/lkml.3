Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaIZLdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:33:32 -0400
Received: from ozlabs.org ([103.22.144.67]:54227 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbaIZLda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:33:30 -0400
Message-ID: <1411731209.1733.51.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 10/15] powerpc/mm: Add hooks for cxl
From: Michael Neuling <mikey@neuling.org>
To: Anton Blanchard <anton@samba.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Date: Fri, 26 Sep 2014 21:33:29 +1000
In-Reply-To: <20140926143309.33c0eeac@kryten>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-11-git-send-email-mikey@neuling.org>
	 <20140926143309.33c0eeac@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 14:33 +1000, Anton Blanchard wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > This add a hook into tlbie() so that we use global invalidations when
> > there are cxl contexts active.
> > 
> > Normally cxl snoops broadcast tlbie.  cxl can have TLB entries
> > invalidated via MMIO, but we aren't doing that yet.  So for now we
> > are just disabling local tlbies when cxl contexts are active.  In
> > future we can make tlbie() local mode smarter so that it invalidates
> > cxl contexts explicitly when it needs to.
> > 
> > This also adds a hooks for when SLBs are invalidated to ensure any
> > corresponding SLBs in cxl are also invalidated at the same time.
> > 
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> > +	use_local = local && mmu_has_feature(MMU_FTR_TLBIEL) && !cxl_ctx_in_use();
> 
> Seems reasonable until we can get the MMIO based optimisation in.
> 
> Will all CAPI cached translations be invalidated before we finish using
> a CAPI context? 

I'm not sure I understand. Can you elaborate?

> And conversely, could CAPI cache any translations when a
> context isn't active? 

The kernel invalidates all translations when the file descriptor is
closed.  So no, unless the PSL was badly behaving and ignoring the
invalidations.... but if we can't trust the PSL we're screwed.

> I'm mostly concerned that we can't have a
> situation where badly behaving userspace could result in a stale
> translation.

We only map what a user processes maps and we tear it down when the
process is teared down (on the file descriptor release).  So I think we
are ok.  

Unless there's some lazy teardown you're alluding to that I'm missing?

> 
> >  	spu_flush_all_slbs(mm);
> >  #endif
> > +	cxl_slbia(mm);
> 
> >  			spu_flush_all_slbs(mm);
> >  #endif
> > +			cxl_slbia(mm);
> 
> >  	spu_flush_all_slbs(mm);
> >  #endif
> > +	cxl_slbia(mm);
> 
> >  	spu_flush_all_slbs(mm);
> >  #endif
> > +	cxl_slbia(mm);
> 
> Should we combine the SPU vs CXL callouts into something common -
> perhaps copro_flush_all_slbs()?

Sounds good.  I'll update.

Mikey
