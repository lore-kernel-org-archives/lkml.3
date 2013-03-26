Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697Ab3CZQaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:30:23 -0400
Received: from fieldses.org ([174.143.236.118]:54100 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933918Ab3CZQaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:30:19 -0400
Date: Tue, 26 Mar 2013 12:30:11 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130326163011.GC3353@fieldses.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130203170241.GA24778@fieldses.org>
 <20130204001557.GB24778@fieldses.org>
 <20130204171031.GK27963@mtj.dyndns.org>
 <20130204171128.GL27963@mtj.dyndns.org>
 <20130321140618.GD27838@fieldses.org>
 <20130321183513.GC20500@htj.dyndns.org>
 <20130326111936.550110bf@tlielax.poochiereds.net>
 <20130326152653.GA3061@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326152653.GA3061@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 08:26:53AM -0700, Tejun Heo wrote:
> Hello, Jeff.
> 
> On Tue, Mar 26, 2013 at 11:19:36AM -0400, Jeff Layton wrote:
> > +/**
> > + * idr_alloc_cyclic - allocate new idr entry in a cyclical fashion
> > + * @idr: the (initialized) idr
> > + * @ptr: pointer to be associated with the new id
> > + * @start: the minimum id (inclusive)
> > + * @end: the maximum id (exclusive, <= 0 for max)
> > + * @cur: ptr to current position in the range (typically, last allocated + 1)
> > + * @gfp_mask: memory allocation flags
> > + *
> > + * Essentially the same as idr_alloc, but prefers to allocate progressively
> > + * higher ids if it can. If the "cur" counter wraps, then it will start again
> > + * at the "start" end of the range and allocate one that has already been used.
> > + */
> > +int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, int *cur,
> > +			gfp_t gfp_mask)
> > +{
> > +	int id;
> > +
> > +	id = idr_alloc(idr, ptr, *cur, end, gfp_mask);
> > +	if (id == -ENOSPC)
> > +		id = idr_alloc(idr, ptr, start, end, gfp_mask);
> > +
> > +	if (likely(id >= 0))
> > +		*cur = id + 1;
> > +	return id;
> > +}
> 
> Wouldn't it be better if idr itself could remember the last position?
> Also, @start/@end should always be honored even if, say, @start moves
> above the last position.  Other than that, yeah.

The old nfsd stateid code just generated stateid's from a counter,
something like:

	static u32 counter;
	return counter++;

and then stuck them in a hash table.  Which had the obvious bug with
(very unlikely, absent malice) collisions on wraparound.

I probably should have ignored idr and just made the obvious fix:

	static u32 counter;

	while (!id_exists_in_hash(counter))
		counter++;
	return counter;

So maybe we should just go back to that.  And possibly choose some
better data structure.

The only requirements are that at a given moment in time id's should be
unique, and that we should make some effort to avoid reusing them
immediately.

I don't know what other "cyclic" idr users need.

--b.
