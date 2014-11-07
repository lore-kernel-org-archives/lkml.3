Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaKGWgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:36:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51208 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKGWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:36:01 -0500
Date: Fri, 7 Nov 2014 22:35:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@redhat.com>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141107223558.GD7996@ZenIV.linux.org.uk>
References: <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
 <20141107.164859.951682597018909290.davem@redhat.com>
 <20141107221114.GB7996@ZenIV.linux.org.uk>
 <20141107223153.GC7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107223153.GC7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:31:53PM +0000, Al Viro wrote:
> On Fri, Nov 07, 2014 at 10:11:14PM +0000, Al Viro wrote:
> 
> > I'm looking through the tree right now; so far it looks like we can just
> > move those suckers to the point where we validate iovec and lose them
> > from low-level iovec and csum copying completely.  I still haven't finished
> > tracing all possible paths for address to arrive at the points where we
> > currently check that stuff, but so far it looks very doable.
> 
> BTW, csum side of that is also chock-full of duplicate access_ok() -
> e.g. generic csum_and_copy_from_user() checks before calling
> csum_partial_copy_from_user().  And generic instance of that is using
> __copy_from_user(), all right, but a _lot_ of non-default instances
> repeat that access_ok().

While we are at it: here's the default csum_and_copy_to_user()
static __inline__ __wsum csum_and_copy_to_user
(const void *src, void __user *dst, int len, __wsum sum, int *err_ptr)
{
        sum = csum_partial(src, len, sum);

        if (access_ok(VERIFY_WRITE, dst, len)) {
                if (copy_to_user(dst, src, len) == 0)
                        return sum;
        }
        if (len)
                *err_ptr = -EFAULT;

        return (__force __wsum)-1; /* invalid checksum */
}

Note that we do that access_ok() and follow it with copy_to_user() on exact
same range, i.e. repeat the same damn check...
