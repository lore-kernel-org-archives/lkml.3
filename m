Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3JEMdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 08:33:24 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33464 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab3JEMdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 08:33:23 -0400
X-Greylist: delayed 1957 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Oct 2013 08:33:23 EDT
Message-ID: <1380974541.1905.12.camel@palomino.walls.org>
Subject: Re: [PATCH 19/26] ivtv: Convert driver to use
 get_user_pages_unlocked()
From: Andy Walls <awalls@md.metrocast.net>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-media@vger.kernel.org
Date: Sat, 05 Oct 2013 08:02:21 -0400
In-Reply-To: <1380724087-13927-20-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
	 <1380724087-13927-20-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-05_01:2013-10-04,2013-10-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1305240000 definitions=main-1310050038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan:

<rant>
This patch alone does not have suffcient information for me to evaluate
it.  get_user_pages_unlocked() is added in another patch which I did not
receive, and which I cannot find in any list archives.

I wasted quite a bit of time looking for this additional patch:

https://git.kernel.org/cgit/linux/kernel/git/jack/linux-fs.git/commit/?h=get_user_pages&id=624fc1bfb70fb65d32d31fbd16427ad9c234653e

</rant>

If I found the correct patch for adding get_user_pages_unlocked(), then
the patch below looks fine.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

On Wed, 2013-10-02 at 16:28 +0200, Jan Kara wrote:
> CC: Andy Walls <awalls@md.metrocast.net>
> CC: linux-media@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/media/pci/ivtv/ivtv-udma.c |  6 ++----
>  drivers/media/pci/ivtv/ivtv-yuv.c  | 12 ++++++------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
> index 7338cb2d0a38..6012e5049076 100644
> --- a/drivers/media/pci/ivtv/ivtv-udma.c
> +++ b/drivers/media/pci/ivtv/ivtv-udma.c
> @@ -124,10 +124,8 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
>  	}
>  
>  	/* Get user pages for DMA Xfer */
> -	down_read(&current->mm->mmap_sem);
> -	err = get_user_pages(current, current->mm,
> -			user_dma.uaddr, user_dma.page_count, 0, 1, dma->map, NULL);
> -	up_read(&current->mm->mmap_sem);
> +	err = get_user_pages_unlocked(current, current->mm, user_dma.uaddr,
> +				      user_dma.page_count, 0, 1, dma->map);
>  
>  	if (user_dma.page_count != err) {
>  		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
> diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
> index 2ad65eb29832..9365995917d8 100644
> --- a/drivers/media/pci/ivtv/ivtv-yuv.c
> +++ b/drivers/media/pci/ivtv/ivtv-yuv.c
> @@ -75,15 +75,15 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
>  	ivtv_udma_get_page_info (&uv_dma, (unsigned long)args->uv_source, 360 * uv_decode_height);
>  
>  	/* Get user pages for DMA Xfer */
> -	down_read(&current->mm->mmap_sem);
> -	y_pages = get_user_pages(current, current->mm, y_dma.uaddr, y_dma.page_count, 0, 1, &dma->map[0], NULL);
> +	y_pages = get_user_pages_unlocked(current, current->mm, y_dma.uaddr,
> +					  y_dma.page_count, 0, 1, &dma->map[0]);
>  	uv_pages = 0; /* silence gcc. value is set and consumed only if: */
>  	if (y_pages == y_dma.page_count) {
> -		uv_pages = get_user_pages(current, current->mm,
> -					  uv_dma.uaddr, uv_dma.page_count, 0, 1,
> -					  &dma->map[y_pages], NULL);
> +		uv_pages = get_user_pages_unlocked(current, current->mm,
> +						   uv_dma.uaddr,
> +						   uv_dma.page_count, 0, 1,
> +						   &dma->map[y_pages]);
>  	}
> -	up_read(&current->mm->mmap_sem);
>  
>  	if (y_pages != y_dma.page_count || uv_pages != uv_dma.page_count) {
>  		int rc = -EFAULT;


