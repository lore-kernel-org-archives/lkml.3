Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677Ab3ECNsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:48:12 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:64942 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762337Ab3ECNsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:48:10 -0400
Message-ID: <5183BFFF.3020709@cogentembedded.com>
Date: Fri, 03 May 2013 17:47:43 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: davinci: vpbe: fix layer availability for NV12
 format
References: <1367574783-19090-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1367574783-19090-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-05-2013 13:53, Prabhakar Lad wrote:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

> For NV12 format, even if display data is single image,
> both VIDWIN0 and VIDWIN1 parameters must be used. The start
> address of Y data plane and C data plane is configured in
> VIDEOWIN0ADH/L and VIDEOWIN1ADH/L respectively.
> cuurently only one layer was requested, which is suffice
> for yuv422, but for yuv420(NV12) two layers are required and
> fix the same by requesting for other layer if pix fmt is NV12
> during set_fmt.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>   drivers/media/platform/davinci/vpbe_display.c |   16 ++++++++++++++++
>   1 files changed, 16 insertions(+), 0 deletions(-)

> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 0341dcc..f2ee07b 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -922,6 +922,22 @@ static int vpbe_display_s_fmt(struct file *file, void *priv,
>   	other video window */
>
>   	layer->pix_fmt = *pixfmt;
> +	if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12 &&
> +	    cpu_is_davinci_dm365()) {

    cpu_is_*() shouldn't be used in the drivers.

> +		struct vpbe_layer *otherlayer;
> +
> +		otherlayer = _vpbe_display_get_other_win_layer(disp_dev, layer);
> +		/* if other layer is available, only
> +		* claim it, do not configure it
> +		*/
> +		ret = osd_device->ops.request_layer(osd_device,
> +						    otherlayer->layer_info.id);
> +		if (ret < 0) {
> +			v4l2_err(&vpbe_dev->v4l2_dev,
> +				 "Display Manager failed to allocate layer\n");
> +			return -EBUSY;
> +		}
> +	}

WBR, Sergei

