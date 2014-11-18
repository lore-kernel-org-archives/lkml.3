Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaKRVdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:33:54 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55814 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932145AbaKRVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:33:50 -0500
Date: Tue, 18 Nov 2014 23:33:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] media: add media token device resource framework
Message-ID: <20141118213342.GW8907@valkosipuli.retiisi.org.uk>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
 <c8bae1d475b1086302fcb83bc463ec01437c3f95.1413246372.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8bae1d475b1086302fcb83bc463ec01437c3f95.1413246372.git.shuahkh@osg.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

A few comments below.

On Tue, Oct 14, 2014 at 08:58:37AM -0600, Shuah Khan wrote:
> Add media token device resource framework to allow sharing
> resources such as tuner, dma, audio etc. across media drivers
> and non-media sound drivers that control media hardware. The
> Media token resource is created at the main struct device that
> is common to all drivers that claim various pieces of the main
> media device, which allows them to find the resource using the
> main struct device. As an example, digital, analog, and
> snd-usb-audio drivers can use the media token resource API
> using the main struct device for the interface the media device
> is attached to.
> 
> A shared media tokens resource is created using devres framework
> for drivers to find and lock/unlock. Creating a shared devres
> helps avoid creating data structure dependencies between drivers.
> This media token resource contains media token for tuner, and
> audio. When tuner token is requested, audio token is issued.
> Subsequent token (for tuner and audio) gets from the same task
> and task in the same tgid succeed. This allows applications that
> make multiple v4l2 ioctls to work with the first call acquiring
> the token and applications that create separate threads to handle
> video and audio functions.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  MAINTAINERS                  |    2 +
>  include/linux/media_tknres.h |   50 +++++++++
>  lib/Makefile                 |    2 +
>  lib/media_tknres.c           |  237 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 291 insertions(+)
>  create mode 100644 include/linux/media_tknres.h
>  create mode 100644 lib/media_tknres.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e80a275..9216179 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5864,6 +5864,8 @@ F:	include/uapi/linux/v4l2-*
>  F:	include/uapi/linux/meye.h
>  F:	include/uapi/linux/ivtv*
>  F:	include/uapi/linux/uvcvideo.h
> +F:	include/linux/media_tknres.h
> +F:	lib/media_tknres.c
>  
>  MEDIAVISION PRO MOVIE STUDIO DRIVER
>  M:	Hans Verkuil <hverkuil@xs4all.nl>
> diff --git a/include/linux/media_tknres.h b/include/linux/media_tknres.h
> new file mode 100644
> index 0000000..6d37327
> --- /dev/null
> +++ b/include/linux/media_tknres.h
> @@ -0,0 +1,50 @@
> +/*
> + * media_tknres.h - managed media token resource
> + *
> + * Copyright (c) 2014 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
> + */
> +#ifndef __LINUX_MEDIA_TOKEN_H
> +#define __LINUX_MEDIA_TOKEN_H
> +
> +struct device;
> +
> +#if defined(CONFIG_MEDIA_SUPPORT)
> +extern int media_tknres_create(struct device *dev);
> +extern int media_tknres_destroy(struct device *dev);
> +
> +extern int media_get_tuner_tkn(struct device *dev);
> +extern int media_put_tuner_tkn(struct device *dev);
> +
> +extern int media_get_audio_tkn(struct device *dev);
> +extern int media_put_audio_tkn(struct device *dev);
> +#else
> +static inline int media_tknres_create(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_tknres_destroy(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_get_tuner_tkn(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_put_tuner_tkn(struct device *dev)
> +{
> +	return 0;
> +}
> +static int media_get_audio_tkn(struct device *dev)
> +{
> +	return 0;
> +}
> +static int media_put_audio_tkn(struct device *dev)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#endif	/* __LINUX_MEDIA_TOKEN_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index d6b4bc4..6f21695 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -139,6 +139,8 @@ obj-$(CONFIG_DQL) += dynamic_queue_limits.o
>  
>  obj-$(CONFIG_GLOB) += glob.o
>  
> +obj-$(CONFIG_MEDIA_SUPPORT) += media_tknres.o

I'd add a new Kconfig option for this, as it's only needed by a very
specific kind of drivers. It could be automatically selected by those that
need it.

> +
>  obj-$(CONFIG_MPILIB) += mpi/
>  obj-$(CONFIG_SIGNATURE) += digsig.o
>  
> diff --git a/lib/media_tknres.c b/lib/media_tknres.c
> new file mode 100644
> index 0000000..e0a36cb
> --- /dev/null
> +++ b/lib/media_tknres.c
> @@ -0,0 +1,237 @@
> +/*
> + * media_tknres.c - managed media token resource
> + *
> + * Copyright (c) 2014 Shuah Khan <shuahkh@osg.samsung.com>
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This file is released under the GPLv2.
> + */
> +/*
> + * Media devices often have hardware resources that are shared
> + * across several functions. For instance, TV tuner cards often
> + * have MUXes, converters, radios, tuners, etc. that are shared
> + * across various functions. However, v4l2, alsa, DVB, usbfs, and
> + * all other drivers have no knowledge of what resources are
> + * shared. For example, users can't access DVB and alsa at the same
> + * time, or the DVB and V4L analog API at the same time, since many
> + * only have one converter that can be in either analog or digital
> + * mode. Accessing and/or changing mode of a converter while it is
> + * in use by another function results in video stream error.
> + *
> + * A shared media tokens resource is created using devres framework
> + * for drivers to find and lock/unlock. Creating a shared devres
> + * helps avoid creating data structure dependencies between drivers.
> + * This media token resource contains media token for tuner, and
> + * audio. When tuner token is requested, audio token is issued.
> + * Subsequent token (for tuner and audio) gets from the same task
> + * and task in the same tgid succeed. This allows applications that
> + * make multiple v4l2 ioctls to work with the first call acquiring
> + * the token and applications that create separate threads to handle
> + * video and audio functions.
> + *
> + * API
> + *	int media_tknres_create(struct device *dev);
> + *	int media_tknres_destroy(struct device *dev);
> + *
> + *	int media_get_tuner_tkn(struct device *dev);
> + *	int media_put_tuner_tkn(struct device *dev);
> + *
> + *	int media_get_audio_tkn(struct device *dev);
> + *	int media_put_audio_tkn(struct device *dev);
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/sched.h>
> +#include <linux/media_tknres.h>

Alphabetical order, please.

> +
> +struct media_tkn {
> +	spinlock_t lock;
> +	unsigned int owner;	/* owner task pid */
> +	unsigned int tgid;	/* owner task gid */
> +	struct task_struct *task;
> +};
> +
> +struct media_tknres {
> +	struct media_tkn tuner;
> +	struct media_tkn audio;
> +};
> +
> +#define TUNER	"Tuner"
> +#define AUDIO	"Audio"
> +
> +static void media_tknres_release(struct device *dev, void *res)
> +{
> +	dev_info(dev, "%s: Media Token Resource released\n", __func__);
> +}
> +
> +int media_tknres_create(struct device *dev)
> +{
> +	struct media_tknres *tkn;
> +
> +	tkn = devres_alloc(media_tknres_release, sizeof(struct media_tknres),
> +				GFP_KERNEL);
> +	if (!tkn)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&tkn->tuner.lock);
> +	tkn->tuner.owner = 0;
> +	tkn->tuner.tgid = 0;
> +	tkn->tuner.task = NULL;
> +
> +	spin_lock_init(&tkn->audio.lock);
> +	tkn->audio.owner = 0;
> +	tkn->audio.tgid = 0;
> +	tkn->audio.task = NULL;
> +
> +	devres_add(dev, tkn);
> +
> +	dev_info(dev, "%s: Media Token Resource created\n", __func__);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_tknres_create);
> +
> +static int __media_get_tkn(struct media_tkn *tkn, char *tkn_str)
> +{
> +	int rc = 0;
> +	unsigned tpid;
> +	unsigned tgid;
> +
> +	spin_lock(&tkn->lock);
> +
> +	tpid = task_pid_nr(current);
> +	tgid = task_tgid_nr(current);
> +
> +	/* allow task in the same group id to release */
> +	if (tkn->task && ((tkn->task != current) && (tkn->tgid != tgid))) {
> +			rc = -EBUSY;

Indentation.

I'd like to someone else comment on this approach in general, but I'm not
aware of better ways to do this either as there's no common device node (so
file handles can't be used either).

> +	} else {
> +		tkn->owner = tpid;
> +		tkn->tgid = tgid;
> +		tkn->task = current;
> +	}
> +	pr_debug("%s: Media %s Token get: owner (%d,%d) req (%d,%d) rc %d\n",
> +		__func__, tkn_str, tkn->owner, tkn->tgid, tpid, tgid, rc);
> +
> +	spin_unlock(&tkn->lock);
> +	return rc;
> +}
> +
> +static int __media_put_tkn(struct media_tkn *tkn, char *tkn_str)
> +{
> +	int rc = 0;
> +	unsigned tpid;
> +	unsigned tgid;
> +
> +	spin_lock(&tkn->lock);
> +
> +	tpid = task_pid_nr(current);
> +	tgid = task_tgid_nr(current);
> +
> +	/* allow task in the same group id to release */
> +	if (tkn->task == NULL ||
> +		((tkn->task != current) && (tkn->tgid != tgid))) {
> +			rc = -EINVAL;

Indentation.

> +	} else {
> +		tkn->owner = 0;
> +		tkn->tgid = 0;
> +		tkn->task = NULL;
> +	}
> +	pr_debug("%s: Media %s Token put: owner (%d,%d) req (%d,%d) rc %d\n",
> +		__func__, tkn_str, tkn->owner, tkn->tgid, tpid, tgid, rc);
> +
> +	spin_unlock(&tkn->lock);

No need to print things while holding the lock.

> +	return rc;
> +}
> +
> +/*
> + * When media tknres doesn't exist, get and put interfaces
> + * return 0 to let the callers take legacy code paths. This
> + * will also cover the drivers that don't create media tknres.
> + * Returning -ENODEV will require additional checks by callers.
> + * Instead handle the media tknres not present case as a driver
> + * not supporting media tknres and return 0.
> +*/
> +int media_get_tuner_tkn(struct device *dev)
> +{
> +	struct media_tknres *tkn_ptr;
> +	int ret = 0;
> +
> +	tkn_ptr = devres_find(dev, media_tknres_release, NULL, NULL);
> +	if (tkn_ptr == NULL) {
> +		dev_dbg(dev, "%s: Media Token Resource not found\n",
> +				__func__);
> +		return 0;
> +	}
> +
> +	ret = __media_get_tkn(&tkn_ptr->tuner, TUNER);
> +	if (ret)
> +		return ret;
> +
> +	/* get audio token */
> +	ret = __media_get_tkn(&tkn_ptr->audio, AUDIO);
> +	if (ret)
> +		__media_put_tkn(&tkn_ptr->tuner, TUNER);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(media_get_tuner_tkn);

You're calling media_get_tuner_tkn() from a number of V4L2 framework
functions that handle common and often performance critical IOCTLs.
devres_find() will loop over the entire list of resources associated with
that device. I think this would be just fine if it was done just once in a
non-performance critical time, but not every time everywhere.

> +
> +int media_put_tuner_tkn(struct device *dev)
> +{
> +	struct media_tknres *tkn_ptr;
> +
> +	tkn_ptr = devres_find(dev, media_tknres_release, NULL, NULL);
> +	if (tkn_ptr == NULL) {
> +		dev_dbg(dev, "%s: Media Token Resource not found\n",
> +			__func__);
> +		return 0;
> +	}
> +
> +	/* put audio token and then tuner token */
> +	__media_put_tkn(&tkn_ptr->audio, AUDIO);
> +
> +	return __media_put_tkn(&tkn_ptr->tuner, TUNER);
> +}
> +EXPORT_SYMBOL_GPL(media_put_tuner_tkn);
> +
> +int media_get_audio_tkn(struct device *dev)
> +{
> +	struct media_tknres *tkn_ptr;
> +
> +	tkn_ptr = devres_find(dev, media_tknres_release, NULL, NULL);
> +	if (tkn_ptr == NULL) {
> +		dev_dbg(dev, "%s: Media Token Resource not found\n",
> +			__func__);
> +		return 0;
> +	}
> +
> +	return __media_get_tkn(&tkn_ptr->audio, AUDIO);
> +}
> +EXPORT_SYMBOL_GPL(media_get_audio_tkn);
> +
> +int media_put_audio_tkn(struct device *dev)
> +{
> +	struct media_tknres *tkn_ptr;
> +
> +	tkn_ptr = devres_find(dev, media_tknres_release, NULL, NULL);
> +	if (tkn_ptr == NULL) {
> +		dev_dbg(dev, "%s: Media Token Resource not found\n",
> +			__func__);
> +		return 0;
> +	}
> +
> +	return __media_put_tkn(&tkn_ptr->audio, AUDIO);
> +}
> +EXPORT_SYMBOL_GPL(media_put_audio_tkn);
> +
> +int media_tknres_destroy(struct device *dev)
> +{
> +	int rc;
> +
> +	rc = devres_release(dev, media_tknres_release, NULL, NULL);
> +	WARN_ON(rc);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_tknres_destroy);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
