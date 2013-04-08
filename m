Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3DHFzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 01:55:48 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38270 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752654Ab3DHFzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 01:55:47 -0400
Message-ID: <1365400526.2673.3.camel@slavad-ubuntu>
Subject: Re: [PATCH 1/2] hfsplus: add error propagation to 
 __hfsplus_ext_write_extent()
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Date: Mon, 08 Apr 2013 09:55:26 +0400
In-Reply-To: <1365369695-8340-1-git-send-email-khoroshilov@ispras.ru>
References: <0199BA74-9971-4928-A133-DB1FC562DC43@dubeyko.com>
	 <1365369695-8340-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.124.66 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Mon, 2013-04-08 at 01:21 +0400, Alexey Khoroshilov wrote:
> __hfsplus_ext_write_extent() suppresses errors coming from hfs_brec_find().
> The patch implements error code propagation.
> 

Please, prepare a single patch set for all your changes in HFS and HFS+. These changes are related to each other, so, it makes sense in one patch set.

Thanks,
Vyacheslav Dubeyko.

> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  fs/hfsplus/extents.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
> index a94f0f7..fed73f7 100644
> --- a/fs/hfsplus/extents.c
> +++ b/fs/hfsplus/extents.c
> @@ -83,7 +83,7 @@ static u32 hfsplus_ext_lastblock(struct hfsplus_extent *ext)
>  	return be32_to_cpu(ext->start_block) + be32_to_cpu(ext->block_count);
>  }
>  
> -static void __hfsplus_ext_write_extent(struct inode *inode,
> +static int __hfsplus_ext_write_extent(struct inode *inode,
>  		struct hfs_find_data *fd)
>  {
>  	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
> @@ -98,13 +98,13 @@ static void __hfsplus_ext_write_extent(struct inode *inode,
>  	res = hfs_brec_find(fd, hfs_find_rec_by_key);
>  	if (hip->extent_state & HFSPLUS_EXT_NEW) {
>  		if (res != -ENOENT)
> -			return;
> +			return res;
>  		hfs_brec_insert(fd, hip->cached_extents,
>  				sizeof(hfsplus_extent_rec));
>  		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
>  	} else {
>  		if (res)
> -			return;
> +			return res;
>  		hfs_bnode_write(fd->bnode, hip->cached_extents,
>  				fd->entryoffset, fd->entrylength);
>  		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
> @@ -117,11 +117,13 @@ static void __hfsplus_ext_write_extent(struct inode *inode,
>  	 * to explicily mark the inode dirty, too.
>  	 */
>  	set_bit(HFSPLUS_I_EXT_DIRTY, &hip->flags);
> +
> +	return 0;
>  }
>  
>  static int hfsplus_ext_write_extent_locked(struct inode *inode)
>  {
> -	int res;
> +	int res = 0;
>  
>  	if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
>  		struct hfs_find_data fd;
> @@ -129,10 +131,10 @@ static int hfsplus_ext_write_extent_locked(struct inode *inode)
>  		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
>  		if (res)
>  			return res;
> -		__hfsplus_ext_write_extent(inode, &fd);
> +		res = __hfsplus_ext_write_extent(inode, &fd);
>  		hfs_find_exit(&fd);
>  	}
> -	return 0;
> +	return res;
>  }
>  
>  int hfsplus_ext_write_extent(struct inode *inode)
> @@ -175,8 +177,11 @@ static inline int __hfsplus_ext_cache_extent(struct hfs_find_data *fd,
>  
>  	WARN_ON(!mutex_is_locked(&hip->extents_lock));
>  
> -	if (hip->extent_state & HFSPLUS_EXT_DIRTY)
> -		__hfsplus_ext_write_extent(inode, fd);
> +	if (hip->extent_state & HFSPLUS_EXT_DIRTY) {
> +		res = __hfsplus_ext_write_extent(inode, fd);
> +		if (res)
> +			return res;
> +	}
>  
>  	res = __hfsplus_ext_read_extent(fd, hip->cached_extents, inode->i_ino,
>  					block, HFSPLUS_IS_RSRC(inode) ?


