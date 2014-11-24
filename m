Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaKXK2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:28:16 -0500
Received: from mx0.aculab.com ([213.249.233.131]:45095 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751062AbaKXK2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:28:14 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Al Viro'" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: RE: [RFC] situation with csum_and_copy_... API
Thread-Topic: [RFC] situation with csum_and_copy_... API
Thread-Index: AQHQBgQ34bLXouueRUuDoiZfcNPHWpxvkadw
Date: Mon, 24 Nov 2014 10:27:11 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9F9B2D@AcuExch.aculab.com>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141120222506.GS7996@ZenIV.linux.org.uk>
 <1416524035.8629.54.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141121084956.GT7996@ZenIV.linux.org.uk>
 <20141122032718.GA24457@ZenIV.linux.org.uk>
In-Reply-To: <20141122032718.GA24457@ZenIV.linux.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro
> On Fri, Nov 21, 2014 at 08:49:56AM +0000, Al Viro wrote:
> 
> > Overall, I think I have the whole series plotted in enough details to be
> > reasonably certain we can pull it off.  Right now I'm dealing with
> > mm/iov_iter.c stuff; the amount of boilerplate source is already high enough
> > and with those extra primitives it'll get really unpleasant.
> >
> > What we need there is something templates-like, as much as I hate C++, and
> > I'm still not happy with what I have at the moment...  Hopefully I'll get
> > that in more or less tolerable form today.
> 
> Folks, I would really like comments on the patch below.  It's an attempt
> to reduce the amount of boilerplate code in mm/iov_iter.c; no new primitives
> added, just trying to reduce the amount of duplication in there.  I'm not
> too fond of the way it currently looks, to put it mildly.  It seems to
> work, it's reasonably straightforward and it even generates slightly better
> code than before, but I would _very_ welcome any tricks that would allow to
> make it not so tasteless.  I like the effect on line count (+124-358), but...
> 
> It defines two iterators (for iovec-backed and bvec-backed ones) and converts
> a bunch of primitives to those.  The last argument is an expression evaluated
> for a bunch of ranges; for bvec one it's void, for iovec - size_t; if it
> evaluates to non-0, we treat it as read/write/whatever short by that many
> bytes and do not proceed any further.
> 
> Any suggestions are welcome.
> 
> diff --git a/mm/iov_iter.c b/mm/iov_iter.c
> index eafcf60..611af2bd 100644
> --- a/mm/iov_iter.c
> +++ b/mm/iov_iter.c
> @@ -4,11 +4,75 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> 
> +#define iterate_iovec(i, n, buf, len, move, STEP) {	\
> +	const struct iovec *iov = i->iov;		\
> +	size_t skip = i->iov_offset;			\
> +	size_t left;					\
> +	size_t wanted = n;				\

All these variable names probably want (at least one) _ prefix
just in case they match the names of arguments.

> +	buf = iov->iov_base + skip;			\
> +	len = min(n, iov->iov_len - skip);		\

You are assigning to parameters, this can get confusing.
Unless these are return values this probably doesn't make sense.
Might be better to 'pass by reference', the generated code is
likely to be the same - but it is clearer to the reader.

> +	left = STEP;					\
> +	len -= left;					\
> +	skip += len;					\
> +	n -= len;					\

Again, a parameter is modified.

> +	while (unlikely(!left && n)) {			\
> +		iov++;					\
> +		buf = iov->iov_base;			\
> +		len = min(n, iov->iov_len);		\
> +		left = STEP;				\
> +		len -= left;				\
> +		skip = len;				\
> +		n -= len;				\
> +	}						\
> +	n = wanted - n;					\
> +	if (move) {					\
> +		if (skip == iov->iov_len) {		\
> +			iov++;				\
> +			skip = 0;			\
> +		}					\
> +		i->count -= n;				\
> +		i->nr_segs -= iov - i->iov;		\
> +		i->iov = iov;				\
> +		i->iov_offset = skip;			\
> +	}						\
> +}
...
> +	iterate_iovec(i, bytes, buf, len, true,
> +			__copy_to_user(buf, (from += len) - len, len))
> +	return bytes;

Using 'buf' and 'len' in __copy_to_user() is very non-obvious.
It might be better if they were fixed names, maybe _ioiter_buf and _ioiter_len.

If this code can use the gcc extension that allows #defines that contain {}
to return values, the it would be better as:

	bytes_left = iterate_iovec(i, bytes, true,
		__copy_to_user(_ioiter_buf, (from += _ioiter_len) - _ioiter_len,
			_ioiter_len);
	return bytes_left;

Possibly also two wrapper #defines that supply the true/false parameter.

	David



