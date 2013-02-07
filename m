Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3BGNiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:38:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41780 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334Ab3BGNiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:38:21 -0500
Message-ID: <5113AE42.8090401@ti.com>
Date: Thu, 7 Feb 2013 19:08:10 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] usb: phy: moving all PHY API definitions to usb/phy
 directory
References: <1360236751-23183-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1360236751-23183-1-git-send-email-vbyravarasu@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 07 February 2013 05:02 PM, Venu Byravarasu wrote:
> As drivers/usb/otg/otg.c contains most of the PHY related APIs which
> are not OTG specific, moving them to more logical place under
> drivers/usb/phy.
>
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v2:
> renamed usb_phy.c to phy.c.
>
> delta from v1:
> Missed adding newly created file usb_phy.c with previous patch.
> hence sending v2, after adding that.
>
>   drivers/usb/otg/otg.c                |  422 ----------------
>   drivers/usb/phy/Makefile             |    1 +
>   drivers/usb/{otg/otg.c => phy/phy.c} |  907 ++++++++++++++++------------------
>   3 files changed, 438 insertions(+), 892 deletions(-)
>   copy drivers/usb/{otg/otg.c => phy/phy.c} (92%)
>
> diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
> index e181439..a5357e9 100644
> --- a/drivers/usb/otg/otg.c
> +++ b/drivers/usb/otg/otg.c
> @@ -9,431 +9,9 @@
>    * (at your option) any later version.
>    */
>
> -#include <linux/kernel.h>
>   #include <linux/export.h>
> -#include <linux/err.h>
> -#include <linux/device.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/of.h>
> -
>   #include <linux/usb/otg.h>
>
> -static LIST_HEAD(phy_list);
> -static LIST_HEAD(phy_bind_list);
> -static DEFINE_SPINLOCK(phy_lock);
> -
> -static struct usb_phy *__usb_find_phy(struct list_head *list,
> -	enum usb_phy_type type)
> -{
> -	struct usb_phy  *phy = NULL;
> -
> -	list_for_each_entry(phy, list, head) {
> -		if (phy->type != type)
> -			continue;
> -
> -		return phy;
> -	}
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static struct usb_phy *__usb_find_phy_dev(struct device *dev,
> -	struct list_head *list, u8 index)
> -{
> -	struct usb_phy_bind *phy_bind = NULL;
> -
> -	list_for_each_entry(phy_bind, list, list) {
> -		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
> -				phy_bind->index == index) {
> -			if (phy_bind->phy)
> -				return phy_bind->phy;
> -			else
> -				return ERR_PTR(-EPROBE_DEFER);
> -		}
> -	}
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static struct usb_phy *__of_usb_find_phy(struct device_node *node)
> -{
> -	struct usb_phy  *phy;
> -
> -	list_for_each_entry(phy, &phy_list, head) {
> -		if (node != phy->dev->of_node)
> -			continue;
> -
> -		return phy;
> -	}
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static void devm_usb_phy_release(struct device *dev, void *res)
> -{
> -	struct usb_phy *phy = *(struct usb_phy **)res;
> -
> -	usb_put_phy(phy);
> -}
> -
> -static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
> -{
> -	return res == match_data;
> -}
> -
> -/**
> - * devm_usb_get_phy - find the USB PHY
> - * @dev - device that requests this phy
> - * @type - the type of the phy the controller requires
> - *
> - * Gets the phy using usb_get_phy(), and associates a device with it using
> - * devres. On driver detach, release function is invoked on the devres data,
> - * then, devres data is freed.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
> -{
> -	struct usb_phy **ptr, *phy;
> -
> -	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr)
> -		return NULL;
> -
> -	phy = usb_get_phy(type);
> -	if (!IS_ERR(phy)) {
> -		*ptr = phy;
> -		devres_add(dev, ptr);
> -	} else
> -		devres_free(ptr);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(devm_usb_get_phy);
> -
> -/**
> - * usb_get_phy - find the USB PHY
> - * @type - the type of the phy the controller requires
> - *
> - * Returns the phy driver, after getting a refcount to it; or
> - * -ENODEV if there is no such phy.  The caller is responsible for
> - * calling usb_put_phy() to release that count.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *usb_get_phy(enum usb_phy_type type)
> -{
> -	struct usb_phy	*phy = NULL;
> -	unsigned long	flags;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	phy = __usb_find_phy(&phy_list, type);
> -	if (IS_ERR(phy)) {
> -		pr_err("unable to find transceiver of type %s\n",
> -			usb_phy_type_string(type));
> -		goto err0;
> -	}
> -
> -	get_device(phy->dev);
> -
> -err0:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(usb_get_phy);
> -
> - /**
> - * devm_usb_get_phy_by_phandle - find the USB PHY by phandle
> - * @dev - device that requests this phy
> - * @phandle - name of the property holding the phy phandle value
> - * @index - the index of the phy
> - *
> - * Returns the phy driver associated with the given phandle value,
> - * after getting a refcount to it, -ENODEV if there is no such phy or
> - * -EPROBE_DEFER if there is a phandle to the phy, but the device is
> - * not yet loaded. While at that, it also associates the device with
> - * the phy using devres. On driver detach, release function is invoked
> - * on the devres data, then, devres data is freed.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
> -	const char *phandle, u8 index)
> -{
> -	struct usb_phy	*phy = ERR_PTR(-ENOMEM), **ptr;
> -	unsigned long	flags;
> -	struct device_node *node;
> -
> -	if (!dev->of_node) {
> -		dev_dbg(dev, "device does not have a device node entry\n");
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	node = of_parse_phandle(dev->of_node, phandle, index);
> -	if (!node) {
> -		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
> -			dev->of_node->full_name);
> -		return ERR_PTR(-ENODEV);
> -	}
> -
> -	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr) {
> -		dev_dbg(dev, "failed to allocate memory for devres\n");
> -		goto err0;
> -	}
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	phy = __of_usb_find_phy(node);
> -	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> -		phy = ERR_PTR(-EPROBE_DEFER);
> -		devres_free(ptr);
> -		goto err1;
> -	}
> -
> -	*ptr = phy;
> -	devres_add(dev, ptr);
> -
> -	get_device(phy->dev);
> -
> -err1:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -err0:
> -	of_node_put(node);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(devm_usb_get_phy_by_phandle);
> -
> -/**
> - * usb_get_phy_dev - find the USB PHY
> - * @dev - device that requests this phy
> - * @index - the index of the phy
> - *
> - * Returns the phy driver, after getting a refcount to it; or
> - * -ENODEV if there is no such phy.  The caller is responsible for
> - * calling usb_put_phy() to release that count.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
> -{
> -	struct usb_phy	*phy = NULL;
> -	unsigned long	flags;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
> -	if (IS_ERR(phy)) {
> -		pr_err("unable to find transceiver\n");
> -		goto err0;
> -	}
> -
> -	get_device(phy->dev);
> -
> -err0:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(usb_get_phy_dev);
> -
> -/**
> - * devm_usb_get_phy_dev - find the USB PHY using device ptr and index
> - * @dev - device that requests this phy
> - * @index - the index of the phy
> - *
> - * Gets the phy using usb_get_phy_dev(), and associates a device with it using
> - * devres. On driver detach, release function is invoked on the devres data,
> - * then, devres data is freed.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
> -{
> -	struct usb_phy **ptr, *phy;
> -
> -	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr)
> -		return NULL;
> -
> -	phy = usb_get_phy_dev(dev, index);
> -	if (!IS_ERR(phy)) {
> -		*ptr = phy;
> -		devres_add(dev, ptr);
> -	} else
> -		devres_free(ptr);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(devm_usb_get_phy_dev);
> -
> -/**
> - * devm_usb_put_phy - release the USB PHY
> - * @dev - device that wants to release this phy
> - * @phy - the phy returned by devm_usb_get_phy()
> - *
> - * destroys the devres associated with this phy and invokes usb_put_phy
> - * to release the phy.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -void devm_usb_put_phy(struct device *dev, struct usb_phy *phy)
> -{
> -	int r;
> -
> -	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
> -	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
> -}
> -EXPORT_SYMBOL(devm_usb_put_phy);
> -
> -/**
> - * usb_put_phy - release the USB PHY
> - * @x: the phy returned by usb_get_phy()
> - *
> - * Releases a refcount the caller received from usb_get_phy().
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -void usb_put_phy(struct usb_phy *x)
> -{
> -	if (x)
> -		put_device(x->dev);
> -}
> -EXPORT_SYMBOL(usb_put_phy);
> -
> -/**
> - * usb_add_phy - declare the USB PHY
> - * @x: the USB phy to be used; or NULL
> - * @type - the type of this PHY
> - *
> - * This call is exclusively for use by phy drivers, which
> - * coordinate the activities of drivers for host and peripheral
> - * controllers, and in some cases for VBUS current regulation.
> - */
> -int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
> -{
> -	int		ret = 0;
> -	unsigned long	flags;
> -	struct usb_phy	*phy;
> -
> -	if (x->type != USB_PHY_TYPE_UNDEFINED) {
> -		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
> -		return -EINVAL;
> -	}
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	list_for_each_entry(phy, &phy_list, head) {
> -		if (phy->type == type) {
> -			ret = -EBUSY;
> -			dev_err(x->dev, "transceiver type %s already exists\n",
> -						usb_phy_type_string(type));
> -			goto out;
> -		}
> -	}
> -
> -	x->type = type;
> -	list_add_tail(&x->head, &phy_list);
> -
> -out:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -	return ret;
> -}
> -EXPORT_SYMBOL(usb_add_phy);
> -
> -/**
> - * usb_add_phy_dev - declare the USB PHY
> - * @x: the USB phy to be used; or NULL
> - *
> - * This call is exclusively for use by phy drivers, which
> - * coordinate the activities of drivers for host and peripheral
> - * controllers, and in some cases for VBUS current regulation.
> - */
> -int usb_add_phy_dev(struct usb_phy *x)
> -{
> -	struct usb_phy_bind *phy_bind;
> -	unsigned long flags;
> -
> -	if (!x->dev) {
> -		dev_err(x->dev, "no device provided for PHY\n");
> -		return -EINVAL;
> -	}
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -	list_for_each_entry(phy_bind, &phy_bind_list, list)
> -		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
> -			phy_bind->phy = x;
> -
> -	list_add_tail(&x->head, &phy_list);
> -
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -	return 0;
> -}
> -EXPORT_SYMBOL(usb_add_phy_dev);
> -
> -/**
> - * usb_remove_phy - remove the OTG PHY
> - * @x: the USB OTG PHY to be removed;
> - *
> - * This reverts the effects of usb_add_phy
> - */
> -void usb_remove_phy(struct usb_phy *x)
> -{
> -	unsigned long	flags;
> -	struct usb_phy_bind *phy_bind;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -	if (x) {
> -		list_for_each_entry(phy_bind, &phy_bind_list, list)
> -			if (phy_bind->phy == x)
> -				phy_bind->phy = NULL;
> -		list_del(&x->head);
> -	}
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -}
> -EXPORT_SYMBOL(usb_remove_phy);
> -
> -/**
> - * usb_bind_phy - bind the phy and the controller that uses the phy
> - * @dev_name: the device name of the device that will bind to the phy
> - * @index: index to specify the port number
> - * @phy_dev_name: the device name of the phy
> - *
> - * Fills the phy_bind structure with the dev_name and phy_dev_name. This will
> - * be used when the phy driver registers the phy and when the controller
> - * requests this phy.
> - *
> - * To be used by platform specific initialization code.
> - */
> -int __init usb_bind_phy(const char *dev_name, u8 index,
> -				const char *phy_dev_name)
> -{
> -	struct usb_phy_bind *phy_bind;
> -	unsigned long flags;
> -
> -	phy_bind = kzalloc(sizeof(*phy_bind), GFP_KERNEL);
> -	if (!phy_bind) {
> -		pr_err("phy_bind(): No memory for phy_bind");
> -		return -ENOMEM;
> -	}
> -
> -	phy_bind->dev_name = dev_name;
> -	phy_bind->phy_dev_name = phy_dev_name;
> -	phy_bind->index = index;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -	list_add_tail(&phy_bind->list, &phy_bind_list);
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(usb_bind_phy);
> -
>   const char *otg_state_string(enum usb_otg_state state)
>   {
>   	switch (state) {
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index b13faa1..886be13 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -4,6 +4,7 @@
>
>   ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
>
> +obj-$(CONFIG_USB_COMMON)			+= phy.o

I think we should have a separate config for PHYs. There might be 
controllers which dont need separate PHY. But we can have that as a 
separate patch later since we might want to change the Kconfig of other 
UDC drivers.
>   obj-$(CONFIG_OMAP_USB2)			+= omap-usb2.o
>   obj-$(CONFIG_OMAP_USB3)			+= omap-usb3.o
>   obj-$(CONFIG_OMAP_CONTROL_USB)		+= omap-control-usb.o
> diff --git a/drivers/usb/otg/otg.c b/drivers/usb/phy/phy.c
> similarity index 92%
> copy from drivers/usb/otg/otg.c
> copy to drivers/usb/phy/phy.c
> index e181439..f3affc6 100644
> --- a/drivers/usb/otg/otg.c
> +++ b/drivers/usb/phy/phy.c
> @@ -1,470 +1,437 @@
> -/*
> - * otg.c -- USB OTG utility code
> - *
> - * Copyright (C) 2004 Texas Instruments
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/export.h>
> -#include <linux/err.h>
> -#include <linux/device.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/of.h>
> -
> -#include <linux/usb/otg.h>
> -
> -static LIST_HEAD(phy_list);
> -static LIST_HEAD(phy_bind_list);
> -static DEFINE_SPINLOCK(phy_lock);
> -
> -static struct usb_phy *__usb_find_phy(struct list_head *list,
> -	enum usb_phy_type type)
> -{
> -	struct usb_phy  *phy = NULL;
> -
> -	list_for_each_entry(phy, list, head) {
> -		if (phy->type != type)
> -			continue;
> -
> -		return phy;
> -	}
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static struct usb_phy *__usb_find_phy_dev(struct device *dev,
> -	struct list_head *list, u8 index)
> -{
> -	struct usb_phy_bind *phy_bind = NULL;
> -
> -	list_for_each_entry(phy_bind, list, list) {
> -		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
> -				phy_bind->index == index) {
> -			if (phy_bind->phy)
> -				return phy_bind->phy;
> -			else
> -				return ERR_PTR(-EPROBE_DEFER);
> -		}
> -	}
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static struct usb_phy *__of_usb_find_phy(struct device_node *node)
> -{
> -	struct usb_phy  *phy;
> -
> -	list_for_each_entry(phy, &phy_list, head) {
> -		if (node != phy->dev->of_node)
> -			continue;
> -
> -		return phy;
> -	}
> -
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static void devm_usb_phy_release(struct device *dev, void *res)
> -{
> -	struct usb_phy *phy = *(struct usb_phy **)res;
> -
> -	usb_put_phy(phy);
> -}
> -
> -static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
> -{
> -	return res == match_data;
> -}
> -
> -/**
> - * devm_usb_get_phy - find the USB PHY
> - * @dev - device that requests this phy
> - * @type - the type of the phy the controller requires
> - *
> - * Gets the phy using usb_get_phy(), and associates a device with it using
> - * devres. On driver detach, release function is invoked on the devres data,
> - * then, devres data is freed.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
> -{
> -	struct usb_phy **ptr, *phy;
> -
> -	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr)
> -		return NULL;
> -
> -	phy = usb_get_phy(type);
> -	if (!IS_ERR(phy)) {
> -		*ptr = phy;
> -		devres_add(dev, ptr);
> -	} else
> -		devres_free(ptr);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(devm_usb_get_phy);
> -
> -/**
> - * usb_get_phy - find the USB PHY
> - * @type - the type of the phy the controller requires
> - *
> - * Returns the phy driver, after getting a refcount to it; or
> - * -ENODEV if there is no such phy.  The caller is responsible for
> - * calling usb_put_phy() to release that count.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *usb_get_phy(enum usb_phy_type type)
> -{
> -	struct usb_phy	*phy = NULL;
> -	unsigned long	flags;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	phy = __usb_find_phy(&phy_list, type);
> -	if (IS_ERR(phy)) {
> -		pr_err("unable to find transceiver of type %s\n",
> -			usb_phy_type_string(type));
> -		goto err0;
> -	}
> -
> -	get_device(phy->dev);
> -
> -err0:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(usb_get_phy);
> -
> - /**
> - * devm_usb_get_phy_by_phandle - find the USB PHY by phandle
> - * @dev - device that requests this phy
> - * @phandle - name of the property holding the phy phandle value
> - * @index - the index of the phy
> - *
> - * Returns the phy driver associated with the given phandle value,
> - * after getting a refcount to it, -ENODEV if there is no such phy or
> - * -EPROBE_DEFER if there is a phandle to the phy, but the device is
> - * not yet loaded. While at that, it also associates the device with
> - * the phy using devres. On driver detach, release function is invoked
> - * on the devres data, then, devres data is freed.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
> -	const char *phandle, u8 index)
> -{
> -	struct usb_phy	*phy = ERR_PTR(-ENOMEM), **ptr;
> -	unsigned long	flags;
> -	struct device_node *node;
> -
> -	if (!dev->of_node) {
> -		dev_dbg(dev, "device does not have a device node entry\n");
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	node = of_parse_phandle(dev->of_node, phandle, index);
> -	if (!node) {
> -		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
> -			dev->of_node->full_name);
> -		return ERR_PTR(-ENODEV);
> -	}
> -
> -	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr) {
> -		dev_dbg(dev, "failed to allocate memory for devres\n");
> -		goto err0;
> -	}
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	phy = __of_usb_find_phy(node);
> -	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> -		phy = ERR_PTR(-EPROBE_DEFER);
> -		devres_free(ptr);
> -		goto err1;
> -	}
> -
> -	*ptr = phy;
> -	devres_add(dev, ptr);
> -
> -	get_device(phy->dev);
> -
> -err1:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -err0:
> -	of_node_put(node);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(devm_usb_get_phy_by_phandle);
> -
> -/**
> - * usb_get_phy_dev - find the USB PHY
> - * @dev - device that requests this phy
> - * @index - the index of the phy
> - *
> - * Returns the phy driver, after getting a refcount to it; or
> - * -ENODEV if there is no such phy.  The caller is responsible for
> - * calling usb_put_phy() to release that count.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
> -{
> -	struct usb_phy	*phy = NULL;
> -	unsigned long	flags;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
> -	if (IS_ERR(phy)) {
> -		pr_err("unable to find transceiver\n");
> -		goto err0;
> -	}
> -
> -	get_device(phy->dev);
> -
> -err0:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(usb_get_phy_dev);
> -
> -/**
> - * devm_usb_get_phy_dev - find the USB PHY using device ptr and index
> - * @dev - device that requests this phy
> - * @index - the index of the phy
> - *
> - * Gets the phy using usb_get_phy_dev(), and associates a device with it using
> - * devres. On driver detach, release function is invoked on the devres data,
> - * then, devres data is freed.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
> -{
> -	struct usb_phy **ptr, *phy;
> -
> -	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr)
> -		return NULL;
> -
> -	phy = usb_get_phy_dev(dev, index);
> -	if (!IS_ERR(phy)) {
> -		*ptr = phy;
> -		devres_add(dev, ptr);
> -	} else
> -		devres_free(ptr);
> -
> -	return phy;
> -}
> -EXPORT_SYMBOL(devm_usb_get_phy_dev);
> -
> -/**
> - * devm_usb_put_phy - release the USB PHY
> - * @dev - device that wants to release this phy
> - * @phy - the phy returned by devm_usb_get_phy()
> - *
> - * destroys the devres associated with this phy and invokes usb_put_phy
> - * to release the phy.
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -void devm_usb_put_phy(struct device *dev, struct usb_phy *phy)
> -{
> -	int r;
> -
> -	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
> -	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
> -}
> -EXPORT_SYMBOL(devm_usb_put_phy);
> -
> -/**
> - * usb_put_phy - release the USB PHY
> - * @x: the phy returned by usb_get_phy()
> - *
> - * Releases a refcount the caller received from usb_get_phy().
> - *
> - * For use by USB host and peripheral drivers.
> - */
> -void usb_put_phy(struct usb_phy *x)
> -{
> -	if (x)
> -		put_device(x->dev);
> -}
> -EXPORT_SYMBOL(usb_put_phy);
> -
> -/**
> - * usb_add_phy - declare the USB PHY
> - * @x: the USB phy to be used; or NULL
> - * @type - the type of this PHY
> - *
> - * This call is exclusively for use by phy drivers, which
> - * coordinate the activities of drivers for host and peripheral
> - * controllers, and in some cases for VBUS current regulation.
> - */
> -int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
> -{
> -	int		ret = 0;
> -	unsigned long	flags;
> -	struct usb_phy	*phy;
> -
> -	if (x->type != USB_PHY_TYPE_UNDEFINED) {
> -		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
> -		return -EINVAL;
> -	}
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -
> -	list_for_each_entry(phy, &phy_list, head) {
> -		if (phy->type == type) {
> -			ret = -EBUSY;
> -			dev_err(x->dev, "transceiver type %s already exists\n",
> -						usb_phy_type_string(type));
> -			goto out;
> -		}
> -	}
> -
> -	x->type = type;
> -	list_add_tail(&x->head, &phy_list);
> -
> -out:
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -	return ret;
> -}
> -EXPORT_SYMBOL(usb_add_phy);
> -
> -/**
> - * usb_add_phy_dev - declare the USB PHY
> - * @x: the USB phy to be used; or NULL
> - *
> - * This call is exclusively for use by phy drivers, which
> - * coordinate the activities of drivers for host and peripheral
> - * controllers, and in some cases for VBUS current regulation.
> - */
> -int usb_add_phy_dev(struct usb_phy *x)
> -{
> -	struct usb_phy_bind *phy_bind;
> -	unsigned long flags;
> -
> -	if (!x->dev) {
> -		dev_err(x->dev, "no device provided for PHY\n");
> -		return -EINVAL;
> -	}
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -	list_for_each_entry(phy_bind, &phy_bind_list, list)
> -		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
> -			phy_bind->phy = x;
> -
> -	list_add_tail(&x->head, &phy_list);
> -
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -	return 0;
> -}
> -EXPORT_SYMBOL(usb_add_phy_dev);
> -
> -/**
> - * usb_remove_phy - remove the OTG PHY
> - * @x: the USB OTG PHY to be removed;
> - *
> - * This reverts the effects of usb_add_phy
> - */
> -void usb_remove_phy(struct usb_phy *x)
> -{
> -	unsigned long	flags;
> -	struct usb_phy_bind *phy_bind;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -	if (x) {
> -		list_for_each_entry(phy_bind, &phy_bind_list, list)
> -			if (phy_bind->phy == x)
> -				phy_bind->phy = NULL;
> -		list_del(&x->head);
> -	}
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -}
> -EXPORT_SYMBOL(usb_remove_phy);
> -
> -/**
> - * usb_bind_phy - bind the phy and the controller that uses the phy
> - * @dev_name: the device name of the device that will bind to the phy
> - * @index: index to specify the port number
> - * @phy_dev_name: the device name of the phy
> - *
> - * Fills the phy_bind structure with the dev_name and phy_dev_name. This will
> - * be used when the phy driver registers the phy and when the controller
> - * requests this phy.
> - *
> - * To be used by platform specific initialization code.
> - */
> -int __init usb_bind_phy(const char *dev_name, u8 index,
> -				const char *phy_dev_name)
> -{
> -	struct usb_phy_bind *phy_bind;
> -	unsigned long flags;
> -
> -	phy_bind = kzalloc(sizeof(*phy_bind), GFP_KERNEL);
> -	if (!phy_bind) {
> -		pr_err("phy_bind(): No memory for phy_bind");
> -		return -ENOMEM;
> -	}
> -
> -	phy_bind->dev_name = dev_name;
> -	phy_bind->phy_dev_name = phy_dev_name;
> -	phy_bind->index = index;
> -
> -	spin_lock_irqsave(&phy_lock, flags);
> -	list_add_tail(&phy_bind->list, &phy_bind_list);
> -	spin_unlock_irqrestore(&phy_lock, flags);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(usb_bind_phy);
> -
> -const char *otg_state_string(enum usb_otg_state state)
> -{
> -	switch (state) {
> -	case OTG_STATE_A_IDLE:
> -		return "a_idle";
> -	case OTG_STATE_A_WAIT_VRISE:
> -		return "a_wait_vrise";
> -	case OTG_STATE_A_WAIT_BCON:
> -		return "a_wait_bcon";
> -	case OTG_STATE_A_HOST:
> -		return "a_host";
> -	case OTG_STATE_A_SUSPEND:
> -		return "a_suspend";
> -	case OTG_STATE_A_PERIPHERAL:
> -		return "a_peripheral";
> -	case OTG_STATE_A_WAIT_VFALL:
> -		return "a_wait_vfall";
> -	case OTG_STATE_A_VBUS_ERR:
> -		return "a_vbus_err";
> -	case OTG_STATE_B_IDLE:
> -		return "b_idle";
> -	case OTG_STATE_B_SRP_INIT:
> -		return "b_srp_init";
> -	case OTG_STATE_B_PERIPHERAL:
> -		return "b_peripheral";
> -	case OTG_STATE_B_WAIT_ACON:
> -		return "b_wait_acon";
> -	case OTG_STATE_B_HOST:
> -		return "b_host";
> -	default:
> -		return "UNDEFINED";
> -	}
> -}
> -EXPORT_SYMBOL(otg_state_string);
> +/*
> + * phy.c -- USB PHY utility code
> + *
> + * Copyright (C) 2004 Texas Instruments

You can update this to 2013.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/export.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +
> +#include <linux/usb/phy.h>
> +
> +static LIST_HEAD(phy_list);
> +static LIST_HEAD(phy_bind_list);
> +static DEFINE_SPINLOCK(phy_lock);
> +
> +static struct usb_phy *__usb_find_phy(struct list_head *list,
> +	enum usb_phy_type type)
> +{
> +	struct usb_phy  *phy = NULL;
> +
> +	list_for_each_entry(phy, list, head) {
> +		if (phy->type != type)
> +			continue;
> +
> +		return phy;
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +static struct usb_phy *__usb_find_phy_dev(struct device *dev,
> +	struct list_head *list, u8 index)
> +{
> +	struct usb_phy_bind *phy_bind = NULL;
> +
> +	list_for_each_entry(phy_bind, list, list) {
> +		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
> +				phy_bind->index == index) {
> +			if (phy_bind->phy)
> +				return phy_bind->phy;
> +			else
> +				return ERR_PTR(-EPROBE_DEFER);
> +		}
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +static struct usb_phy *__of_usb_find_phy(struct device_node *node)
> +{
> +	struct usb_phy  *phy;
> +
> +	list_for_each_entry(phy, &phy_list, head) {
> +		if (node != phy->dev->of_node)
> +			continue;
> +
> +		return phy;
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +static void devm_usb_phy_release(struct device *dev, void *res)
> +{
> +	struct usb_phy *phy = *(struct usb_phy **)res;
> +
> +	usb_put_phy(phy);
> +}
> +
> +static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
> +{
> +	return res == match_data;
> +}
> +
> +/**
> + * devm_usb_get_phy - find the USB PHY
> + * @dev - device that requests this phy
> + * @type - the type of the phy the controller requires
> + *
> + * Gets the phy using usb_get_phy(), and associates a device with it using
> + * devres. On driver detach, release function is invoked on the devres data,
> + * then, devres data is freed.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
> +{
> +	struct usb_phy **ptr, *phy;
> +
> +	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	phy = usb_get_phy(type);
> +	if (!IS_ERR(phy)) {
> +		*ptr = phy;
> +		devres_add(dev, ptr);
> +	} else
> +		devres_free(ptr);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL(devm_usb_get_phy);
> +
> +/**
> + * usb_get_phy - find the USB PHY
> + * @type - the type of the phy the controller requires
> + *
> + * Returns the phy driver, after getting a refcount to it; or
> + * -ENODEV if there is no such phy.  The caller is responsible for
> + * calling usb_put_phy() to release that count.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +struct usb_phy *usb_get_phy(enum usb_phy_type type)
> +{
> +	struct usb_phy	*phy = NULL;
> +	unsigned long	flags;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +
> +	phy = __usb_find_phy(&phy_list, type);
> +	if (IS_ERR(phy)) {
> +		pr_err("unable to find transceiver of type %s\n",
> +			usb_phy_type_string(type));
> +		goto err0;
> +	}
> +
> +	get_device(phy->dev);
> +
> +err0:
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL(usb_get_phy);
> +
> + /**
> + * devm_usb_get_phy_by_phandle - find the USB PHY by phandle
> + * @dev - device that requests this phy
> + * @phandle - name of the property holding the phy phandle value
> + * @index - the index of the phy
> + *
> + * Returns the phy driver associated with the given phandle value,
> + * after getting a refcount to it, -ENODEV if there is no such phy or
> + * -EPROBE_DEFER if there is a phandle to the phy, but the device is
> + * not yet loaded. While at that, it also associates the device with
> + * the phy using devres. On driver detach, release function is invoked
> + * on the devres data, then, devres data is freed.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
> +	const char *phandle, u8 index)
> +{
> +	struct usb_phy	*phy = ERR_PTR(-ENOMEM), **ptr;
> +	unsigned long	flags;
> +	struct device_node *node;
> +
> +	if (!dev->of_node) {
> +		dev_dbg(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node = of_parse_phandle(dev->of_node, phandle, index);
> +	if (!node) {
> +		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr) {
> +		dev_dbg(dev, "failed to allocate memory for devres\n");
> +		goto err0;
> +	}
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +
> +	phy = __of_usb_find_phy(node);
> +	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> +		phy = ERR_PTR(-EPROBE_DEFER);
> +		devres_free(ptr);
> +		goto err1;
> +	}
> +
> +	*ptr = phy;
> +	devres_add(dev, ptr);
> +
> +	get_device(phy->dev);
> +
> +err1:
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +err0:
> +	of_node_put(node);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL(devm_usb_get_phy_by_phandle);
> +
> +/**
> + * usb_get_phy_dev - find the USB PHY
> + * @dev - device that requests this phy
> + * @index - the index of the phy
> + *
> + * Returns the phy driver, after getting a refcount to it; or
> + * -ENODEV if there is no such phy.  The caller is responsible for
> + * calling usb_put_phy() to release that count.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
> +{
> +	struct usb_phy	*phy = NULL;
> +	unsigned long	flags;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +
> +	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
> +	if (IS_ERR(phy)) {
> +		pr_err("unable to find transceiver\n");
> +		goto err0;
> +	}
> +
> +	get_device(phy->dev);
> +
> +err0:
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL(usb_get_phy_dev);
> +
> +/**
> + * devm_usb_get_phy_dev - find the USB PHY using device ptr and index
> + * @dev - device that requests this phy
> + * @index - the index of the phy
> + *
> + * Gets the phy using usb_get_phy_dev(), and associates a device with it using
> + * devres. On driver detach, release function is invoked on the devres data,
> + * then, devres data is freed.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
> +{
> +	struct usb_phy **ptr, *phy;
> +
> +	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	phy = usb_get_phy_dev(dev, index);
> +	if (!IS_ERR(phy)) {
> +		*ptr = phy;
> +		devres_add(dev, ptr);
> +	} else
> +		devres_free(ptr);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL(devm_usb_get_phy_dev);
> +
> +/**
> + * devm_usb_put_phy - release the USB PHY
> + * @dev - device that wants to release this phy
> + * @phy - the phy returned by devm_usb_get_phy()
> + *
> + * destroys the devres associated with this phy and invokes usb_put_phy
> + * to release the phy.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +void devm_usb_put_phy(struct device *dev, struct usb_phy *phy)
> +{
> +	int r;
> +
> +	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
> +	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
> +}
> +EXPORT_SYMBOL(devm_usb_put_phy);
> +
> +/**
> + * usb_put_phy - release the USB PHY
> + * @x: the phy returned by usb_get_phy()
> + *
> + * Releases a refcount the caller received from usb_get_phy().
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +void usb_put_phy(struct usb_phy *x)
> +{
> +	if (x)
> +		put_device(x->dev);
> +}
> +EXPORT_SYMBOL(usb_put_phy);
> +
> +/**
> + * usb_add_phy - declare the USB PHY
> + * @x: the USB phy to be used; or NULL
> + * @type - the type of this PHY
> + *
> + * This call is exclusively for use by phy drivers, which
> + * coordinate the activities of drivers for host and peripheral
> + * controllers, and in some cases for VBUS current regulation.
> + */
> +int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
> +{
> +	int		ret = 0;
> +	unsigned long	flags;
> +	struct usb_phy	*phy;
> +
> +	if (x->type != USB_PHY_TYPE_UNDEFINED) {
> +		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +
> +	list_for_each_entry(phy, &phy_list, head) {
> +		if (phy->type == type) {
> +			ret = -EBUSY;
> +			dev_err(x->dev, "transceiver type %s already exists\n",
> +						usb_phy_type_string(type));
> +			goto out;
> +		}
> +	}
> +
> +	x->type = type;
> +	list_add_tail(&x->head, &phy_list);
> +
> +out:
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(usb_add_phy);
> +
> +/**
> + * usb_add_phy_dev - declare the USB PHY
> + * @x: the USB phy to be used; or NULL
> + *
> + * This call is exclusively for use by phy drivers, which
> + * coordinate the activities of drivers for host and peripheral
> + * controllers, and in some cases for VBUS current regulation.
> + */
> +int usb_add_phy_dev(struct usb_phy *x)
> +{
> +	struct usb_phy_bind *phy_bind;
> +	unsigned long flags;
> +
> +	if (!x->dev) {
> +		dev_err(x->dev, "no device provided for PHY\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +	list_for_each_entry(phy_bind, &phy_bind_list, list)
> +		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
> +			phy_bind->phy = x;
> +
> +	list_add_tail(&x->head, &phy_list);
> +
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL(usb_add_phy_dev);
> +
> +/**
> + * usb_remove_phy - remove the OTG PHY
> + * @x: the USB OTG PHY to be removed;
> + *
> + * This reverts the effects of usb_add_phy
> + */
> +void usb_remove_phy(struct usb_phy *x)
> +{
> +	unsigned long	flags;
> +	struct usb_phy_bind *phy_bind;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +	if (x) {
> +		list_for_each_entry(phy_bind, &phy_bind_list, list)
> +			if (phy_bind->phy == x)
> +				phy_bind->phy = NULL;
> +		list_del(&x->head);
> +	}
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +}
> +EXPORT_SYMBOL(usb_remove_phy);
> +
> +/**
> + * usb_bind_phy - bind the phy and the controller that uses the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @index: index to specify the port number
> + * @phy_dev_name: the device name of the phy
> + *
> + * Fills the phy_bind structure with the dev_name and phy_dev_name. This will
> + * be used when the phy driver registers the phy and when the controller
> + * requests this phy.
> + *
> + * To be used by platform specific initialization code.
> + */
> +int __init usb_bind_phy(const char *dev_name, u8 index,
> +				const char *phy_dev_name)
> +{
> +	struct usb_phy_bind *phy_bind;
> +	unsigned long flags;
> +
> +	phy_bind = kzalloc(sizeof(*phy_bind), GFP_KERNEL);
> +	if (!phy_bind) {
> +		pr_err("phy_bind(): No memory for phy_bind");
> +		return -ENOMEM;
> +	}
> +
> +	phy_bind->dev_name = dev_name;
> +	phy_bind->phy_dev_name = phy_dev_name;
> +	phy_bind->index = index;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +	list_add_tail(&phy_bind->list, &phy_bind_list);
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_bind_phy);
> +
> +
Unnecessary spaces here.

You might want to do this patch after applying *[PATCH] usb: otg: use 
try_module_get in all usb_get_phy functions and add missing module_put* 
by Marc.

This patch should go to mainline ASAP since it allows drivers other than 
otg controllers to make use of PHY library.

Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>

Thanks
Kishon


