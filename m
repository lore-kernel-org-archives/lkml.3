Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaESJXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:23:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaESJX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:23:29 -0400
Message-ID: <1400491331.8467.8.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 4/4] drm/nouveau: introduce CPU cache flushing macro
From: Lucas Stach <l.stach@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, gnurou@gmail.com,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        linux-tegra@vger.kernel.org
Date: Mon, 19 May 2014 11:22:11 +0200
In-Reply-To: <20140519090202.GC7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
	 <1400483458-9648-5-git-send-email-acourbot@nvidia.com>
	 <20140519090202.GC7138@ulmo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.05.2014, 11:02 +0200 schrieb Thierry Reding:
> On Mon, May 19, 2014 at 04:10:58PM +0900, Alexandre Courbot wrote:
> > Some architectures (e.g. ARM) need the CPU buffers to be explicitely
> > flushed for a memory write to take effect. Not doing so results in
> > synchronization issues, especially after writing to BOs.
> 
> It seems to me that the above is generally true for all architectures,
> not just ARM.
> 
No, on PCI coherent arches, like x86 and some PowerPCs, the GPU will
snoop the CPU caches and therefore an explicit cache flush is not
required.

> Also: s/explicitely/explicitly/
> 
> > This patch introduces a macro that flushes the caches on ARM and
> > translates to a no-op on other architectures, and uses it when
> > writing to in-memory BOs. It will also be useful for implementations of
> > instmem that access shared memory directly instead of going through
> > PRAMIN.
> 
> Presumably instmem can access shared memory on all architectures, so
> this doesn't seem like a property of the architecture but rather of the
> memory pool backing the instmem.
> 
> In that case I wonder if this shouldn't be moved into an operation that
> is implemented by the backing memory pool and be a noop where the cache
> doesn't need explicit flushing.
> 
> > diff --git a/drivers/gpu/drm/nouveau/core/os.h b/drivers/gpu/drm/nouveau/core/os.h
> > index d0ced94ca54c..274b4460bb03 100644
> > --- a/drivers/gpu/drm/nouveau/core/os.h
> > +++ b/drivers/gpu/drm/nouveau/core/os.h
> > @@ -38,4 +38,21 @@
> >  #endif /* def __BIG_ENDIAN else */
> >  #endif /* !ioread32_native */
> >  
> > +#if defined(__arm__)
> > +
> > +#define nv_cpu_cache_flush_area(va, size)	\
> > +do {						\
> > +	phys_addr_t pa = virt_to_phys(va);	\
> > +	__cpuc_flush_dcache_area(va, size);	\
> > +	outer_flush_range(pa, pa + size);	\
> > +} while (0)
> 
> Couldn't this be a static inline function?
> 
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> [...]
> > index 0886f47e5244..b9c9729c5733 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> > @@ -437,8 +437,10 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned index, u16 val)
> >  	mem = &mem[index];
> >  	if (is_iomem)
> >  		iowrite16_native(val, (void __force __iomem *)mem);
> > -	else
> > +	else {
> >  		*mem = val;
> > +		nv_cpu_cache_flush_area(mem, 2);
> > +	}
> >  }
> >  
> >  u32
> > @@ -461,8 +463,10 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigned index, u32 val)
> >  	mem = &mem[index];
> >  	if (is_iomem)
> >  		iowrite32_native(val, (void __force __iomem *)mem);
> > -	else
> > +	else {
> >  		*mem = val;
> > +		nv_cpu_cache_flush_area(mem, 4);
> > +	}
> 
> This looks rather like a sledgehammer to me. Effectively this turns nvbo
> into an uncached buffer. With additional overhead of constantly flushing
> caches. Wouldn't it make more sense to locate the places where these are
> called and flush the cache after all the writes have completed?
> 
I don't think the explicit flushing for those things makes sense. I
think it is a lot more effective to just map the BOs write-combined on
PCI non-coherent arches. This way any writes will be buffered. Reads
will be slow, but I don't think nouveau is reading back a lot from those
buffers.
Using the write-combining buffer doesn't need any additional
synchronization as it will get flushed on pushbuf kickoff anyways.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

