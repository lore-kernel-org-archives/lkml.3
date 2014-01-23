Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaAWMI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:08:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:22574 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaAWMI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:08:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,705,1384329600"; 
   d="scan'208";a="443425816"
Date: Thu, 23 Jan 2014 07:08:29 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 22/22] XIP: Add support for unwritten extents
Message-ID: <20140123120829.GF5722@linux.intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
 <CEFD7DAD.22F65%matthew.r.wilcox@intel.com>
 <alpine.OSX.2.00.1401221546240.70541@scrumpy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1401221546240.70541@scrumpy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 03:51:56PM -0700, Ross Zwisler wrote:
> > +			if (hole) {
> >  				addr = NULL;
> > -				hole = true;
> >  				size = bh->b_size;
> > +			} else {
> > +				unsigned first;
> > +				retval = xip_get_addr(inode, bh, &addr);
> > +				if (retval < 0)
> > +					break;
> > +				size = retval;
> > +				first = offset - (block << inode->i_blkbits);
> > +				if (buffer_unwritten(bh))
> > +					memset(addr, 0, first);
> > +				addr += first;
> 
> +                               size -= first;
> 
> This is needed so that we don't overrun the XIP buffer we are given in the
> event that our user buffer >= our XIP buffer and the start of our I/O isn't
> block aligned.

You're right!  Thank you!  However, we also need it for the hole ==
true case, don't we?  So maybe something like this, incrementally on top of
patch 22/22:

P.S. Can someone come up with a better name for this variable than 'first'?
I'd usually use 'offset', but that's already taken.  'annoying_bit' seems a
bit judgemental.  'misaligned', maybe?  'skip' or 'seek' like dd uses?

diff --git a/fs/xip.c b/fs/xip.c
index 92157ff..1ae00db 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -103,6 +103,7 @@ static ssize_t xip_io(int rw, struct inode *inode, const struct iovec *iov,
 
 		if (max == offset) {
 			sector_t block = offset >> inode->i_blkbits;
+			unsigned first = offset - (block << inode->i_blkbits);
 			long size;
 			memset(bh, 0, sizeof(*bh));
 			bh->b_size = ALIGN(end - offset, PAGE_SIZE);
@@ -121,14 +122,12 @@ static ssize_t xip_io(int rw, struct inode *inode, const struct iovec *iov,
 
 			if (hole) {
 				addr = NULL;
-				size = bh->b_size;
+				size = bh->b_size - first;
 			} else {
-				unsigned first;
 				retval = xip_get_addr(inode, bh, &addr);
 				if (retval < 0)
 					break;
-				size = retval;
-				first = offset - (block << inode->i_blkbits);
+				size = retval - first;
 				if (buffer_unwritten(bh))
 					memset(addr, 0, first);
 				addr += first;
