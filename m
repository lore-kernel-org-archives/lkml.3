Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbaHYO1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:27:20 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:38222 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbaHYO1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:27:19 -0400
Message-ID: <53fb47c5.019c3c0a.6cdb.02e1@mx.google.com>
X-Google-Original-Message-ID: 5a4c913f-a01d-450c-b017-4269e388643f@gmail.com>
Date: Mon, 25 Aug 2014 09:27:12 -0500
Subject: Re: [PATCH 2/2] PM / sleep: Asynchronous threads for dpm_complete
In-Reply-To: <1408979617-14140-2-git-send-email-xiaoming.wang@intel.com>
References: <1408979617-14140-1-git-send-email-xiaoming.wang@intel.com>
 <1408979617-14140-2-git-send-email-xiaoming.wang@intel.com>
From: kodiak furr <boxerspam1@gmail.com>
To: xiaoming wang <xiaoming.wang@intel.com>
Cc: gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, rjw@rjwysocki.net,
        Chuansheng Liu <chuansheng.liu@intel.com>, len.brown@intel.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7PERSg5027151

kodiak furr liked your message with Boxer for Android.

On Aug 25, 2014 10:13 AM, xiaoming wang <xiaoming.wang@intel.com> wrote:
>
> In analogy with commits 5af84b82701a and 97df8c12995, 
> using asynchronous threads can improve the overall 
> resume time significantly. 
>
> This patch is for dpm_complete phase. 
>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com> 
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com> 
> --- 
> drivers/base/power/main.c |Â Â  38 ++++++++++++++++++++++++++++++++++---- 
> 1 files changed, 34 insertions(+), 4 deletions(-) 
>
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c 
> index f9fe1b3..00c4bf1 100644 
> --- a/drivers/base/power/main.c 
> +++ b/drivers/base/power/main.c 
> @@ -889,14 +889,15 @@ void dpm_resume(pm_message_t state) 
> Â  * @dev: Device to handle. 
> Â  * @state: PM transition of the system being carried out. 
> Â  */ 
> -static void device_complete(struct device *dev, pm_message_t state) 
> +static void device_complete(struct device *dev, pm_message_t state, bool async) 
> { 
> void (*callback)(struct device *) = NULL; 
> char *info = NULL; 
>
> if (dev->power.syscore) 
> - return; 
> + goto Complete; 
>
> + dpm_wait(dev->parent, async); 
> device_lock(dev); 
>
> if (dev->pm_domain) { 
> @@ -928,6 +929,17 @@ static void device_complete(struct device *dev, pm_message_t state) 
> device_unlock(dev); 
>
> pm_runtime_put(dev); 
> + 
> +Complete: 
> + complete_all(&dev->power.completion); 
> +} 
> + 
> +static void async_complete(void *data, async_cookie_t cookie) 
> +{ 
> + struct device *dev = (struct device *)data; 
> + 
> + device_complete(dev, pm_transition, true); 
> + put_device(dev); 
> } 
>
> /** 
> @@ -940,27 +952,45 @@ static void device_complete(struct device *dev, pm_message_t state) 
> void dpm_complete(pm_message_t state) 
> { 
> struct list_head list; 
> + struct device *dev; 
>
> trace_suspend_resume(TPS("dpm_complete"), state.event, true); 
> might_sleep(); 
>
> INIT_LIST_HEAD(&list); 
> mutex_lock(&dpm_list_mtx); 
> + pm_transition = state; 
> + 
> + /* 
> + Â  * Advanced the async threads upfront, 
> + Â  * in case the starting of async threads is 
> + Â  * delayed by non-async resuming devices. 
> + Â  */ 
> + list_for_each_entry(dev, &dpm_prepared_list, power.entry) { 
> + reinit_completion(&dev->power.completion); 
> + if (is_async(dev)) { 
> + get_device(dev); 
> + async_schedule(async_complete, dev); 
> + } 
> + } 
> + 
> while (!list_empty(&dpm_prepared_list)) { 
> - struct device *dev = to_device(dpm_prepared_list.prev); 
> + dev = to_device(dpm_prepared_list.prev); 
>
> get_device(dev); 
> dev->power.is_prepared = false; 
> list_move(&dev->power.entry, &list); 
> mutex_unlock(&dpm_list_mtx); 
>
> - device_complete(dev, state); 
> + if (!is_async(dev)) 
> + device_complete(dev, state, false); 
>
> mutex_lock(&dpm_list_mtx); 
> put_device(dev); 
> } 
> list_splice(&list, &dpm_list); 
> mutex_unlock(&dpm_list_mtx); 
> + async_synchronize_full(); 
> trace_suspend_resume(TPS("dpm_complete"), state.event, false); 
> } 
>
> -- 
> 1.7.1 
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info atÂ  http://vger.kernel.org/majordomo-info.html 
> Please read the FAQ atÂ  http://www.tux.org/lkml/ 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
