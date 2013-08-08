Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3HHWLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:11:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3HHWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:11:20 -0400
Date: Thu, 8 Aug 2013 15:11:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time: enable HID input
 processing early
Message-Id: <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org>
In-Reply-To: <1375382342-25454-2-git-send-email-holler@ahsoftware.de>
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de>
	<1375382342-25454-2-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Aug 2013 20:39:02 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

> Enable the processing of HID input records before the RTC will be registered,
> in order to allow the RTC register function to read clock. Without doing
> that the clock can only be read after the probe function has finished.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  drivers/rtc/rtc-hid-sensor-time.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
> index 1ab3d13..1006a62 100644
> --- a/drivers/rtc/rtc-hid-sensor-time.c
> +++ b/drivers/rtc/rtc-hid-sensor-time.c
> @@ -279,11 +279,18 @@ static int hid_time_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> +	/*
> +	 * Enable HID input processing early in order to be able to read the
> +	 * clock already in devm_rtc_device_register().
> +	 */
> +	hid_device_io_start(hsdev->hdev);
> +
>  	time_state->rtc = devm_rtc_device_register(&pdev->dev,
>  					"hid-sensor-time", &hid_time_rtc_ops,
>  					THIS_MODULE);
>  
>  	if (IS_ERR_OR_NULL(time_state->rtc)) {
> +		hid_device_io_stop(hsdev->hdev);
>  		ret = time_state->rtc ? PTR_ERR(time_state->rtc) : -ENODEV;
>  		time_state->rtc = NULL;
>  		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);

Shouldn't now there be a hid_device_io_stop() in hid_time_remove()?

Also, hid_device_io_start() does a weird up() on a
downed-by-someone-else semaphore.  Where was that down() performed in
this case?

Also, your changelog implies that the kernel is already doing this
hid_device_io_start(), only it does it too late.  If that is the case
then will the existing-before-this-patch call to hid_device_io_start()
generate the "io already started" warning?

