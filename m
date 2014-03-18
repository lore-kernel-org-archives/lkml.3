Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbaCRSoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:44:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:47439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbaCRSob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,679,1389772800"; 
   d="scan'208";a="501403350"
Date: Tue, 18 Mar 2014 12:45:29 -0600 (MDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
X-X-Sender: rzwisler@scrumpy
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v6 20/22] ext4: Add DAX functionality
In-Reply-To: <CF4DEE22.25C8F%matthew.r.wilcox@intel.com>
Message-ID: <alpine.OSX.2.00.1403181236280.8685@scrumpy>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com> <CF4DEE22.25C8F%matthew.r.wilcox@intel.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Matthew Wilcox wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> This is a port of the DAX functionality found in the current version of
> ext2.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> [heavily tweaked]
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

...

> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 594009f..dbdacef 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -686,15 +686,22 @@ retry:
>  			inode_dio_done(inode);
>  			goto locked;
>  		}
> -		ret = __blockdev_direct_IO(rw, iocb, inode,
> -				 inode->i_sb->s_bdev, iov,
> -				 offset, nr_segs,
> -				 ext4_get_block, NULL, NULL, 0);
> +		if (IS_DAX(inode))
> +			ret = dax_do_io(rw, iocb, inode, iov, offset, nr_segs,
> +					ext4_get_block, NULL, 0);
> +		else
> +			ret = __blockdev_direct_IO(rw, iocb, inode,
> +					inode->i_sb->s_bdev, iov, offset,
> +					nr_segs, ext4_get_block, NULL, NULL, 0);
>  		inode_dio_done(inode);
>  	} else {
>  locked:
> -		ret = blockdev_direct_IO(rw, iocb, inode, iov,
> -				 offset, nr_segs, ext4_get_block);
> +		if (IS_DAX(inode))
> +			ret = dax_do_io(rw, iocb, inode, iov, offset, nr_segs,
> +					ext4_get_block, NULL, 0);

We need to pass in a DIO_LOCKING flag to this call to dax_do_io.  This flag is
provided correctly in ext2_direct_IO which is the only other place I found
where we have a call to dax_do_io as an alternative to blockdev_direct_IO.

The other calls to dax_do_io are alternatives to __blockdev_direct_IO, which
has an explicit flags parameter.  I believe all of these cases are being
handled correctly.

- Ross
