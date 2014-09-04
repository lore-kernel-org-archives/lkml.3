Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaIDVIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:08:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:15102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbaIDVIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:08:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,468,1406617200"; 
   d="scan'208";a="598142063"
Date: Thu, 4 Sep 2014 17:08:02 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        willy@linux.intel.com, Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v10 19/21] xip: Add xip_zero_page_range
Message-ID: <20140904210802.GA27730@localhost.localdomain>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
 <80c8efc903971eb3a338f262fbd3ef135db63eb0.1409110741.git.matthew.r.wilcox@intel.com>
 <20140903092116.GF20473@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903092116.GF20473@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 07:21:16PM +1000, Dave Chinner wrote:
> > @@ -481,9 +484,14 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
> >  		err = dax_get_addr(&bh, &addr, inode->i_blkbits);
> >  		if (err < 0)
> >  			return err;
> > +		/*
> > +		 * ext4 sometimes asks to zero past the end of a block.  It
> > +		 * really just wants to zero to the end of the block.
> > +		 */
> > +		length = min_t(unsigned, length, PAGE_CACHE_SIZE - offset);
> >  		memset(addr + offset, 0, length);
> 
> Sorry, what?
> 
> You introduce that bug with the way dax_truncate_page() is redefined
> to always pass PAGE_CACHE_SIZE a a length later on in this patch.
> into the function. That's hardly an ext4 bug....

ext4 does (or did?) have this bug (expectation?).  I then take advantage
of the fact that we have to accommodate it, so there are now two places
that have to accommodate it.  I forget what the path was that has that
assumption, but xfstests used to display it.

I'm away this week (... bad timing), but I can certainly fix it elsewhere
in ext4 next week.

> >  int dax_clear_blocks(struct inode *, sector_t block, long size);
> > +int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
> >  int dax_truncate_page(struct inode *, loff_t from, get_block_t);
> 
> It's still defined as a function that doesn't exist now....

Oops.

> > +/* Can't be a function because PAGE_CACHE_SIZE is defined in pagemap.h */
> > +#define dax_truncate_page(inode, from, get_block)	\
> > +	dax_zero_page_range(inode, from, PAGE_CACHE_SIZE, get_block)
> 
> And then redefined as a macro here.

Heh, which means we never notice the stale delaration above.  Thanks, C!

> This is wrong, IMO,
> dax_truncate_page() should remain as a function and it should
> correctly calculate how much of the page shoul dbe trimmed, not
> leave landmines that other code has to clean up...
> 
> (Yup, I'm tracking down a truncate bug in XFS from fsx...)

I'll put an assert in the rewrite, make sure that nobody's trying to
overtruncate.

