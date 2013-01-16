Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3APDkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:40:07 -0500
Received: from ozlabs.org ([203.10.76.45]:43618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab3APDkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:40:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
In-Reply-To: <20130114173914.GB19207@redhat.com>
References: <871ug75vp1.fsf@rustcorp.com.au> <1354718230-4486-1-git-send-email-sjur@brendeland.net> <20121206102750.GF10837@redhat.com> <877goc0wac.fsf@rustcorp.com.au> <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com> <87pq1f2rj0.fsf@rustcorp.com.au> <87wqvl1g9s.fsf@rustcorp.com.au> <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com> <87pq1c1uj4.fsf@rustcorp.com.au> <877gnk1ayv.fsf@rustcorp.com.au> <20130114173914.GB19207@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 16 Jan 2013 13:43:32 +1030
Message-ID: <874nihzuoz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
>> +static int resize_iovec(struct vringh_iov *iov, gfp_t gfp)
>> +{
>> +	struct iovec *new;
>> +	unsigned int new_num = iov->max * 2;
>
> We must limit this I think, this is coming
> from userspace. How about UIO_MAXIOV?

We limit it to the ring size already; UIO_MAXIOV is a weird choice here.

>> +static u16 __cold return_from_indirect(const struct vringh *vrh, int *up_next,
>> +				       struct vring_desc **descs, int *desc_max)
>
> Not sure it should be cold like that - virtio net uses indirect on data
> path.

This is only when we have a chained, indirect descriptor (ie. we have to
go back up to the next entry in the main descriptor table).  That's
allowed in the spec, but noone does it.
>> +		/* Make sure it's OK, and get offset. */
>> +		if (!check_range(desc.addr, desc.len, &range, getrange)) {
>> +			err = -EINVAL;
>> +			goto fail;
>> +		}
>
> Hmm this looks like it will translate and
> validate immediate descriptors same way as indirect ones.
> vhost-net has different translation for regular descriptors
> and indirect ones, both for speed and to allow ring aliasing,
> so it has to know which is which.

I see translate_desc() in both cases, what's different?

>> +		addr = (void *)(long)desc.addr + range.offset;
>
> I really dislike raw pointers that we must never dereference.
> Since we are forcing everything to __user anyway, why don't we
> tag all addresses as __user? The kernel users of this API
> can cast that away, this will keep the casts to minimum.
>
> Failing that, we can add our own class
> # define __virtio         __attribute__((noderef, address_space(2)))

In this case, perhaps we should leave addr as a u64?

>> +		iov->iov[iov->i].iov_base = (__force __user void *)addr;
>> +		iov->iov[iov->i].iov_len = desc.len;
>> +		iov->i++;
>
>
> This looks like it won't do the right thing if desc.len spans multiple
> ranges. I don't know if this happens in practice but this is something
> vhost supports ATM.

Well, kind of.  I assumed that the bool (*getrange)(u64, struct
vringh_range *)) callback would meld any adjacent ranges if it needs to.

>> +/* All the information about an iovec. */
>> +struct vringh_iov {
>> +	struct iovec *iov;
>> +	unsigned i, max;
>> +	bool allocated;
>
> MAybe set iov = NULL when not allocated?

The idea was that iov points to the initial (on-stack?) iov, for the
fast path.

I'm writing a more complete test at the moment, then I will look at how
this fits with vhost.c as it stands...

Cheers,
Rusty.
