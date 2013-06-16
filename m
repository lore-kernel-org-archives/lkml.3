Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3FPNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 09:16:28 -0400
Received: from www84.your-server.de ([213.133.104.84]:48010 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3FPNQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 09:16:27 -0400
X-Greylist: delayed 1175 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Jun 2013 09:16:27 EDT
Message-ID: <1371387419.5055.6.camel@wall-e>
Subject: Re: Insane kfifo_put API
From: Stefani Seibold <stefani@seibold.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jun 2013 14:56:59 +0200
In-Reply-To: <20130616115921.GQ18614@n2100.arm.linux.org.uk>
References: <20130616115921.GQ18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have cross checked this use case. This was tested, but i doesn't work
any more. So i need a little bit time to fix it. The macro for this are
a little bit tricky, but i think there is a way to solve this issue.

For the next two weeks i am heavy busy in a final project stage, so
please be patient.
 
BTW: Insane is a hard word for an API which was reviewed by a lot of
people.

Am Sonntag, den 16.06.2013, 12:59 +0100 schrieb Russell King - ARM
Linux:
> So, this kfifo API...  Here's an example:
> 
> Let's say that we want a kfifo of structure pointers:
> 
> 	DECLARE_KFIFO(my_ptr_kfifo, struct my_struct *, SIZE);
> 
> Now, to extract pointers from this, it's relatively straight forward:
> 
> 	struct my_struct *ptr;
> 
> 	success = kfifo_get(&my_ptr_kfifo, &ptr);
> 
> Nothing wrong with that - kfifo_get looks just like a normal C function
> which is good.  However, what about adding pointers?  This is where things
> become really quite horrid.  It took many attempts to find out what the
> API requires - and that's a sign of a bad API IMHO.
> 
> So, this is what the kfifo API requires:
> 
> 	struct my_struct *ptr = something;
> 	const struct my_struct *my_other_ptr = ptr;
> 
> 	success = kfifo_put(&my_ptr_kfifo, &my_other_ptr);
> 
> But... why?  This is wrong because:
> 
> 1. the const-ness of 'my_other_ptr' is not saying that the value of the
>    pointer is const, it's saying that the data pointed to by the pointer
>    is const.
> 2. the kfifo API should have no regard for the const-ness of the data
>    pointed to by the object its storing (in this case, the value of
>    the pointer, not the data itself).
> 3. it forces users to jump through unnecessary hoops to use this API.
> 4. in any case, the data's const-ness is lost through the put to the
>    get operation!
> 
> I almost gave up with it and rolled my own over this, trying to get the
> compiler not to warn (which it was obviously doing because something
> was wrong with the code) - it was only through lots of experimentation
> and reading other users that I found something which worked through this
> obscure API (as above).
> 
> So, what should the API be?
> 
> 	success = kfifo_put(&my_ptr_kfifo, ptr);
> 
> To get there means every user needs to change, thankfully there are not
> that many.  In doing so, we can also get rid of one unnecessary members
> of the kfifo struct, namely ptr_const.
> 
> What's more is that those using it for integers also get a sane API:
> 
> 	unsigned my_uint;
> 
> 	kfifo_get(&my_uint_fifo, &my_uint)
> 
> 	kfifo_put(&my_uint_fifo, my_uint);
> 
> rather than also having to take the address in the _put API.  And it
> could work that way for structures too:
> 
> 	struct my_struct my_str;
> 
> 	kfifo_get(&my_struct_fifo, &my_str);
> 
> 	kfifo_put(&my_struct_fifo, my_str);
> 
> The last is probably the only questionable one, as it looks like passing
> a structure through a function argument, but as kfifo_put() is already a
> (huge) macro, that's not really a problem.
> 
> Here's some of the examples of code in drivers which suffer with the
> current API:
> 
> OMAP drm:
>         DECLARE_KFIFO_PTR(unpin_fifo, struct drm_gem_object *);
> ...
>         if (kfifo_put(&omap_plane->unpin_fifo,
>                         (const struct drm_gem_object **)&bo)) {
> ...
>         struct drm_gem_object *bo = NULL;
> 
>         while (kfifo_get(&omap_plane->unpin_fifo, &bo)) {
>                 omap_gem_put_paddr(bo);
>                 drm_gem_object_unreference_unlocked(bo);
>         }
> ...
>         ret = kfifo_alloc(&omap_plane->unpin_fifo, 16, GFP_KERNEL);
> 
> tildc:
> 
>         struct drm_framebuffer *fb;
> 
>         while (kfifo_get(&tilcdc_crtc->unref_fifo, &fb))
>                 drm_framebuffer_unreference(fb);
> ...
>                 if (kfifo_put(&tilcdc_crtc->unref_fifo,
>                                 (const struct drm_framebuffer **)&tilcdc_crtc->scanout[n])) {
> ...
>         ret = kfifo_alloc(&tilcdc_crtc->unref_fifo, 16, GFP_KERNEL);
> 
> This API is luckily only about six users of this macro in the mainline
> kernel, so it shouldn't be that big a change to change this to be sane.
> 
> Comments?


