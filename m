Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3DWQEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:04:40 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46865 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3DWQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:33 -0400
Date: Tue, 23 Apr 2013 09:04:31 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Lukas Czerner <lczerner@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3 07/18] ceph: use ->invalidatepage() length argument
In-Reply-To: <1365498867-27782-8-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.DEB.2.00.1304230904060.19511@cobra.newdream.net>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com> <1365498867-27782-8-git-send-email-lczerner@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in ceph_invalidatepage().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: ceph-devel@vger.kernel.org

Acked-by: Sage Weil <sage@inktank.com>


> ---
>  fs/ceph/addr.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 168a35a..d953afd 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -164,20 +164,20 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
>  	if (!PageDirty(page))
>  		pr_err("%p invalidatepage %p page not dirty\n", inode, page);
>  
> -	if (offset == 0)
> +	if (offset == 0 && length == PAGE_CACHE_SIZE)
>  		ClearPageChecked(page);
>  
>  	ci = ceph_inode(inode);
> -	if (offset == 0) {
> -		dout("%p invalidatepage %p idx %lu full dirty page %u\n",
> -		     inode, page, page->index, offset);
> +	if (offset == 0 && length == PAGE_CACHE_SIZE) {
> +		dout("%p invalidatepage %p idx %lu full dirty page\n",
> +		     inode, page, page->index);
>  		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
>  		ceph_put_snap_context(snapc);
>  		page->private = 0;
>  		ClearPagePrivate(page);
>  	} else {
> -		dout("%p invalidatepage %p idx %lu partial dirty page\n",
> -		     inode, page, page->index);
> +		dout("%p invalidatepage %p idx %lu partial dirty page %u(%u)\n",
> +		     inode, page, page->index, offset, length);
>  	}
>  }
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
