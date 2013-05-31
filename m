Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3EaPb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:31:28 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:61989 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3EaPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:30:01 -0400
Date: Fri, 31 May 2013 17:29:56 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: =?utf-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for
 reimporting
Message-ID: <20130531152956.GX15743@phenom.ffwll.local>
Mail-Followup-To: =?utf-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
 <51A879E0.3080106@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51A879E0.3080106@samsung.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 07:22:24PM +0900, 김승우 wrote:
> Hello Daniel,
> 
> Thanks for your comment.
> 
> On 2013년 05월 31일 18:14, Daniel Vetter wrote:
> > On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> >> importer private data in dma-buf attachment can be used by importer to
> >> reimport same dma-buf.
> >>
> >> Seung-Woo Kim (2):
> >>   dma-buf: add importer private data to attachment
> >>   drm/prime: find gem object from the reimported dma-buf
> > 
> > Self-import should already work (at least with the latest refcount
> > fixes merged). At least the tests to check both re-import on the same
> > drm fd and on a different all work as expected now.
> 
> Currently, prime works well for all case including self-importing,
> importing, and reimporting as you describe. Just, importing dma-buf from
> other driver twice with different drm_fd, each import create its own gem
> object even two import is done for same buffer because prime_priv is in
> struct drm_file. This means mapping to the device is done also twice.
> IMHO, these duplicated creations and maps are not necessary if drm can
> find previous import in different prime_priv.

Well, that's imo a bug with the other driver. If it doesn't export
something really simple (e.g. contiguous memory which doesn't require any
mmio resources at all) it should have a cache of exported dma_buf fds so
that it hands out the same dma_buf every time.

Or it needs to be more clever in it's dma_buf_attachment_map functions and
lookup up a pre-existing iommu mapping.

But dealing with this in the importer is just broken.

> > Second, the dma_buf_attachment is _definitely_ the wrong place to do
> > this. If you need iommu mapping caching, that should happen at a lower
> > level (i.e. in the map_attachment callback somewhere of the exporter,
> > that's what the priv field in the attachment is for). Snatching away
> > the attachement from some random other import is certainly not the way
> > to go - attachements are _not_ refcounted!
> 
> Yes, attachments do not have refcount, so importer should handle and drm
> case in my patch, importer private data is gem object and it has, of
> course, refcount.
> 
> And at current, exporter can not classify map_dma_buf requests of same
> importer to same buffer with different attachment because dma_buf_attach
> always makes new attachments. To resolve this exporter should search all
> different attachment from same importer of dma-buf and it seems more
> complex than importer private data to me.
> 
> If I misunderstood something, please let me know.

Like I've said above, just fix this in the exporter. If an importer sees
two different dma_bufs it can very well presume that it those two indeed
point to different backing storage.

This will be even more important if we attach fences two dma_bufs. If your
broken exporter creates multiple dma_bufs each one of them will have their
own fences attached, leading to a complete disasters. Ok, strictly
speaking if you keep the same reservation pointer for each dma_buf it'll
work, but that's just a detail of how you solve this in the exporter.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
