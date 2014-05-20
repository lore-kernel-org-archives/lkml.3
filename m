Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaETDnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:43:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54190 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaETDnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:43:06 -0400
Date: Mon, 19 May 2014 20:43:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] input: cyapa: enable/disable trackpad device based
 on LID state
Message-ID: <20140520034302.GB986@core.coreip.homeip.net>
References: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Wed, Apr 16, 2014 at 08:39:34AM +0000, Dudley Du wrote:
> Rely on EV_SW and SW_LID bits to identify a LID device, and hook
> up our filter to listen for SW_LID events to enable/disable touchpad when
> LID is open/closed.
> TEST=test on Chomebooks.

This is a policy and it does not belong in the kernel. Please work with
Rafael to establish generic interface to put devices into low power mode
(like accelerating runtime PM idle timeout) and use it when userspace
detects that lid is closed.

Thanks.

> 
> Signed-off-by: Du, Dudley <dudl@cypress.com>
> ---
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index 6820b3f..da03427 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -523,6 +523,9 @@ struct cyapa {
>         int physical_size_x;
>         int physical_size_y;
> 
> +       bool lid_handler_registered;
> +       struct input_handler lid_handler;
> +
>         /* used in ttsp and truetouch based trackpad devices. */
>         u8 x_origin;  /* X Axis Origin: 0 = left side; 1 = rigth side. */
>         u8 y_origin;  /* Y Axis Origin: 0 = top; 1 = bottom. */
> @@ -3107,6 +3110,125 @@ static void cyapa_start_runtime(struct cyapa *cyapa)
>  static void cyapa_start_runtime(struct cyapa *cyapa) {}
>  #endif /* CONFIG_PM_RUNTIME */
> 
> +
> +/*
> + * We rely on EV_SW and SW_LID bits to identify a LID device, and hook
> + * up our filter to listen for SW_LID events to enable/disable touchpad when
> + * LID is open/closed.
> + */
> +static const struct input_device_id lid_device_ids[] = {
> +       {
> +               .flags = INPUT_DEVICE_ID_MATCH_EVBIT |
> +                        INPUT_DEVICE_ID_MATCH_SWBIT,
> +               .evbit = { BIT_MASK(EV_SW) },
> +               .swbit = { BIT_MASK(SW_LID) },
> +       },
> +       { },
> +};
> +
> +static int lid_device_connect(struct input_handler *handler,
> +                             struct input_dev *dev,
> +                             const struct input_device_id *id)
> +{
> +       struct input_handle *lid_handle;
> +       int error;
> +
> +       lid_handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
> +       if (!lid_handle)
> +               return -ENOMEM;
> +
> +       lid_handle->dev = dev;
> +       lid_handle->handler = handler;
> +       lid_handle->name = "lid_event_handler";
> +       lid_handle->private = handler->private;
> +
> +       error = input_register_handle(lid_handle);
> +       if (error)
> +               goto err_free;
> +
> +       error = input_open_device(lid_handle);
> +       if (error)
> +               goto err_unregister;
> +
> +       return 0;
> +err_unregister:
> +       input_unregister_handle(lid_handle);
> +err_free:
> +       kfree(lid_handle);
> +       return error;
> +}
> +
> +static void lid_device_disconnect(struct input_handle *handle)
> +{
> +       input_close_device(handle);
> +       input_unregister_handle(handle);
> +       kfree(handle);
> +}
> +
> +static bool lid_event_filter(struct input_handle *handle,
> +                            unsigned int type, unsigned int code, int value)
> +{
> +       struct cyapa *cyapa = handle->private;
> +       struct device *dev = &cyapa->client->dev;
> +
> +       if (type == EV_SW && code == SW_LID) {
> +               if (cyapa->suspended) {
> +                       /*
> +                        * If the lid event filter is called while suspended,
> +                        * there is no guarantee that the underlying i2cs are
> +                        * resumed at this point, so it is not safe to issue
> +                        * the command to change power modes.
> +                        * Instead, rely on cyapa_resume to set us back to
> +                        * PWR_MODE_FULL_ACTIVE.
> +                        */
> +                       return false;
> +               }
> +               if (value == 0) {
> +                       if (cyapa->cyapa_set_power_mode)
> +                               cyapa->cyapa_set_power_mode(cyapa,
> +                                               PWR_MODE_FULL_ACTIVE, 0);
> +                       pm_runtime_set_active(dev);
> +                       pm_runtime_enable(dev);
> +               } else {
> +                       pm_runtime_disable(dev);
> +                       if (cyapa->cyapa_set_power_mode)
> +                               cyapa->cyapa_set_power_mode(cyapa,
> +                                               PWR_MODE_OFF, 0);
> +               }
> +       }
> +
> +       return false;
> +}
> +
> +static void lid_event_register_handler(struct cyapa *cyapa)
> +{
> +       int error;
> +       struct input_handler *lid_handler = &cyapa->lid_handler;
> +
> +       if (cyapa->lid_handler_registered)
> +               return;
> +
> +       lid_handler->filter     = lid_event_filter;
> +       lid_handler->connect    = lid_device_connect;
> +       lid_handler->disconnect = lid_device_disconnect;
> +       lid_handler->name       = "cyapa_lid_event_handler";
> +       lid_handler->id_table   = lid_device_ids;
> +       lid_handler->private    = cyapa;
> +
> +       error = input_register_handler(lid_handler);
> +       if (error)
> +               return;
> +       cyapa->lid_handler_registered = true;
> +}
> +
> +static void lid_event_unregister_handler(struct cyapa *cyapa)
> +{
> +       if (cyapa->lid_handler_registered) {
> +               input_unregister_handler(&cyapa->lid_handler);
> +               cyapa->lid_handler_registered = false;
> +       }
> +}
> +
>  static void cyapa_detect_async(void *data, async_cookie_t cookie)
>  {
>         struct cyapa *cyapa = (struct cyapa *)data;
> @@ -3126,6 +3248,7 @@ static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
>         cyapa_detect_async(data, cookie);
> 
>         cyapa_start_runtime(cyapa);
> +       lid_event_register_handler(cyapa);
>  }
> 
>  static int cyapa_probe(struct i2c_client *client,
> @@ -3221,7 +3344,7 @@ static int cyapa_remove(struct i2c_client *client)
> 
>         free_irq(cyapa->irq, cyapa);
>         input_unregister_device(cyapa->input);
> -
> +       lid_event_unregister_handler(cyapa);
>         if (cyapa->cyapa_set_power_mode)
>                 cyapa->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
>         i2c_set_clientdata(client, NULL);
> This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

-- 
Dmitry
