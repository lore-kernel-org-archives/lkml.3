Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3IXHWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:22:25 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:49219 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab3IXHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:22:24 -0400
Message-ID: <52413DA9.4050000@vmware.com>
Date: Tue, 24 Sep 2013 09:22:17 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC PATCH] drm/nouveau: fix nested locking in mmap handler
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <20130913082933.GH31370@twins.programming.kicks-ass.net> <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com> <20130913090000.GJ31370@twins.programming.kicks-ass.net> <52405F3E.4000609@canonical.com>
In-Reply-To: <52405F3E.4000609@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 05:33 PM, Maarten Lankhorst wrote:
> Hey,
>
> Op 13-09-13 11:00, Peter Zijlstra schreef:
>> On Fri, Sep 13, 2013 at 10:41:54AM +0200, Daniel Vetter wrote:
>>> On Fri, Sep 13, 2013 at 10:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>> On Fri, Sep 13, 2013 at 09:46:03AM +0200, Thomas Hellstrom wrote:
>>>>>>> if (!bo_tryreserve()) {
>>>>>>>      up_read mmap_sem(); // Release the mmap_sem to avoid deadlocks.
>>>>>>>      bo_reserve();               // Wait for the BO to become available (interruptible)
>>>>>>>      bo_unreserve();           // Where is bo_wait_unreserved() when we need it, Maarten :P
>>>>>>>      return VM_FAULT_RETRY; // Go ahead and retry the VMA walk, after regrabbing
>>>>>>> }
>>>>> Anyway, could you describe what is wrong, with the above solution, because
>>>>> it seems perfectly legal to me.
>>>> Luckily the rule of law doesn't have anything to do with this stuff --
>>>> at least I sincerely hope so.
>>>>
>>>> The thing that's wrong with that pattern is that its still not
>>>> deterministic - although its a lot better than the pure trylock. Because
>>>> you have to release and re-acquire with the trylock another user might
>>>> have gotten in again. Its utterly prone to starvation.
>>>>
>>>> The acquire+release does remove the dead/life-lock scenario from the
>>>> FIFO case, since blocking on the acquire will allow the other task to
>>>> run (or even get boosted on -rt).
>>>>
>>>> Aside from that there's nothing particularly wrong with it and lockdep
>>>> should be happy afaict (but I haven't had my morning juice yet).
>>> bo_reserve internally maps to a ww-mutex and task can already hold
>>> ww-mutex (potentially even the same for especially nasty userspace).
>> OK, yes I wasn't aware of that. Yes in that case you're quite right.
>>
> I added a RFC patch below.  I only tested with PROVE_LOCKING, and always forced the slowpath for debugging.
>
> This fixes nouveau and core ttm to always use blocking acquisition in fastpath.
> Nouveau was a bit of a headache, but afaict it should work.
>
> In almost all cases relocs are not updated, so I kept intact the fastpath
> of not copying relocs from userspace. The slowpath tries to copy it atomically,
> and if that fails it will unreserve all bo's and copy everything.
>
> One thing to note is that the command submission ioctl may fail now with -EFAULT
> if presumed cannot be updated, while the commands are submitted succesfully.

I think the Nouveau guys need to comment further on this, but returning 
-EFAULT might break existing user-space, and that's not allowed, but 
IIRC the return value of "presumed" is only a hint, and if it's 
incorrect will only trigger future command stream patching.

Otherwise reviewing mostly the TTM stuff. FWIW, from wat I can tell the 
vmwgfx driver doesn't need any fixups.
>
> I'm not sure what the right behavior was here, and this can only happen if you
> touch the memory during the ioctl or use a read-only page. Both of them are not done
> in the common case.
>
> Reviews welcome. :P
>
> 8<---
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
> index e4d60e7..2964bb7 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_gem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
> @@ -445,8 +445,6 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
>   	      uint64_t user_pbbo_ptr)
>   {
>   	struct nouveau_drm *drm = chan->drm;
> -	struct drm_nouveau_gem_pushbuf_bo __user *upbbo =
> -				(void __force __user *)(uintptr_t)user_pbbo_ptr;
>   	struct nouveau_bo *nvbo;
>   	int ret, relocs = 0;
>   
> @@ -475,7 +473,7 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
>   			return ret;
>   		}
>   
> -		if (nv_device(drm->device)->card_type < NV_50) {
> +		if (nv_device(drm->device)->card_type < NV_50 && !relocs) {
>   			if (nvbo->bo.offset == b->presumed.offset &&
>   			    ((nvbo->bo.mem.mem_type == TTM_PL_VRAM &&
>   			      b->presumed.domain & NOUVEAU_GEM_DOMAIN_VRAM) ||
> @@ -483,53 +481,86 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
>   			      b->presumed.domain & NOUVEAU_GEM_DOMAIN_GART)))
>   				continue;
>   
> -			if (nvbo->bo.mem.mem_type == TTM_PL_TT)
> -				b->presumed.domain = NOUVEAU_GEM_DOMAIN_GART;
> -			else
> -				b->presumed.domain = NOUVEAU_GEM_DOMAIN_VRAM;
> -			b->presumed.offset = nvbo->bo.offset;
> -			b->presumed.valid = 0;
> -			relocs++;
> -
> -			if (DRM_COPY_TO_USER(&upbbo[nvbo->pbbo_index].presumed,
> -					     &b->presumed, sizeof(b->presumed)))
> -				return -EFAULT;
> +			relocs = 1;
>   		}
>   	}
>   
>   	return relocs;
>   }
>   
> +static inline void
> +u_free(void *addr)
> +{
> +	if (!is_vmalloc_addr(addr))
> +		kfree(addr);
> +	else
> +		vfree(addr);
> +}

Isn't there a DRM utilty for this?

> +
> +static inline void *
> +u_memcpya(uint64_t user, unsigned nmemb, unsigned size, unsigned inatomic)
> +{
> +	void *mem;
> +	void __user *userptr = (void __force __user *)(uintptr_t)user;
> +
> +	size *= nmemb;
> +
> +	mem = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!mem)
> +		mem = vmalloc(size);
And for the above as well?

> +	if (!mem)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (inatomic && (!access_ok(VERIFY_READ, userptr, size) ||
> +	    __copy_from_user_inatomic(mem, userptr, size))) {
> +		u_free(mem);
> +		return ERR_PTR(-EFAULT);
> +	} else if (!inatomic && copy_from_user(mem, userptr, size)) {
> +		u_free(mem);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	return mem;
> +}
> +
> +static int
> +nouveau_gem_pushbuf_reloc_apply(struct nouveau_cli *cli,
> +				struct drm_nouveau_gem_pushbuf *req,
> +				struct drm_nouveau_gem_pushbuf_bo *bo,
> +				struct drm_nouveau_gem_pushbuf_reloc *reloc);
> +
>   static int
>   nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
>   			     struct drm_file *file_priv,
>   			     struct drm_nouveau_gem_pushbuf_bo *pbbo,
> +			     struct drm_nouveau_gem_pushbuf *req,
>   			     uint64_t user_buffers, int nr_buffers,
> -			     struct validate_op *op, int *apply_relocs)
> +			     struct validate_op *op, int *do_reloc)
>   {
>   	struct nouveau_cli *cli = nouveau_cli(file_priv);
>   	int ret, relocs = 0;
> +	struct drm_nouveau_gem_pushbuf_reloc *reloc = NULL;
> +
> +	if (nr_buffers == 0)
> +		return 0;
>   
> +restart:
>   	INIT_LIST_HEAD(&op->vram_list);
>   	INIT_LIST_HEAD(&op->gart_list);
>   	INIT_LIST_HEAD(&op->both_list);
>   
> -	if (nr_buffers == 0)
> -		return 0;
> -
>   	ret = validate_init(chan, file_priv, pbbo, nr_buffers, op);
>   	if (unlikely(ret)) {
>   		if (ret != -ERESTARTSYS)
>   			NV_ERROR(cli, "validate_init\n");
> -		return ret;
> +		goto err;
>   	}
>   
>   	ret = validate_list(chan, cli, &op->vram_list, pbbo, user_buffers);
>   	if (unlikely(ret < 0)) {
>   		if (ret != -ERESTARTSYS)
>   			NV_ERROR(cli, "validate vram_list\n");
> -		validate_fini(op, NULL);
> -		return ret;
> +		goto err_fini;
>   	}
>   	relocs += ret;
>   
> @@ -537,8 +568,7 @@ nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
>   	if (unlikely(ret < 0)) {
>   		if (ret != -ERESTARTSYS)
>   			NV_ERROR(cli, "validate gart_list\n");
> -		validate_fini(op, NULL);
> -		return ret;
> +		goto err_fini;
>   	}
>   	relocs += ret;
>   
> @@ -546,58 +576,93 @@ nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
>   	if (unlikely(ret < 0)) {
>   		if (ret != -ERESTARTSYS)
>   			NV_ERROR(cli, "validate both_list\n");
> -		validate_fini(op, NULL);
> -		return ret;
> +		goto err_fini;
>   	}
>   	relocs += ret;
> +	if (relocs) {
> +		if (!reloc) {
> +			//reloc = u_memcpya(req->relocs, req->nr_relocs, sizeof(*reloc), 1);
> +			reloc = ERR_PTR(-EFAULT); NV_ERROR(cli, "slowpath!\n");
> +		}
> +		if (IS_ERR(reloc)) {
> +			validate_fini(op, NULL);
> +
> +			if (PTR_ERR(reloc) == -EFAULT)
> +				reloc = u_memcpya(req->relocs, req->nr_relocs, sizeof(*reloc), 0);
> +
> +			if (IS_ERR(reloc))
> +				return PTR_ERR(reloc);
> +			goto restart;
> +		}
> +
> +		ret = nouveau_gem_pushbuf_reloc_apply(cli, req, pbbo, reloc);
> +		if (ret) {
> +			NV_ERROR(cli, "reloc apply: %d\n", ret);
> +			/* No validate_fini, already called. */
> +			return ret;
> +		}
> +		u_free(reloc);
> +		*do_reloc = 1;
> +	}
>   
> -	*apply_relocs = relocs;
>   	return 0;
> -}
>   
> -static inline void
> -u_free(void *addr)
> -{
> -	if (!is_vmalloc_addr(addr))
> -		kfree(addr);
> -	else
> -		vfree(addr);
> +err_fini:
> +	validate_fini(op, NULL);
> +err:
> +	if (reloc)
> +		u_free(reloc);
> +	return ret;
>   }
>   
> -static inline void *
> -u_memcpya(uint64_t user, unsigned nmemb, unsigned size)
> +static int
> +nouveau_gem_pushbuf_reloc_copy_to_user(struct drm_nouveau_gem_pushbuf *req,
> +				       struct drm_nouveau_gem_pushbuf_bo *bo)
>   {
> -	void *mem;
> -	void __user *userptr = (void __force __user *)(uintptr_t)user;
> +	struct drm_nouveau_gem_pushbuf_bo __user *upbbo =
> +				 (void __force __user *)(uintptr_t)req->buffers;
> +	unsigned i;
>   
> -	size *= nmemb;
> +	for (i = 0; i < req->nr_buffers; ++i) {
> +		struct drm_nouveau_gem_pushbuf_bo *b = &bo[i];
>   
> -	mem = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> -	if (!mem)
> -		mem = vmalloc(size);
> -	if (!mem)
> -		return ERR_PTR(-ENOMEM);
> -
> -	if (DRM_COPY_FROM_USER(mem, userptr, size)) {
> -		u_free(mem);
> -		return ERR_PTR(-EFAULT);
> +		if (!b->presumed.valid &&
> +		    copy_to_user(&upbbo[i].presumed, &b->presumed, sizeof(b->presumed)))
> +			return -EFAULT;
>   	}
> -
> -	return mem;
> +	return 0;
>   }
>   
>   static int
>   nouveau_gem_pushbuf_reloc_apply(struct nouveau_cli *cli,
>   				struct drm_nouveau_gem_pushbuf *req,
> -				struct drm_nouveau_gem_pushbuf_bo *bo)
> +				struct drm_nouveau_gem_pushbuf_bo *bo,
> +				struct drm_nouveau_gem_pushbuf_reloc *reloc)
>   {
> -	struct drm_nouveau_gem_pushbuf_reloc *reloc = NULL;
>   	int ret = 0;
>   	unsigned i;
>   
> -	reloc = u_memcpya(req->relocs, req->nr_relocs, sizeof(*reloc));
> -	if (IS_ERR(reloc))
> -		return PTR_ERR(reloc);
> +	for (i = 0; i < req->nr_buffers; ++i) {
> +		struct drm_nouveau_gem_pushbuf_bo *b = &bo[i];
> +		struct nouveau_bo *nvbo = (void *)(unsigned long)
> +			bo[i].user_priv;
> +
> +		if (nvbo->bo.offset == b->presumed.offset &&
> +		    ((nvbo->bo.mem.mem_type == TTM_PL_VRAM &&
> +		      b->presumed.domain & NOUVEAU_GEM_DOMAIN_VRAM) ||
> +		     (nvbo->bo.mem.mem_type == TTM_PL_TT &&
> +		      b->presumed.domain & NOUVEAU_GEM_DOMAIN_GART))) {
> +			b->presumed.valid = 1;
> +			continue;
> +		}
> +
> +		if (nvbo->bo.mem.mem_type == TTM_PL_TT)
> +			b->presumed.domain = NOUVEAU_GEM_DOMAIN_GART;
> +		else
> +			b->presumed.domain = NOUVEAU_GEM_DOMAIN_VRAM;
> +		b->presumed.offset = nvbo->bo.offset;
> +		b->presumed.valid = 0;
> +	}
>   
>   	for (i = 0; i < req->nr_relocs; i++) {
>   		struct drm_nouveau_gem_pushbuf_reloc *r = &reloc[i];
> @@ -664,8 +729,6 @@ nouveau_gem_pushbuf_reloc_apply(struct nouveau_cli *cli,
>   
>   		nouveau_bo_wr32(nvbo, r->reloc_bo_offset >> 2, data);
>   	}
> -
> -	u_free(reloc);
>   	return ret;
>   }
>   
> @@ -721,11 +784,11 @@ nouveau_gem_ioctl_pushbuf(struct drm_device *dev, void *data,
>   		return nouveau_abi16_put(abi16, -EINVAL);
>   	}
>   
> -	push = u_memcpya(req->push, req->nr_push, sizeof(*push));
> +	push = u_memcpya(req->push, req->nr_push, sizeof(*push), 0);
>   	if (IS_ERR(push))
>   		return nouveau_abi16_put(abi16, PTR_ERR(push));
>   
> -	bo = u_memcpya(req->buffers, req->nr_buffers, sizeof(*bo));
> +	bo = u_memcpya(req->buffers, req->nr_buffers, sizeof(*bo), 0);
>   	if (IS_ERR(bo)) {
>   		u_free(push);
>   		return nouveau_abi16_put(abi16, PTR_ERR(bo));
> @@ -741,7 +804,7 @@ nouveau_gem_ioctl_pushbuf(struct drm_device *dev, void *data,
>   	}
>   
>   	/* Validate buffer list */
> -	ret = nouveau_gem_pushbuf_validate(chan, file_priv, bo, req->buffers,
> +	ret = nouveau_gem_pushbuf_validate(chan, file_priv, bo, req, req->buffers,
>   					   req->nr_buffers, &op, &do_reloc);
>   	if (ret) {
>   		if (ret != -ERESTARTSYS)
> @@ -749,15 +812,6 @@ nouveau_gem_ioctl_pushbuf(struct drm_device *dev, void *data,
>   		goto out_prevalid;
>   	}
>   
> -	/* Apply any relocations that are required */
> -	if (do_reloc) {
> -		ret = nouveau_gem_pushbuf_reloc_apply(cli, req, bo);
> -		if (ret) {
> -			NV_ERROR(cli, "reloc apply: %d\n", ret);
> -			goto out;
> -		}
> -	}
> -
>   	if (chan->dma.ib_max) {
>   		ret = nouveau_dma_wait(chan, req->nr_push + 1, 16);
>   		if (ret) {
> @@ -837,6 +891,17 @@ out:
>   	validate_fini(&op, fence);
>   	nouveau_fence_unref(&fence);
>   
> +	if (do_reloc && !ret) {
> +		ret = nouveau_gem_pushbuf_reloc_copy_to_user(req, bo);
> +		if (ret) {
> +			NV_ERROR(cli, "error copying presumed back to userspace: %d\n", ret);
> +			/*
> +			 * XXX: We return -EFAULT, but command submission
> +			 * has already been completed.
> +			 */
> +		}
> +	}
> +
>   out_prevalid:
>   	u_free(bo);
>   	u_free(push);
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> index 1006c15..829e911 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> @@ -64,12 +64,9 @@ static int ttm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>   	 * for reserve, and if it fails, retry the fault after scheduling.
>   	 */
>   
> -	ret = ttm_bo_reserve(bo, true, true, false, 0);
> -	if (unlikely(ret != 0)) {
> -		if (ret == -EBUSY)
> -			set_need_resched();
> +	ret = ttm_bo_reserve(bo, true, false, false, 0);
> +	if (unlikely(ret != 0))
>   		return VM_FAULT_NOPAGE;
> -	}
>   

Actually, it's not the locking order bo:reserve -> mmap_sem that 
triggers the lockdep warning, right? but the fact that copy_from_user 
could recurse into the fault handler? Grabbing bo:reseves recursively? 
which should leave us free to choose locking order at this point.

>   	if (bdev->driver->fault_reserve_notify) {
>   		ret = bdev->driver->fault_reserve_notify(bo);
> @@ -77,6 +74,7 @@ static int ttm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>   		case 0:
>   			break;
>   		case -EBUSY:
> +			WARN_ON(1);
>   			set_need_resched();

I don't think this is used anymore, so set_need_resched might go.

>   		case -ERESTARTSYS:
>   			retval = VM_FAULT_NOPAGE;
/Thomas
