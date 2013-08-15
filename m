Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3HOOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:37:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59809 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab3HOOhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:37:08 -0400
Date: Thu, 15 Aug 2013 09:37:06 -0500
From: Ben Myers <bpm@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Jeff Liu <jeff.liu@oracle.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] xfs: check for underflow in xfs_iformat_fork()
Message-ID: <20130815143706.GI7153@sgi.com>
References: <20130815055338.GC23580@elgon.mountain>
 <520CA923.4060409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520CA923.4060409@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan & Jeff,

On Thu, Aug 15, 2013 at 06:10:43PM +0800, Jeff Liu wrote:
> On 08/15/2013 01:53 PM, Dan Carpenter wrote:
> 
> > The "di_size" variable comes from the disk and it's a signed 64 bit.
> > We check the upper limit but we should check for negative numbers as
> > well.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> > index 123971b..849fc70 100644
> > --- a/fs/xfs/xfs_inode_fork.c
> > +++ b/fs/xfs/xfs_inode_fork.c
> > @@ -167,7 +167,8 @@ xfs_iformat_fork(
> >  			}
> >  
> >  			di_size = be64_to_cpu(dip->di_size);
> > -			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> > +			if (unlikely(di_size < 0 ||
> 
> But the di_size is initialized to ZERO while allocating a new inode on disk.
> I wonder if that is better to ASSERT in this case because the current check
> is used to make sure that the item is inlined, or we don't need it at all.

Hmm.  Dan's additional check looks good to me.  In this case I'd say the forced
shutdown is more appropriate than an assert, because here we're reading the
inode from disk, as opposed to looking at a structure that is already incore
which we think we've initialized.  We want to handle unexpected inputs from
disk without crashing even if we are CONFIG_XFS_DEBUG.

How did you come across this one?

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
Ben
