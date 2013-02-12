Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab3BLSTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:19:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab3BLST1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:19:27 -0500
Date: Tue, 12 Feb 2013 20:23:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] virtio: add functions for piecewise addition of
 buffers
Message-ID: <20130212182355.GA5642@redhat.com>
References: <20130212145620.GA3392@redhat.com>
 <511A608B.5080007@redhat.com>
 <20130212154338.GA4083@redhat.com>
 <511A6457.80609@redhat.com>
 <20130212161326.GB4373@redhat.com>
 <511A6B2B.50700@redhat.com>
 <20130212163524.GB4555@redhat.com>
 <511A7493.50901@redhat.com>
 <20130212173454.GA5028@redhat.com>
 <511A842B.1030101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511A842B.1030101@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 07:04:27PM +0100, Paolo Bonzini wrote:
> >> Perhaps, but 3 or 4 arguments (in/out/nsg or in/out/nsg_in/nsg_out) just
> >> for this are definitely too many and make the API harder to use.
> >>
> >> You have to find a balance.  Having actually used the API, the
> >> possibility of mixing in/out buffers by mistake never even occurred to
> >> me, much less happened in practice, so I didn't consider it a problem.
> >> Mixing in/out buffers in a single call wasn't a necessity, either.
> > 
> > It is useful for virtqueue_add_buf implementation.
> 
>         ret = virtqueue_start_buf(vq, data, out + in, !!out + !!in,
> 				  gfp);
>         if (ret < 0)
>                 return ret;
> 
>         if (out)
>                 virtqueue_add_sg(vq, sg, out, DMA_TO_DEVICE);
>         if (in)
>                 virtqueue_add_sg(vq, sg + out, in, DMA_FROM_DEVICE);
> 
>         virtqueue_end_buf(vq);
> 	return 0;
> 
> How can it be simpler and easier to understand than that?

Like this:

         ret = virtqueue_start_buf(vq, data, in, out, gfp);
         if (ret < 0)
                 return ret;
 
         virtqueue_add_sg(vq, sg, in, out);
 
         virtqueue_end_buf(vq);


> > Basically the more consistent the interface is with virtqueue_add_buf,
> > the better.
> 
> The interface is consistent with virtqueue_add_buf_single, where out/in
> clearly doesn't make sense.

Hmm, we could make virtqueue_add_buf_single consistent by giving it 'bool in'.

> virtqueue_add_buf and virtqueue_add_sg are very different, despite the
> similar name.

True. The similarity is between _start and _add_buf.
And this is confusing too. Maybe this means
_start and _add_sg should be renamed.

> > I'm not against changing virtqueue_add_buf if you like but let's keep
> > it all consistent.
> 
> How can you change virtqueue_add_buf?

Donnu.

-- 
MST
