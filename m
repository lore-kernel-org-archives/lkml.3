Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3FEIio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:38:44 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47895 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3FEIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:38:40 -0400
Date: Wed, 5 Jun 2013 10:38:33 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: =?utf-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for
 reimporting
Message-ID: <20130605083833.GG15743@phenom.ffwll.local>
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
 <20130531152956.GX15743@phenom.ffwll.local>
 <51ADC48E.80907@samsung.com>
 <20130604125558.GB15743@phenom.ffwll.local>
 <51AEA80B.8030008@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51AEA80B.8030008@samsung.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:52:59AM +0900, 김승우 wrote:
> 
> 
> On 2013년 06월 04일 21:55, Daniel Vetter wrote:
> > On Tue, Jun 04, 2013 at 07:42:22PM +0900, 김승우 wrote:
> >>
> >>
> >> On 2013년 06월 01일 00:29, Daniel Vetter wrote:
> >>> On Fri, May 31, 2013 at 07:22:24PM +0900, 김승우 wrote:
> >>>> Hello Daniel,
> >>>>
> >>>> Thanks for your comment.
> >>>>
> >>>> On 2013년 05월 31일 18:14, Daniel Vetter wrote:
> >>>>> On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> >>>>>> importer private data in dma-buf attachment can be used by importer to
> >>>>>> reimport same dma-buf.
> >>>>>>
> >>>>>> Seung-Woo Kim (2):
> >>>>>>   dma-buf: add importer private data to attachment
> >>>>>>   drm/prime: find gem object from the reimported dma-buf
> >>>>>
> >>>>> Self-import should already work (at least with the latest refcount
> >>>>> fixes merged). At least the tests to check both re-import on the same
> >>>>> drm fd and on a different all work as expected now.
> >>>>
> >>>> Currently, prime works well for all case including self-importing,
> >>>> importing, and reimporting as you describe. Just, importing dma-buf from
> >>>> other driver twice with different drm_fd, each import create its own gem
> >>>> object even two import is done for same buffer because prime_priv is in
> >>>> struct drm_file. This means mapping to the device is done also twice.
> >>>> IMHO, these duplicated creations and maps are not necessary if drm can
> >>>> find previous import in different prime_priv.
> >>>
> >>> Well, that's imo a bug with the other driver. If it doesn't export
> >>> something really simple (e.g. contiguous memory which doesn't require any
> >>> mmio resources at all) it should have a cache of exported dma_buf fds so
> >>> that it hands out the same dma_buf every time.
> >>
> >> Hm, all existing dma-buf exporter including i915 driver implements its
> >> map_dma_buf callback as allocating scatter-gather table with pages in
> >> its buffer and calling dma_map_sg() with the sgt. With different
> >> drm_fds, importing one dma-buf *twice*, then importer calls
> >> dma_buf_attach() and dma_buf_map_attachment() twice at least in drm
> >> importer because re-importing case can only checked with prime_priv in
> >> drm_file as I described.
> > 
> > Well, but thanks to all the self-import and re-import checks, it's
> > _impossible_ to import the same dma_buf twice without noticing (presuming
> > both importer and exporter are drm devices).
> 
> No, it is possible. Prime function, drm_gem_prime_fd_to_handle(), checks
> re-import with following code.
> 
> ret = drm_prime_lookup_buf_handle(&file_priv->prime,
> 		dma_buf, handle);
> 
> Unfortunately, file_priv is allocated per each open of drm node so this
> code can only find re-import within same drm open context.
> 
> And driver specific import functions, like drm_gem_prime_import(), only
> check self-import like following code.
> 
> if (dma_buf->ops == &drm_gem_prime_dmabuf_ops) {
> 	obj = dma_buf->priv;
> 	if (obj->dev == dev) {
> 		/* ... */
> 	}
> }
> 
> This means some application like following can make re-import to
> different gem objects.
> 
> int drm_fd1, drm_fd2, ret;
> int dma_buf_fd;
> struct drm_prime_handle prime1, prime2;
> 
> drm_fd1 = open(DRM_NODE, O_RDWR, 0);
> drm_fd2 = open(DRM_NODE, O_RDWR, 0);
> 
> /* get some dma-buf_fd from other dma-buf exporter */
> prime1.fd = dma_buf_fd;
> prime2.fd = dma_buf_fd;
> 
> ret = ioctl(drm_fd1, DRM_IOCTL_PRIME_FD_TO_HANDLE, &prime1);
> ret = ioctl(drm_fd2, DRM_IOCTL_PRIME_FD_TO_HANDLE, &prime2);
> 
> This will import same dma-buf twice as different GEM object because
> above checking codes can not check already imported gem object from the
> dma-buf.

Oh right, now I understand. Somehow I've always thought we already take
care of this case, since I remember discussing it.

To fix that we need a device-global import cache similar to how we already
have one for each file_priv. I think we can reuse the same locking and
refcounting scheme, but I haven't checked. The commit messages of the past
few prime changes have fairly good explanations of the tricky stuff going
on there.

Sorry for being dense for so long, I should have checked my idea of what
the drm prime code does with reality sooner ;-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
