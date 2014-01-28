Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaA1Dg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:36:29 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41295 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaA1Dg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:36:27 -0500
MIME-Version: 1.0
In-Reply-To: <1389694438-18614-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1389694438-18614-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 27 Jan 2014 22:36:25 -0500
Message-ID: <CAN+gG=Fa+H53V1evKXiWK6OpWj29pF4z8rGJAXWs3C7mHm1mLQ@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: add runtime PM support
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-input <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 5:13 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> This patch adds runtime PM support for the HID over I2C driver. When the
> i2c-hid device is first opened we power it on and on the last close we
> power it off.
>
> The implementation is not the most power efficient because it needs some
> interaction from the userspace (e.g close the device node whenever we are
> no more interested in getting events), nevertheless it allows us to save
> some power and works with devices that are not wake capable.
>

Hi Mika,

I am a little bit puzzled here. The commit message just says that you
changed the implementation of the power saving with the exact same
behavior...  At least that's what I understand.
Currently, the devices should be put on sleep if nobody is reading,
and back alive if a reader arrives.
I think there is a gain with the patch, but my knowledge of the pm
subsystem is far too limited to see it :(

> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 81 ++++++++++++++++++++++++++++---------------
>  1 file changed, 54 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index d1f81f52481a..ff767d03d60e 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -25,6 +25,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/pm.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/device.h>
>  #include <linux/wait.h>
>  #include <linux/err.h>
> @@ -454,10 +455,18 @@ static void i2c_hid_init_reports(struct hid_device *hid)
>                 return;
>         }
>
> +       /*
> +        * The device must be powered on while we fetch initial reports
> +        * from it.
> +        */
> +       pm_runtime_get_sync(&client->dev);
> +
>         list_for_each_entry(report,
>                 &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
>                 i2c_hid_init_report(report, inbuf, ihid->bufsize);
>
> +       pm_runtime_put(&client->dev);
> +
>         kfree(inbuf);
>  }
>
> @@ -703,8 +712,8 @@ static int i2c_hid_open(struct hid_device *hid)
>
>         mutex_lock(&i2c_hid_open_mut);
>         if (!hid->open++) {
> -               ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
> -               if (ret) {
> +               ret = pm_runtime_get_sync(&client->dev);

dummy question (kind of late here...). Is there a counter of how many
get/put has been called in pm_runtime which could allow us to get rid
of the hid->open count?

> +               if (ret < 0) {
>                         hid->open--;
>                         goto done;
>                 }
> @@ -712,7 +721,7 @@ static int i2c_hid_open(struct hid_device *hid)
>         }
>  done:
>         mutex_unlock(&i2c_hid_open_mut);
> -       return ret;
> +       return ret < 0 ? ret : 0;
>  }
>
>  static void i2c_hid_close(struct hid_device *hid)
> @@ -729,37 +738,17 @@ static void i2c_hid_close(struct hid_device *hid)
>                 clear_bit(I2C_HID_STARTED, &ihid->flags);
>
>                 /* Save some power */
> -               i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
> +               pm_runtime_put(&client->dev);
>         }
>         mutex_unlock(&i2c_hid_open_mut);
>  }
>
> -static int i2c_hid_power(struct hid_device *hid, int lvl)
> -{
> -       struct i2c_client *client = hid->driver_data;
> -       struct i2c_hid *ihid = i2c_get_clientdata(client);
> -       int ret = 0;
> -
> -       i2c_hid_dbg(ihid, "%s lvl:%d\n", __func__, lvl);
> -
> -       switch (lvl) {
> -       case PM_HINT_FULLON:
> -               ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
> -               break;
> -       case PM_HINT_NORMAL:
> -               ret = i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
> -               break;
> -       }
> -       return ret;
> -}
> -
>  static struct hid_ll_driver i2c_hid_ll_driver = {
>         .parse = i2c_hid_parse,
>         .start = i2c_hid_start,
>         .stop = i2c_hid_stop,
>         .open = i2c_hid_open,
>         .close = i2c_hid_close,
> -       .power = i2c_hid_power,

If I understand correctly, here you are trying to fix hidraw (with
i2c_hid tramsport) which used to set_power on/off twice with the first
reader, right?
I don't think we have other i2c_hid users of hid_hw_power, but I am a
little bit worried of simply removing the callback.

What if we just change i2c_hid_set_power in i2c_hid_power by the
corresponding pm_runtime calls?

>         .request = i2c_hid_request,
>  };
>
> @@ -973,13 +962,17 @@ static int i2c_hid_probe(struct i2c_client *client,
>         if (ret < 0)
>                 goto err;
>
> +       pm_runtime_get_noresume(&client->dev);
> +       pm_runtime_set_active(&client->dev);
> +       pm_runtime_enable(&client->dev);
> +
>         ret = i2c_hid_fetch_hid_descriptor(ihid);
>         if (ret < 0)
> -               goto err;
> +               goto err_pm;
>
>         ret = i2c_hid_init_irq(client);
>         if (ret < 0)
> -               goto err;
> +               goto err_pm;
>
>         hid = hid_allocate_device();
>         if (IS_ERR(hid)) {
> @@ -1010,6 +1003,7 @@ static int i2c_hid_probe(struct i2c_client *client,
>                 goto err_mem_free;
>         }
>
> +       pm_runtime_put(&client->dev);
>         return 0;
>
>  err_mem_free:
> @@ -1018,6 +1012,10 @@ err_mem_free:
>  err_irq:
>         free_irq(client->irq, ihid);
>
> +err_pm:
> +       pm_runtime_put_noidle(&client->dev);
> +       pm_runtime_disable(&client->dev);
> +
>  err:
>         i2c_hid_free_buffers(ihid);
>         kfree(ihid);
> @@ -1029,6 +1027,11 @@ static int i2c_hid_remove(struct i2c_client *client)
>         struct i2c_hid *ihid = i2c_get_clientdata(client);
>         struct hid_device *hid;
>
> +       pm_runtime_get_sync(&client->dev);
> +       pm_runtime_disable(&client->dev);
> +       pm_runtime_set_suspended(&client->dev);
> +       pm_runtime_put_noidle(&client->dev);
> +
>         hid = ihid->hid;
>         hid_destroy_device(hid);
>
> @@ -1074,7 +1077,31 @@ static int i2c_hid_resume(struct device *dev)
>  }
>  #endif
>
> -static SIMPLE_DEV_PM_OPS(i2c_hid_pm, i2c_hid_suspend, i2c_hid_resume);
> +#ifdef CONFIG_PM_RUNTIME
> +static int i2c_hid_runtime_suspend(struct device *dev)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +
> +       i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
> +       disable_irq(client->irq);
> +       return 0;
> +}
> +
> +static int i2c_hid_runtime_resume(struct device *dev)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +
> +       enable_irq(client->irq);
> +       i2c_hid_set_power(client, I2C_HID_PWR_ON);
> +       return 0;
> +}

These two functions looks very similar to i2c_hid_suspend and
i2c_hid_resume, without the reset and the irq_wake :(
So, my question here is can we use some common code for them?
It may not be possible regarding CONFIG_PM_RUNTIME and
CONFIG_PM_SLEEP, but it still looks ugly to me.
I tested this today, and it works, so you should be right, but I'd
like to have your opinion on this.

Cheers,
Benjamin

> +#endif
> +
> +static const struct dev_pm_ops i2c_hid_pm = {
> +       SET_SYSTEM_SLEEP_PM_OPS(i2c_hid_suspend, i2c_hid_resume)
> +       SET_RUNTIME_PM_OPS(i2c_hid_runtime_suspend, i2c_hid_runtime_resume,
> +                          NULL)
> +};
>
>  static const struct i2c_device_id i2c_hid_id_table[] = {
>         { "hid", 0 },
> --
> 1.8.5.2
