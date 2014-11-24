Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaKXKDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:03:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39441 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKXKDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:03:22 -0500
Date: Mon, 24 Nov 2014 10:03:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jason Wang <jasowang@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [PATCH 07/17] new helpers: skb_copy_datagram_from_iter() and
 zerocopy_sg_from_iter()
Message-ID: <20141124100314.GD7996@ZenIV.linux.org.uk>
References: <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <20141120.182339.972861702759954603.davem@davemloft.net>
 <20141121.122615.1091044030302005883.davem@davemloft.net>
 <20141122042856.GZ7996@ZenIV.linux.org.uk>
 <20141122043320.GG30478@ZenIV.linux.org.uk>
 <1416787365.7215.63.camel@decadent.org.uk>
 <5472C366.8020905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5472C366.8020905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:34:30PM +0800, Jason Wang wrote:
> >> +		copied = iov_iter_get_pages(from, pages, ~0U, MAX_SKB_FRAGS, &start);

> > Why is this condition needed, given we told iov_iter_get_pages() to
> > limit to MAX_SKB_FRAGS pages?
> 
> We don't want to send truncated packets and there's no other way to put
> those pages since it was not in the frag array.

No, his point is that it could never happen.  It could, actually - what's
confusing here (and that's inherited from zerocopy_from_iovec()) is
that 'i' is a lousy name for that variable.  It's actually "how many fragments
have we already put there?" and it is not reset when we go into the next
iteration of outer loop.

FWIW, I've just renamed it into 'frag', put
	if (frag == MAX_SKB_FRAGS)
		return -EMSGSIZE;
*before* iov_iter_get_pages(), passing MAX_SKB_FRAGS - frag as the
limit on number of pages in that call.  Voila - logics with put_page()
disappears and the inner loop is less obfuscated.

There was another bug in that function - iov_iter_get_pages() does *not*
advance the iterator; the caller needs to do iov_iter_advance() itself.
Also fixed...
