Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKCAQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:16:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35367 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaKCAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:16:43 -0500
Date: Mon, 3 Nov 2014 00:16:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: fs: Use non-const iov in aio_read/aio_write
Message-ID: <20141103001634.GV7996@ZenIV.linux.org.uk>
References: <20141102230552.GA26095@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141102230552.GA26095@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 07:05:52AM +0800, Herbert Xu wrote:
> Currently the functions aio_read/aio_write use a const iov as
> input.  This is unnecessary as all their callers supply a
> stack-based or kmalloced iov which is never reused.  Conceptually
> this is fine because iovs supplied to aio_read/aio_write ultimately
> come from user-space so we always have to make a copy of them for
> the kernel.
> 
> This is also a joke because for as long (since 2.1.15) as we've
> had the const iov, the network stack (currently through do_sock_read
> and do_sock_write) has been casting the const away.  IOW if anybody
> did supply a const iov they would crash and burn if they ever
> entered the network stack.
> 
> The network stack needs a non-const iov because it iterates through
> the iov as it reads/writes data.
> 
> So we have two alternatives, either change the network stack to
> not touch the iovs or make the iovs non-const.
> 
> As there is no reason for the iovs to be const in the first place,
> I have taken the second choice and changed all aio_read/aio_write
> functions to use non-const iovs.

NAK with extreme prejudice.  The right way to deal with that is
to convert the socket side of things to iov_iter.  And give it a
consistent behaviour, while we are at it (some protocols do advance
the damn thing, so do not).  There are _very_ good reasons to have those
iovecs unchanged - if you look at the callers on the socket side, you'll
see a bunch that has to _copy_ iovec just to avoid it being buggered.
And you get rather suboptimal behaviour in memcpy_fromiovec() and friends,
exactly because you have to skip through the emptied elements.

IOW, no way in hell.
