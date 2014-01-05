Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaAEGOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 01:14:18 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44699 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaAEGOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 01:14:17 -0500
Date: Sat, 4 Jan 2014 22:14:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com, gregkh@linuxfoundation.org,
        mchehab@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] saa7146: fix a possible NULL pointer reference
 in saa7146_set_position
Message-ID: <20140105061413.GF18213@core.coreip.homeip.net>
References: <1388887680-942-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388887680-942-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 10:08:00AM +0800, Ethan Zhao wrote:
> Function saa7146_format_by_fourcc() may return NULL, reference of the returned
> result would cause NULL pointer issue without checking.
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/media/common/saa7146/saa7146_hlp.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
> index be746d1..3e23eab 100644
> --- a/drivers/media/common/saa7146/saa7146_hlp.c
> +++ b/drivers/media/common/saa7146/saa7146_hlp.c
> @@ -575,6 +575,7 @@ static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int
>  	 */
>  	u32 base = (u32)(unsigned long)vv->ov_fb.base;
>  
> +	int which = 1;
>  	struct	saa7146_video_dma vdma1;
>  
>  	/* calculate memory offsets for picture, look if we shall top-down-flip */
> @@ -608,10 +609,14 @@ static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int
>  		vdma1.pitch *= -1;
>  	}
>  
> -	vdma1.base_page = sfmt->swap;
> +	if (sfmt)
> +		vdma1.base_page = sfmt->swap;
> +	else
> +		which = 0;
> +
>  	vdma1.num_line_byte = (vv->standard->v_field<<16)+vv->standard->h_pixels;
>  
> -	saa7146_write_out_dma(dev, 1, &vdma1);
> +	saa7146_write_out_dma(dev, which, &vdma1);

If saa7146_format_by_fourcc() returns NULL you'll crash much earlier
when trying to do

	int depth = sfmt->depth;

I am not familiar with the code by it seems you are papering over the
problem. Will we ever get here with unknown pixel format?

Thanks.

-- 
Dmitry
