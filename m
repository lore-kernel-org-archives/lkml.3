Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaJJIl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:41:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:6971 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaJJIly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,690,1406617200"; 
   d="scan'208";a="616316372"
Message-ID: <1412930442.3713.79.camel@rzhang1-toshiba>
Subject: Re: linux-next: manual merge of the thermal tree with the pm tree
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudip Mukherjee <sudip@vectorindia.org>,
        Aaron Lu <aaron.lu@intel.com>
Date: Fri, 10 Oct 2014 16:40:42 +0800
In-Reply-To: <20141010121033.38dc4d0e@canb.auug.org.au>
References: <20141010121033.38dc4d0e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

On Fri, 2014-10-10 at 12:10 +1100, Stephen Rothwell wrote:
> Hi Zhang,
> 
> Today's linux-next merge of the thermal tree got a conflict in
> drivers/acpi/fan.c between commit 88989fd26a74 ("ACPI / fan: printk
> replacement") from the pm tree and commits 71532a58d2b0 ("ACPI / fan:
> remove unused macro") and ff39c76855e8 ("ACPI / fan: convert to
> platform driver") from the thermal tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
thanks a lot for your patch, I don't know why but it seems that you
missed one conflict? how about the patch below?

thanks,
rui

diff --cc drivers/acpi/fan.c
index e007c49,5328b10..e0ba2af
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@@ -27,11 -27,15 +27,11 @@@
  #include <linux/module.h>
  #include <linux/init.h>
  #include <linux/types.h>
- #include <asm/uaccess.h>
+ #include <linux/uaccess.h>
  #include <linux/thermal.h>
  #include <linux/acpi.h>
 -
 -#define ACPI_FAN_CLASS			"fan"
 -#define ACPI_FAN_FILE_STATE		"state"
 -
 -#define _COMPONENT		ACPI_FAN_COMPONENT
 -ACPI_MODULE_NAME("fan");
 +#include <linux/platform_device.h>
 +#include <linux/sort.h>
  
  MODULE_AUTHOR("Paul Diefenbaugh");
  MODULE_DESCRIPTION("ACPI Fan Driver");
@@@ -221,128 -125,25 +221,129 @@@ static const struct thermal_cooling_dev
  };
  
  /* --------------------------------------------------------------------------
-                                  Driver Interface
-    -------------------------------------------------------------------------- */
+  *                               Driver Interface
+  * --------------------------------------------------------------------------
+ */
  
 -static int acpi_fan_add(struct acpi_device *device)
 +static bool acpi_fan_is_acpi4(struct acpi_device *device)
  {
 -	int result = 0;
 -	struct thermal_cooling_device *cdev;
 +	return acpi_has_method(device->handle, "_FIF") &&
 +	       acpi_has_method(device->handle, "_FPS") &&
 +	       acpi_has_method(device->handle, "_FSL") &&
 +	       acpi_has_method(device->handle, "_FST");
 +}
  
 -	if (!device)
 -		return -EINVAL;
 +static int acpi_fan_get_fif(struct acpi_device *device)
 +{
 +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 +	struct acpi_fan *fan = acpi_driver_data(device);
 +	struct acpi_buffer format = { sizeof("NNNN"), "NNNN" };
 +	struct acpi_buffer fif = { sizeof(fan->fif), &fan->fif };
 +	union acpi_object *obj;
 +	acpi_status status;
 +
 +	status = acpi_evaluate_object(device->handle, "_FIF", NULL, &buffer);
 +	if (ACPI_FAILURE(status))
 +		return status;
 +
 +	obj = buffer.pointer;
 +	if (!obj || obj->type != ACPI_TYPE_PACKAGE) {
 +		dev_err(&device->dev, "Invalid _FIF data\n");
 +		status = -EINVAL;
 +		goto err;
 +	}
  
 -	strcpy(acpi_device_name(device), "Fan");
 -	strcpy(acpi_device_class(device), ACPI_FAN_CLASS);
 +	status = acpi_extract_package(obj, &format, &fif);
 +	if (ACPI_FAILURE(status)) {
 +		dev_err(&device->dev, "Invalid _FIF element\n");
 +		status = -EINVAL;
 +	}
  
 -	result = acpi_bus_update_power(device->handle, NULL);
 -	if (result) {
 -		dev_err(&device->dev, "Setting initial power state\n");
 -		goto end;
 +err:
 +	kfree(obj);
 +	return status;
 +}
 +
 +static int acpi_fan_speed_cmp(const void *a, const void *b)
 +{
 +	const struct acpi_fan_fps *fps1 = a;
 +	const struct acpi_fan_fps *fps2 = b;
 +	return fps1->speed - fps2->speed;
 +}
 +
 +static int acpi_fan_get_fps(struct acpi_device *device)
 +{
 +	struct acpi_fan *fan = acpi_driver_data(device);
 +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 +	union acpi_object *obj;
 +	acpi_status status;
 +	int i;
 +
 +	status = acpi_evaluate_object(device->handle, "_FPS", NULL, &buffer);
 +	if (ACPI_FAILURE(status))
 +		return status;
 +
 +	obj = buffer.pointer;
 +	if (!obj || obj->type != ACPI_TYPE_PACKAGE || obj->package.count < 2) {
 +		dev_err(&device->dev, "Invalid _FPS data\n");
 +		status = -EINVAL;
 +		goto err;
 +	}
 +
 +	fan->fps_count = obj->package.count - 1; /* minus revision field */
 +	fan->fps = devm_kzalloc(&device->dev,
 +				fan->fps_count * sizeof(struct acpi_fan_fps),
 +				GFP_KERNEL);
 +	if (!fan->fps) {
 +		dev_err(&device->dev, "Not enough memory\n");
 +		status = -ENOMEM;
 +		goto err;
 +	}
 +	for (i = 0; i < fan->fps_count; i++) {
 +		struct acpi_buffer format = { sizeof("NNNNN"), "NNNNN" };
 +		struct acpi_buffer fps = { sizeof(fan->fps[i]), &fan->fps[i] };
 +		status = acpi_extract_package(&obj->package.elements[i + 1],
 +					      &format, &fps);
 +		if (ACPI_FAILURE(status)) {
 +			dev_err(&device->dev, "Invalid _FPS element\n");
 +			break;
 +		}
 +	}
 +
 +	/* sort the state array according to fan speed in increase order */
 +	sort(fan->fps, fan->fps_count, sizeof(*fan->fps),
 +	     acpi_fan_speed_cmp, NULL);
 +
 +err:
 +	kfree(obj);
 +	return status;
 +}
 +
 +static int acpi_fan_probe(struct platform_device *pdev)
 +{
 +	int result = 0;
 +	struct thermal_cooling_device *cdev;
 +	struct acpi_fan *fan;
 +	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 +
 +	fan = devm_kzalloc(&pdev->dev, sizeof(*fan), GFP_KERNEL);
 +	if (!fan) {
 +		dev_err(&device->dev, "No memory for fan\n");
 +		return -ENOMEM;
 +	}
 +	device->driver_data = fan;
 +	platform_set_drvdata(pdev, fan);
 +
 +	if (acpi_fan_is_acpi4(device)) {
 +		if (acpi_fan_get_fif(device) || acpi_fan_get_fps(device))
 +			goto end;
 +		fan->acpi4 = true;
 +	} else {
 +		result = acpi_device_update_power(device, NULL);
 +		if (result) {
 +			dev_err(&device->dev, "Setting initial power state\n");
 +			goto end;
 +		}
  	}
  
  	cdev = thermal_cooling_device_register("Fan", device,
@@@ -363,12 -164,15 +364,11 @@@
  			"'thermal_cooling'\n");
  
  	result = sysfs_create_link(&cdev->device.kobj,
 -				   &device->dev.kobj,
 +				   &pdev->dev.kobj,
  				   "device");
  	if (result)
- 		dev_err(&pdev->dev, "Failed to create sysfs link "
- 			"'device'\n");
+ 		dev_err(&device->dev, "Failed to create sysfs link 'device'\n");
  
 -	dev_info(&device->dev, "ACPI: %s [%s] (%s)\n",
 -	       acpi_device_name(device), acpi_device_bid(device),
 -	       !device->power.state ? "on" : "off");
 -
  end:
  	return result;
  }


