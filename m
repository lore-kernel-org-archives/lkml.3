Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3FPL7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:59:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42951 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab3FPL7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:59:31 -0400
Date: Sun, 16 Jun 2013 12:59:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Insane kfifo_put API
Message-ID: <20130616115921.GQ18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, this kfifo API...  Here's an example:

Let's say that we want a kfifo of structure pointers:

	DECLARE_KFIFO(my_ptr_kfifo, struct my_struct *, SIZE);

Now, to extract pointers from this, it's relatively straight forward:

	struct my_struct *ptr;

	success = kfifo_get(&my_ptr_kfifo, &ptr);

Nothing wrong with that - kfifo_get looks just like a normal C function
which is good.  However, what about adding pointers?  This is where things
become really quite horrid.  It took many attempts to find out what the
API requires - and that's a sign of a bad API IMHO.

So, this is what the kfifo API requires:

	struct my_struct *ptr = something;
	const struct my_struct *my_other_ptr = ptr;

	success = kfifo_put(&my_ptr_kfifo, &my_other_ptr);

But... why?  This is wrong because:

1. the const-ness of 'my_other_ptr' is not saying that the value of the
   pointer is const, it's saying that the data pointed to by the pointer
   is const.
2. the kfifo API should have no regard for the const-ness of the data
   pointed to by the object its storing (in this case, the value of
   the pointer, not the data itself).
3. it forces users to jump through unnecessary hoops to use this API.
4. in any case, the data's const-ness is lost through the put to the
   get operation!

I almost gave up with it and rolled my own over this, trying to get the
compiler not to warn (which it was obviously doing because something
was wrong with the code) - it was only through lots of experimentation
and reading other users that I found something which worked through this
obscure API (as above).

So, what should the API be?

	success = kfifo_put(&my_ptr_kfifo, ptr);

To get there means every user needs to change, thankfully there are not
that many.  In doing so, we can also get rid of one unnecessary members
of the kfifo struct, namely ptr_const.

What's more is that those using it for integers also get a sane API:

	unsigned my_uint;

	kfifo_get(&my_uint_fifo, &my_uint)

	kfifo_put(&my_uint_fifo, my_uint);

rather than also having to take the address in the _put API.  And it
could work that way for structures too:

	struct my_struct my_str;

	kfifo_get(&my_struct_fifo, &my_str);

	kfifo_put(&my_struct_fifo, my_str);

The last is probably the only questionable one, as it looks like passing
a structure through a function argument, but as kfifo_put() is already a
(huge) macro, that's not really a problem.

Here's some of the examples of code in drivers which suffer with the
current API:

OMAP drm:
        DECLARE_KFIFO_PTR(unpin_fifo, struct drm_gem_object *);
...
        if (kfifo_put(&omap_plane->unpin_fifo,
                        (const struct drm_gem_object **)&bo)) {
...
        struct drm_gem_object *bo = NULL;

        while (kfifo_get(&omap_plane->unpin_fifo, &bo)) {
                omap_gem_put_paddr(bo);
                drm_gem_object_unreference_unlocked(bo);
        }
...
        ret = kfifo_alloc(&omap_plane->unpin_fifo, 16, GFP_KERNEL);

tildc:

        struct drm_framebuffer *fb;

        while (kfifo_get(&tilcdc_crtc->unref_fifo, &fb))
                drm_framebuffer_unreference(fb);
...
                if (kfifo_put(&tilcdc_crtc->unref_fifo,
                                (const struct drm_framebuffer **)&tilcdc_crtc->scanout[n])) {
...
        ret = kfifo_alloc(&tilcdc_crtc->unref_fifo, 16, GFP_KERNEL);

This API is luckily only about six users of this macro in the mainline
kernel, so it shouldn't be that big a change to change this to be sane.

Comments?
