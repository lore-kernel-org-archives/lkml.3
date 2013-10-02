Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3JBTlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:41:08 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab3JBTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:41:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 05/26] omap3isp: Make isp_video_buffer_prepare_user() use get_user_pages_fast()
Date: Wed, 02 Oct 2013 21:41:10 +0200
Message-ID: <11048370.rLWI050cLv@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380724087-13927-6-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz> <1380724087-13927-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Thank you for the patch.

On Wednesday 02 October 2013 16:27:46 Jan Kara wrote:
> CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> CC: linux-media@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Could you briefly explain where you're headed with this ? The V4L2 subsystem 
has suffered for quite a long time from potentiel AB-BA deadlocks, due the 
drivers taking the mmap_sem semaphore while holding the V4L2 buffers queue 
lock in the code path below, and taking them in reverse order in the mmap() 
path (as the mm core takes the mmap_sem semaphore before calling the mmap() 
operation). We've solved that by releasing the V4L2 buffers queue lock before 
taking the mmap_sem lock below and taking it back after releasing the mmap_sem 
lock. Having an explicit indication that the mmap_sem lock was taken helped 
keeping the problem in mind. I'm not against hiding it in 
get_user_pages_fast(), but I'd like to know what the next step is. Maybe it 
would also be worth it adding a /* get_user_pages_fast() takes the mmap_sem */ 
comment before the call ?

> ---
>  drivers/media/platform/omap3isp/ispqueue.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispqueue.c
> b/drivers/media/platform/omap3isp/ispqueue.c index
> e15f01342058..bed380395e6c 100644
> --- a/drivers/media/platform/omap3isp/ispqueue.c
> +++ b/drivers/media/platform/omap3isp/ispqueue.c
> @@ -331,13 +331,9 @@ static int isp_video_buffer_prepare_user(struct
> isp_video_buffer *buf) if (buf->pages == NULL)
>  		return -ENOMEM;
> 
> -	down_read(&current->mm->mmap_sem);
> -	ret = get_user_pages(current, current->mm, data & PAGE_MASK,
> -			     buf->npages,
> -			     buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
> -			     buf->pages, NULL);
> -	up_read(&current->mm->mmap_sem);
> -
> +	ret = get_user_pages_fast(data & PAGE_MASK, buf->npages,
> +				  buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +				  buf->pages);
>  	if (ret != buf->npages) {
>  		buf->npages = ret < 0 ? 0 : ret;
>  		isp_video_buffer_cleanup(buf);
-- 
Regards,

Laurent Pinchart

