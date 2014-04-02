Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbaDBTf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:35:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:21929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993AbaDBTf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,782,1389772800"; 
   d="scan'208";a="505576307"
Date: Wed, 2 Apr 2014 15:27:59 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/22] Change direct_access calling convention
Message-ID: <20140402192759.GD27299@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <214af2a38d840d0b8e983d39d03711d1292bc2d6.1395591795.git.matthew.r.wilcox@intel.com>
 <20140329163028.GD1211@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140329163028.GD1211@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 05:30:28PM +0100, Jan Kara wrote:
> > @@ -379,7 +379,9 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
> >  	*kaddr = page_address(page);
> >  	*pfn = page_to_pfn(page);
> >  
> > -	return 0;
> > +	/* Could optimistically check to see if the next page in the
> > +	 * file is mapped to the next page of physical RAM */
> > +	return PAGE_SIZE;
>   This should be min_t(long, PAGE_SIZE, size), shouldn't it?

Yes, it should.  In practice, I don't think anyone's calling it with
size < PAGE_SIZE, but we might as well future-proof it.

> > @@ -866,25 +866,26 @@ fail:
> >  	bio_io_error(bio);
> >  }
> >  
> > -static int
> > +static long
> >  dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
> > -			void **kaddr, unsigned long *pfn)
> > +			void **kaddr, unsigned long *pfn, long size)
> >  {
> >  	struct dcssblk_dev_info *dev_info;
> > -	unsigned long pgoff;
> > +	unsigned long offset, dev_sz;

> > -	return 0;
> > +	return min_t(unsigned long, size, dev_sz - offset);
>                      ^^^ Why unsigned? Everything seems to be long...

offset is unsigned long ... but might as well do the comparison in signed
as unsigned.  'size' shouldn't be passed in as < 0 anyway.
