Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3JIMhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:37:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3JIMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:37:07 -0400
Message-ID: <52554DE9.80107@canonical.com>
Date: Wed, 09 Oct 2013 14:36:57 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH v2] drm/radeon: fixup locking inversion between, mmap_sem
 and reservations
References: <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232A39B.5040205@vmware.com> <52541350.5060807@canonical.com> <20131008143354.GA2355@gmail.com> <52541A7E.6050807@vodafone.de> <20131008145540.GB2355@gmail.com> <525432EF.3050005@vmware.com> <20131008164737.GA2782@gmail.com> <525439A3.4050201@vmware.com>
In-Reply-To: <525439A3.4050201@vmware.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 08-10-13 18:58, Thomas Hellstrom schreef:
> On 10/08/2013 06:47 PM, Jerome Glisse wrote:
>> On Tue, Oct 08, 2013 at 06:29:35PM +0200, Thomas Hellstrom wrote:
>>> On 10/08/2013 04:55 PM, Jerome Glisse wrote:
>>>> On Tue, Oct 08, 2013 at 04:45:18PM +0200, Christian König wrote:
>>>>> Am 08.10.2013 16:33, schrieb Jerome Glisse:
>>>>>> On Tue, Oct 08, 2013 at 04:14:40PM +0200, Maarten Lankhorst wrote:
>>>>>>> Allocate and copy all kernel memory before doing reservations. This prevents a locking
>>>>>>> inversion between mmap_sem and reservation_class, and allows us to drop the trylocking
>>>>>>> in ttm_bo_vm_fault without upsetting lockdep.
>>>>>>>
>>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>> I would say NAK. Current code only allocate temporary page in AGP case.
>>>>>> So AGP case is userspace -> temp page -> cs checker -> radeon ib.
>>>>>>
>>>>>> Non AGP is directly memcpy to radeon IB.
>>>>>>
>>>>>> Your patch allocate memory memcpy userspace to it and it will then be
>>>>>> memcpy to IB. Which means you introduce an extra memcpy in the process
>>>>>> not something we want.
>>>>> Totally agree. Additional to that there is no good reason to provide
>>>>> anything else than anonymous system memory to the CS ioctl, so the
>>>>> dependency between the mmap_sem and reservations are not really
>>>>> clear to me.
>>>>>
>>>>> Christian.
>>>> I think is that in other code path you take mmap_sem first then reserve
>>>> bo. But here we reserve bo and then we take mmap_sem because of copy
>>> >from user.
>>>> Cheers,
>>>> Jerome
>>>>
>>> Actually the log message is a little confusing. I think the mmap_sem
>>> locking inversion problem is orthogonal to what's being fixed here.
>>>
>>> This patch fixes the possible recursive bo::reserve caused by
>>> malicious user-space handing a pointer to ttm memory so that the ttm
>>> fault handler is called when bos are already reserved. That may
>>> cause a (possibly interruptible) livelock.
>>>
>>> Once that is fixed, we are free to choose the mmap_sem ->
>>> bo::reserve locking order. Currently it's bo::reserve->mmap_sem(),
>>> but the hack required in the ttm fault handler is admittedly a bit
>>> ugly.  The plan is to change the locking order to
>>> mmap_sem->bo::reserve
>>>
>>> I'm not sure if it applies to this particular case, but it should be
>>> possible to make sure that copy_from_user_inatomic() will always
>>> succeed, by making sure the pages are present using
>>> get_user_pages(), and release the pages after
>>> copy_from_user_inatomic() is done. That way there's no need for a
>>> double memcpy slowpath, but if the copied data is very fragmented I
>>> guess the resulting code may look ugly. The get_user_pages()
>>> function will return an error if it hits TTM pages.
>>>
>>> /Thomas
>> get_user_pages + copy_from_user_inatomic is overkill. We should just
>> do get_user_pages which fails with ttm memory and then use copy_highpage
>> helper.
>>
>> Cheers,
>> Jerome
> Yeah, it may well be that that's the preferred solution.
>
> /Thomas
>
I still disagree, and shuffled radeon_ib_get around to be called sooner.

How does the patch below look?
8<-------
Allocate and copy all kernel memory before doing reservations. This prevents a locking
inversion between mmap_sem and reservation_class, and allows us to drop the trylocking
in ttm_bo_vm_fault without upsetting lockdep.

Changes since v1:
- Kill extra memcpy for !AGP case.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/radeon/r600_cs.c   |  16 +-
 drivers/gpu/drm/radeon/radeon.h    |  15 +-
 drivers/gpu/drm/radeon/radeon_cs.c | 298 ++++++++++++-------------------------
 3 files changed, 106 insertions(+), 223 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 01a3ec8..1abaa2b 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2328,13 +2328,8 @@ static void r600_cs_parser_fini(struct radeon_cs_parser *parser, int error)
 	unsigned i;
 
 	kfree(parser->relocs);
-	for (i = 0; i < parser->nchunks; i++) {
-		kfree(parser->chunks[i].kdata);
-		if (parser->rdev && (parser->rdev->flags & RADEON_IS_AGP)) {
-			kfree(parser->chunks[i].kpage[0]);
-			kfree(parser->chunks[i].kpage[1]);
-		}
-	}
+	for (i = 0; i < parser->nchunks; i++)
+		drm_free_large(parser->chunks[i].kdata);
 	kfree(parser->chunks);
 	kfree(parser->chunks_array);
 }
@@ -2391,13 +2386,12 @@ int r600_cs_legacy(struct drm_device *dev, void *data, struct drm_file *filp,
 	ib_chunk = &parser.chunks[parser.chunk_ib_idx];
 	parser.ib.length_dw = ib_chunk->length_dw;
 	*l = parser.ib.length_dw;
-	r = r600_cs_parse(&parser);
-	if (r) {
-		DRM_ERROR("Invalid command stream !\n");
+	if (DRM_COPY_FROM_USER(ib, ib_chunk->user_ptr, ib_chunk->length_dw * 4)) {
+		r = -EFAULT;
 		r600_cs_parser_fini(&parser, r);
 		return r;
 	}
-	r = radeon_cs_finish_pages(&parser);
+	r = r600_cs_parse(&parser);
 	if (r) {
 		DRM_ERROR("Invalid command stream !\n");
 		r600_cs_parser_fini(&parser, r);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index a400ac1..837c577 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -967,12 +967,8 @@ struct radeon_cs_reloc {
 struct radeon_cs_chunk {
 	uint32_t		chunk_id;
 	uint32_t		length_dw;
-	int			kpage_idx[2];
-	uint32_t		*kpage[2];
 	uint32_t		*kdata;
 	void __user		*user_ptr;
-	int			last_copied_page;
-	int			last_page_index;
 };
 
 struct radeon_cs_parser {
@@ -1007,8 +1003,15 @@ struct radeon_cs_parser {
 	struct ww_acquire_ctx	ticket;
 };
 
-extern int radeon_cs_finish_pages(struct radeon_cs_parser *p);
-extern u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx);
+static inline u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
+{
+	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
+
+	if (ibc->kdata)
+		return ibc->kdata[idx];
+	return p->ib.ptr[idx];
+}
+
 
 struct radeon_cs_packet {
 	unsigned	idx;
diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 66c2228..c8ab019 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -213,9 +213,7 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 			return -EFAULT;
 		}
 		p->chunks[i].length_dw = user_chunk.length_dw;
-		p->chunks[i].kdata = NULL;
 		p->chunks[i].chunk_id = user_chunk.chunk_id;
-		p->chunks[i].user_ptr = (void __user *)(unsigned long)user_chunk.chunk_data;
 		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_RELOCS) {
 			p->chunk_relocs_idx = i;
 		}
@@ -238,25 +236,31 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 				return -EINVAL;
 		}
 
-		cdata = (uint32_t *)(unsigned long)user_chunk.chunk_data;
-		if ((p->chunks[i].chunk_id == RADEON_CHUNK_ID_RELOCS) ||
-		    (p->chunks[i].chunk_id == RADEON_CHUNK_ID_FLAGS)) {
-			size = p->chunks[i].length_dw * sizeof(uint32_t);
-			p->chunks[i].kdata = kmalloc(size, GFP_KERNEL);
-			if (p->chunks[i].kdata == NULL) {
-				return -ENOMEM;
-			}
-			if (DRM_COPY_FROM_USER(p->chunks[i].kdata,
-					       p->chunks[i].user_ptr, size)) {
-				return -EFAULT;
-			}
-			if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_FLAGS) {
-				p->cs_flags = p->chunks[i].kdata[0];
-				if (p->chunks[i].length_dw > 1)
-					ring = p->chunks[i].kdata[1];
-				if (p->chunks[i].length_dw > 2)
-					priority = (s32)p->chunks[i].kdata[2];
-			}
+		size = p->chunks[i].length_dw;
+		cdata = (void __user *)(unsigned long)user_chunk.chunk_data;
+		p->chunks[i].user_ptr = cdata;
+		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_CONST_IB)
+			continue;
+
+		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_IB) {
+			if (!p->rdev || !(p->rdev->flags & RADEON_IS_AGP))
+				continue;
+		}
+
+		p->chunks[i].kdata = drm_malloc_ab(size, sizeof(uint32_t));
+		size *= sizeof(uint32_t);
+		if (p->chunks[i].kdata == NULL) {
+			return -ENOMEM;
+		}
+		if (DRM_COPY_FROM_USER(p->chunks[i].kdata, cdata, size)) {
+			return -EFAULT;
+		}
+		if (p->chunks[i].chunk_id == RADEON_CHUNK_ID_FLAGS) {
+			p->cs_flags = p->chunks[i].kdata[0];
+			if (p->chunks[i].length_dw > 1)
+				ring = p->chunks[i].kdata[1];
+			if (p->chunks[i].length_dw > 2)
+				priority = (s32)p->chunks[i].kdata[2];
 		}
 	}
 
@@ -279,34 +283,6 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 		}
 	}
 
-	/* deal with non-vm */
-	if ((p->chunk_ib_idx != -1) &&
-	    ((p->cs_flags & RADEON_CS_USE_VM) == 0) &&
-	    (p->chunks[p->chunk_ib_idx].chunk_id == RADEON_CHUNK_ID_IB)) {
-		if (p->chunks[p->chunk_ib_idx].length_dw > (16 * 1024)) {
-			DRM_ERROR("cs IB too big: %d\n",
-				  p->chunks[p->chunk_ib_idx].length_dw);
-			return -EINVAL;
-		}
-		if (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) {
-			p->chunks[p->chunk_ib_idx].kpage[0] = kmalloc(PAGE_SIZE, GFP_KERNEL);
-			p->chunks[p->chunk_ib_idx].kpage[1] = kmalloc(PAGE_SIZE, GFP_KERNEL);
-			if (p->chunks[p->chunk_ib_idx].kpage[0] == NULL ||
-			    p->chunks[p->chunk_ib_idx].kpage[1] == NULL) {
-				kfree(p->chunks[p->chunk_ib_idx].kpage[0]);
-				kfree(p->chunks[p->chunk_ib_idx].kpage[1]);
-				p->chunks[p->chunk_ib_idx].kpage[0] = NULL;
-				p->chunks[p->chunk_ib_idx].kpage[1] = NULL;
-				return -ENOMEM;
-			}
-		}
-		p->chunks[p->chunk_ib_idx].kpage_idx[0] = -1;
-		p->chunks[p->chunk_ib_idx].kpage_idx[1] = -1;
-		p->chunks[p->chunk_ib_idx].last_copied_page = -1;
-		p->chunks[p->chunk_ib_idx].last_page_index =
-			((p->chunks[p->chunk_ib_idx].length_dw * 4) - 1) / PAGE_SIZE;
-	}
-
 	return 0;
 }
 
@@ -340,13 +316,8 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error, bo
 	kfree(parser->track);
 	kfree(parser->relocs);
 	kfree(parser->relocs_ptr);
-	for (i = 0; i < parser->nchunks; i++) {
-		kfree(parser->chunks[i].kdata);
-		if ((parser->rdev->flags & RADEON_IS_AGP)) {
-			kfree(parser->chunks[i].kpage[0]);
-			kfree(parser->chunks[i].kpage[1]);
-		}
-	}
+	for (i = 0; i < parser->nchunks; i++)
+		drm_free_large(parser->chunks[i].kdata);
 	kfree(parser->chunks);
 	kfree(parser->chunks_array);
 	radeon_ib_free(parser->rdev, &parser->ib);
@@ -356,7 +327,6 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error, bo
 static int radeon_cs_ib_chunk(struct radeon_device *rdev,
 			      struct radeon_cs_parser *parser)
 {
-	struct radeon_cs_chunk *ib_chunk;
 	int r;
 
 	if (parser->chunk_ib_idx == -1)
@@ -365,28 +335,11 @@ static int radeon_cs_ib_chunk(struct radeon_device *rdev,
 	if (parser->cs_flags & RADEON_CS_USE_VM)
 		return 0;
 
-	ib_chunk = &parser->chunks[parser->chunk_ib_idx];
-	/* Copy the packet into the IB, the parser will read from the
-	 * input memory (cached) and write to the IB (which can be
-	 * uncached).
-	 */
-	r =  radeon_ib_get(rdev, parser->ring, &parser->ib,
-			   NULL, ib_chunk->length_dw * 4);
-	if (r) {
-		DRM_ERROR("Failed to get ib !\n");
-		return r;
-	}
-	parser->ib.length_dw = ib_chunk->length_dw;
 	r = radeon_cs_parse(rdev, parser->ring, parser);
 	if (r || parser->parser_error) {
 		DRM_ERROR("Invalid command stream !\n");
 		return r;
 	}
-	r = radeon_cs_finish_pages(parser);
-	if (r) {
-		DRM_ERROR("Invalid command stream !\n");
-		return r;
-	}
 
 	if (parser->ring == R600_RING_TYPE_UVD_INDEX)
 		radeon_uvd_note_usage(rdev);
@@ -424,7 +377,6 @@ static int radeon_bo_vm_update_pte(struct radeon_cs_parser *parser,
 static int radeon_cs_ib_vm_chunk(struct radeon_device *rdev,
 				 struct radeon_cs_parser *parser)
 {
-	struct radeon_cs_chunk *ib_chunk;
 	struct radeon_fpriv *fpriv = parser->filp->driver_priv;
 	struct radeon_vm *vm = &fpriv->vm;
 	int r;
@@ -434,49 +386,13 @@ static int radeon_cs_ib_vm_chunk(struct radeon_device *rdev,
 	if ((parser->cs_flags & RADEON_CS_USE_VM) == 0)
 		return 0;
 
-	if ((rdev->family >= CHIP_TAHITI) &&
-	    (parser->chunk_const_ib_idx != -1)) {
-		ib_chunk = &parser->chunks[parser->chunk_const_ib_idx];
-		if (ib_chunk->length_dw > RADEON_IB_VM_MAX_SIZE) {
-			DRM_ERROR("cs IB CONST too big: %d\n", ib_chunk->length_dw);
-			return -EINVAL;
-		}
-		r =  radeon_ib_get(rdev, parser->ring, &parser->const_ib,
-				   vm, ib_chunk->length_dw * 4);
-		if (r) {
-			DRM_ERROR("Failed to get const ib !\n");
-			return r;
-		}
-		parser->const_ib.is_const_ib = true;
-		parser->const_ib.length_dw = ib_chunk->length_dw;
-		/* Copy the packet into the IB */
-		if (DRM_COPY_FROM_USER(parser->const_ib.ptr, ib_chunk->user_ptr,
-				       ib_chunk->length_dw * 4)) {
-			return -EFAULT;
-		}
+	if (parser->const_ib.length_dw) {
 		r = radeon_ring_ib_parse(rdev, parser->ring, &parser->const_ib);
 		if (r) {
 			return r;
 		}
 	}
 
-	ib_chunk = &parser->chunks[parser->chunk_ib_idx];
-	if (ib_chunk->length_dw > RADEON_IB_VM_MAX_SIZE) {
-		DRM_ERROR("cs IB too big: %d\n", ib_chunk->length_dw);
-		return -EINVAL;
-	}
-	r =  radeon_ib_get(rdev, parser->ring, &parser->ib,
-			   vm, ib_chunk->length_dw * 4);
-	if (r) {
-		DRM_ERROR("Failed to get ib !\n");
-		return r;
-	}
-	parser->ib.length_dw = ib_chunk->length_dw;
-	/* Copy the packet into the IB */
-	if (DRM_COPY_FROM_USER(parser->ib.ptr, ib_chunk->user_ptr,
-			       ib_chunk->length_dw * 4)) {
-		return -EFAULT;
-	}
 	r = radeon_ring_ib_parse(rdev, parser->ring, &parser->ib);
 	if (r) {
 		return r;
@@ -528,6 +444,62 @@ static int radeon_cs_handle_lockup(struct radeon_device *rdev, int r)
 	return r;
 }
 
+static int radeon_cs_ib_fill(struct radeon_device *rdev, struct radeon_cs_parser *parser)
+{
+	struct radeon_cs_chunk *ib_chunk;
+	struct radeon_vm *vm = NULL;
+	int r;
+
+	if (parser->chunk_ib_idx == -1)
+		return 0;
+
+	if (parser->cs_flags & RADEON_CS_USE_VM) {
+		struct radeon_fpriv *fpriv = parser->filp->driver_priv;
+		vm = &fpriv->vm;
+
+		if ((rdev->family >= CHIP_TAHITI) &&
+		    (parser->chunk_const_ib_idx != -1)) {
+			ib_chunk = &parser->chunks[parser->chunk_const_ib_idx];
+			if (ib_chunk->length_dw > RADEON_IB_VM_MAX_SIZE) {
+				DRM_ERROR("cs IB CONST too big: %d\n", ib_chunk->length_dw);
+				return -EINVAL;
+			}
+			r =  radeon_ib_get(rdev, parser->ring, &parser->const_ib,
+					   vm, ib_chunk->length_dw * 4);
+			if (r) {
+				DRM_ERROR("Failed to get const ib !\n");
+				return r;
+			}
+			parser->const_ib.is_const_ib = true;
+			parser->const_ib.length_dw = ib_chunk->length_dw;
+			if (DRM_COPY_FROM_USER(parser->const_ib.ptr,
+					       ib_chunk->user_ptr,
+					       ib_chunk->length_dw * 4))
+				return -EFAULT;
+		}
+
+		ib_chunk = &parser->chunks[parser->chunk_ib_idx];
+		if (ib_chunk->length_dw > RADEON_IB_VM_MAX_SIZE) {
+			DRM_ERROR("cs IB too big: %d\n", ib_chunk->length_dw);
+			return -EINVAL;
+		}
+	}
+	ib_chunk = &parser->chunks[parser->chunk_ib_idx];
+
+	r =  radeon_ib_get(rdev, parser->ring, &parser->ib,
+			   vm, ib_chunk->length_dw * 4);
+	if (r) {
+		DRM_ERROR("Failed to get ib !\n");
+		return r;
+	}
+	parser->ib.length_dw = ib_chunk->length_dw;
+	if (ib_chunk->kdata)
+		memcpy(parser->ib.ptr, ib_chunk->kdata, ib_chunk->length_dw * 4);
+	else if (DRM_COPY_FROM_USER(parser->ib.ptr, ib_chunk->user_ptr, ib_chunk->length_dw * 4))
+		return -EFAULT;
+	return 0;
+}
+
 int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct radeon_device *rdev = dev->dev_private;
@@ -553,10 +525,15 @@ int radeon_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		r = radeon_cs_handle_lockup(rdev, r);
 		return r;
 	}
-	r = radeon_cs_parser_relocs(&parser);
-	if (r) {
-		if (r != -ERESTARTSYS)
+
+	r = radeon_cs_ib_fill(rdev, &parser);
+	if (!r) {
+		r = radeon_cs_parser_relocs(&parser);
+		if (r && r != -ERESTARTSYS)
 			DRM_ERROR("Failed to parse relocation %d!\n", r);
+	}
+
+	if (r) {
 		radeon_cs_parser_fini(&parser, r, false);
 		up_read(&rdev->exclusive_lock);
 		r = radeon_cs_handle_lockup(rdev, r);
@@ -580,97 +557,6 @@ out:
 	return r;
 }
 
-int radeon_cs_finish_pages(struct radeon_cs_parser *p)
-{
-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
-	int i;
-	int size = PAGE_SIZE;
-
-	for (i = ibc->last_copied_page + 1; i <= ibc->last_page_index; i++) {
-		if (i == ibc->last_page_index) {
-			size = (ibc->length_dw * 4) % PAGE_SIZE;
-			if (size == 0)
-				size = PAGE_SIZE;
-		}
-		
-		if (DRM_COPY_FROM_USER(p->ib.ptr + (i * (PAGE_SIZE/4)),
-				       ibc->user_ptr + (i * PAGE_SIZE),
-				       size))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static int radeon_cs_update_pages(struct radeon_cs_parser *p, int pg_idx)
-{
-	int new_page;
-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
-	int i;
-	int size = PAGE_SIZE;
-	bool copy1 = (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) ?
-		false : true;
-
-	for (i = ibc->last_copied_page + 1; i < pg_idx; i++) {
-		if (DRM_COPY_FROM_USER(p->ib.ptr + (i * (PAGE_SIZE/4)),
-				       ibc->user_ptr + (i * PAGE_SIZE),
-				       PAGE_SIZE)) {
-			p->parser_error = -EFAULT;
-			return 0;
-		}
-	}
-
-	if (pg_idx == ibc->last_page_index) {
-		size = (ibc->length_dw * 4) % PAGE_SIZE;
-		if (size == 0)
-			size = PAGE_SIZE;
-	}
-
-	new_page = ibc->kpage_idx[0] < ibc->kpage_idx[1] ? 0 : 1;
-	if (copy1)
-		ibc->kpage[new_page] = p->ib.ptr + (pg_idx * (PAGE_SIZE / 4));
-
-	if (DRM_COPY_FROM_USER(ibc->kpage[new_page],
-			       ibc->user_ptr + (pg_idx * PAGE_SIZE),
-			       size)) {
-		p->parser_error = -EFAULT;
-		return 0;
-	}
-
-	/* copy to IB for non single case */
-	if (!copy1)
-		memcpy((void *)(p->ib.ptr+(pg_idx*(PAGE_SIZE/4))), ibc->kpage[new_page], size);
-
-	ibc->last_copied_page = pg_idx;
-	ibc->kpage_idx[new_page] = pg_idx;
-
-	return new_page;
-}
-
-u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
-{
-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
-	u32 pg_idx, pg_offset;
-	u32 idx_value = 0;
-	int new_page;
-
-	pg_idx = (idx * 4) / PAGE_SIZE;
-	pg_offset = (idx * 4) % PAGE_SIZE;
-
-	if (ibc->kpage_idx[0] == pg_idx)
-		return ibc->kpage[0][pg_offset/4];
-	if (ibc->kpage_idx[1] == pg_idx)
-		return ibc->kpage[1][pg_offset/4];
-
-	new_page = radeon_cs_update_pages(p, pg_idx);
-	if (new_page < 0) {
-		p->parser_error = new_page;
-		return 0;
-	}
-
-	idx_value = ibc->kpage[new_page][pg_offset/4];
-	return idx_value;
-}
-
 /**
  * radeon_cs_packet_parse() - parse cp packet and point ib index to next packet
  * @parser:	parser structure holding parsing context.

