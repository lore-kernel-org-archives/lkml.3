Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaIXL1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:27:15 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4369 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaIXL1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:27:11 -0400
Message-ID: <5422AA63.1070406@xs4all.nl>
Date: Wed, 24 Sep 2014 13:26:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.co, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] media: add media token device resource framework
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <78fed57ab9b3bed4269a078c9a7361bfe9ff6d92.1411397045.git.shuahkh@osg.samsung.com>
In-Reply-To: <78fed57ab9b3bed4269a078c9a7361bfe9ff6d92.1411397045.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

Here is my review...

On 09/22/2014 05:00 PM, Shuah Khan wrote:
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
> The media token resource contains token for tuner, dma, and
> audio.

Why dma and audio? Neither is being used in this patch series. I
would leave them out until you actually show how they are used in a
driver.

>  Each token has valid modes or states it can be in.
> When a token is in one of the exclusive modes, only one owner
> is allowed. When a token is in shared mode, owners with the
> request the token in the same mode in shared mode are allowed
> to share the token.
>
> As an example, when tuner token is held digital and exclusive
> mode, no other requests are granted. On the other hand, when
> the tuner token is held in shared analog mode, other requests
> for shared analog access are granted.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>   MAINTAINERS                  |    2 +
>   include/linux/media_tknres.h |   98 ++++++++++++
>   lib/Makefile                 |    2 +
>   lib/media_tknres.c           |  361 ++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 463 insertions(+)
>   create mode 100644 include/linux/media_tknres.h
>   create mode 100644 lib/media_tknres.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aefa948..861f6c6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5821,6 +5821,8 @@ F:	include/uapi/linux/v4l2-*
>   F:	include/uapi/linux/meye.h
>   F:	include/uapi/linux/ivtv*
>   F:	include/uapi/linux/uvcvideo.h
> +F:	include/linux/media_tknres.h
> +F:	lib/media_tknres.c
>
>   MEDIAVISION PRO MOVIE STUDIO DRIVER
>   M:	Hans Verkuil <hverkuil@xs4all.nl>
> diff --git a/include/linux/media_tknres.h b/include/linux/media_tknres.h
> new file mode 100644
> index 0000000..65a24df
> --- /dev/null
> +++ b/include/linux/media_tknres.h
> @@ -0,0 +1,98 @@
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
> +enum media_tkn_mode {
> +	MEDIA_MODE_DVB,
> +	MEDIA_MODE_ANALOG,
> +	MEDIA_MODE_RADIO,
> +};
> +
> +#if defined(CONFIG_MEDIA_SUPPORT)
> +extern int media_tknres_create(struct device *dev);
> +extern int media_tknres_destroy(struct device *dev);
> +
> +extern int media_get_tuner_tkn(struct device *dev, enum media_tkn_mode mode);
> +extern int media_get_shared_tuner_tkn(struct device *dev,
> +				enum media_tkn_mode mode);
> +extern int media_put_tuner_tkn(struct device *dev, enum media_tkn_mode mode);
> +extern int media_reset_shared_tuner_tkn(struct device *dev,
> +				enum media_tkn_mode mode);
> +
> +extern int media_get_dma_tkn(struct device *dev, enum media_tkn_mode mode);
> +extern int media_get_shared_dma_tkn(struct device *dev,
> +				enum media_tkn_mode mode);
> +extern int media_put_dma_tkn(struct device *dev, enum media_tkn_mode mode);
> +
> +extern int media_get_audio_tkn(struct device *dev, enum media_tkn_mode mode);
> +extern int media_get_shared_audio_tkn(struct device *dev,
> +				enum media_tkn_mode mode);
> +extern int media_put_audio_tkn(struct device *dev, enum media_tkn_mode mode);
> +#else
> +static inline int media_tknres_create(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_tknres_destroy(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_get_tuner_tkn(struct device *dev,
> +					enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_get_shared_tuner_tkn(struct device *dev,
> +						enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_put_tuner_tkn(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_reset_shared_tuner_tkn(struct device *dev,
> +						enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_get_dma_tkn(struct device *dev,
> +					enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_get_shared_dma_tkn(struct device *dev,
> +						enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_put_dma_tkn(struct device *dev)
> +{
> +	return 0;
> +}
> +static inline int media_get_audio_tkn(struct device *dev,
> +					enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_get_shared_audio_tkn(struct device *dev,
> +						enum media_tkn_mode mode)
> +{
> +	return 0;
> +}
> +static inline int media_put_audio_tkn(struct device *dev)
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
>   obj-$(CONFIG_GLOB) += glob.o
>
> +obj-$(CONFIG_MEDIA_SUPPORT) += media_tknres.o
> +
>   obj-$(CONFIG_MPILIB) += mpi/
>   obj-$(CONFIG_SIGNATURE) += digsig.o
>
> diff --git a/lib/media_tknres.c b/lib/media_tknres.c
> new file mode 100644
> index 0000000..863336b
> --- /dev/null
> +++ b/lib/media_tknres.c
> @@ -0,0 +1,361 @@
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
> + * This media token resource contains media token for tuner, dma,
> + * and audio. Each token has valid modes or states it can be in.
> + * When a token is in one of the exclusive modes, only one owner is
> + * allowed. When a token is in shared mode, owners with the same
> + * mode request are allowed to share the token.
> + *
> + * API
> + *	int media_tknres_create(struct device *dev);
> + *	int media_tknres_destroy(struct device *dev);
> + *
> + *	int media_get_tuner_tkn(struct device *dev, enum media_tkn_mode mode);
> + *	int media_get_shared_tuner_tkn(struct device *dev,
> + *					enum media_tkn_mode mode);
> + *	int media_put_tuner_tkn(struct device *dev)
> + *					enum media_tkn_mode mode);
> + *	int media_reset_shared_tuner_tkn(struct device *dev,
> + *						enum media_tkn_mode mode);
> + *
> + *	int media_get_dma_tkn(struct device *dev, enum media_tkn_mode mode);
> + *	int media_get_shared_dma_tkn(struct device *dev,
> + *					enum media_tkn_mode mode);
> + *	int media_put_dma_tkn(struct device *dev)
> + *					enum media_tkn_mode mode);
> + *
> + *	int media_get_audio_tkn(struct device *dev, enum media_tkn_mode mode);
> + *	int media_get_shared_audio_tkn(struct device *dev,
> + *					enum media_tkn_mode mode);
> + *	int media_put_audio_tkn(struct device *dev)
> + *					enum media_tkn_mode mode);
> + * Not yet implemented:
> + *	int media_reset_shared_dma_tkn(struct device *dev,
> + *					enum media_tkn_mode mode);
> + *	int media_reset_shared_adudio_tkn(struct device *dev,
> + *					enum media_tkn_mode mode);
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/media_tknres.h>
> +
> +struct media_tkn {
> +	spinlock_t lock;
> +	enum media_tkn_mode mode;
> +	int owners;
> +	bool is_exclusive;
> +};
> +
> +struct media_tknres {
> +	struct media_tkn tuner;
> +	struct media_tkn dma;
> +	struct media_tkn audio;
> +};
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
> +	tkn->tuner.mode = MEDIA_MODE_DVB;
> +	spin_lock_init(&tkn->tuner.lock);
> +	tkn->tuner.owners = 0;
> +	tkn->tuner.is_exclusive = false;
> +
> +	tkn->dma.mode = MEDIA_MODE_DVB;
> +	spin_lock_init(&tkn->dma.lock);
> +	tkn->dma.owners = 0;
> +	tkn->tuner.is_exclusive = false;
> +
> +	tkn->audio.mode = MEDIA_MODE_DVB;
> +	spin_lock_init(&tkn->audio.lock);
> +	tkn->audio.owners = 0;
> +	tkn->tuner.is_exclusive = false;
> +
> +	devres_add(dev, tkn);
> +
> +	dev_info(dev, "%s: Media Token Resource created\n", __func__);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_tknres_create);
> +
> +static int __media_get_tkn(struct media_tkn *tkn,
> +				enum media_tkn_mode mode, bool exclusive)
> +{
> +	int rc = 0;
> +
> +	spin_lock(&tkn->lock);
> +	if (tkn->is_exclusive)
> +		rc = -EBUSY;
> +	else if (tkn->owners && ((mode != tkn->mode) || exclusive))
> +		rc = -EBUSY;
> +	else {
> +		if (tkn->owners < INT_MAX)
> +			tkn->owners++;
> +		else
> +			tkn->owners = 1;

Somewhat weird. Can owners ever become INT_MAX?

> +		tkn->mode = mode;
> +		tkn->is_exclusive = exclusive;
> +		pr_debug("%s: Media Token Resource get (%d - %d - %d)\n",
> +			__func__, tkn->mode, tkn->owners, tkn->is_exclusive);
> +	}
> +	spin_unlock(&tkn->lock);
> +	pr_debug("%s: Media Token Resource get rc = %d exclusive %d\n",
> +		__func__, rc, exclusive);
> +	return rc;
> +}
> +
> +static int __media_put_tkn(struct media_tkn *tkn,
> +				enum media_tkn_mode mode)
> +{
> +	int rc = 0;
> +
> +	spin_lock(&tkn->lock);
> +	if (tkn->owners == 0) {
> +		pr_debug("%s: Media Token Resource put with %d owners\n",
> +				__func__, tkn->owners);
> +		rc = -EINVAL;
> +	} else if (mode != tkn->mode) {
> +		pr_debug("%s: Media Token Resource put wrong mode (%d - %d)\n",
> +			__func__, mode, tkn->mode);
> +		rc = -EINVAL;
> +	} else {
> +		tkn->owners--;
> +		if (tkn->owners == 0 && tkn->is_exclusive)
> +			tkn->is_exclusive = false;
> +		pr_debug("%s: Media Token Resource put (%d - %d - %d)\n",
> +			__func__, tkn->mode, tkn->owners, tkn->is_exclusive);
> +	}
> +	spin_unlock(&tkn->lock);
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
> +int media_get_tuner_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource get mode=%d\n",
> +			__func__, mode);
> +	return __media_get_tkn(&tkn_ptr->tuner, mode, true);
> +}
> +EXPORT_SYMBOL_GPL(media_get_tuner_tkn);
> +
> +int media_get_shared_tuner_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource get mode=%d\n",
> +			__func__, mode);
> +	return __media_get_tkn(&tkn_ptr->tuner, mode, false);
> +}
> +EXPORT_SYMBOL_GPL(media_get_shared_tuner_tkn);
> +
> +int media_put_tuner_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource put mode %d\n",
> +			__func__, mode);
> +	return __media_put_tkn(&tkn_ptr->tuner, mode);
> +}
> +EXPORT_SYMBOL_GPL(media_put_tuner_tkn);
> +
> +int media_reset_shared_tuner_tkn(struct device *dev, enum media_tkn_mode mode)
> +{
> +	struct media_tknres *tkn_ptr;
> +	struct media_tkn *tkn;
> +
> +	tkn_ptr = devres_find(dev, media_tknres_release, NULL, NULL);
> +	if (tkn_ptr == NULL) {
> +		dev_dbg(dev, "%s: Media Token Resource not found\n",
> +			__func__);
> +		return 0;
> +	}
> +
> +	tkn = &tkn_ptr->tuner;
> +	spin_lock(&tkn->lock);
> +	if (tkn->is_exclusive || mode != tkn->mode || tkn->owners == 0)
> +		goto done;
> +	tkn->owners = 0;
> +	tkn->mode = MEDIA_MODE_DVB;
> +	tkn->is_exclusive = false;
> +	dev_dbg(dev, "%s: Media Token Resource reset done mode %d\n",
> +			__func__, mode);
> +done:
> +	spin_unlock(&tkn->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_reset_shared_tuner_tkn);

Hmm, I think this is asking for problems. You are working around a problem
in the v4l2 API by adding this reset function, but you should address the
real issue. I have more about this in my review of patch 2.

If you do refcounting as is done here, then reset functions like this
basically defeat the whole refcounting idea. It's too easy to be abused.

> +
> +int media_get_dma_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource get mode=%d\n",
> +			__func__, mode);
> +	return __media_get_tkn(&tkn_ptr->dma, mode, true);
> +}
> +EXPORT_SYMBOL_GPL(media_get_dma_tkn);
> +
> +int media_get_shared_dma_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource get mode=%d\n",
> +			__func__, mode);
> +	return __media_get_tkn(&tkn_ptr->dma, mode, false);
> +}
> +EXPORT_SYMBOL_GPL(media_get_shared_dma_tkn);
> +
> +int media_put_dma_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource put mode=%d\n",
> +			__func__, mode);
> +	return __media_put_tkn(&tkn_ptr->dma, mode);
> +}
> +EXPORT_SYMBOL_GPL(media_put_dma_tkn);
> +
> +int media_get_audio_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource get mode=%d\n",
> +			__func__, mode);
> +	return __media_get_tkn(&tkn_ptr->audio, mode, true);
> +}
> +EXPORT_SYMBOL_GPL(media_get_audio_tkn);
> +
> +int media_get_shared_audio_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource get mode=%d\n",
> +			__func__, mode);
> +	return __media_get_tkn(&tkn_ptr->audio, mode, false);
> +}
> +EXPORT_SYMBOL_GPL(media_get_shared_audio_tkn);
> +
> +int media_put_audio_tkn(struct device *dev, enum media_tkn_mode mode)
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
> +	dev_dbg(dev, "%s: Media Token Resource put mode=%d\n",
> +			__func__, mode);
> +	return __media_put_tkn(&tkn_ptr->audio, mode);
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
>

As I mentioned at the beginning, these dma and audio tokens aren't used anywhere,
so just drop them for now.

Regards,

	Hans
