Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaIKLOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:14:34 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47394 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaIKLOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140911111000.GA552@ulmo>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
	<1410364463-12692-4-git-send-email-dh.herrmann@gmail.com>
	<20140911111000.GA552@ulmo>
Date: Thu, 11 Sep 2014 13:14:31 +0200
Message-ID: <CANq1E4S=0EHyLh6M_pA94QNgMzzj5NXpd6p7OMDTaQSW+Qd_bQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] backlight: add kernel-internal backlight API
From: David Herrmann <dh.herrmann@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Sep 11, 2014 at 1:10 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Sep 10, 2014 at 05:54:22PM +0200, David Herrmann wrote:
> [...]
>> +void backlight_set_brightness(struct backlight_device *bd, unsigned int value,
>> +                           enum backlight_update_reason reason)
>> +{
>> +     mutex_lock(&bd->ops_lock);
>> +     if (bd->ops) {
>> +             value = clamp(value, 0U, (unsigned)bd->props.max_brightness);
>
> max_brightness should really be unsigned to begin with...
>
>> +             pr_debug("set brightness to %u\n", value);
>
> dev_dbg(&bd->dev, ...)?

I agree with both comments, but I tried to be consistent with what
brightness_store() does.

>> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
>> index adb14a8..bcc0dec 100644
>> --- a/include/linux/backlight.h
>> +++ b/include/linux/backlight.h
>> @@ -141,6 +141,22 @@ extern bool backlight_device_registered(enum backlight_type type);
>>  extern int backlight_register_notifier(struct notifier_block *nb);
>>  extern int backlight_unregister_notifier(struct notifier_block *nb);
>>
>> +struct backlight_device *backlight_device_lookup(const char *name);
>> +void backlight_set_brightness(struct backlight_device *bd, unsigned int value,
>> +                           enum backlight_update_reason reason);
>> +
>> +static inline void backlight_device_ref(struct backlight_device *bd)
>> +{
>> +     if (bd)
>> +             get_device(&bd->dev);
>> +}
>
> Perhaps for consistency with get_device() this should return bd? That
> way you can chain things like so:
>
>         priv->backlight = backlight_device_ref(bd);

Makes sense, will change it. Same is actually true for _unref(), which
should return NULL unconditionally. This way, you can use:
  priv->backlight = backlight_device_unref(priv->backlight);
to release a reference and reset the pointer at the same time.

Thanks
David
