Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaGNIqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:46:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaGNIqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:46:11 -0400
Date: Mon, 14 Jul 2014 10:46:06 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Yu <chao2.yu@samsung.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: avoid redundant memcpy when writing data in ICB
Message-ID: <20140714084606.GB30550@quack.suse.cz>
References: <000901cf9425$71219200$5364b600$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901cf9425$71219200$5364b600$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 30-06-14 13:37:15, Chao Yu wrote:
> We have already copied the changed data of page to extent area in ICB when call
> ->write_end() of adinicb aops, so we do not need to copy them another time in
> ->writepage() of adinicb aops. SetPageUptodate is redundant too, so it's better
> to remove these redundant codes.
> 
> Also it looks more reasonable to set inode dirty after extent area are modified,
> we'd better move mark_inode_dirty() from ->writepage() to ->write_end().
  This doesn't look right. The copy is there because the page can be
modified via mmap as well, not only via buffered write... So if anything,
we may be able to remove the copy in udf_adinicb_write_end() (actually
using directly simple_write_end() for that), not the one in
udf_adinicb_write_begin().

								Honza
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/udf/file.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index d80738f..3cd0a50 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -65,17 +65,7 @@ static int udf_adinicb_readpage(struct file *file, struct page *page)
>  static int udf_adinicb_writepage(struct page *page,
>  				 struct writeback_control *wbc)
>  {
> -	struct inode *inode = page->mapping->host;
> -	char *kaddr;
> -	struct udf_inode_info *iinfo = UDF_I(inode);
> -
>  	BUG_ON(!PageLocked(page));
> -
> -	kaddr = kmap(page);
> -	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
> -	mark_inode_dirty(inode);
> -	SetPageUptodate(page);
> -	kunmap(page);
>  	unlock_page(page);
>  
>  	return 0;
> @@ -115,6 +105,8 @@ static int udf_adinicb_write_end(struct file *file,
>  		kaddr + offset, copied);
>  	kunmap_atomic(kaddr);
>  
> +	mark_inode_dirty(inode);
> +
>  	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
>  }
>  
> -- 
> 1.7.9.5
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
