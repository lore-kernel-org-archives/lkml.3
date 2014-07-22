Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaGVGL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:11:29 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55465 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaGVGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:11:27 -0400
Date: Tue, 22 Jul 2014 08:11:36 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Hugh Dickins <hughd@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: fix freeze with blank screen booting highmem
Message-ID: <20140722061136.GC15237@phenom.ffwll.local>
Mail-Followup-To: Hugh Dickins <hughd@google.com>,
	Mika Kuoppala <mika.kuoppala@linux.intel.com>,
	Damien Lespiau <damien.lespiau@intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <alpine.LSU.2.11.1407212121570.1345@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407212121570.1345@eggly.anvils>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 09:34:30PM -0700, Hugh Dickins wrote:
> x86_64 boots and displays fine, but booting x86_32 with CONFIG_HIGHMEM
> has frozen with a blank screen throughout 3.16-rc on this ThinkPad T420s,
> with i915 generation 6 graphics.
> 
> Fix 9d0a6fa6c5e6 ("drm/i915: add render state initialization"): kunmap()
> takes struct page * argument, not virtual address.  Which the compiler
> kindly points out, if you use the appropriate u32 *batch, instead of
> silencing it with a void *.
> 
> Why did bisection lead decisively to nearby 229b0489aa75 ("drm/i915:
> add null render states for gen6, gen7 and gen8")?  Because the u32
> deposited at that virtual address by the previous stub failed the
> PageHighMem test, and so did no harm.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Oops. Thanks for tracking this down, patch merged to my -fixes queue.
-Daniel

> ---
> 
>  drivers/gpu/drm/i915/i915_gem_render_state.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 3.16-rc/drivers/gpu/drm/i915/i915_gem_render_state.c	2014-06-16 00:28:52.384076465 -0700
> +++ linux/drivers/gpu/drm/i915/i915_gem_render_state.c	2014-07-21 20:10:03.824481521 -0700
> @@ -31,7 +31,7 @@
>  struct i915_render_state {
>  	struct drm_i915_gem_object *obj;
>  	unsigned long ggtt_offset;
> -	void *batch;
> +	u32 *batch;
>  	u32 size;
>  	u32 len;
>  };
> @@ -80,7 +80,7 @@ free:
>  
>  static void render_state_free(struct i915_render_state *so)
>  {
> -	kunmap(so->batch);
> +	kunmap(kmap_to_page(so->batch));
>  	i915_gem_object_ggtt_unpin(so->obj);
>  	drm_gem_object_unreference(&so->obj->base);
>  	kfree(so);

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
