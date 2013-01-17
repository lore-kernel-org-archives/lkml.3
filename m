Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3AQUHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:07:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3AQUHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:07:19 -0500
Date: Thu, 17 Jan 2013 18:07:11 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Alexander Beregalov <a.beregalov@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [ 36/71] ext4: lock i_mutex when truncating orphan inodes
Message-ID: <20130117200710.GD2872@herton-Z68MA-D2H-B3>
References: <20130115225340.367496998@linuxfoundation.org>
 <20130115225343.033036403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115225343.033036403@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 02:54:33PM -0800, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Theodore Ts'o <tytso@mit.edu>
> 
> commit 721e3eba21e43532e438652dd8f1fcdfce3187e7 upstream.
> 
> Commit c278531d39 added a warning when ext4_flush_unwritten_io() is
> called without i_mutex being taken.  It had previously not been taken
> during orphan cleanup since races weren't possible at that point in
> the mount process, but as a result of this c278531d39, we will now see
> a kernel WARN_ON in this case.  Take the i_mutex in
> ext4_orphan_cleanup() to suppress this warning.
> 
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

By the description and looking at commit c278531d39, this change isn't
needed for 3.0 or 3.4 kernels (anything <= 3.6), they don't contain
commit c278531d39.

> 
> ---
>  fs/ext4/super.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2204,7 +2204,9 @@ static void ext4_orphan_cleanup(struct s
>  				__func__, inode->i_ino, inode->i_size);
>  			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
>  				  inode->i_ino, inode->i_size);
> +			mutex_lock(&inode->i_mutex);
>  			ext4_truncate(inode);
> +			mutex_unlock(&inode->i_mutex);
>  			nr_truncates++;
>  		} else {
>  			ext4_msg(sb, KERN_DEBUG,
> 
> 

-- 
[]'s
Herton
