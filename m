Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaKECX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:23:26 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:40830 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaKECXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:23:25 -0500
Date: Wed, 5 Nov 2014 10:22:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141105022251.GA19136@gondor.apana.org.au>
References: <20141104033818.GA11149@gondor.apana.org.au>
 <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
 <20141104143200.GC7996@ZenIV.linux.org.uk>
 <20141104144258.GA14743@gondor.apana.org.au>
 <20141104151353.GG7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104151353.GG7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 03:13:55PM +0000, Al Viro wrote:
> 
> Think of it that way: every sendmsg/recvmsg path leading to memcpy_fromiovec
> and its friends (including the open-coded ones) would need to be changed
> at some point.  Assuming we do not end up passing struct iov_iter * as
> an extra argument through a fairly large part of net/* (and that would
> be prohibitively hard and messy, not to mention the effects on the stack
> footprint, etc.), the most obvious strategy is to have that thing passed
> where msg_iov/msg_iovlen are - in struct msghdr.  *IF* we go that way,
> it makes a whole lot of sense to start with a bunch of cleanups that
> will make sense on their own (most of callers of skb_copy_datagram_iovec
> do look like skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied); might
> as well give it an inlined helper) and will reduce the amount of places
> where ->msg_iov is used.  With such cleanups standing on their own and
> being splittable from the rest of the queue.  And leaving us with fewer
> places in code that deal with ->msg_iov and need to be dealt with.

I think your solution is great.  However, I don't see how my four
patches impede in anyway the work that you're doing.  I presume
your first patch will make skb_copy_datagram_msg just a wrapper
around skb_copy_datagram_iovec.

Since I'm not removing skb_copy_datagram_iovec (it can't be removed
until all users are gone) you can still do that and when you're
ready to switch over to iov_iter you can just move the wrapper over
to skb_copy_datagram_iter.  No?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
