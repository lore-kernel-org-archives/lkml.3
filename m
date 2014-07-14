Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaGNNOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:14:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbaGNNOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:14:00 -0400
Date: Mon, 14 Jul 2014 15:13:56 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Jan Kara'" <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: avoid redundant memcpy when writing data in ICB
Message-ID: <20140714131356.GB17279@quack.suse.cz>
References: <000901cf9425$71219200$5364b600$@samsung.com>
 <20140714084606.GB30550@quack.suse.cz>
 <000601cf9f54$e44cc760$ace65620$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601cf9f54$e44cc760$ace65620$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-07-14 19:14:39, Chao Yu wrote:
> > -----Original Message-----
> > From: Jan Kara [mailto:jack@suse.cz]
> > Sent: Monday, July 14, 2014 4:46 PM
> > To: Chao Yu
> > Cc: jack@suse.cz; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] udf: avoid redundant memcpy when writing data in ICB
> > 
> > On Mon 30-06-14 13:37:15, Chao Yu wrote:
> > > We have already copied the changed data of page to extent area in ICB when call
> > > ->write_end() of adinicb aops, so we do not need to copy them another time in
> > > ->writepage() of adinicb aops. SetPageUptodate is redundant too, so it's better
> > > to remove these redundant codes.
> > >
> > > Also it looks more reasonable to set inode dirty after extent area are modified,
> > > we'd better move mark_inode_dirty() from ->writepage() to ->write_end().
> >   This doesn't look right. The copy is there because the page can be
> > modified via mmap as well, not only via buffered write... So if anything,
> 
> You're right, I have made a mistake that I have not considered the 'mmap' case,
> Thank you for reminding me about that. :)
> 
> > we may be able to remove the copy in udf_adinicb_write_end() (actually
> > using directly simple_write_end() for that), not the one in
> > udf_adinicb_write_begin().
> 
> Agreed, valid data within i_size will be copied to ICB cache when we writeback
> the page by invoking udf_adinicb_writepage, so the copy in udf_adinicb_write_end
> is redundant. So our patch should be modified like the following one, is this right?
> 
> ---
>  fs/udf/file.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index d80738f..a8dc0f1 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -105,16 +105,6 @@ static int udf_adinicb_write_end(struct file *file,
>  			loff_t pos, unsigned len, unsigned copied,
>  			struct page *page, void *fsdata)
>  {
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
>  	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
>  }
  You can completely remove udf_adinicb_write_end() function and just use
simple_write_end() in udf_adinicb_aops. 
 								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
