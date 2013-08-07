Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3HGSgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:36:01 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:32990 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3HGSf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <1375880938-6979-1-git-send-email-gautam.vivek@samsung.com>
References: <1375880938-6979-1-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 7 Aug 2013 11:35:58 -0700
X-Google-Sender-Auth: 9I_jYtq7A__IPDbMFc9LXSAMMXU
Message-ID: <CAODwPW8X-sVj1XPmZsFNtUtb-LQG96omNwOqdqh8UQMDsupvVg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: Cleanup error code in **_usb_get_phy_**() APIs
From: Julius Werner <jwerner@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        kishon@ti.com, Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -94,11 +94,11 @@ static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
>   */
>  struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
>  {
> -       struct usb_phy **ptr, *phy;
> +       struct usb_phy  *phy = ERR_PTR(-ENOMEM), **ptr;

This looks a little roundabout, don't you think? Why don't you just
directly have 'return ERR_PTR(-ENOMEM)' down there where you put 'goto
err0'?

>
>         ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
>         if (!ptr)
> -               return NULL;
> +               goto err0;
>
>         phy = usb_get_phy(type);
>         if (!IS_ERR(phy)) {
> @@ -107,6 +107,7 @@ struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
>         } else
>                 devres_free(ptr);
>
> +err0:
>         return phy;
>  }
>  EXPORT_SYMBOL_GPL(devm_usb_get_phy);

>  struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
>  {
> -       struct usb_phy **ptr, *phy;
> +       struct usb_phy  *phy = ERR_PTR(-ENOMEM), **ptr;

Same here

>
>         ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
>         if (!ptr)
> -               return NULL;
> +               goto err0;
>
>         phy = usb_get_phy_dev(dev, index);
>         if (!IS_ERR(phy)) {
> @@ -267,6 +268,7 @@ struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
>         } else
>                 devres_free(ptr);
>
> +err0:
>         return phy;
>  }
>  EXPORT_SYMBOL_GPL(devm_usb_get_phy_dev);

> @@ -142,7 +142,7 @@ extern void usb_remove_phy(struct usb_phy *);
>  /* helpers for direct access thru low-level io interface */
>  static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
>  {
> -       if (x->io_ops && x->io_ops->read)
> +       if (!IS_ERR(x) && x->io_ops && x->io_ops->read)

I liked the ones where we had IS_ERR_OR_NULL() here (and in all the
ones below)... you sometimes have to handle PHYs in
platform-independent code where you don't want to worry about if this
platform actually has a PHY driver there or not. Any reason you
changed that?

>                 return x->io_ops->read(x, reg);
>
>         return -EINVAL;
> @@ -150,7 +150,7 @@ static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
>
>  static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
>  {
> -       if (x->io_ops && x->io_ops->write)
> +       if (!IS_ERR(x) && x->io_ops && x->io_ops->write)
>                 return x->io_ops->write(x, val, reg);
>
>         return -EINVAL;
> @@ -159,7 +159,7 @@ static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
>  static inline int
>  usb_phy_init(struct usb_phy *x)
>  {
> -       if (x->init)
> +       if (!IS_ERR(x) && x->init)
>                 return x->init(x);
>
>         return 0;
> @@ -168,26 +168,27 @@ usb_phy_init(struct usb_phy *x)
>  static inline void
>  usb_phy_shutdown(struct usb_phy *x)
>  {
> -       if (x->shutdown)
> +       if (!IS_ERR(x) && x->shutdown)
>                 x->shutdown(x);
>  }
>
>  static inline int
>  usb_phy_vbus_on(struct usb_phy *x)
>  {
> -       if (!x->set_vbus)
> -               return 0;
> +       if (!IS_ERR(x) && x->set_vbus)
> +               return x->set_vbus(x, true);
>
> -       return x->set_vbus(x, true);
> +       return 0;
>  }
>
>  static inline int
>  usb_phy_vbus_off(struct usb_phy *x)
>  {
> -       if (!x->set_vbus)
> -               return 0;
> +       if (!IS_ERR(x) && x->set_vbus)
> +               return x->set_vbus(x, false);
> +
> +       return 0;
>
> -       return x->set_vbus(x, false);
>  }
>
>  /* for usb host and peripheral controller drivers */
> @@ -249,8 +250,9 @@ static inline int usb_bind_phy(const char *dev_name, u8 index,
>  static inline int
>  usb_phy_set_power(struct usb_phy *x, unsigned mA)
>  {
> -       if (x && x->set_power)
> +       if (!IS_ERR(x) && x->set_power)
>                 return x->set_power(x, mA);
> +
>         return 0;
>  }
>
> @@ -258,28 +260,28 @@ usb_phy_set_power(struct usb_phy *x, unsigned mA)
>  static inline int
>  usb_phy_set_suspend(struct usb_phy *x, int suspend)
>  {
> -       if (x->set_suspend != NULL)
> +       if (!IS_ERR(x) && x->set_suspend != NULL)
>                 return x->set_suspend(x, suspend);
> -       else
> -               return 0;
> +
> +       return 0;
>  }
>
>  static inline int
>  usb_phy_notify_connect(struct usb_phy *x, enum usb_device_speed speed)
>  {
> -       if (x->notify_connect)
> +       if (!IS_ERR(x) && x->notify_connect)
>                 return x->notify_connect(x, speed);
> -       else
> -               return 0;
> +
> +       return 0;
>  }
>
>  static inline int
>  usb_phy_notify_disconnect(struct usb_phy *x, enum usb_device_speed speed)
>  {
> -       if (x->notify_disconnect)
> +       if (!IS_ERR(x) && x->notify_disconnect)
>                 return x->notify_disconnect(x, speed);
> -       else
> -               return 0;
> +
> +       return 0;
>  }

Otherwise looks good to me.
