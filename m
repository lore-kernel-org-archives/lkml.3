Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbbALPDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:03:55 -0500
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58177 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbbALPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:03:54 -0500
Message-ID: <54B3E24B.5030403@xs4all.nl>
Date: Mon, 12 Jan 2015 16:03:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Kamil Debski <k.debski@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Fr=E9d=E9ric_Sureau?= 
	<frederic.sureau@vodalys.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [RFC PATCH] [media] coda: Use S_PARM to set nominal framerate
 for h.264 encoder
References: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 05:00 PM, Philipp Zabel wrote:
> The encoder needs to know the nominal framerate for the constant bitrate
> control mechanism to work. Currently the only way to set the framerate is
> by using VIDIOC_S_PARM on the output queue.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-common.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 39330a7..63eb510 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -803,6 +803,32 @@ static int coda_decoder_cmd(struct file *file, void *fh,
>  	return 0;
>  }
>  
> +static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(fh);
> +

If a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT, then return -EINVAL. Ditto for s_parm.

> +	a->parm.output.timeperframe.denominator = 1;
> +	a->parm.output.timeperframe.numerator = ctx->params.framerate;
> +
> +	return 0;
> +}
> +
> +static int coda_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(fh);
> +
> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +	    a->parm.output.timeperframe.numerator != 0) {
> +		ctx->params.framerate = a->parm.output.timeperframe.denominator
> +				      / a->parm.output.timeperframe.numerator;

Hmm, what happens if the denominator is 1 and the numerator is 2?
You probably want to clamp ctx->params.framerate to the range of allowed framerates.
And at least ensure a framerate > 0.

Also check with v4l2_compliance! You'd have caught at least the missing a->type check.

> +	}
> +
> +	a->parm.output.timeperframe.denominator = 1;
> +	a->parm.output.timeperframe.numerator = ctx->params.framerate;
> +
> +	return 0;
> +}
> +
>  static int coda_subscribe_event(struct v4l2_fh *fh,
>  				const struct v4l2_event_subscription *sub)
>  {
> @@ -843,6 +869,9 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
>  	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
>  	.vidioc_decoder_cmd	= coda_decoder_cmd,
>  
> +	.vidioc_g_parm		= coda_g_parm,
> +	.vidioc_s_parm		= coda_s_parm,
> +
>  	.vidioc_subscribe_event = coda_subscribe_event,
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
> 

Regards,

	Hans
