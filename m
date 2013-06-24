Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3FXVhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:37:18 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10613 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab3FXVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:37:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUOAI26yFF5LPX0/2dsb2JhbABagwmDFrd5hSsEAYELF3SCIwEBBAE6HCMFCwgDGAklDwUlAyEBEogIBbsAFo4BARqBHQeDYwOXQoofhyaDIiqBLAEBHgY
Date: Tue, 25 Jun 2013 07:37:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, g@dastard
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: check for integer overflows in posix_acl_alloc()
Message-ID: <20130624213709.GT29338@dastard>
References: <20130624162719.GB32503@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624162719.GB32503@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 07:27:19PM +0300, Dan Carpenter wrote:
> We've seen cases where people passed negative numbers to
> posix_acl_alloc() and we fixed the caller.  For example 093019cf1b "xfs:
> fix acl count validation in xfs_acl_from_disk()".

Yeah, we failed to detect an on-disk corruption correctly....

> But there are other
> places which might be affected like ext4_acl_from_disk() which checks
> for negative but doesn't check an upper limit.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index cea4623..cd7fd2f 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -46,7 +46,12 @@ posix_acl_alloc(int count, gfp_t flags)
>  {
>  	const size_t size = sizeof(struct posix_acl) +
>  	                    count * sizeof(struct posix_acl_entry);
> -	struct posix_acl *acl = kmalloc(size, flags);
> +	struct posix_acl *acl;
> +
> +	if (count < 0 || count > (SIZE_MAX - sizeof(struct posix_acl) /
> +					sizeof(struct posix_acl_entry)))
> +		return NULL;

That's not going to solve your problems, because ACLs are limied by
filesystem on-disk formats, not SIZE_MAX.  The number of valid ACLs
is capped by the fact they are stored in xattrs on most (all?)
filesystems, and so are limited to fitting into the maximum
attribute data length which is 64k.

IOWs, the valid ACL limit is per-filesystem, and needs to be checked
in the filesystem code as something that is beyond the range of what
the on-disk format of the filesystem can handle is a corruption
event and needs to be treated as a corruption, not a ENOMEM error..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
