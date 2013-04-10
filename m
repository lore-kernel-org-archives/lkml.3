Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937127Ab3DJJws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937107Ab3DJJwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:52:45 -0400
Date: Wed, 10 Apr 2013 11:51:54 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-1-230.brq.redhat.com
To: Jan Kara <jack@suse.cz>
cc: Lukas Czerner <lczerner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH v3 09/18] reiserfs: use ->invalidatepage() length
 argument
In-Reply-To: <20130409132756.GE13672@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1304101151130.10609@dhcp-1-230.brq.redhat.com>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com> <1365498867-27782-10-git-send-email-lczerner@redhat.com> <20130409132756.GE13672@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Jan Kara wrote:

> Date: Tue, 9 Apr 2013 15:27:56 +0200
> From: Jan Kara <jack@suse.cz>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     reiserfs-devel@vger.kernel.org
> Subject: Re: [PATCH v3 09/18] reiserfs: use ->invalidatepage() length argument
> 
> On Tue 09-04-13 11:14:18, Lukas Czerner wrote:
> > ->invalidatepage() aop now accepts range to invalidate so we can make
> > use of it in reiserfs_invalidatepage()
>   Hum, reiserfs is probably never going to support punch hole. So shouldn't
> we rather WARN and return without doing anything if stop !=
> PAGE_CACHE_SIZE?
> 
> 								Honza

Hi,

I can not even think of the case when this would happen since it
could not happen before either. However in the case it happens the
code will do what's expected. So I do not have any strong preference
about this one, but I do not think it's necessary to WARN here. If
you still insist on the WARN, let me know and I'll resend the patch.

Thanks for the reviews!
-Lukas

> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Cc: reiserfs-devel@vger.kernel.org
> > ---
> >  fs/reiserfs/inode.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> > index 808e02e..e963164 100644
> > --- a/fs/reiserfs/inode.c
> > +++ b/fs/reiserfs/inode.c
> > @@ -2975,11 +2975,13 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
> >  	struct buffer_head *head, *bh, *next;
> >  	struct inode *inode = page->mapping->host;
> >  	unsigned int curr_off = 0;
> > +	unsigned int stop = offset + length;
> > +	int partial_page = (offset || length < PAGE_CACHE_SIZE);
> >  	int ret = 1;
> >  
> >  	BUG_ON(!PageLocked(page));
> >  
> > -	if (offset == 0)
> > +	if (!partial_page)
> >  		ClearPageChecked(page);
> >  
> >  	if (!page_has_buffers(page))
> > @@ -2991,6 +2993,9 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
> >  		unsigned int next_off = curr_off + bh->b_size;
> >  		next = bh->b_this_page;
> >  
> > +		if (next_off > stop)
> > +			goto out;
> > +
> >  		/*
> >  		 * is this block fully invalidated?
> >  		 */
> > @@ -3009,7 +3014,7 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
> >  	 * The get_block cached value has been unconditionally invalidated,
> >  	 * so real IO is not possible anymore.
> >  	 */
> > -	if (!offset && ret) {
> > +	if (!partial_page && ret) {
> >  		ret = try_to_release_page(page, 0);
> >  		/* maybe should BUG_ON(!ret); - neilb */
> >  	}
> > -- 
> > 1.7.7.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
