Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3AMQhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 11:37:40 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46492 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136Ab3AMQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 11:37:38 -0500
Message-ID: <1358095051.2284.3.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 8/9] parisc: Provide dma_mmap_coherent() and
 dma_get_sgtable()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-parisc@vger.kernel.org
Date: Sun, 13 Jan 2013 16:37:31 +0000
In-Reply-To: <CAMuHMdVETGzkf3nu+AohYN=gUjH3nmodxiLhi0Vrdo=SYKiokA@mail.gmail.com>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
	 <1358073890-3610-8-git-send-email-geert@linux-m68k.org>
	 <1358077001.3065.14.camel@dabdike.int.hansenpartnership.com>
	 <CAMuHMdVvRmNZS_L8-kYm4VGexD3h=nW4wC266cu7VAxJFx+-oA@mail.gmail.com>
	 <1358084972.3065.18.camel@dabdike.int.hansenpartnership.com>
	 <CAMuHMdVETGzkf3nu+AohYN=gUjH3nmodxiLhi0Vrdo=SYKiokA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-13 at 15:52 +0100, Geert Uytterhoeven wrote:
> On Sun, Jan 13, 2013 at 2:49 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Sun, 2013-01-13 at 14:12 +0100, Geert Uytterhoeven wrote:
> >> On Sun, Jan 13, 2013 at 12:36 PM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> > On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
> >> >> parisc/allmodconfig:
> >> >>
> >> >> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> >> >> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> >> >> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> >> >> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> >> >>
> >> >> For architectures using dma_map_ops, dma_mmap_coherent() and
> >> >> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> >> >>
> >> >> Parisc does not use dma_map_ops, hence it should implement them as inline
> >> >> stubs using dma_common_mmap() and dma_common_get_sgtable().
> >> >>
> >> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> >> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> >> >> Cc: linux-parisc@vger.kernel.org
> >> >> ---
> >> >>  arch/parisc/include/asm/dma-mapping.h |   10 ++++++++++
> >> >>  1 files changed, 10 insertions(+), 0 deletions(-)
> >> >>
> >> >> diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
> >> >> index 467bbd5..1fac0bf 100644
> >> >> --- a/arch/parisc/include/asm/dma-mapping.h
> >> >> +++ b/arch/parisc/include/asm/dma-mapping.h
> >> >> @@ -238,4 +238,14 @@ void * sba_get_iommu(struct parisc_device *dev);
> >> >>  /* At the moment, we panic on error for IOMMU resource exaustion */
> >> >>  #define dma_mapping_error(dev, x)    0
> >> >>
> >> >> +/* drivers/base/dma-mapping.c */
> >> >> +extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
> >> >> +                        void *cpu_addr, dma_addr_t dma_addr, size_t size);
> >> >> +extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
> >> >> +                               void *cpu_addr, dma_addr_t dma_addr,
> >> >> +                               size_t size);
> >> >> +
> >> >> +#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
> >> >> +#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
> >> >
> >> > What is the documentation around these functions?  The name sounds
> >> > suspiciously like you want a mapping of a buffer coherent between kernel
> >> > and user space, which doesn't seem possible for us given the API.  We're
> >> > a VIPT architecture, so the only way we can do this is to have the
> >> > actual vma user space address be congruent with cpu_addr.  How do we do
> >> > that if the vma and kernel addresses are already fixed?
> >>
> >> I was already afraid of this when seeing the "coherent" in the naming...
> >
> > Afraid of what, that the interface won't actually work for VIPT or that
> > we need special functions?
> 
> That it wouldn't work on parisc.

Hmm, so that would seem to be a serious deficiency with the API then.

> > We won't be the only ones: MIPS at least will have this issue.
> 
> MIPS uses <asm-generic/dma-mapping-common.h>, BUT has some ugly
> #ifdefery in sound/core/pcm_native.c:snd_pcm_lib_default_mmap().
> 
> BTW, does current ALSA mmap() work on parisc?

Yes, we used to have the same #ifdeffery, but in the alsa core ... I
can't remember how we fixed it for our two sound drivers (harmony and
AD1889).

> > But I would like to clear up whether we can actually use this on PA or
> > not.
> >
> >> > In other words, either the interface is unusable by parisc, or the
> >> > common code definitely won't work for us.
> >>
> >> So you probably want a static inline function that returns -EINVAL for now?
> >
> > Yes, that should work (provided the consumers handle the return code
> > correctly).
> 
> OK. Let's wait (for Marek's documentation) and see whether we can fix it
> for real in 3.8, or have to resort to -EINVAL.

The way we could fix this is by altering the kernel CPU address, using a
kmap area, so we have to change the virtual address by which the kernel
refers to this page to be coherent with user space, but the API is two
narrow to allow that, so perhaps we need to redesign how the API works.

James


