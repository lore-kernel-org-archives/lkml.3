Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaENGMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:12:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaENGM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:12:29 -0400
Date: Wed, 14 May 2014 07:12:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 17/19] fs: buffer: Do not use unnecessary atomic
 operations when discarding buffers
Message-ID: <20140514061222.GW23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-18-git-send-email-mgorman@suse.de>
 <20140513152900.ea0a58cf4a650fb0b4110e3e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140513152900.ea0a58cf4a650fb0b4110e3e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:29:00PM -0700, Andrew Morton wrote:
> On Tue, 13 May 2014 10:45:48 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > Discarding buffers uses a bunch of atomic operations when discarding buffers
> > because ...... I can't think of a reason. Use a cmpxchg loop to clear all the
> > necessary flags. In most (all?) cases this will be a single atomic operations.
> > 
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1485,14 +1485,18 @@ EXPORT_SYMBOL(set_bh_page);
> >   */
> >  static void discard_buffer(struct buffer_head * bh)
> >  {
> > +	unsigned long b_state, b_state_old;
> > +
> >  	lock_buffer(bh);
> >  	clear_buffer_dirty(bh);
> >  	bh->b_bdev = NULL;
> > -	clear_buffer_mapped(bh);
> > -	clear_buffer_req(bh);
> > -	clear_buffer_new(bh);
> > -	clear_buffer_delay(bh);
> > -	clear_buffer_unwritten(bh);
> > +	b_state = bh->b_state;
> > +	for (;;) {
> > +		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
> > +		if (b_state_old == b_state)
> > +			break;
> > +		b_state = b_state_old;
> > +	}
> >  	unlock_buffer(bh);
> >  }
> >  
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -77,6 +77,11 @@ struct buffer_head {
> >  	atomic_t b_count;		/* users using this buffer_head */
> >  };
> >  
> > +/* Bits that are cleared during an invalidate */
> > +#define BUFFER_FLAGS_DISCARD \
> > +	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
> > +	 1 << BH_Delay | 1 << BH_Unwritten)
> > +
> 
> There isn't much point in having this in the header file is there?
> 

No, it's not necessary. I was just keeping it with the definition of the
flags. Your fix on top looks fine.

-- 
Mel Gorman
SUSE Labs
