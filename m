Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaK2TL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 14:11:59 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:57364 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaK2TL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 14:11:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API for v4l2_subdev_get_try_*()
Date: Sat, 29 Nov 2014 21:12:25 +0200
Message-ID: <3017627.SLutb67dz2@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CA+V-a8s-mP+Fjok2s_nDUAOb4vN3RWyRc5VHuZqPdk4pJtv03A@mail.gmail.com>
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com> <20141118180759.GT8907@valkosipuli.retiisi.org.uk> <CA+V-a8s-mP+Fjok2s_nDUAOb4vN3RWyRc5VHuZqPdk4pJtv03A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Saturday 29 November 2014 18:30:09 Prabhakar Lad wrote:
> On Tue, Nov 18, 2014 at 6:07 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Tue, Nov 18, 2014 at 10:39:24AM +0100, Hans Verkuil wrote:
> >> On 11/17/14 11:41, Lad, Prabhakar wrote:
> >> > this patch removes the guard CONFIG_VIDEO_V4L2_SUBDEV_API
> >> > for v4l2_subdev_get_try_*() functions.
> >> > In cases where a subdev using v4l2_subdev_get_try_*() calls
> >> > internally and the bridge using subdev pad ops which is
> >> > not MC aware forces to select MEDIA_CONTROLLER, as
> >> > VIDEO_V4L2_SUBDEV_API is dependent on it.
> >> > 
> >> > Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> > ---
> >> > 
> >> >  include/media/v4l2-subdev.h | 2 --
> >> >  1 file changed, 2 deletions(-)
> >> > 
> >> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >> > index 5860292..076ca11 100644
> >> > --- a/include/media/v4l2-subdev.h
> >> > +++ b/include/media/v4l2-subdev.h
> >> > @@ -642,7 +642,6 @@ struct v4l2_subdev_fh {
> >> >  #define to_v4l2_subdev_fh(fh)      \
> >> >     container_of(fh, struct v4l2_subdev_fh, vfh)
> >> > 
> >> > -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> >> >  #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)         
> >> >      \
> >> >     static inline struct rtype *                                    \
> >> >     v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,       \
> >> > 
> >> > @@ -656,7 +655,6 @@ struct v4l2_subdev_fh {
> >> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> >> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
> >> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> >> > -#endif
> >> > 
> >> >  extern const struct v4l2_file_operations v4l2_subdev_fops;
> >> 
> >> The problem is that v4l2_subdev_get_try_*() needs a v4l2_subdev_fh which
> >> you don't have if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined. So I don't
> >> see how removing the guards help with that.
> >> 
> >> What can be done is that if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
> >> then these functions return NULL.
> > 
> > Sure. That's a better choice than removing the config option dependency of
> > the fields struct v4l2_subdev.

Decoupling CONFIG_VIDEO_V4L2_SUBDEV_API from the availability of the in-kernel 
pad format and selection rectangles helpers is definitely a good idea. I was 
thinking about decoupling the try format and rectangles from v4l2_subdev_fh by 
creating a kind of configuration store structure to store them, and embedding 
that structure in v4l2_subdev_fh. The pad-level operations would then take a 
pointer to the configuration store instead of the v4l2_subdev_fh. Bridge 
drivers that want to implement TRY_FMT based on pad-level operations would 
create a configuration store, use the pad-level operations, and destroy the 
configuration store. The userspace subdev API would use the configuration 
store from the file handle.

> >> BTW, one patch I will very happily accept is one where the
> >> __V4L2_SUBDEV_MK_GET_TRY is removed and these three try functions are
> >> just written as proper static inlines. I find it very obfuscated code.
> > 
> > I originally wrote them like that in order to avoid writing essentially
> > the same code three times over. If there will be more targets, the same
> > repeats further, should one write those functions open for all different
> > macro arguments. That's why it was a macro to begin with.
> > 
> >> In addition, because it is a macro you won't find the function
> >> definitions if you grep on the function name.
> > 
> > True as well. You could simply change the macro to include the full
> > function name. This was not suggested in review back then AFAIR.
> > 
> >> But any functional changes here need to be Acked by Laurent first.
> 
> How do you want me to proceed on this ?

-- 
Regards,

Laurent Pinchart

