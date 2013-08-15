Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3HOKK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:10:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45127 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HOKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:10:25 -0400
Message-ID: <520CA923.4060409@oracle.com>
Date: Thu, 15 Aug 2013 18:10:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] xfs: check for underflow in xfs_iformat_fork()
References: <20130815055338.GC23580@elgon.mountain>
In-Reply-To: <20130815055338.GC23580@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 01:53 PM, Dan Carpenter wrote:

> The "di_size" variable comes from the disk and it's a signed 64 bit.
> We check the upper limit but we should check for negative numbers as
> well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> index 123971b..849fc70 100644
> --- a/fs/xfs/xfs_inode_fork.c
> +++ b/fs/xfs/xfs_inode_fork.c
> @@ -167,7 +167,8 @@ xfs_iformat_fork(
>  			}
>  
>  			di_size = be64_to_cpu(dip->di_size);
> -			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> +			if (unlikely(di_size < 0 ||

But the di_size is initialized to ZERO while allocating a new inode on disk.
I wonder if that is better to ASSERT in this case because the current check
is used to make sure that the item is inlined, or we don't need it at all.

> +				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
>  				xfs_warn(ip->i_mount,
>  			"corrupt inode %Lu (bad size %Ld for local inode).",
>  					(unsigned long long) ip->i_ino,
>

Thanks,
-Jeff
