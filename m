Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaGOOf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:35:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaGOOfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:35:25 -0400
Date: Tue, 15 Jul 2014 16:35:21 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Yu <chao2.yu@samsung.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH v2] udf: avoid redundant memcpy when writing
 data in ICB
Message-ID: <20140715143521.GC1733@quack.suse.cz>
References: <000d01cf9fcd$9e226500$da672f00$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000d01cf9fcd$9e226500$da672f00$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-07-14 09:38:51, Chao Yu wrote:
> Valid data within i_size in page cache will be copied to ICB cache when we
> writeback the page by invoking udf_adinicb_writepage, so the copy in
> udf_adinicb_write_end is redundant.
> After we remove the copy, it's better to use simple_write_end directly in
> udf_adinicb_aops instead of udf_adinicb_write_end.
> 
> v2:
>  o fix to remove redundant code correctly and use simple_write_end directly in
> udf_adinicb_aops pointed out by Jan Kara.
  Thanks! I've merged the patch.

								Honza
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/udf/file.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index d80738f..3d06489 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -100,24 +100,6 @@ static int udf_adinicb_write_begin(struct file *file,
>  	return 0;
>  }
>  
> -static int udf_adinicb_write_end(struct file *file,
> -			struct address_space *mapping,
> -			loff_t pos, unsigned len, unsigned copied,
> -			struct page *page, void *fsdata)
> -{
> -	struct inode *inode = mapping->host;
> -	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
> -	char *kaddr;
> -	struct udf_inode_info *iinfo = UDF_I(inode);
> -
> -	kaddr = kmap_atomic(page);
> -	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
> -		kaddr + offset, copied);
> -	kunmap_atomic(kaddr);
> -
> -	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
> -}
> -
>  static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
>  				     struct iov_iter *iter,
>  				     loff_t offset)
> @@ -130,7 +112,7 @@ const struct address_space_operations udf_adinicb_aops = {
>  	.readpage	= udf_adinicb_readpage,
>  	.writepage	= udf_adinicb_writepage,
>  	.write_begin	= udf_adinicb_write_begin,
> -	.write_end	= udf_adinicb_write_end,
> +	.write_end	= simple_write_end,
>  	.direct_IO	= udf_adinicb_direct_IO,
>  };
>  
> -- 
> 2.0.1.474.g72c7794
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
