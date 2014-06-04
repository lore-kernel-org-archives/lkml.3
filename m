Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaFDR3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:29:33 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56500 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaFDR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <1401883796-17841-4-git-send-email-lee.jones@linaro.org>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
	<1401883796-17841-4-git-send-email-lee.jones@linaro.org>
Date: Wed, 4 Jun 2014 12:29:29 -0500
Message-ID: <CAL_JsqJOEipHyjD2NCjQd1BvLumnM3PkVDqUjrMNfXCOmXcNAA@mail.gmail.com>
Subject: Re: [PATCH 3/7] i2c: Add the ability to match device to compatible
 string without an of_node
From: Rob Herring <robherring2@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 7:09 AM, Lee Jones <lee.jones@linaro.org> wrote:
> A great deal of I2C devices are currently matched via DT node name, and
> as such the compatible naming convention of '<vendor>,<device>' has gone
> somewhat awry - some nodes don't supply one, some supply an arbitrary
> string and others the correct device name with an arbitrary vendor prefix.
>
> In an effort to correct this problem we have to supply a mechanism to
> match a device by compatible string AND by simple device name.  This
> function strips off the '<vendor>,' part of a supplied compatible string
> and attempts to match without it.
>
> The plan is to remove this function once all of the compatible strings
> for each device have been brought into line.

Then should you add a warning for cases needing to be fixed?

Rob

>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/i2c/i2c-core.c | 25 +++++++++++++++++++++++++
>  include/linux/i2c.h    | 10 ++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index d3802dc..7dcd5c3 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1090,6 +1090,31 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
>         return i2c_verify_adapter(dev);
>  }
>  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> +
> +const struct of_device_id
> +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> +                                 struct device *dev)
> +{
> +       const struct i2c_client *client = i2c_verify_client(dev);
> +       const char *name;
> +
> +       if (!(client && matches))
> +               return NULL;
> +
> +       for (; matches->compatible[0]; matches++) {
> +               name = strchr(matches->compatible, ',');
> +               if (!name)
> +                       name = matches->compatible;
> +               else
> +                       name++;
> +
> +               if (!strncmp(client->name, name, strlen(client->name)))
> +                       return matches;
> +       }
> +
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(i2c_of_match_device_strip_vendor);
>  #else
>  static void of_i2c_register_devices(struct i2c_adapter *adap) { }
>  #endif /* CONFIG_OF */
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index b556e0a..f7ec75b 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -564,6 +564,9 @@ extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
>  /* must call put_device() when done with returned i2c_adapter device */
>  extern struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
>
> +extern const struct of_device_id
> +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> +                                 struct device *dev);
>  #else
>
>  static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
> @@ -575,6 +578,13 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
>  {
>         return NULL;
>  }
> +
> +const struct of_device_id
> +*i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> +                                 struct device *dev)
> +{
> +       return NULL;
> +}
>  #endif /* CONFIG_OF */
>
>  #endif /* _LINUX_I2C_H */
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
