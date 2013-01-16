Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3APIMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:12:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3APIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:12:18 -0500
Date: Wed, 16 Jan 2013 10:16:06 +0200
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
Message-ID: <20130116081606.GB11465@redhat.com>
References: <20121206102750.GF10837@redhat.com>
 <877goc0wac.fsf@rustcorp.com.au>
 <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
 <87pq1f2rj0.fsf@rustcorp.com.au>
 <87wqvl1g9s.fsf@rustcorp.com.au>
 <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
 <87pq1c1uj4.fsf@rustcorp.com.au>
 <877gnk1ayv.fsf@rustcorp.com.au>
 <20130114173914.GB19207@redhat.com>
 <874nihzuoz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nihzuoz.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 01:43:32PM +1030, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> +static int resize_iovec(struct vringh_iov *iov, gfp_t gfp)
> >> +{
> >> +	struct iovec *new;
> >> +	unsigned int new_num = iov->max * 2;
> >
> > We must limit this I think, this is coming
> > from userspace. How about UIO_MAXIOV?
> 
> We limit it to the ring size already;

1. do we limit it in case there's a loop in the descriptor ring?
2. do we limit it in case there are indirect descriptors?
I guess I missed where we do this could you point this out to me?

> UIO_MAXIOV is a weird choice here.

It's kind of forced by the need to pass the iov on to the linux kernel,
so we know that any guest using more is broken on existing hypervisors.

Ring size is somewhat arbitrary too, isn't it?  A huge ring where we
post lots of short descriptors (e.g. RX buffers) seems like a valid thing to do.

> >> +static u16 __cold return_from_indirect(const struct vringh *vrh, int *up_next,
> >> +				       struct vring_desc **descs, int *desc_max)
> >
> > Not sure it should be cold like that - virtio net uses indirect on data
> > path.
> 
> This is only when we have a chained, indirect descriptor (ie. we have to
> go back up to the next entry in the main descriptor table).  That's
> allowed in the spec, but noone does it.
> >> +		/* Make sure it's OK, and get offset. */
> >> +		if (!check_range(desc.addr, desc.len, &range, getrange)) {
> >> +			err = -EINVAL;
> >> +			goto fail;
> >> +		}
> >
> > Hmm this looks like it will translate and
> > validate immediate descriptors same way as indirect ones.
> > vhost-net has different translation for regular descriptors
> > and indirect ones, both for speed and to allow ring aliasing,
> > so it has to know which is which.
> 
> I see translate_desc() in both cases, what's different?
> >> +		addr = (void *)(long)desc.addr + range.offset;
> >
> > I really dislike raw pointers that we must never dereference.
> > Since we are forcing everything to __user anyway, why don't we
> > tag all addresses as __user? The kernel users of this API
> > can cast that away, this will keep the casts to minimum.
> >
> > Failing that, we can add our own class
> > # define __virtio         __attribute__((noderef, address_space(2)))
> 
> In this case, perhaps we should leave addr as a u64?

Point being? All users will cast to a pointer.
It seems at first passing in raw pointers is cleaner,
but it turns out in the API we are passing iovs around,
and they are __user anyway.
So using raw pointers here does not buy us anything,
so let's use __user and gain extra static checks at no cost.


> >> +		iov->iov[iov->i].iov_base = (__force __user void *)addr;
> >> +		iov->iov[iov->i].iov_len = desc.len;
> >> +		iov->i++;
> >
> >
> > This looks like it won't do the right thing if desc.len spans multiple
> > ranges. I don't know if this happens in practice but this is something
> > vhost supports ATM.
> 
> Well, kind of.  I assumed that the bool (*getrange)(u64, struct
> vringh_range *)) callback would meld any adjacent ranges if it needs to.

Confused. If addresses 0 to 0x1000 map to virtual addresses 0 to 0x1000
and 0x1000 to 0x2000 map to virtual addresses 0x2000 to 0x3000, then
a single descriptor covering 0 to 0x2000 in guest needs two
iov entries. What can getrange do about it?


> >> +/* All the information about an iovec. */
> >> +struct vringh_iov {
> >> +	struct iovec *iov;
> >> +	unsigned i, max;
> >> +	bool allocated;
> >
> > MAybe set iov = NULL when not allocated?
> 
> The idea was that iov points to the initial (on-stack?) iov, for the
> fast path.
> 
> I'm writing a more complete test at the moment, then I will look at how
> this fits with vhost.c as it stands...
> 
> Cheers,
> Rusty.
