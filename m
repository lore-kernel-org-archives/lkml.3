Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaGZAjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:39:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36420 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGZAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:39:13 -0400
Date: Fri, 25 Jul 2014 17:39:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 06/10] Input - wacom: prepare the driver to include BT
 devices
Message-ID: <20140726003909.GA16900@core.coreip.homeip.net>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406225645-32141-7-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406225645-32141-7-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Thu, Jul 24, 2014 at 02:14:01PM -0400, Benjamin Tissoires wrote:
> Now that wacom is a hid driver, there is no point in having a separate
> driver for bluetooth devices.
> This patch prepares the common paths of Bluetooth devices in the
> common wacom driver.
> It also adds the sysfs file "speed" used by Bluetooth devices.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> new in v2
> 
>  drivers/hid/wacom_sys.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/hid/wacom_wac.h |  2 ++
>  2 files changed, 69 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index d0d06b8..add76ec 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -262,6 +262,12 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
>  	return error < 0 ? error : 0;
>  }
>  
> +static int wacom_bt_query_tablet_data(struct hid_device *hdev, u8 speed,
> +		struct wacom_features *features)
> +{
> +	return 0;
> +}
> +
>  /*
>   * Switch the tablet into its most-capable mode. Wacom tablets are
>   * typically configured to power-up in a mode which sends mouse-like
> @@ -272,6 +278,9 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
>  static int wacom_query_tablet_data(struct hid_device *hdev,
>  		struct wacom_features *features)
>  {
> +	if (hdev->bus == BUS_BLUETOOTH)
> +		return wacom_bt_query_tablet_data(hdev, 1, features);
> +
>  	if (features->device_type == BTN_TOOL_FINGER) {
>  		if (features->type > TABLETPC) {
>  			/* MT Tablet PC touch */
> @@ -890,6 +899,38 @@ static void wacom_destroy_battery(struct wacom *wacom)
>  	}
>  }
>  
> +static ssize_t wacom_show_speed(struct device *dev,
> +				struct device_attribute
> +				*attr, char *buf)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct wacom *wacom = hid_get_drvdata(hdev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%i\n", wacom->wacom_wac.bt_high_speed);
> +}
> +
> +static ssize_t wacom_store_speed(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct wacom *wacom = hid_get_drvdata(hdev);
> +	int new_speed;
> +
> +	if (sscanf(buf, "%1d", &new_speed ) != 1)

Checkpach is unhappy with ')' placement and I agree with it.

> +		return -EINVAL;

kstrtou8?

> +
> +	if (new_speed == 0 || new_speed == 1) {
> +		wacom_bt_query_tablet_data(hdev, new_speed,
> +				&wacom->wacom_wac.features);
> +		return strnlen(buf, PAGE_SIZE);

This is weird. Normally you want to return count since you should refuse
input with excessive data.

> +	} else
> +		return -EINVAL;

Need braces on both branches.

Thanks.

-- 
Dmitry
