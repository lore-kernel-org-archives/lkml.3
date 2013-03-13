Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3CMKhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:37:07 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38558 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3CMKhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:37:01 -0400
Message-ID: <514056C8.3040702@suse.cz>
Date: Wed, 13 Mar 2013 11:36:56 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>, bskeggs@redhat.com
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: WARNING: at drivers/gpu/drm/nouveau/core/core/mm.c:242
References: <5122021F.1060207@suse.cz> <20130218232335.GA9730@joi.lan> <5122BC8A.6040503@suse.cz> <20130219070744.GA3032@joi.lan> <20130219223255.GA13522@joi.lan>
In-Reply-To: <20130219223255.GA13522@joi.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:32 PM, Marcin Slusarz wrote:
> On Tue, Feb 19, 2013 at 08:07:44AM +0100, Marcin Slusarz wrote:
>> On Tue, Feb 19, 2013 at 12:43:06AM +0100, Jiri Slaby wrote:
>>> On 02/19/2013 12:23 AM, Marcin Slusarz wrote:
>>>> Tomorrow I'll post a patch for page allocation failure.
>>>
>>> What do you mean -- what kind of patch?
>>
>> A patch which will change pgt allocation to use vmalloc.

It's still not in -next. Any plans on this?

> ---
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] drm/nouveau: use vmalloc for pgt allocation
> 
> Page tables on nv50 take 48kB, which can be hard to allocate in one piece.
> Let's use vmalloc.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/nouveau/core/subdev/vm/base.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/vm/base.c b/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
> index 77c67fc..e66fb77 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
> @@ -362,7 +362,7 @@ nouveau_vm_create(struct nouveau_vmmgr *vmm, u64 offset, u64 length,
>  	vm->fpde = offset >> (vmm->pgt_bits + 12);
>  	vm->lpde = (offset + length - 1) >> (vmm->pgt_bits + 12);
>  
> -	vm->pgt  = kcalloc(vm->lpde - vm->fpde + 1, sizeof(*vm->pgt), GFP_KERNEL);
> +	vm->pgt  = vzalloc((vm->lpde - vm->fpde + 1) * sizeof(*vm->pgt));
>  	if (!vm->pgt) {
>  		kfree(vm);
>  		return -ENOMEM;
> @@ -371,7 +371,7 @@ nouveau_vm_create(struct nouveau_vmmgr *vmm, u64 offset, u64 length,
>  	ret = nouveau_mm_init(&vm->mm, mm_offset >> 12, mm_length >> 12,
>  			      block >> 12);
>  	if (ret) {
> -		kfree(vm->pgt);
> +		vfree(vm->pgt);
>  		kfree(vm);
>  		return ret;
>  	}
> @@ -446,7 +446,7 @@ nouveau_vm_del(struct nouveau_vm *vm)
>  	}
>  
>  	nouveau_mm_fini(&vm->mm);
> -	kfree(vm->pgt);
> +	vfree(vm->pgt);
>  	kfree(vm);
>  }
>  
> 


-- 
js
suse labs
