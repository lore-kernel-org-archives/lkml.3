Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaJUKsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:48:06 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1348 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaJUKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:48:03 -0400
Message-ID: <5446396B.9010709@xs4all.nl>
Date: Tue, 21 Oct 2014 12:46:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] media: add media token device resource framework
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <c8bae1d475b1086302fcb83bc463ec01437c3f95.1413246372.git.shuahkh@osg.samsung.com>
In-Reply-To: <c8bae1d475b1086302fcb83bc463ec01437c3f95.1413246372.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

As promised, here is my review for this patch series.

On 10/14/2014 04:58 PM, Shuah Khan wrote:
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

Did you mean: 'tuner token is issued' instead of audio token?

I also have the same question as Takashi: why do we have an audio
token in the first place? While you are streaming audio over alsa
the underlying tuner must be marked as being in use. It's all about
the tuner, since that's the resource that is being shared, not about
audio as such.

For the remainder of my review I will ignore the audio-related code
and concentrate only on the tuner part.

> Subsequent token (for tuner and audio) gets from the same task
> and task in the same tgid succeed. This allows applications that
> make multiple v4l2 ioctls to work with the first call acquiring
> the token and applications that create separate threads to handle
> video and audio functions.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>   MAINTAINERS                  |    2 +
>   include/linux/media_tknres.h |   50 +++++++++
>   lib/Makefile                 |    2 +
>   lib/media_tknres.c           |  237 ++++++++++++++++++++++++++++++++++++++++++

I am still not convinced myself that this should be a generic API.
The only reason we need it today is for sharing tuners. Which is almost
a purely media thing with USB audio as the single non-media driver that
will be affected. Today I see no use case outside of tuners. I would
probably want to keep this inside drivers/media.

If this is going to be expanded it can always be moved to lib later.

>   4 files changed, 291 insertions(+)
>   create mode 100644 include/linux/media_tknres.h
>   create mode 100644 lib/media_tknres.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e80a275..9216179 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5864,6 +5864,8 @@ F:	include/uapi/linux/v4l2-*
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
>   obj-$(CONFIG_GLOB) += glob.o
>
> +obj-$(CONFIG_MEDIA_SUPPORT) += media_tknres.o
> +
>   obj-$(CONFIG_MPILIB) += mpi/
>   obj-$(CONFIG_SIGNATURE) += digsig.o
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

dev_dbg would be more appropriate.

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

Ditto.

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

As I understand it this makes no sense: if tkn->task == current,
then tkn->tgid == tgid.

Why would you allow different task in the same group id to release anyway?

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
> +	} else {
> +		tkn->owner = 0;
> +		tkn->tgid = 0;
> +		tkn->task = NULL;
> +	}
> +	pr_debug("%s: Media %s Token put: owner (%d,%d) req (%d,%d) rc %d\n",
> +		__func__, tkn_str, tkn->owner, tkn->tgid, tpid, tgid, rc);
> +
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

OK, this makes no sense. I am completely missing the tuner mode here.
Speaking for V4L2 (I am less sure about DVB) any application can access
the tuner even if it is owned by another application as long as you don't
switch mode.

The way it works now it would block any other application from accessing
the tuner, or even other threads in the same process group. That's pretty
much guaranteed to break existing code.

So these tokens should be refcounted (certainly for the analog tuner mode,
but probably for all modes). In the V4L2 wrapper function you just check
if the token has been obtained already by setting a flag in struct v4l2_fh.
If not, then you get the token.

When the file handle is released and if it has the token, then you release
that token.

It is my understanding (correct me if I am wrong) that DVB and ALSA allow
only one user of the interface at a time, so you can still use refcounting
there, but the refcount will never go above 1 anyway.

I just hacked tknres support into vivid to test this and it really disables
this important feature.

I also discovered that you are missing MODULE_AUTHOR, MODULE_DESCRIPTION
and above all MODULE_LICENSE. Without the MODULE_LICENSE it won't link this
module to the GPL devres_* functions. It took me some time to figure that
out.

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
>

I'm really sorry but I have to nack this patch series. It simply breaks
existing V4L functionality that I know people are using.

I'm not going to review the other patches, they seemed mostly OK to me
although I would expect to see changes to videobuf2-core.c as well which
I didn't.

You might want to think about adding media token support to vivid to test
this. The vivid driver supports both radio and TV tuners. Currently those
are emulated as independent tuners, but you could try to use media token
to emulate it as a shared resource. That way you can test this with a vb2
driver as well.

Anyway:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
