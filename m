Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936933Ab3DIJbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935122Ab3DIJbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:31:49 -0400
Subject: Re: [Cluster-devel] [PATCH v3 08/18] gfs2: use ->invalidatepage()
 length argument
From: Steven Whitehouse <swhiteho@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
In-Reply-To: <1365498867-27782-9-git-send-email-lczerner@redhat.com>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
	 <1365498867-27782-9-git-send-email-lczerner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 09 Apr 2013 10:29:33 +0100
Message-ID: <1365499773.2708.5.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-04-09 at 11:14 +0200, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in gfs2_invalidatepage().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: cluster-devel@redhat.com
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

> ---
>  fs/gfs2/aops.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 37093ba..ea920bf 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -947,24 +947,29 @@ static void gfs2_invalidatepage(struct page *page, unsigned int offset,
>  				unsigned int length)
>  {
>  	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
> +	unsigned int stop = offset + length;
> +	int partial_page = (offset || length < PAGE_CACHE_SIZE);
>  	struct buffer_head *bh, *head;
>  	unsigned long pos = 0;
>  
>  	BUG_ON(!PageLocked(page));
> -	if (offset == 0)
> +	if (!partial_page)
>  		ClearPageChecked(page);
>  	if (!page_has_buffers(page))
>  		goto out;
>  
>  	bh = head = page_buffers(page);
>  	do {
> +		if (pos + bh->b_size > stop)
> +			return;
> +
>  		if (offset <= pos)
>  			gfs2_discard(sdp, bh);
>  		pos += bh->b_size;
>  		bh = bh->b_this_page;
>  	} while (bh != head);
>  out:
> -	if (offset == 0)
> +	if (!partial_page)
>  		try_to_release_page(page, 0);
>  }
>  


