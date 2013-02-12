Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3BLUt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:49:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab3BLUtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:49:24 -0500
Date: Tue, 12 Feb 2013 22:49:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] virtio: add functions for piecewise addition of
 buffers
Message-ID: <20130212204920.GB6972@redhat.com>
References: <20130212154338.GA4083@redhat.com>
 <511A6457.80609@redhat.com>
 <20130212161326.GB4373@redhat.com>
 <511A6B2B.50700@redhat.com>
 <20130212163524.GB4555@redhat.com>
 <511A7493.50901@redhat.com>
 <20130212173454.GA5028@redhat.com>
 <511A842B.1030101@redhat.com>
 <20130212182355.GA5642@redhat.com>
 <511AA13B.30809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511AA13B.30809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:08:27PM +0100, Paolo Bonzini wrote:
> Il 12/02/2013 19:23, Michael S. Tsirkin ha scritto:
> > On Tue, Feb 12, 2013 at 07:04:27PM +0100, Paolo Bonzini wrote:
> >>>> Perhaps, but 3 or 4 arguments (in/out/nsg or in/out/nsg_in/nsg_out) just
> >>>> for this are definitely too many and make the API harder to use.
> >>>>
> >>>> You have to find a balance.  Having actually used the API, the
> >>>> possibility of mixing in/out buffers by mistake never even occurred to
> >>>> me, much less happened in practice, so I didn't consider it a problem.
> >>>> Mixing in/out buffers in a single call wasn't a necessity, either.
> >>>
> >>> It is useful for virtqueue_add_buf implementation.
> >>
> >>         ret = virtqueue_start_buf(vq, data, out + in, !!out + !!in,
> >> 				  gfp);
> >>         if (ret < 0)
> >>                 return ret;
> >>
> >>         if (out)
> >>                 virtqueue_add_sg(vq, sg, out, DMA_TO_DEVICE);
> >>         if (in)
> >>                 virtqueue_add_sg(vq, sg + out, in, DMA_FROM_DEVICE);
> >>
> >>         virtqueue_end_buf(vq);
> >> 	return 0;
> >>
> >> How can it be simpler and easier to understand than that?
> > 
> > Like this:
> > 
> >          ret = virtqueue_start_buf(vq, data, in, out, gfp);
> >          if (ret < 0)
> >                  return ret;
> >  
> >          virtqueue_add_sg(vq, sg, in, out);
> >  
> >          virtqueue_end_buf(vq);
> 
> It's out/in, not in/out... I know you wrote it in a hurry, but it kind
> of shows that the new API is easier to use.  Check out patch 8, it's  a
> real improvement in readability.

That's virtqueue_add_buf_single, that's a separate matter.
Another option for _single is just two wrappers:
virtqueue_add_buf_in
virtqueue_add_buf_out

> Plus you haven't solved the problem of alternating to/from-device
> elements (which is also harder to spot with in/out than with the enum).

Yes it does, if add_sg does not have in/out at all there's no way to
request the impossible to/from mix.

> And no one else would use add_sg with in != 0 && out != 0, so you'd be
> favoring one caller over all the others.

Yes but it's an important caller as all drivers besides storage use this
path.

>  If you did this instead:
> 
>          virtqueue_add_sg(vq, sg, in + out);
> 
> it would really look like a hack IMHO.
> 
> >>> Basically the more consistent the interface is with virtqueue_add_buf,
> >>> the better.
> >>
> >> The interface is consistent with virtqueue_add_buf_single, where out/in
> >> clearly doesn't make sense.
> > 
> > Hmm, we could make virtqueue_add_buf_single consistent by giving it 'bool in'.
> 
> But is it "bool in" or "bool out"?

Agree, bool is a bit ugly anyway.

> >> virtqueue_add_buf and virtqueue_add_sg are very different, despite the
> >> similar name.
> > 
> > True. The similarity is between _start and _add_buf.
> > And this is confusing too. Maybe this means
> > _start and _add_sg should be renamed.
> 
> Maybe.  If you have any suggestions it's fine.
> 
> BTW I tried using out/in for start_buf, and the code in virtio-blk gets
> messier, it has to do all the math twice.

I'm pretty sure we can do this without duplication, if we want to.

> Perhaps we just need to
> acknowledge that the API is different and thus the optimal choice of
> arguments is different.  C doesn't have keyword arguments, there not
> much that we can do.
> 
> Paolo

Yea, maybe. I'm not the API guru here anyway, it's Rusty's street.

-- 
MST
