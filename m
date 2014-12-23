Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaLWMZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:25:04 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56767 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaLWMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:25:01 -0500
Date: Tue, 23 Dec 2014 13:24:58 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 08/17] block: refactor __bio_copy_iov()
Message-ID: <20141223122458.GF15080@gmail.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <20141223104551.GC27600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141223104551.GC27600@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.2014 02:45, Christoph Hellwig wrote:
> >  static int __bio_copy_iov(struct bio *bio, const struct iov_iter *iter,
> > +			  int to_iov)
> >  {
> > +	int i;
> >  	struct bio_vec *bvec;
> >  	struct iov_iter iov_iter = *iter;
> 
> Why not pass the iov_iter by value?

Agreed.

> >  	bio_for_each_segment_all(bvec, bio, i) {
> > +		ssize_t ret;
> > +
> > +		if (to_iov == WRITE)
> > +			ret = copy_page_to_iter(bvec->bv_page,
> > +						bvec->bv_offset,
> > +						bvec->bv_len,
> > +						&iov_iter);
> > +		else
> > +			ret = copy_page_from_iter(bvec->bv_page,
> > +						  bvec->bv_offset,
> > +						  bvec->bv_len,
> > +						  &iov_iter);
> > +
> > +		if (!iov_iter_count(&iov_iter))
> > +			break;
> >  
> > +		if (ret < bvec->bv_len)
> > +			return -EFAULT;
> >  	}
> >  
> > +	return 0;
> 
> Seems like this should be split into two functions for the read
> and write cases?

Agreed. I'll update it in the next round.

Thanks,
Dongsu
