Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3AKOrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:47:53 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45914 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754322Ab3AKOrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:47:51 -0500
Date: Fri, 11 Jan 2013 14:47:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: Alexandru Copot <alex.mihai.c@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "mst@redhat.com" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio: suppress kmemleak false positive
Message-ID: <20130111144719.GE31281@arm.com>
References: <1357912303-17026-1-git-send-email-alex.mihai.c@gmail.com>
 <20130111140231.GA31281@arm.com>
 <CAEnQRZCvNZ_1OF7Jc43Oo10ADQEMVgqdTJZG7KG7m9yNoQDBfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEnQRZCvNZ_1OF7Jc43Oo10ADQEMVgqdTJZG7KG7m9yNoQDBfg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 02:32:12PM +0000, Daniel Baluta wrote:
> On Fri, Jan 11, 2013 at 4:02 PM, Catalin Marinas <catalin.marinas@arm.com>
> wrote:
> > On Fri, Jan 11, 2013 at 01:51:43PM +0000, Alexandru Copot wrote:
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -23,6 +23,7 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/module.h>
> > >  #include <linux/hrtimer.h>
> > > +#include <linux/kmemleak.h>
> > >
> > >  /* virtio guest is communicating with a virtual "device" that actually runs on
> > >   * a host processor.  Memory barriers are used to control SMP effects. */
> > > @@ -140,6 +141,7 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
> > >       desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
> > >       if (!desc)
> > >               return -ENOMEM;
> > > +     kmemleak_not_leak(desc);
> >
> > Please add a comment above this call in case people later wonder why
> > this annotation is needed.
> 
> So, kememleak cannot handle this kind of pointer aliases?

No. Basically it stores the allocated object start/end in an rb-tree and
cannot cope with overlapping blocks. If we allow aliases, we could have
some overlapping.

I think there was a patch in the past to add a separate rb-tree for
aliases but I didn't particularly like it because it affected the
performance.

> Also, I wonder if phys_to_virt(virt_to_phys(x)) == x holds true all the time.

It should as long as x is a valid kernel virtual address in the logical
(linear) mapping.

-- 
Catalin
