Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaFVA01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 20:26:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53317 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaFVA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 20:26:26 -0400
Date: Sun, 22 Jun 2014 01:26:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: 32-bit bug in iovec iterator changes
Message-ID: <20140622002618.GR18016@ZenIV.linux.org.uk>
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
 <20140619160801.GB4907@thunk.org>
 <20140619162144.GC4907@thunk.org>
 <20140619223820.GN4453@dastard>
 <20140621035144.GA8526@thunk.org>
 <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403395400.2592.4.camel@jarvis.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 05:03:20PM -0700, James Bottomley wrote:

> > Anyway, does the following alone fix the problem you are seeing?
> > 
> > diff --git a/include/linux/uio.h b/include/linux/uio.h
> > index ddfdb53..dbb02d4 100644
> > --- a/include/linux/uio.h
> > +++ b/include/linux/uio.h
> > @@ -94,7 +94,7 @@ static inline size_t iov_iter_count(struct iov_iter *i)
> >  	return i->count;
> >  }
> >  
> > -static inline void iov_iter_truncate(struct iov_iter *i, size_t count)
> > +static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
> >  {
> >  	if (i->count > count)
> >  		i->count = count;
> 
> Al, how can that work?  i->count is size_t, which is 32 bit, so we're
> going to get truncation errors.

No, we are not.  Look:
	* comparison promotes both operands to u64 here, so its result is
accurate, no matter how large count is.  They are compared as natural
numbers.
	* assignment converts count to size_t, which *would* truncate for
values that are greater than the maximal value representable by size_t.
But in that case it's by definition greater than i->count, so we do not
reach that assignment at all.
