Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaDQP06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:26:58 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34471 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDQP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <1397729403-32045-2-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
	<1397729403-32045-2-git-send-email-sangjung.woo@samsung.com>
Date: Fri, 18 Apr 2014 00:26:50 +0900
Message-ID: <CAGTfZH1YtzQ0jZS3N-JgX8GYzSx753v_yO0dYM_E+B1bnJvqEQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/8] extcon: Add resource-managed extcon register function
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangjung,

This patch(v2) is same as previous patch(v1).
I think you sent previous patch(v1) instead of v2.

Thanks
Chanwoo Choi

On Thu, Apr 17, 2014 at 7:09 PM, Sangjung Woo <sangjung.woo@samsung.com> wrote:
> Add resource-managed extcon device register function for convenience.
> For example, if a extcon device is attached with new
> devm_extcon_dev_register(), that extcon device is automatically
> unregistered on driver detach.
>
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-class.c |   83 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/extcon.h        |    8 ++++
>  2 files changed, 91 insertions(+)
>
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 7ab21aa..accb49c 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -32,6 +32,7 @@
>  #include <linux/slab.h>
>  #include <linux/sysfs.h>
>  #include <linux/of.h>
> +#include <linux/gfp.h>
>
>  /*
>   * extcon_cable_name suggests the standard cable names for commonly used
> @@ -819,6 +820,88 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>
> +
> +/*
> + * Device resource management
> + */
> +
> +struct extcon_devres {
> +       struct extcon_dev *edev;
> +};
> +
> +static void devm_extcon_release(struct device *dev, void *res)
> +{
> +       struct extcon_devres *dr = (struct extcon_devres *)res;
> +
> +       extcon_dev_unregister(dr->edev);
> +}
> +
> +static int devm_extcon_match(struct device *dev, void *res, void *data)
> +{
> +       struct extcon_devres *dr = (struct extcon_devres *)res;
> +       struct extcon_devres *match = (struct extcon_devres *)data;
> +
> +       return dr->edev == match->edev;
> +}
> +
> +/**
> + * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
> + * @dev:       device to allocate extcon device
> + * @edev:      the new extcon device to register
> + *
> + * Managed extcon_dev_register() function. If extcon device is attached with
> + * this function, that extcon device is automatically unregistered on driver
> + * detach. Internally this function calls extcon_dev_register() function.
> + * To get more information, refer that function.
> + *
> + * If extcon device is registered with this function and the device needs to be
> + * unregistered separately, devm_extcon_dev_unregister() should be used.
> + *
> + * RETURNS:
> + * 0 on success, negative error number on failure.
> + */
> +int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
> +{
> +       struct extcon_devres *dr;
> +       int rc;
> +
> +       dr = devres_alloc(devm_extcon_release, sizeof(struct extcon_devres),
> +                       GFP_KERNEL);
> +       if (!dr)
> +               return -ENOMEM;
> +
> +       rc = extcon_dev_register(edev);
> +       if (rc) {
> +               devres_free(dr);
> +               return rc;
> +       }
> +
> +       dr->edev = edev;
> +       devres_add(dev, dr);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_register);
> +
> +/**
> + * devm_extcon_dev_unregister() - Resource-managed extcon_dev_unregister()
> + * @dev:       device the extcon belongs to
> + * @edev:      the extcon device to unregister
> + *
> + * Unregister extcon device that is registered with devm_extcon_dev_register()
> + * function.
> + */
> +void devm_extcon_dev_unregister(struct device *dev, struct extcon_dev *edev)
> +{
> +       struct extcon_devres match_dr = { edev };
> +
> +       WARN_ON(devres_destroy(dev, devm_extcon_release,
> +                       devm_extcon_match, &match_dr));
> +
> +       extcon_dev_unregister(edev);
> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
> +
>  #ifdef CONFIG_OF
>  /*
>   * extcon_get_edev_by_phandle - Get the extcon device from devicetree
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index f488145..e1e85a1 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
>  extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
>
>  /*
> + * Resource-managed extcon device register function.
> + */
> +extern int devm_extcon_dev_register(struct device *dev,
> +                               struct extcon_dev *edev);
> +extern void devm_extcon_dev_unregister(struct device *dev,
> +                               struct extcon_dev *edev);
> +
> +/*
>   * get/set/update_state access the 32b encoded state value, which represents
>   * states of all possible cables of the multistate port. For example, if one
>   * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
