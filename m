Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaDSHNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 03:13:23 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46408 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDSHNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 03:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <1397781160-744-2-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
	<1397781160-744-2-git-send-email-sangjung.woo@samsung.com>
Date: Sat, 19 Apr 2014 16:13:20 +0900
Message-ID: <CAGTfZH3L-FZ4+cNHYMpuRqWSbcvEZoOYQdJzxOK8yLofFc5dVw@mail.gmail.com>
Subject: Re: [PATCHv3 1/8] extcon: Add resource-managed extcon register function
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

On Fri, Apr 18, 2014 at 9:32 AM, Sangjung Woo <sangjung.woo@samsung.com> wrote:
> Add resource-managed extcon device register function for convenience.
> For example, if a extcon device is attached with new
> devm_extcon_dev_register(), that extcon device is automatically
> unregistered on driver detach.
>
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-class.c |   72 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/extcon.h        |   17 ++++++++++
>  2 files changed, 89 insertions(+)
>
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 7ab21aa..e177edb6 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -819,6 +819,78 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>
> +
> +/*
> + * Device resource management
> + */

This comment is un-necessary because this patchset(v3) remove 'struct
extcon_devres'.

> +static void devm_extcon_dev_release(struct device *dev, void *res)
> +{
> +       struct extcon_dev *devres = res;
> +
> +       extcon_dev_unregister(devres);

I prefer following function call withou defining separate 'devres' variable.
But, this casting on the first argument is only for readability.
  extcon_dev_unregister((strcut extcon_dev *)res);

> +}
> +
> +static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
> +{
> +       struct extcon_dev *devres = res;
> +       struct extcon_dev *match = data;
> +       return devres == match;

To simplify code, I think you could change checking code as following:
            return res == data;

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
> +       struct extcon_dev *devres;

The 'devres' in this function don't mean 'device resource structure'.
So I think it is not proper name.
I think you should use other general name (e.g.,  'ptr' or 'res'
instead of 'devres')

> +       int ret;
> +
> +       devres = devres_alloc(devm_extcon_dev_release, sizeof(*devres)

Other subsytem used double pointer to get device resource from
devres_alloc() instead of
single pointer.(devres is single pointer)  I can't find subsystem
using single pointer of devm function.
First of all, We have to analyze the correct reason using only double
pointer instead of single pointer whether single pointer use is good
or not.

> +                       GFP_KERNEL);
> +       if (!devres)
> +               return -ENOMEM;
> +
> +       ret = extcon_dev_register(edev);
> +       if (ret) {
> +               devres_free(devres);
> +               return ret;
> +       }
> +
> +       devres = edev;
> +       devres_add(dev, devres);
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
> +       WARN_ON(devres_release(dev, devm_extcon_dev_release,
> +                       devm_extcon_dev_match, edev));
> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
> +
>  #ifdef CONFIG_OF
>  /*
>   * extcon_get_edev_by_phandle - Get the extcon device from devicetree
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index f488145..35f3343 100644
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

I prefer that this function meet indentation of function definition
needs as following:

extern int devm_extcon_dev_register(struct device *dev,

struct extcon_dev *edev);
extern void devm_extcon_dev_unregister(struct device *dev,

  struct extcon_dev *edev);

> +
> +/*
>   * get/set/update_state access the 32b encoded state value, which represents
>   * states of all possible cables of the multistate port. For example, if one
>   * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
> @@ -254,6 +262,15 @@ static inline int extcon_dev_register(struct extcon_dev *edev)
>
>  static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
>
> +static inline devm_extcon_dev_register(struct device *dev,
> +               struct extcon_dev *edev)

Missing the type of return value.
-> static inline int devm_extcon_dev_register(...

Also, ditto about function definition identification.

> +{
> +       return 0;
> +}
> +
> +static inline devm_extcon_dev_unregister(struct device *dev,

ditto.
-> static inline void devm_extcon_dev_unregister(...

Thanks,
Chanwoo Choi
