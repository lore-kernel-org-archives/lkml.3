Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbaGYKQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:16:36 -0400
Received: from mx02.posteo.de ([89.146.194.165]:43049 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbaGYKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:16:35 -0400
Message-ID: <53D22E4D.2060600@posteo.de>
Date: Fri, 25 Jul 2014 12:15:41 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: daniel.vetter@ffwll.ch, Zhang Rui <rui.zhang@intel.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] rc1 rc2 rc3 not bootable - black screen after kernel loading
References: <53A6E72A.9090000@posteo.de>  <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>  <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>  <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba>  <53ADB359.4010401@posteo.de> <53ADCB24.9030206@posteo.de>  <53ADECDA.60600@posteo.de> <53B11749.3020902@posteo.de>  <1404116299.8366.0.camel@rzhang1-toshiba> <1404116444.8366.1.camel@rzhang1-toshiba> <53B12723.4080902@posteo.de> <53B13E4B.2080603@posteo.de> <53D131E7.2090304@posteo.de> <alpine.LSU.2.11.1407241610320.3733@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1407241610320.3733@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-25 01:20, schrieb Hugh Dickins:
> On Thu, 24 Jul 2014, Martin Kepplinger wrote:
>> Am 2014-06-30 12:39, schrieb Martin Kepplinger:
>>> back to aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
>>> commit. why is this not revertable exactly? how can I show a complete
>>> list of commits this merge introduces?
>>>
>>
>> It seems that _nobody_ is running a simple 32 bit i915 (acer) laptop.
>> rc6 is still unusable. Black screen directly after kernel-loading. no
>> change since rc1.
>>
>> Seems like I won't be able to use 3.16. I'm happy to test patches and am
>> happy for any advice what to do, when time permits.
> 
> Martin, I know nothing about aaeb25543372 and why it should be relevant,
> but if you're having rc1..rc6 32-bit i915 black screens, please try this
> patch that Daniel Vetter put in his fixes queue on Monday, which I'm
> hoping will reach Linus for -rc7.
> 
> Hugh
> 
> [PATCH] drm/i915: fix freeze with blank screen booting highmem
> 
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
> PageHighMem test, and so caused no harm.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
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
> 

yes! thanks Hugh. On top of linus' current tree, that finally fixes my
problem! I hope it'll be included soon!

                              martin

p.s. linux-media removed from thread
