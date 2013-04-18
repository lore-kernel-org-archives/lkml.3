Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622Ab3DROIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:08:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab3DROIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:08:41 -0400
Date: Thu, 18 Apr 2013 11:08:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2] media: davinci: vpif: align the buffers size to page
 page size boundary
Message-ID: <20130418110828.563ff251@redhat.com>
In-Reply-To: <4068729.pdlKXoIiR6@avalon>
References: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
	<20130418082121.0221e59e@redhat.com>
	<20130418083547.41f975f8@redhat.com>
	<4068729.pdlKXoIiR6@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 18 Apr 2013 15:22:16 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Thursday 18 April 2013 08:35:47 Mauro Carvalho Chehab wrote:
> > Em Thu, 18 Apr 2013 08:21:21 -0300 Mauro Carvalho Chehab escreveu:
> > > Em Thu, 18 Apr 2013 10:17:14 +0530 Prabhakar Lad escreveu:
> > > > On Tue, Apr 16, 2013 at 4:48 PM, Laurent Pinchart wrote:
> > > > > Hi Prabhakar,
> > > 
> > > ...
> > > 
> > > > >> *nbuffers = config_params.min_numbuffers;
> > > > >> 
> > > > >>       *nplanes = 1;
> > > > >> 
> > > > >> +     size = PAGE_ALIGN(size);
> > > > > 
> > > > > I wonder if that's the best fix.
> > > > > The queue_setup operation is supposed to return the size required by
> > > > > the driver for each plane. Depending on the hardware requirements,
> > > > > that size might not be a multiple of the page size.
> > > > > 
> > > > > As we can't mmap() a fraction of a page, the allocated plane size
> > > > > needs to be rounded up to the next page boundary to allow mmap()
> > > > > support. The dma-contig and dma-sg allocators already do so in their
> > > > > alloc operation, but the vmalloc allocator doesn't.
> > > > > 
> > > > > The recent "media: vb2: add length check for mmap" patch verifies that
> > > > > the mmap() size requested by userspace doesn't exceed the buffer size.
> > > > > As the mmap() size is rounded up to the next page boundary the check
> > > > > will fail for buffer sizes that are not multiple of the page size.
> > > > > 
> > > > > Your fix will not result in overallocation (as the allocator already
> > > > > rounds the size up), but will prevent the driver from importing a
> > > > > buffer large enough for the hardware but not rounded up to the page
> > > > > size.
> > > > > 
> > > > > A better fix might be to round up the buffer size in the buffer size
> > > > > check at mmap() time, and fix the vmalloc allocator to round up the
> > > > > size. That the allocator, not drivers, is responsible for buffer size
> > > > > alignment should be documented in videobuf2-core.h.
> > > > 
> > > > Do you plan to post a patch fixing it as per Laurent's suggestion ?
> > > 
> > > I agree with Laurent: page size roundup should be done at VB2 core code,
> > > for memory allocated there, and not at driver's level. Yet, looking at
> > > VB2 code, it already does page size align at __setup_offsets(), but it
> > > doesn't do if for the size field; just for the offset.
> > > 
> > > The adjusted size should be stored at the VB2 size field, and the check
> > > for buffer overflow, added on changeset
> > > 068a0df76023926af958a336a78bef60468d2033 should be kept.
> > > 
> > > IMO, it also makes sense to enforce that the USERPTR memory is multiple of
> > > the page size, as otherwise the DMA transfer may overwrite some area that
> > > is outside the allocated range. So, the size from USERPTR should be round
> > > down.
> 
> I don't think that's needed. You can transfer a number of bytes not multiple 
> of the page size using DMA. This is true for DMABUF as well, an imported 
> buffer might have a size not aligned on a page boundary.

Are you sure that, on all supported archs/buses, the DMA transfers are
byte-aligned?

> > > That change, however, will break userspace, as it uses the picture
> > > sizeimage to allocate the buffers. So, sizeimage needs to be PAGE_SIZE
> > > roundup before passing it to userspace.
> > > 
> > > Instead of modifying all drivers, the better seems to patch v4l_g_fmt()
> > > and v4l_try_fmt() to return a roundup value for sizeimage. As usual,
> > > uvcvideo requires a separate patch, because it doesn't use vidio_ioctl2.
> > 
> > Hmm... PAGE_SIZE alignment is not needed on all places. It is needed only
> > when DMA is done directly into the buffer, e. g. videobuf2-dma-contig and
> > videobuf2-dma-sg.
> > 
> > It means that we'll need an extra function for the VB2 memory allocation
> > drivers to do do the memory-dependent roundups, and a new ancillary
> > function at VB2 core for the VB2 clients to call to round sizeimage if
> > needed.
> 
> Can't we just round the size up at allocation time and when checking the size 
> in mmap() ? That's a simple fix, local to vb2, and won't require new vb2 
> memops.

That's not needed for videobuf2-vmalloc. We shouldn't bloat the core VB2
with memops specific stuff. Ok, in this specific case, this is a simple
trivial patch, so perhaps we could do it there.

-- 

Cheers,
Mauro
