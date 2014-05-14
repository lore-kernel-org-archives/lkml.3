Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaENBtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 21:49:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63860 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaENBtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 21:49:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+BWVUS0QYG54W3ws5s3g6iM=SXQHxBxJcKnjCxcEfZRAqp_Dg@mail.gmail.com>
References: <CA+BWVUS0QYG54W3ws5s3g6iM=SXQHxBxJcKnjCxcEfZRAqp_Dg@mail.gmail.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 13 May 2014 20:49:17 -0500
Message-ID: <CA+BWVUSm2FQ+U9sHu-Gj5FFpo1kQfjKmxw8PpripExaDXGwUjg@mail.gmail.com>
Subject: Re: [PATCH] HID: hid-sensor-hub: Fix lockdep warning for dynamic
 callback locks.
To: linux-kernel@vger.kernel.org, linux-input <linux-input@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a sample of the kernel lockdep warning I got after turingon
dynamic debugging:
https://bugzilla.kernel.org/show_bug.cgi?id=73321#c3



On Tue, May 13, 2014 at 8:03 PM, Reyad Attiyat <reyad.attiyat@gmail.com> wrote:
> Changes all dyn_callback_lock spinlocks to spinlocks that disable
> interrupts. The dynamic callback lock (dyn_callback_lock) must not be
> interrupted when locked as it is used in an interrupt handler
> function, sensor_hub_raw_event.
> ---
>  drivers/hid/hid-sensor-hub.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index af8244b..1e1644c 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -133,10 +133,11 @@ static struct hid_sensor_hub_callbacks
> *sensor_hub_get_callback(
>   struct hid_sensor_hub_device **hsdev,
>   void **priv)
>  {
> + unsigned long flags;
>   struct hid_sensor_hub_callbacks_list *callback;
>   struct sensor_hub_data *pdata = hid_get_drvdata(hdev);
>
> - spin_lock(&pdata->dyn_callback_lock);
> + spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
>   list_for_each_entry(callback, &pdata->dyn_callback_list, list)
>   if (callback->usage_id == usage_id &&
>   (collection_index >=
> @@ -145,10 +146,10 @@ static struct hid_sensor_hub_callbacks
> *sensor_hub_get_callback(
>   callback->hsdev->end_collection_index)) {
>   *priv = callback->priv;
>   *hsdev = callback->hsdev;
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>   return callback->usage_callback;
>   }
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>
>   return NULL;
>  }
> @@ -157,19 +158,20 @@ int sensor_hub_register_callback(struct
> hid_sensor_hub_device *hsdev,
>   u32 usage_id,
>   struct hid_sensor_hub_callbacks *usage_callback)
>  {
> + unsigned long flags;
>   struct hid_sensor_hub_callbacks_list *callback;
>   struct sensor_hub_data *pdata = hid_get_drvdata(hsdev->hdev);
>
> - spin_lock(&pdata->dyn_callback_lock);
> + spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
>   list_for_each_entry(callback, &pdata->dyn_callback_list, list)
>   if (callback->usage_id == usage_id &&
>   callback->hsdev == hsdev) {
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>   return -EINVAL;
>   }
>   callback = kzalloc(sizeof(*callback), GFP_ATOMIC);
>   if (!callback) {
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>   return -ENOMEM;
>   }
>   callback->hsdev = hsdev;
> @@ -177,7 +179,7 @@ int sensor_hub_register_callback(struct
> hid_sensor_hub_device *hsdev,
>   callback->usage_id = usage_id;
>   callback->priv = NULL;
>   list_add_tail(&callback->list, &pdata->dyn_callback_list);
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>
>   return 0;
>  }
> @@ -186,10 +188,11 @@ EXPORT_SYMBOL_GPL(sensor_hub_register_callback);
>  int sensor_hub_remove_callback(struct hid_sensor_hub_device *hsdev,
>   u32 usage_id)
>  {
> + unsigned long flags;
>   struct hid_sensor_hub_callbacks_list *callback;
>   struct sensor_hub_data *pdata = hid_get_drvdata(hsdev->hdev);
>
> - spin_lock(&pdata->dyn_callback_lock);
> + spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
>   list_for_each_entry(callback, &pdata->dyn_callback_list, list)
>   if (callback->usage_id == usage_id &&
>   callback->hsdev == hsdev) {
> @@ -197,7 +200,7 @@ int sensor_hub_remove_callback(struct
> hid_sensor_hub_device *hsdev,
>   kfree(callback);
>   break;
>   }
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>
>   return 0;
>  }
> @@ -376,34 +379,36 @@ EXPORT_SYMBOL_GPL(sensor_hub_input_get_attribute_info);
>  #ifdef CONFIG_PM
>  static int sensor_hub_suspend(struct hid_device *hdev, pm_message_t message)
>  {
> + unsigned long flags;
>   struct sensor_hub_data *pdata = hid_get_drvdata(hdev);
>   struct hid_sensor_hub_callbacks_list *callback;
>
>   hid_dbg(hdev, " sensor_hub_suspend\n");
> - spin_lock(&pdata->dyn_callback_lock);
> + spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
>   list_for_each_entry(callback, &pdata->dyn_callback_list, list) {
>   if (callback->usage_callback->suspend)
>   callback->usage_callback->suspend(
>   callback->hsdev, callback->priv);
>   }
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>
>   return 0;
>  }
>
>  static int sensor_hub_resume(struct hid_device *hdev)
>  {
> + unsigned long flags;
>   struct sensor_hub_data *pdata = hid_get_drvdata(hdev);
>   struct hid_sensor_hub_callbacks_list *callback;
>
>   hid_dbg(hdev, " sensor_hub_resume\n");
> - spin_lock(&pdata->dyn_callback_lock);
> + spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
>   list_for_each_entry(callback, &pdata->dyn_callback_list, list) {
>   if (callback->usage_callback->resume)
>   callback->usage_callback->resume(
>   callback->hsdev, callback->priv);
>   }
> - spin_unlock(&pdata->dyn_callback_lock);
> + spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
>
>   return 0;
>  }
> --
> 1.9.0
