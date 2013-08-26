Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3HZOhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:37:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42614 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3HZOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:37:33 -0400
Date: Mon, 26 Aug 2013 17:37:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        Jeff Liu <jeff.liu@oracle.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: check for underflow in xfs_iformat_fork()
Message-ID: <20130826143714.GA6329@mwanda>
References: <20130815055338.GC23580@elgon.mountain>
 <520CA923.4060409@oracle.com>
 <20130815143706.GI7153@sgi.com>
 <20130815222650.GX6023@dastard>
 <20130823173613.GT5262@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823173613.GT5262@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 12:36:13PM -0500, Ben Myers wrote:
> Dan,
> 
> On Fri, Aug 16, 2013 at 08:26:50AM +1000, Dave Chinner wrote:
> > On Thu, Aug 15, 2013 at 09:37:06AM -0500, Ben Myers wrote:
> > > Hey Dan & Jeff,
> > > 
> > > On Thu, Aug 15, 2013 at 06:10:43PM +0800, Jeff Liu wrote:
> > > > On 08/15/2013 01:53 PM, Dan Carpenter wrote:
> > > > 
> > > > > The "di_size" variable comes from the disk and it's a signed 64 bit.
> > > > > We check the upper limit but we should check for negative numbers as
> > > > > well.
> > > > > 
> > > > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> > > > > index 123971b..849fc70 100644
> > > > > --- a/fs/xfs/xfs_inode_fork.c
> > > > > +++ b/fs/xfs/xfs_inode_fork.c
> > > > > @@ -167,7 +167,8 @@ xfs_iformat_fork(
> > > > >  			}
> > > > >  
> > > > >  			di_size = be64_to_cpu(dip->di_size);
> > > > > -			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> > > > > +			if (unlikely(di_size < 0 ||
> > > > 
> > > > But the di_size is initialized to ZERO while allocating a new inode on disk.
> > > > I wonder if that is better to ASSERT in this case because the current check
> > > > is used to make sure that the item is inlined, or we don't need it at all.
> > > 
> > > Hmm.  Dan's additional check looks good to me.  In this case I'd say the forced
> > > shutdown is more appropriate than an assert, because here we're reading the
> > > inode from disk, as opposed to looking at a structure that is already incore
> > > which we think we've initialized.  We want to handle unexpected inputs from
> > > disk without crashing even if we are CONFIG_XFS_DEBUG.
> > 
> > There are lots of places where we only check di_size to be greater
> > than some value, and don't check for it being less than zero. Hence
> > I think that a better solution might be to di_size unsigned as that
> > will catch "negative" sizes for all types of situations.
> 
> What do you say to making di_size unsigned?  Any interest?
> 

I'm not the right person to change "lots of places".  Some of these
are probably subtle.  Just give me the reported-by and I'm happy.

regards,
dan carpenter

