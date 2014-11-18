Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaKRJkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:40:09 -0500
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:42680 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbaKRJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:40:05 -0500
Message-ID: <546B13CC.6050605@xs4all.nl>
Date: Tue, 18 Nov 2014 10:39:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API
 for v4l2_subdev_get_try_*()
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/14 11:41, Lad, Prabhakar wrote:
> this patch removes the guard CONFIG_VIDEO_V4L2_SUBDEV_API
> for v4l2_subdev_get_try_*() functions.
> In cases where a subdev using v4l2_subdev_get_try_*() calls
> internally and the bridge using subdev pad ops which is
> not MC aware forces to select MEDIA_CONTROLLER, as
> VIDEO_V4L2_SUBDEV_API is dependent on it.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  include/media/v4l2-subdev.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5860292..076ca11 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -642,7 +642,6 @@ struct v4l2_subdev_fh {
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
>  	static inline struct rtype *					\
>  	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
> @@ -656,7 +655,6 @@ struct v4l2_subdev_fh {
>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> -#endif
>  
>  extern const struct v4l2_file_operations v4l2_subdev_fops;
>  
> 

The problem is that v4l2_subdev_get_try_*() needs a v4l2_subdev_fh which
you don't have if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined. So I don't
see how removing the guards help with that.

What can be done is that if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
then these functions return NULL.

BTW, one patch I will very happily accept is one where the __V4L2_SUBDEV_MK_GET_TRY
is removed and these three try functions are just written as proper
static inlines. I find it very obfuscated code.

In addition, because it is a macro you won't find the function definitions
if you grep on the function name.

But any functional changes here need to be Acked by Laurent first.

Regards,

	Hans
