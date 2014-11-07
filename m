Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaKGB62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:58:28 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33376 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKGB60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:58:26 -0500
Date: Fri, 7 Nov 2014 09:58:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141107015815.GA9101@gondor.apana.org.au>
References: <20141106082704.GB29800@gondor.apana.org.au>
 <E1XmIQU-0007m1-2e@gondolin.me.apana.org.au>
 <20141106173012.GY7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106173012.GY7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:30:12PM +0000, Al Viro wrote:
> On Thu, Nov 06, 2014 at 04:28:18PM +0800, Herbert Xu wrote:
> > +		if (copy_to_iter(skb->data + offset, copy, to))
> > +			goto fault;
> 
> Sorry, no - copy_to_iter() returns the number of bytes copied, not 0 or -EFAULT.
>
> > +			vaddr = kmap(page);
> > +			err = copy_to_iter(vaddr + frag->page_offset +
> > +					   offset - start, copy, to);
> > +			kunmap(page);
> > +			if (err)
> > +				goto fault;
> 
> And that one should be
> 			copied = copy_page_to_iter(page, frag->page_offset +
> 					   offset - start, copy, to);
> 			if (copied != copy)
> 				goto fault;
> 
> Don't bother with kmap(), vaddr and all that shite.  The primitive is
> 	copy_page_to_iter(page, offset_in_page, nbytes, iter)
> it does all needed kmap itself and it's smart enough to use kmap_atomic
> when it can get away with that.  Similar for copy_page_from_iter().
> 
> Both of those (as well as copy_{to,from}_iter()) advance iov_iter and return
> the number of bytes actually copied.  So the check for EFAULT is "it has copied
> less than you've asked it to copy *and* you haven't run out that iov_iter".
> The second part is guaranteed to be true in this case - your code makes sure
> that 'copy' is no more than the space left in iterator.
> 
> In general, this check would be spelled
> 			if (copied != copy && iov_iter_count(to))
> 				goto fault;

Thanks, I'll redo the patches.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
