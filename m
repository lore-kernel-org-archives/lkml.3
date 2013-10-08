Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3JHOzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:55:50 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43540 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:55:49 -0400
Date: Tue, 8 Oct 2013 10:55:41 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH] drm/radeon: fixup locking inversion between mmap_sem
 and reservations
Message-ID: <20131008145540.GB2355@gmail.com>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
 <5231E18D.7070306@canonical.com>
 <5231EF5A.7010901@vmware.com>
 <52323734.4070908@canonical.com>
 <5232A39B.5040205@vmware.com>
 <52541350.5060807@canonical.com>
 <20131008143354.GA2355@gmail.com>
 <52541A7E.6050807@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52541A7E.6050807@vodafone.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 04:45:18PM +0200, Christian König wrote:
> Am 08.10.2013 16:33, schrieb Jerome Glisse:
> >On Tue, Oct 08, 2013 at 04:14:40PM +0200, Maarten Lankhorst wrote:
> >>Allocate and copy all kernel memory before doing reservations. This prevents a locking
> >>inversion between mmap_sem and reservation_class, and allows us to drop the trylocking
> >>in ttm_bo_vm_fault without upsetting lockdep.
> >>
> >>Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> >I would say NAK. Current code only allocate temporary page in AGP case.
> >So AGP case is userspace -> temp page -> cs checker -> radeon ib.
> >
> >Non AGP is directly memcpy to radeon IB.
> >
> >Your patch allocate memory memcpy userspace to it and it will then be
> >memcpy to IB. Which means you introduce an extra memcpy in the process
> >not something we want.
> 
> Totally agree. Additional to that there is no good reason to provide
> anything else than anonymous system memory to the CS ioctl, so the
> dependency between the mmap_sem and reservations are not really
> clear to me.
> 
> Christian.

I think is that in other code path you take mmap_sem first then reserve
bo. But here we reserve bo and then we take mmap_sem because of copy
from user.

Cheers,
Jerome

> 
> >Cheers,
> >Jerome
> >
> >>---
> >>diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
> >>index 01a3ec8..efa9bca 100644
> >>--- a/drivers/gpu/drm/radeon/r600_cs.c
> >>+++ b/drivers/gpu/drm/radeon/r600_cs.c
> >>@@ -2391,18 +2391,13 @@ int r600_cs_legacy(struct drm_device *dev, void *data, struct drm_file *filp,
> >>  	ib_chunk = &parser.chunks[parser.chunk_ib_idx];
> >>  	parser.ib.length_dw = ib_chunk->length_dw;
> >>  	*l = parser.ib.length_dw;
> >>+	memcpy(ib, ib_chunk->kdata, ib_chunk->length_dw * 4);
> >>  	r = r600_cs_parse(&parser);
> >>  	if (r) {
> >>  		DRM_ERROR("Invalid command stream !\n");
> >>  		r600_cs_parser_fini(&parser, r);
> >>  		return r;
> >>  	}
> >>-	r = radeon_cs_finish_pages(&parser);
> >>-	if (r) {
> >>-		DRM_ERROR("Invalid command stream !\n");
> >>-		r600_cs_parser_fini(&parser, r);
> >>-		return r;
> >>-	}
> >>  	r600_cs_parser_fini(&parser, r);
> >>  	return r;
> >>  }
> >>diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> >>index e067024..c52bb5e 100644
> >>--- a/drivers/gpu/drm/radeon/radeon.h
> >>+++ b/drivers/gpu/drm/radeon/radeon.h
> >>@@ -983,12 +983,7 @@ struct radeon_cs_reloc {
> >>  struct radeon_cs_chunk {
> >>  	uint32_t		chunk_id;
> >>  	uint32_t		length_dw;
> >>-	int			kpage_idx[2];
> >>-	uint32_t		*kpage[2];
> >>  	uint32_t		*kdata;
> >>-	void __user		*user_ptr;
> >>-	int			last_copied_page;
> >>-	int			last_page_index;
> >>  };
> >>  struct radeon_cs_parser {
> >>@@ -1027,8 +1022,13 @@ struct radeon_cs_parser {
> >>  	struct radeon_sa_bo	*cpu_sema;
> >>  };
> >>-extern int radeon_cs_finish_pages(struct radeon_cs_parser *p);
> >>-extern u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx);
> >>+static inline u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
> >>+{
> >>+	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
> >>+
> >>+	return ibc->kdata[idx];
> >>+}
> >>+
> >>  struct radeon_cs_packet {
> >>  	unsigned	idx;
> >>diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
> >>index 7d7322e..98d8898 100644
> >>--- a/drivers/gpu/drm/radeon/radeon_cs.c
> >>+++ b/drivers/gpu/drm/radeon/radeon_cs.c
> >>@@ -217,9 +217,7 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
> >>  			return -EFAULT;
> >>  		}
> >>  		p->chunks[i].length_dw = user_chunk.length_dw;
> >>-		p->chunks[i].kdata = NULL;
> >>  		p->chunks[i].chunk_id = user_chunk.chunk_id;
> >>-		p->chunks[i].user_ptr = (void __user *)(unsigned long)user_chunk.chunk_data;
> >>  		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_RELOCS) {
> >>  			p->chunk_relocs_idx = i;
> >>  		}
> >>@@ -242,25 +240,22 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
> >>  				return -EINVAL;
> >>  		}
> >>-		cdata = (uint32_t *)(unsigned long)user_chunk.chunk_data;
> >>-		if ((p->chunks[i].chunk_id == RADEON_CHUNK_ID_RELOCS) ||
> >>-		    (p->chunks[i].chunk_id == RADEON_CHUNK_ID_FLAGS)) {
> >>-			size = p->chunks[i].length_dw * sizeof(uint32_t);
> >>-			p->chunks[i].kdata = kmalloc(size, GFP_KERNEL);
> >>-			if (p->chunks[i].kdata == NULL) {
> >>-				return -ENOMEM;
> >>-			}
> >>-			if (DRM_COPY_FROM_USER(p->chunks[i].kdata,
> >>-					       p->chunks[i].user_ptr, size)) {
> >>-				return -EFAULT;
> >>-			}
> >>-			if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_FLAGS) {
> >>-				p->cs_flags = p->chunks[i].kdata[0];
> >>-				if (p->chunks[i].length_dw > 1)
> >>-					ring = p->chunks[i].kdata[1];
> >>-				if (p->chunks[i].length_dw > 2)
> >>-					priority = (s32)p->chunks[i].kdata[2];
> >>-			}
> >>+		size = p->chunks[i].length_dw;
> >>+		p->chunks[i].kdata = drm_malloc_ab(size, sizeof(uint32_t));
> >>+		size *= sizeof(uint32_t);
> >>+		if (p->chunks[i].kdata == NULL) {
> >>+			return -ENOMEM;
> >>+		}
> >>+		cdata = (void __user *)(unsigned long)user_chunk.chunk_data;
> >>+		if (DRM_COPY_FROM_USER(p->chunks[i].kdata, cdata, size)) {
> >>+			return -EFAULT;
> >>+		}
> >>+		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_FLAGS) {
> >>+			p->cs_flags = p->chunks[i].kdata[0];
> >>+			if (p->chunks[i].length_dw > 1)
> >>+				ring = p->chunks[i].kdata[1];
> >>+			if (p->chunks[i].length_dw > 2)
> >>+				priority = (s32)p->chunks[i].kdata[2];
> >>  		}
> >>  	}
> >>@@ -283,34 +278,6 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
> >>  		}
> >>  	}
> >>-	/* deal with non-vm */
> >>-	if ((p->chunk_ib_idx != -1) &&
> >>-	    ((p->cs_flags & RADEON_CS_USE_VM) == 0) &&
> >>-	    (p->chunks[p->chunk_ib_idx].chunk_id == RADEON_CHUNK_ID_IB)) {
> >>-		if (p->chunks[p->chunk_ib_idx].length_dw > (16 * 1024)) {
> >>-			DRM_ERROR("cs IB too big: %d\n",
> >>-				  p->chunks[p->chunk_ib_idx].length_dw);
> >>-			return -EINVAL;
> >>-		}
> >>-		if (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) {
> >>-			p->chunks[p->chunk_ib_idx].kpage[0] = kmalloc(PAGE_SIZE, GFP_KERNEL);
> >>-			p->chunks[p->chunk_ib_idx].kpage[1] = kmalloc(PAGE_SIZE, GFP_KERNEL);
> >>-			if (p->chunks[p->chunk_ib_idx].kpage[0] == NULL ||
> >>-			    p->chunks[p->chunk_ib_idx].kpage[1] == NULL) {
> >>-				kfree(p->chunks[p->chunk_ib_idx].kpage[0]);
> >>-				kfree(p->chunks[p->chunk_ib_idx].kpage[1]);
> >>-				p->chunks[p->chunk_ib_idx].kpage[0] = NULL;
> >>-				p->chunks[p->chunk_ib_idx].kpage[1] = NULL;
> >>-				return -ENOMEM;
> >>-			}
> >>-		}
> >>-		p->chunks[p->chunk_ib_idx].kpage_idx[0] = -1;
> >>-		p->chunks[p->chunk_ib_idx].kpage_idx[1] = -1;
> >>-		p->chunks[p->chunk_ib_idx].last_copied_page = -1;
> >>-		p->chunks[p->chunk_ib_idx].last_page_index =
> >>-			((p->chunks[p->chunk_ib_idx].length_dw * 4) - 1) / PAGE_SIZE;
> >>-	}
> >>-
> >>  	return 0;
> >>  }
> >>@@ -450,13 +417,8 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error, bo
> >>  	kfree(parser->track);
> >>  	kfree(parser->relocs);
> >>  	kfree(parser->relocs_ptr);
> >>-	for (i = 0; i < parser->nchunks; i++) {
> >>-		kfree(parser->chunks[i].kdata);
> >>-		if ((parser->rdev->flags & RADEON_IS_AGP)) {
> >>-			kfree(parser->chunks[i].kpage[0]);
> >>-			kfree(parser->chunks[i].kpage[1]);
> >>-		}
> >>-	}
> >>+	for (i = 0; i < parser->nchunks; i++)
> >>+		drm_free_large(parser->chunks[i].kdata);
> >>  	kfree(parser->chunks);
> >>  	kfree(parser->chunks_array);
> >>  	radeon_ib_free(parser->rdev, &parser->ib);
> >>@@ -483,17 +445,15 @@ static int radeon_cs_ib_chunk(struct radeon_device *rdev,
> >>  		DRM_ERROR("Failed to get ib !\n");
> >>  		return r;
> >>  	}
> >>+
> >>+	memcpy(parser->ib.ptr, ib_chunk->kdata, ib_chunk->length_dw * 4);
> >>  	parser->ib.length_dw = ib_chunk->length_dw;
> >>+
> >>  	r = radeon_cs_parse(rdev, parser->ring, parser);
> >>  	if (r || parser->parser_error) {
> >>  		DRM_ERROR("Invalid command stream !\n");
> >>  		return r;
> >>  	}
> >>-	r = radeon_cs_finish_pages(parser);
> >>-	if (r) {
> >>-		DRM_ERROR("Invalid command stream !\n");
> >>-		return r;
> >>-	}
> >>  	if (parser->ring == R600_RING_TYPE_UVD_INDEX)
> >>  		radeon_uvd_note_usage(rdev);
> >>@@ -555,10 +515,8 @@ static int radeon_cs_ib_vm_chunk(struct radeon_device *rdev,
> >>  		parser->const_ib.is_const_ib = true;
> >>  		parser->const_ib.length_dw = ib_chunk->length_dw;
> >>  		/* Copy the packet into the IB */
> >>-		if (DRM_COPY_FROM_USER(parser->const_ib.ptr, ib_chunk->user_ptr,
> >>-				       ib_chunk->length_dw * 4)) {
> >>-			return -EFAULT;
> >>-		}
> >>+		memcpy(parser->const_ib.ptr, ib_chunk->kdata,
> >>+		       ib_chunk->length_dw * 4);
> >>  		r = radeon_ring_ib_parse(rdev, parser->ring, &parser->const_ib);
> >>  		if (r) {
> >>  			return r;
> >>@@ -578,10 +536,7 @@ static int radeon_cs_ib_vm_chunk(struct radeon_device *rdev,
> >>  	}
> >>  	parser->ib.length_dw = ib_chunk->length_dw;
> >>  	/* Copy the packet into the IB */
> >>-	if (DRM_COPY_FROM_USER(parser->ib.ptr, ib_chunk->user_ptr,
> >>-			       ib_chunk->length_dw * 4)) {
> >>-		return -EFAULT;
> >>-	}
> >>+	memcpy(parser->ib.ptr, ib_chunk->kdata, ib_chunk->length_dw * 4);
> >>  	r = radeon_ring_ib_parse(rdev, parser->ring, &parser->ib);
> >>  	if (r) {
> >>  		return r;
> >>@@ -704,97 +659,6 @@ int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
> >>  	return r;
> >>  }
> >>-int radeon_cs_finish_pages(struct radeon_cs_parser *p)
> >>-{
> >>-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
> >>-	int i;
> >>-	int size = PAGE_SIZE;
> >>-
> >>-	for (i = ibc->last_copied_page + 1; i <= ibc->last_page_index; i++) {
> >>-		if (i == ibc->last_page_index) {
> >>-			size = (ibc->length_dw * 4) % PAGE_SIZE;
> >>-			if (size == 0)
> >>-				size = PAGE_SIZE;
> >>-		}
> >>-		
> >>-		if (DRM_COPY_FROM_USER(p->ib.ptr + (i * (PAGE_SIZE/4)),
> >>-				       ibc->user_ptr + (i * PAGE_SIZE),
> >>-				       size))
> >>-			return -EFAULT;
> >>-	}
> >>-	return 0;
> >>-}
> >>-
> >>-static int radeon_cs_update_pages(struct radeon_cs_parser *p, int pg_idx)
> >>-{
> >>-	int new_page;
> >>-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
> >>-	int i;
> >>-	int size = PAGE_SIZE;
> >>-	bool copy1 = (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) ?
> >>-		false : true;
> >>-
> >>-	for (i = ibc->last_copied_page + 1; i < pg_idx; i++) {
> >>-		if (DRM_COPY_FROM_USER(p->ib.ptr + (i * (PAGE_SIZE/4)),
> >>-				       ibc->user_ptr + (i * PAGE_SIZE),
> >>-				       PAGE_SIZE)) {
> >>-			p->parser_error = -EFAULT;
> >>-			return 0;
> >>-		}
> >>-	}
> >>-
> >>-	if (pg_idx == ibc->last_page_index) {
> >>-		size = (ibc->length_dw * 4) % PAGE_SIZE;
> >>-		if (size == 0)
> >>-			size = PAGE_SIZE;
> >>-	}
> >>-
> >>-	new_page = ibc->kpage_idx[0] < ibc->kpage_idx[1] ? 0 : 1;
> >>-	if (copy1)
> >>-		ibc->kpage[new_page] = p->ib.ptr + (pg_idx * (PAGE_SIZE / 4));
> >>-
> >>-	if (DRM_COPY_FROM_USER(ibc->kpage[new_page],
> >>-			       ibc->user_ptr + (pg_idx * PAGE_SIZE),
> >>-			       size)) {
> >>-		p->parser_error = -EFAULT;
> >>-		return 0;
> >>-	}
> >>-
> >>-	/* copy to IB for non single case */
> >>-	if (!copy1)
> >>-		memcpy((void *)(p->ib.ptr+(pg_idx*(PAGE_SIZE/4))), ibc->kpage[new_page], size);
> >>-
> >>-	ibc->last_copied_page = pg_idx;
> >>-	ibc->kpage_idx[new_page] = pg_idx;
> >>-
> >>-	return new_page;
> >>-}
> >>-
> >>-u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
> >>-{
> >>-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
> >>-	u32 pg_idx, pg_offset;
> >>-	u32 idx_value = 0;
> >>-	int new_page;
> >>-
> >>-	pg_idx = (idx * 4) / PAGE_SIZE;
> >>-	pg_offset = (idx * 4) % PAGE_SIZE;
> >>-
> >>-	if (ibc->kpage_idx[0] == pg_idx)
> >>-		return ibc->kpage[0][pg_offset/4];
> >>-	if (ibc->kpage_idx[1] == pg_idx)
> >>-		return ibc->kpage[1][pg_offset/4];
> >>-
> >>-	new_page = radeon_cs_update_pages(p, pg_idx);
> >>-	if (new_page < 0) {
> >>-		p->parser_error = new_page;
> >>-		return 0;
> >>-	}
> >>-
> >>-	idx_value = ibc->kpage[new_page][pg_offset/4];
> >>-	return idx_value;
> >>-}
> >>-
> >>  /**
> >>   * radeon_cs_packet_parse() - parse cp packet and point ib index to next packet
> >>   * @parser:	parser structure holding parsing context.
> >>
> >>_______________________________________________
> >>dri-devel mailing list
> >>dri-devel@lists.freedesktop.org
> >>http://lists.freedesktop.org/mailman/listinfo/dri-devel
> >_______________________________________________
> >dri-devel mailing list
> >dri-devel@lists.freedesktop.org
> >http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
