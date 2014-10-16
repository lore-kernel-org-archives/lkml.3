Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaJQHCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:02:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:52256 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaJQHCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401670885"
Date: Thu, 16 Oct 2014 18:16:24 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 20/21] ext4: Add DAX functionality
Message-ID: <20141016221624.GL11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-21-git-send-email-matthew.r.wilcox@intel.com>
 <20141016125625.GR19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016125625.GR19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:56:25PM +0200, Mathieu Desnoyers wrote:
> > +#define EXT4_MOUNT_DAX			0x00200	/* Execute in place */
> 
> Execute in place -> Direct Access stuff... (comment above)

Thanks!  Fixed.

> > +static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > +{
> > +	return dax_fault(vma, vmf, ext4_get_block);
> > +					/* Is this the right get_block? */
> 
> perhaps this needs a TODO or FIXME or XXX to make sure an ext4
> maintainer does not miss this question.

Maybe I can ambush Ted in the halls tomorrow and find out?  :-)

> > +	.fsync		= ext4_sync_file,
> > +	.fallocate	= ext4_fallocate,
> 
> Perhaps adding comments saying that .splice_read and .splice_write are
> unavailable here would help understanding why we need a different file
> operations structure.

Good idea.  Done.

> > +static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
> > +{
> > +	struct inode *inode = bh->b_assoc_map->host;
> > +	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
> 
> Good question! It would be interesting to get an answer :)

Another thing to check tomorrow ...

> > +	if (!uptodate)
> > +		return;
> > +	WARN_ON(!buffer_unwritten(bh));
> > +	err = ext4_convert_unwritten_extents(NULL, inode, offset, bh->b_size);
> 
> err is simply unused here, that does not look good (silent failure).

I don't think I can do more than WARN_ON here.  Maybe we can change
b_end_io() to return an int instead of void ... I think Dave Chinner has
grand plans for changes in this area as part of replacing the buffer_head
abstraction.

> > @@ -3238,14 +3249,6 @@ static int ext4_block_zero_page_range(handle_t *handle,
> >  		return -ENOMEM;
> >  
> >  	blocksize = inode->i_sb->s_blocksize;
> > -	max = blocksize - (offset & (blocksize - 1));
> > -
> > -	/*
> > -	 * correct length if it does not fall between
> > -	 * 'from' and the end of the block
> > -	 */
> > -	if (length > max || length < 0)
> > -		length = max;
> >  
> >  	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
[...]
> > +
> > +	/*
> > +	 * correct length if it does not fall between
> > +	 * 'from' and the end of the block
> > +	 */
> 
> Shouldn't a length < 0 be treated as an error instead ?
> 
> > +	if (length > max || length < 0)
> > +		length = max;

Monkey see code in wrong place.  Monkey move code.  monkey not understand
code.

> > @@ -3572,6 +3579,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> >  				 "both data=journal and dioread_nolock");
> >  			goto failed_mount;
> >  		}
> > +		if (test_opt(sb, DAX)) {
> > +			ext4_msg(sb, KERN_ERR, "can't mount with "
> > +				 "both data=journal and dax");
> 
> This limitation regarding ext4 and dax should be documented in dax
> Documentation.

Maybe the ext4 documentation too?  It seems kind of obvious to me that if
ypu're enabling in-place-updates that you can't journal the data you're
updating (well ... you could implement undo-log journalling, I suppose,
which would be quite a change for ext4)
