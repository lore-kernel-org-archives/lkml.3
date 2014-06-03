Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbaFCTqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:46:04 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43687 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbaFCTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 3 Jun 2014 12:46:00 -0700
X-Google-Sender-Auth: jEbzTYtwUmhSGjoDs8NIuZkHh5E
Message-ID: <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: Add support for Acer C720
From: Benson Leung <bleung@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Olof Johansson <olof@lixom.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika!

Thanks for putting this patch together. It looks like this does the
job of distinguishing the two busses apart. Thanks!


On Tue, Jun 3, 2014 at 6:02 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Acer C720 has touchpad and light sensor connected to a separate I2C buses.
> Since the designware I2C host controller driver has two instances on this
> particular machine we need a way to match the correct instance. Add support
> for this and then register both C720 touchpad and light sensor.
>
> This code is based on following patch from Benson Leung:
>
> https://patchwork.kernel.org/patch/3074411/
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Benson Leung <bleung@chromium.org>

Since it was based on my original:
Signed-off-by: Benson Leung <bleung@chromium.org>

> ---
>  drivers/platform/chrome/chromeos_laptop.c | 45 ++++++++++++++++++++++++++-----
>  1 file changed, 39 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
> index 7f3aad0e115c..44806c5dc26f 100644
> --- a/drivers/platform/chrome/chromeos_laptop.c
> +++ b/drivers/platform/chrome/chromeos_laptop.c
> @@ -45,6 +45,8 @@ static const char *i2c_adapter_names[] = {
>         "SMBus I801 adapter",
>         "i915 gmbus vga",
>         "i915 gmbus panel",
> +       "i2c-designware-pci",
> +       "i2c-designware-pci",
>  };
>
>  /* Keep this enum consistent with i2c_adapter_names */
> @@ -52,6 +54,8 @@ enum i2c_adapter_type {
>         I2C_ADAPTER_SMBUS = 0,
>         I2C_ADAPTER_VGADDC,
>         I2C_ADAPTER_PANEL,
> +       I2C_ADAPTER_DESIGNWARE_0,
> +       I2C_ADAPTER_DESIGNWARE_1,
>  };
>
>  struct i2c_peripheral {
> @@ -183,29 +187,42 @@ static struct i2c_client *__add_probed_i2c_device(
>         return client;
>  }
>
> +struct i2c_lookup {
> +       const char *name;
> +       int instance;
> +       int n;
> +};
> +
>  static int __find_i2c_adap(struct device *dev, void *data)
>  {
> -       const char *name = data;
> +       struct i2c_lookup *lookup = data;
>         static const char *prefix = "i2c-";
>         struct i2c_adapter *adapter;
>         if (strncmp(dev_name(dev), prefix, strlen(prefix)) != 0)
>                 return 0;
>         adapter = to_i2c_adapter(dev);
> -       return (strncmp(adapter->name, name, strlen(name)) == 0);
> +       if (strncmp(adapter->name, lookup->name, strlen(lookup->name)) == 0 &&
> +           lookup->n++ == lookup->instance)
> +               return 1;
> +       return 0;

minor nit. This could retain the original form with a single return.

return  (strncmp(adapter->name, name, strlen(name)) == 0) &&
            lookup->n++ == lookup->instance);

>  }
>
>  static int find_i2c_adapter_num(enum i2c_adapter_type type)
>  {
>         struct device *dev = NULL;
>         struct i2c_adapter *adapter;
> -       const char *name = i2c_adapter_names[type];
> +       struct i2c_lookup lookup;
> +
> +       memset(&lookup, 0, sizeof(lookup));
> +       lookup.name = i2c_adapter_names[type];
> +       lookup.instance = (type == I2C_ADAPTER_DESIGNWARE_1) ? 1 : 0;
> +
>         /* find the adapter by name */
> -       dev = bus_find_device(&i2c_bus_type, NULL, (void *)name,
> -                             __find_i2c_adap);
> +       dev = bus_find_device(&i2c_bus_type, NULL, &lookup, __find_i2c_adap);
>         if (!dev) {
>                 /* Adapters may appear later. Deferred probing will retry */
>                 pr_notice("%s: i2c adapter %s not found on system.\n", __func__,
> -                         name);
> +                         lookup.name);
>                 return -ENODEV;
>         }
>         adapter = to_i2c_adapter(dev);
> @@ -388,6 +405,15 @@ static struct chromeos_laptop acer_ac700 = {
>         },
>  };
>
> +static struct chromeos_laptop acer_c720 = {
> +       .i2c_peripherals = {
> +               /* Touchpad. */
> +               { .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
> +               /* Light Sensor. */
> +               { .add = setup_isl29018_als, I2C_ADAPTER_DESIGNWARE_1 },
> +       },
> +};
> +
>  static struct chromeos_laptop hp_pavilion_14_chromebook = {
>         .i2c_peripherals = {
>                 /* Touchpad. */
> @@ -445,6 +471,13 @@ static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
>                 _CBDD(acer_ac700),
>         },
>         {
> +               .ident = "Acer C720",
> +               .matches = {
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "Peppy"),
> +               },
> +               _CBDD(acer_c720),
> +       },
> +       {
>                 .ident = "HP Pavilion 14 Chromebook",
>                 .matches = {
>                         DMI_MATCH(DMI_PRODUCT_NAME, "Butterfly"),
> --
> 2.0.0.rc4
>

By the way, I can create patches on top of this to support the other
systems that we missed as well, the HP 14, the Dell 11, the Toshiba,
etc.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
