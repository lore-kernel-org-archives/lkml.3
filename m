Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab3AQJy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:54:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866Ab3AQJyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:54:55 -0500
Date: Thu, 17 Jan 2013 11:58:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
Message-ID: <20130117095845.GD14388@redhat.com>
References: <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
 <87pq1f2rj0.fsf@rustcorp.com.au>
 <87wqvl1g9s.fsf@rustcorp.com.au>
 <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
 <87pq1c1uj4.fsf@rustcorp.com.au>
 <877gnk1ayv.fsf@rustcorp.com.au>
 <20130114173914.GB19207@redhat.com>
 <874nihzuoz.fsf@rustcorp.com.au>
 <20130116081606.GB11465@redhat.com>
 <87k3rcy2y2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3rcy2y2.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 12:40:29PM +1030, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Wed, Jan 16, 2013 at 01:43:32PM +1030, Rusty Russell wrote:
> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> >> +static int resize_iovec(struct vringh_iov *iov, gfp_t gfp)
> >> >> +{
> >> >> +	struct iovec *new;
> >> >> +	unsigned int new_num = iov->max * 2;
> >> >
> >> > We must limit this I think, this is coming
> >> > from userspace. How about UIO_MAXIOV?
> >> 
> >> We limit it to the ring size already;
> >
> > 1. do we limit it in case there's a loop in the descriptor ring?
> 
> Yes, we catch loops as per normal (simple counter):
> 
> 		if (count++ == vrh->vring.num) {
> 			vringh_bad("Descriptor loop in %p", descs);
> 			err = -ELOOP;
> 			goto fail;
> 		}
> 
> > 2. do we limit it in case there are indirect descriptors?
> > I guess I missed where we do this could you point this out to me?
> 
> Well, the total is limited above, indirect descriptors or no (since we
> handle them inline).  Because each indirect descriptor must contain one
> descriptor (we always grab descriptor 0), the loop must terminate.
> 
> >> UIO_MAXIOV is a weird choice here.
> >
> > It's kind of forced by the need to pass the iov on to the linux kernel,
> > so we know that any guest using more is broken on existing hypervisors.
> >
> > Ring size is somewhat arbitrary too, isn't it?  A huge ring where we
> > post lots of short descriptors (e.g. RX buffers) seems like a valid thing to do.
> 
> Sure, but the ring size is a documented limit (even if indirect
> descriptors are used).  I hadn't realized we have an
> implementation-specific limit of 1024 descriptors: I shall add this.
> While noone reasonable will exceed that, we should document it somewhere
> in the spec.
> 
> >> > I really dislike raw pointers that we must never dereference.
> >> > Since we are forcing everything to __user anyway, why don't we
> >> > tag all addresses as __user? The kernel users of this API
> >> > can cast that away, this will keep the casts to minimum.
> >> >
> >> > Failing that, we can add our own class
> >> > # define __virtio         __attribute__((noderef, address_space(2)))
> >> 
> >> In this case, perhaps we should leave addr as a u64?
> >
> > Point being? All users will cast to a pointer.
> > It seems at first passing in raw pointers is cleaner,
> > but it turns out in the API we are passing iovs around,
> > and they are __user anyway.
> > So using raw pointers here does not buy us anything,
> > so let's use __user and gain extra static checks at no cost.
> 
> I resist sprinkling __user everywhere because it's *not* always user
> addresses, and it's deeply misleading to anyone reading it.  I'd rather
> have it in one place with a big comment.
> I can try using a union of kvec and iovec, since they are the same
> layout in practice AFAICT.

I suggest the following easy fix: as you say, it's
in one place with a bug comment.

/* On the host side we often communicate to untrusted
 * entities over virtio, so set __user tag on addresses
 * we get helps make sure we don't directly dereference the addresses,
 * while making it possible to pass the addresses in iovec arrays
 * without casts.
 */
#define __virtio __user

/* A helper to discard __virtio tag - only call when
 * you are communicating to a trusted entity.
 */
static inline void *virtio_raw_addr(__virtio void *addr)
{
	return (__force void *)addr;
}

Hmm?

> 
> >> >> +		iov->iov[iov->i].iov_base = (__force __user void *)addr;
> >> >> +		iov->iov[iov->i].iov_len = desc.len;
> >> >> +		iov->i++;
> >> >
> >> >
> >> > This looks like it won't do the right thing if desc.len spans multiple
> >> > ranges. I don't know if this happens in practice but this is something
> >> > vhost supports ATM.
> >> 
> >> Well, kind of.  I assumed that the bool (*getrange)(u64, struct
> >> vringh_range *)) callback would meld any adjacent ranges if it needs to.
> >
> > Confused. If addresses 0 to 0x1000 map to virtual addresses 0 to 0x1000
> > and 0x1000 to 0x2000 map to virtual addresses 0x2000 to 0x3000, then
> > a single descriptor covering 0 to 0x2000 in guest needs two
> > iov entries. What can getrange do about it?
> 
> getrange doesn't map virtual to physical, it maps virtual to user.
> 
> Cheers,
> Rusty.
