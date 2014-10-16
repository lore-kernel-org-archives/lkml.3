Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaJQHDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:03:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:40866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbaJQHDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:03:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="615952002"
Date: Thu, 16 Oct 2014 18:01:26 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 19/21] dax: Add dax_zero_page_range
Message-ID: <20141016220126.GK11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-20-git-send-email-matthew.r.wilcox@intel.com>
 <20141016123824.GQ19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016123824.GQ19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:38:24PM +0200, Mathieu Desnoyers wrote:
> > +int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
> 
> nit: unsigned -> unsigned int ?
> 
> Do we want a unsigned int or unsigned long here ?

It's supposed to be for a fragment of a page, so until we see a machine
with PAGE_SIZE > 4GB, we're good to use an unsigned int.

> >  	if (!length)
> >  		return 0;
> > +	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
> 
> Isn't it a bit extreme to BUG_ON this condition ? We could return an
> error to the caller, and perhaps WARN_ON_ONCE(), but BUG_ON() appears to
> be slightly too strong here.

Dave Chinner asked for it :-)  The filesystem is supposed to be doing
this clamping (until the last version, I had this function doing the
clamping, and I was told off for "leaving landmines lying around".

> > +static inline int dax_zero_page_range(struct inode *i, loff_t frm,
> > +						unsigned len, get_block_t gb)
> > +{
> > +	return 0;
> 
> Should we return 0 or -ENOSYS here ?

I kind of wonder if we shouldn't just declare the function.  It's called
like this:

        if (IS_DAX(inode))
                return dax_zero_page_range(inode, from, length, ext4_get_block);
        return __ext4_block_zero_page_range(handle, mapping, from, length);

and if CONFIG_DAX is not set, IS_DAX evaluates to 0 at compile time, so
the compiler will optimise out the call to dax_zero_page_range() anyway.
