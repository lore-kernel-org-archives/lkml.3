Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3HSCk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:40:29 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60227 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3HSCk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:40:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW8X-sVj1XPmZsFNtUtb-LQG96omNwOqdqh8UQMDsupvVg@mail.gmail.com>
References: <1375880938-6979-1-git-send-email-gautam.vivek@samsung.com>
	<CAODwPW8X-sVj1XPmZsFNtUtb-LQG96omNwOqdqh8UQMDsupvVg@mail.gmail.com>
Date: Mon, 19 Aug 2013 08:10:26 +0530
Message-ID: <CAFp+6iEFibXaXOUq2Aqkt5EGeGJEuc65+_fnHpoME9QOkhArwA@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: Cleanup error code in **_usb_get_phy_**() APIs
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        kishon <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Aug 8, 2013 at 12:05 AM, Julius Werner <jwerner@chromium.org> wrote:
>> @@ -94,11 +94,11 @@ static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
>>   */
>>  struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
>>  {
>> -       struct usb_phy **ptr, *phy;
>> +       struct usb_phy  *phy = ERR_PTR(-ENOMEM), **ptr;
>
> This looks a little roundabout, don't you think? Why don't you just
> directly have 'return ERR_PTR(-ENOMEM)' down there where you put 'goto
> err0'?

Ok, will change this.

>
>>
>>         ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
>>         if (!ptr)
>> -               return NULL;
>> +               goto err0;
>>
>>         phy = usb_get_phy(type);
>>         if (!IS_ERR(phy)) {
>> @@ -107,6 +107,7 @@ struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
>>         } else
>>                 devres_free(ptr);
>>
>> +err0:
>>         return phy;
>>  }
>>  EXPORT_SYMBOL_GPL(devm_usb_get_phy);
>
>>  struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
>>  {
>> -       struct usb_phy **ptr, *phy;
>> +       struct usb_phy  *phy = ERR_PTR(-ENOMEM), **ptr;
>
> Same here

will change this too.

>
>>
>>         ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
>>         if (!ptr)
>> -               return NULL;
>> +               goto err0;
>>
>>         phy = usb_get_phy_dev(dev, index);
>>         if (!IS_ERR(phy)) {
>> @@ -267,6 +268,7 @@ struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
>>         } else
>>                 devres_free(ptr);
>>
>> +err0:
>>         return phy;
>>  }
>>  EXPORT_SYMBOL_GPL(devm_usb_get_phy_dev);
>
>> @@ -142,7 +142,7 @@ extern void usb_remove_phy(struct usb_phy *);
>>  /* helpers for direct access thru low-level io interface */
>>  static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
>>  {
>> -       if (x->io_ops && x->io_ops->read)
>> +       if (!IS_ERR(x) && x->io_ops && x->io_ops->read)
>
> I liked the ones where we had IS_ERR_OR_NULL() here (and in all the
> ones below)... you sometimes have to handle PHYs in
> platform-independent code where you don't want to worry about if this
> platform actually has a PHY driver there or not. Any reason you
> changed that?

The **get_phy_*() APIs never return a NULL pointer now, do we still
need to handle that in that case.
Or are we assuming that code will use these phy operations without
getting a phy in the first place ?

>
>>                 return x->io_ops->read(x, reg);
>>
>>         return -EINVAL;
>> @@ -150,7 +150,7 @@ static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
>>
>>  static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
>>  {
>> -       if (x->io_ops && x->io_ops->write)
>> +       if (!IS_ERR(x) && x->io_ops && x->io_ops->write)
>>                 return x->io_ops->write(x, val, reg);
>>
>>         return -EINVAL;
>> @@ -159,7 +159,7 @@ static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
>>  static inline int
>>  usb_phy_init(struct usb_phy *x)
>>  {
>> -       if (x->init)
>> +       if (!IS_ERR(x) && x->init)
>>                 return x->init(x);
>>
>>         return 0;
>> @@ -168,26 +168,27 @@ usb_phy_init(struct usb_phy *x)
>>  static inline void
>>  usb_phy_shutdown(struct usb_phy *x)
>>  {
>> -       if (x->shutdown)
>> +       if (!IS_ERR(x) && x->shutdown)
>>                 x->shutdown(x);
>>  }
>>
>>  static inline int
>>  usb_phy_vbus_on(struct usb_phy *x)
>>  {
>> -       if (!x->set_vbus)
>> -               return 0;
>> +       if (!IS_ERR(x) && x->set_vbus)
>> +               return x->set_vbus(x, true);
>>
>> -       return x->set_vbus(x, true);
>> +       return 0;
>>  }
>>
>>  static inline int
>>  usb_phy_vbus_off(struct usb_phy *x)
>>  {
>> -       if (!x->set_vbus)
>> -               return 0;
>> +       if (!IS_ERR(x) && x->set_vbus)
>> +               return x->set_vbus(x, false);
>> +
>> +       return 0;
>>
>> -       return x->set_vbus(x, false);
>>  }
>>
>>  /* for usb host and peripheral controller drivers */
>> @@ -249,8 +250,9 @@ static inline int usb_bind_phy(const char *dev_name, u8 index,
>>  static inline int
>>  usb_phy_set_power(struct usb_phy *x, unsigned mA)
>>  {
>> -       if (x && x->set_power)
>> +       if (!IS_ERR(x) && x->set_power)
>>                 return x->set_power(x, mA);
>> +
>>         return 0;
>>  }
>>
>> @@ -258,28 +260,28 @@ usb_phy_set_power(struct usb_phy *x, unsigned mA)
>>  static inline int
>>  usb_phy_set_suspend(struct usb_phy *x, int suspend)
>>  {
>> -       if (x->set_suspend != NULL)
>> +       if (!IS_ERR(x) && x->set_suspend != NULL)
>>                 return x->set_suspend(x, suspend);
>> -       else
>> -               return 0;
>> +
>> +       return 0;
>>  }
>>
>>  static inline int
>>  usb_phy_notify_connect(struct usb_phy *x, enum usb_device_speed speed)
>>  {
>> -       if (x->notify_connect)
>> +       if (!IS_ERR(x) && x->notify_connect)
>>                 return x->notify_connect(x, speed);
>> -       else
>> -               return 0;
>> +
>> +       return 0;
>>  }
>>
>>  static inline int
>>  usb_phy_notify_disconnect(struct usb_phy *x, enum usb_device_speed speed)
>>  {
>> -       if (x->notify_disconnect)
>> +       if (!IS_ERR(x) && x->notify_disconnect)
>>                 return x->notify_disconnect(x, speed);
>> -       else
>> -               return 0;
>> +
>> +       return 0;
>>  }
>
> Otherwise looks good to me.

Thanks !!



-- 
Best Regards
Vivek
