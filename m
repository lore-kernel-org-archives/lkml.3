Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3BMKdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:33:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab3BMKdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:33:42 -0500
Date: Wed, 13 Feb 2013 12:33:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] virtio: add functions for piecewise addition of
 buffers
Message-ID: <20130213103337.GC14452@redhat.com>
References: <20130212161326.GB4373@redhat.com>
 <511A6B2B.50700@redhat.com>
 <20130212163524.GB4555@redhat.com>
 <511A7493.50901@redhat.com>
 <20130212173454.GA5028@redhat.com>
 <511A842B.1030101@redhat.com>
 <20130212182355.GA5642@redhat.com>
 <511AA13B.30809@redhat.com>
 <20130212204920.GB6972@redhat.com>
 <511B4983.7010103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B4983.7010103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:06:27AM +0100, Paolo Bonzini wrote:
> Il 12/02/2013 21:49, Michael S. Tsirkin ha scritto:
> > On Tue, Feb 12, 2013 at 09:08:27PM +0100, Paolo Bonzini wrote:
> >> Il 12/02/2013 19:23, Michael S. Tsirkin ha scritto:
> >>> On Tue, Feb 12, 2013 at 07:04:27PM +0100, Paolo Bonzini wrote:
> >>>>>> Perhaps, but 3 or 4 arguments (in/out/nsg or in/out/nsg_in/nsg_out) just
> >>>>>> for this are definitely too many and make the API harder to use.
> >>>>>>
> >>>>>> You have to find a balance.  Having actually used the API, the
> >>>>>> possibility of mixing in/out buffers by mistake never even occurred to
> >>>>>> me, much less happened in practice, so I didn't consider it a problem.
> >>>>>> Mixing in/out buffers in a single call wasn't a necessity, either.
> >>>>>
> >>>>> It is useful for virtqueue_add_buf implementation.
> >>>>
> >>>>         ret = virtqueue_start_buf(vq, data, out + in, !!out + !!in,
> >>>> 				  gfp);
> >>>>         if (ret < 0)
> >>>>                 return ret;
> >>>>
> >>>>         if (out)
> >>>>                 virtqueue_add_sg(vq, sg, out, DMA_TO_DEVICE);
> >>>>         if (in)
> >>>>                 virtqueue_add_sg(vq, sg + out, in, DMA_FROM_DEVICE);
> >>>>
> >>>>         virtqueue_end_buf(vq);
> >>>> 	return 0;
> >>>>
> >>>> How can it be simpler and easier to understand than that?
> >>>
> >>> Like this:
> >>>
> >>>          ret = virtqueue_start_buf(vq, data, in, out, gfp);
> >>>          if (ret < 0)
> >>>                  return ret;
> >>>  
> >>>          virtqueue_add_sg(vq, sg, in, out);
> >>>  
> >>>          virtqueue_end_buf(vq);
> >>
> >> It's out/in, not in/out... I know you wrote it in a hurry, but it kind
> >> of shows that the new API is easier to use.  Check out patch 8, it's  a
> >> real improvement in readability.
> > 
> > That's virtqueue_add_buf_single, that's a separate matter.
> > Another option for _single is just two wrappers:
> > virtqueue_add_buf_in
> > virtqueue_add_buf_out
> 
> I like it less, but yes this one would be ok (no driver uses a variable
> for the enum parameter).

OK, this has the advantage of being even shorter.

> >> Plus you haven't solved the problem of alternating to/from-device
> >> elements (which is also harder to spot with in/out than with the enum).
> > 
> > Yes it does, if add_sg does not have in/out at all there's no way to
> > request the impossible to/from mix.
> 
> In your example above it does have it.  I assume you meant
> 
>          ret = virtqueue_start_buf(vq, data, out, in, gfp);
>          if (ret < 0)
>                  return ret;
> 
>           virtqueue_add_sg(vq, sg, out + in);
>           virtqueue_end_buf(vq);
> 
> >>>> virtqueue_add_buf and virtqueue_add_sg are very different, despite the
> >>>> similar name.
> >>>
> >>> True. The similarity is between _start and _add_buf.
> >>> And this is confusing too. Maybe this means
> >>> _start and _add_sg should be renamed.
> >>
> >> Maybe.  If you have any suggestions it's fine.
> >>
> >> BTW I tried using out/in for start_buf, and the code in virtio-blk gets
> >> messier, it has to do all the math twice.
> > 
> > I'm pretty sure we can do this without duplication, if we want to.
> 
> Indeed, if you remove the out/in arguments from _sg there is no
> duplication in virtio-blk.  That's because it places data-out at the end
> and data-in at the beginning (so data is always after the request header
> and before the response footer).

Yes, it's not a virtio-blk thing, virtio spec and interface require that
we have in after out.
So yes, to me it seems cleaner to drop out/in arguments from _sg.

> >> acknowledge that the API is different and thus the optimal choice of
> >> arguments is different.  C doesn't have keyword arguments, there not
> >> much that we can do.
> > 
> > Yea, maybe. I'm not the API guru here anyway, it's Rusty's street.
> 
> Let's wait for him.
> 
> Paolo
