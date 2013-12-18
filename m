Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3LRXhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:37:40 -0500
Received: from leo.clearchain.com ([199.73.29.74]:49150 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LRXhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:37:39 -0500
Date: Thu, 19 Dec 2013 09:40:09 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Message-ID: <20131218234009.GA9360@yabbi.redhat.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
 <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.7 (mail.clearchain.com [127.0.0.1]); Thu, 19 Dec 2013 10:07:29 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:48:52PM +0100, David Herrmann wrote:
> As we painfully noticed during the 3.12 merge-window our
> EVIOCGABS/EVIOCSABS API is limited to ABS_MAX<=0x3f. We tried several
> hacks to work around it but if we ever decide to increase ABS_MAX, the
> EVIOCSABS ioctl ABI might overflow into the next byte causing horrible
> misinterpretations in the kernel that we cannot catch.
> 
> Therefore, we decided to go with ABS_MAX2/CNT2 and introduce two new
> ioctls to get/set abs-params. They no longer encode the ABS code in the
> ioctl number and thus allow up to 4 billion ABS codes.
> 
> The new API also allows to query multiple ABS values with one call. To
> allow EVIOCSABS2(code = 0, cnt = ABS_CNT2) we need to silently ignore
> writes to ABS_MT_SLOT. Furthermore, for better compatibility with
> newer user-space, we ignore writes to unknown codes. Hence, if we ever
> increase ABS_MAX2, new user-space will work with code=0,cnt=ABS_CNT2 just
> fine even on old kernels.
> 
> Note that we also need to increase EV_VERSION so user-space can reliably
> know whether ABS2 is supported. Unfortunately, we return EINVAL instead of
> ENOSYS for unknown evdev ioctls so it's nearly impossible to catch
> reliably without EVIOCGVERSION.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  drivers/hid/hid-debug.c                  |  2 +-
>  drivers/hid/hid-input.c                  |  2 +-
>  drivers/input/evdev.c                    | 95 +++++++++++++++++++++++++++++++-
>  drivers/input/input.c                    | 14 ++---
>  drivers/input/keyboard/goldfish_events.c |  6 +-
>  drivers/input/keyboard/hil_kbd.c         |  2 +-
>  drivers/input/misc/uinput.c              |  6 +-
>  include/linux/hid.h                      |  2 +-
>  include/linux/input.h                    |  6 +-
>  include/uapi/linux/input.h               | 42 +++++++++++++-
>  include/uapi/linux/uinput.h              |  2 +-
>  11 files changed, 155 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
> index 8453214..d32fa30 100644
> --- a/drivers/hid/hid-debug.c
> +++ b/drivers/hid/hid-debug.c
> @@ -862,7 +862,7 @@ static const char *relatives[REL_MAX + 1] = {
>  	[REL_WHEEL] = "Wheel",		[REL_MISC] = "Misc",
>  };
>  
> -static const char *absolutes[ABS_CNT] = {
> +static const char *absolutes[ABS_CNT2] = {
>  	[ABS_X] = "X",			[ABS_Y] = "Y",
>  	[ABS_Z] = "Z",			[ABS_RX] = "Rx",
>  	[ABS_RY] = "Ry",		[ABS_RZ] = "Rz",
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index d97f232..a02721c 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1300,7 +1300,7 @@ static bool hidinput_has_been_populated(struct hid_input *hidinput)
>  	for (i = 0; i < BITS_TO_LONGS(REL_CNT); i++)
>  		r |= hidinput->input->relbit[i];
>  
> -	for (i = 0; i < BITS_TO_LONGS(ABS_CNT); i++)
> +	for (i = 0; i < BITS_TO_LONGS(ABS_CNT2); i++)
>  		r |= hidinput->input->absbit[i];
>  
>  	for (i = 0; i < BITS_TO_LONGS(MSC_CNT); i++)
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index a06e125..32b74e5 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -643,7 +643,7 @@ static int handle_eviocgbit(struct input_dev *dev,
>  	case      0: bits = dev->evbit;  len = EV_MAX;  break;
>  	case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
>  	case EV_REL: bits = dev->relbit; len = REL_MAX; break;
> -	case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
> +	case EV_ABS: bits = dev->absbit; len = ABS_MAX2; break;
>  	case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
>  	case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
>  	case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
> @@ -671,6 +671,93 @@ static int handle_eviocgbit(struct input_dev *dev,
>  }
>  #undef OLD_KEY_MAX
>  
> +static int evdev_handle_get_abs2(struct input_dev *dev, void __user *p)
> +{
> +	u32 code, cnt, valid_cnt, i;
> +	struct input_absinfo2 __user *pinfo = p;
> +	struct input_absinfo abs;
> +
> +	if (copy_from_user(&code, &pinfo->code, sizeof(code)))
> +		return -EFAULT;
> +	if (copy_from_user(&cnt, &pinfo->cnt, sizeof(cnt)))
> +		return -EFAULT;
> +	if (!cnt)
> +		return 0;
> +
> +	if (!dev->absinfo)
> +		valid_cnt = 0;
> +	else if (code > ABS_MAX2)
> +		valid_cnt = 0;
> +	else if (code + cnt <= code || code + cnt > ABS_MAX2)
> +		valid_cnt = ABS_MAX2 - code + 1;
> +	else
> +		valid_cnt = cnt;
> +
> +	for (i = 0; i < valid_cnt; ++i) {
> +		/*
> +		 * Take event lock to ensure that we are not
> +		 * copying data while EVIOCSABS2 changes it.
> +		 * Might be inconsistent, otherwise.
> +		 */
> +		spin_lock_irq(&dev->event_lock);
> +		abs = dev->absinfo[code + i];
> +		spin_unlock_irq(&dev->event_lock);
> +
> +		if (copy_to_user(&pinfo->info[i], &abs, sizeof(abs)))
> +			return -EFAULT;
> +	}
> +
> +	memset(&abs, 0, sizeof(abs));
> +	for (i = valid_cnt; i < cnt; ++i)
> +		if (copy_to_user(&pinfo->info[i], &abs, sizeof(abs)))
> +			return -EFAULT;
> +
> +	return 0;

why don't you return the number of valid copied axes to the user?
that seems better even than forcing the remainder to 0.

> +}
> +
> +static int evdev_handle_set_abs2(struct input_dev *dev, void __user *p)
> +{
> +	struct input_absinfo2 __user *pinfo = p;
> +	struct input_absinfo *abs;
> +	u32 code, cnt, i;
> +	size_t size;
> +
> +	if (!dev->absinfo)
> +		return 0;
> +	if (copy_from_user(&code, &pinfo->code, sizeof(code)))
> +		return -EFAULT;
> +	if (copy_from_user(&cnt, &pinfo->cnt, sizeof(cnt)))
> +		return -EFAULT;
> +	if (!cnt || code > ABS_MAX2)
> +		return 0;
> +
> +	if (code + cnt <= code || code + cnt > ABS_MAX2)
> +		cnt = ABS_MAX2 - code + 1;
> +
> +	size = cnt * sizeof(*abs);
> +	abs = memdup_user(pinfo->info, size);
> +	if (IS_ERR(abs))
> +		return PTR_ERR(abs);
> +
> +	/*
> +	 * Take event lock to ensure that we are not
> +	 * changing device parameters in the middle
> +	 * of event.
> +	 */
> +	spin_lock_irq(&dev->event_lock);
> +	for (i = 0; i < cnt; ++i) {
> +		/* silently drop ABS_MT_SLOT */
> +		if (code + i == ABS_MT_SLOT)
> +			continue;
> +
> +		dev->absinfo[code + i] = abs[i];
> +	}
> +	spin_unlock_irq(&dev->event_lock);
> +
> +	kfree(abs);
> +	return 0;
> +}
> +
>  static int evdev_handle_get_keycode(struct input_dev *dev, void __user *p)
>  {
>  	struct input_keymap_entry ke = {
> @@ -898,6 +985,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  		client->clkid = i;
>  		return 0;
>  
> +	case EVIOCGABS2:
> +		return evdev_handle_get_abs2(dev, p);
> +
> +	case EVIOCSABS2:
> +		return evdev_handle_set_abs2(dev, p);
> +
>  	case EVIOCGKEYCODE:
>  		return evdev_handle_get_keycode(dev, p);
>  

[...]

> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 927ad9a..4660ed1 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -311,7 +311,7 @@ static int uinput_validate_absbits(struct input_dev *dev)
>  	unsigned int cnt;
>  	int retval = 0;
>  
> -	for (cnt = 0; cnt < ABS_CNT; cnt++) {
> +	for (cnt = 0; cnt < ABS_CNT2; cnt++) {
>  		int min, max;
>  		if (!test_bit(cnt, dev->absbit))
>  			continue;
> @@ -474,7 +474,7 @@ static int uinput_setup_device2(struct uinput_device *udev,
>  		return -EINVAL;
>  
>  	/* rough check to avoid huge kernel space allocations */
> -	max = ABS_CNT * sizeof(*user_dev2->abs) + sizeof(*user_dev2);
> +	max = ABS_CNT2 * sizeof(*user_dev2->abs) + sizeof(*user_dev2);

hmm, if you ever up the value of ABS_CNT2 and you don't have it query-able,
userspace won't be able to create a uinput device on a kernel with a smaller
ABS_CNT2.  worst of all, the only error you get is EINVAL, which is also
used for invalid axis ranges, etc.

>  	if (count > max)
>  		return -EINVAL;
>  
> @@ -780,7 +780,7 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>  			break;
>  
>  		case UI_SET_ABSBIT:
> -			retval = uinput_set_bit(arg, absbit, ABS_MAX);
> +			retval = uinput_set_bit(arg, absbit, ABS_MAX2);
>  			break;
>  
>  		case UI_SET_MSCBIT:
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 31b9d29..c21d8bb 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -828,7 +828,7 @@ static inline void hid_map_usage(struct hid_input *hidinput,
>  	switch (type) {
>  	case EV_ABS:
>  		*bit = input->absbit;
> -		*max = ABS_MAX;
> +		*max = ABS_MAX2;
>  		break;
>  	case EV_REL:
>  		*bit = input->relbit;
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 82ce323..c6add6f 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -129,7 +129,7 @@ struct input_dev {
>  	unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
>  	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
>  	unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
> -	unsigned long absbit[BITS_TO_LONGS(ABS_CNT)];
> +	unsigned long absbit[BITS_TO_LONGS(ABS_CNT2)];
>  	unsigned long mscbit[BITS_TO_LONGS(MSC_CNT)];
>  	unsigned long ledbit[BITS_TO_LONGS(LED_CNT)];
>  	unsigned long sndbit[BITS_TO_LONGS(SND_CNT)];
> @@ -210,8 +210,8 @@ struct input_dev {
>  #error "REL_MAX and INPUT_DEVICE_ID_REL_MAX do not match"
>  #endif
>  
> -#if ABS_MAX != INPUT_DEVICE_ID_ABS_MAX
> -#error "ABS_MAX and INPUT_DEVICE_ID_ABS_MAX do not match"
> +#if ABS_MAX2 != INPUT_DEVICE_ID_ABS_MAX
> +#error "ABS_MAX2 and INPUT_DEVICE_ID_ABS_MAX do not match"
>  #endif
>  
>  #if MSC_MAX != INPUT_DEVICE_ID_MSC_MAX
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index bd24470..1856461 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -32,7 +32,7 @@ struct input_event {
>   * Protocol version.
>   */
>  
> -#define EV_VERSION		0x010001
> +#define EV_VERSION		0x010002

A history in the comments would be nice. something like

/**
 * 0x010000: original version
 * 0x010001: support for long scancodes
 * 0x010002: added ABS_CNT2/ABS_MAX2, EVIOCSABS2, EVIOCGABS2
 */


>  /*
>   * IOCTLs (0x00 - 0x7f)
> @@ -74,6 +74,30 @@ struct input_absinfo {
>  };
>  
>  /**
> + * struct input_absinfo2 - used by EVIOC[G/S]ABS2 ioctls

please spell the two out (at least once in this paragraph), it makes it grep-able.

> + * @code: First ABS code to query
> + * @cnt: Number of ABS codes to query starting at @code
> + * @info: #@cnt absinfo structures to get/set abs parameters for all codes
> + *
> + * This structure is used by the new EVIOC[G/S]ABS2 ioctls which
> + * do the same as the old EVIOC[G/S]ABS ioctls but avoid encoding
> + * the ABS code in the ioctl number. This allows a much wider
> + * range of ABS codes. Furthermore, it allows to query multiple codes with a
> + * single call.

"new" and "old" have a tendency to become "old" and "before old" quickly,
just skip both. A simple "use of EVIOCGABS/EVIOCSABS is discouraged except on kernels
without EVIOCGABS2/EVIOCSABS2 support" is enough to signal which one is preferred.

> + *
> + * Note that this silently drops any requests to set ABS_MT_SLOT. Hence, it is
> + * allowed to call this with code=0 cnt=ABS_CNT2. Furthermore, retrieving
> + * invalid codes returns all 0, setting them does nothing. So you must check
> + * with EVIOCGBIT first if you want reliable results. This behavior is needed
> + * to allow forward compatibility to new ABS codes.

I think this needs rewording, I was quite confused reading this. How about:

"For axes not present on the device and for axes exceeding the kernel's
built-in ABS_CNT2 maximum, EVIOCGABS2 sets all values in the struct absinfo
to 0. EVIOCGSABS2 silently ignores write requests to these axes.
ABS_MT_SlOT is an immutable axis and cannot be modified by EVIOCSABS2, 
the respective value is silently ignored."

also, please document the return value of the ioctl.

Cheers,
   Peter

> + */
> +struct input_absinfo2 {
> +	__u32 code;
> +	__u32 cnt;
> +	struct input_absinfo info[1];
> +};
> +
> +/**
>   * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
>   * @scancode: scancode represented in machine-endian form.
>   * @len: length of the scancode that resides in @scancode buffer.
> @@ -153,6 +177,8 @@ struct input_keymap_entry {
>  
>  #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
>  #define EVIOCREVOKE		_IOW('E', 0x91, int)			/* Revoke device access */
> +#define EVIOCGABS2		_IOR('E', 0x92, struct input_absinfo2)	/* get abs value/limits */
> +#define EVIOCSABS2		_IOW('E', 0x93, struct input_absinfo2)	/* set abs value/limits */
>  
>  #define EVIOCSCLOCKID		_IOW('E', 0xa0, int)			/* Set clockid to be used for timestamps */
>  
> @@ -835,11 +861,23 @@ struct input_keymap_entry {
>  #define ABS_MT_TOOL_X		0x3c	/* Center X tool position */
>  #define ABS_MT_TOOL_Y		0x3d	/* Center Y tool position */
>  
> -
> +/*
> + * ABS_MAX/CNT is limited to a maximum of 0x3f due to the design of EVIOCGABS
> + * and EVIOCSABS ioctls. Other kernel APIs like uinput also hardcoded it. Do
> + * not modify this value and instead use the extended ABS_MAX2/CNT2 API.
> + */
>  #define ABS_MAX			0x3f
>  #define ABS_CNT			(ABS_MAX+1)
>  
>  /*
> + * Due to API restrictions the legacy evdev API only supports ABS values up to
> + * ABS_MAX/CNT. Use the extended *ABS2 ioctls to operate on any ABS values in
> + * between ABS_MAX and ABS_MAX2.
> + */
> +#define ABS_MAX2		0x3f
> +#define ABS_CNT2		(ABS_MAX2+1)
> +
> +/*
>   * Switch events
>   */
>  
> diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
> index c2e8710..27ee521 100644
> --- a/include/uapi/linux/uinput.h
> +++ b/include/uapi/linux/uinput.h
> @@ -140,7 +140,7 @@ struct uinput_user_dev2 {
>  	char name[UINPUT_MAX_NAME_SIZE];
>  	struct input_id id;
>  	__u32 ff_effects_max;
> -	struct input_absinfo abs[ABS_CNT];
> +	struct input_absinfo abs[ABS_CNT2];
>  };
>  
>  #endif /* _UAPI__UINPUT_H_ */
> -- 
> 1.8.5.1
> 
