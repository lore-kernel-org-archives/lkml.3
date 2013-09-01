Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3IACtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:14 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53585 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3IACtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:13 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 0/9] Introduce hwmon_device_register_with_groups and
Date: Sat, 31 Aug 2013 19:48:53 -0700
Message-Id: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces new hwmon API functions
hwmon_device_register_with_groups() and devm_hwmon_device_register_with_groups().

hwmon_device_register_with_groups() lets callers register hwmon devices
as well as associated sysfs attributes with a single call. This simplifies
hwmon device registration and avoids potential race conditions seen
if sysfs attributes are created after the initial hwmon device was
registered.

devm_hwmon_device_register_with_groups() is the managed version of the same
function.

The rationale for the new API is that sysfs attributes should be created
synchronously with device creation to avoid race conditions, as outlined in
http://www.linuxfoundation.org/news-media/blogs/browse/2013/06/how-create-sysfs-file-correctly.

The first patch of the series introduces hwmon_device_register_with_groups().

Patches 2 to 6 convert some hwmon drivers to use the new API to show and
test its use. Only the ds1621 and nct6775 patches have been tested at this time;
the others are informational to show the potential of the new functions.

Patch 7 introduces devm_hwmon_device_register_with_groups() and
the matching function devm_hwmon_device_unregister(). Patch 8 and 9
convert the nct6775 and ds1621 drivers drivers to use this function.

hwmon attributes

The old hwmon API attaches hwmon attributes to the parent device, not to the
hwmon device itself. With the new API, hwmon attributes are attached to the
hwmon device itself.

Handling the 'name' attribute for hwmon drivers

Since sysfs attributes are no longer attached to the parent device, the
mandatory 'name' attribute has to be created explicitly. For some drivers,
this was already the case. I2c drivers, however, create the 'name' attribute
in the i2c core, and it was used by the hwmon driver.

To simplify name attribute handling, the value of the 'name' attribute is
passed as parameter to hwmon_device_register_with_groups(). The hwmon core
creates and manages the attribute. If a NULL pointer is passed instead of
a name, the attribute is not created.

Unfortunately, since we need a variable to store the pointer to 'name',
it was necessary to create an internal 'struct hwmon_device'. For this
reason, device_create(), or rather device_create_with_groups() can no
longer be used to create the actual device. device_register() is used
instead, and the device data structures are managed locally. 
[ If there is a better solution for this problem, I am listening. ]

The series is based on my hwmon-next branch and should apply to the top of
linux-next.

---------

v2: Rename API functions
	device_create_groups -> device_create_with_groups
    	hwmon_device_register_groups -> hwmon_device_register_with_groups
    Additional parameter 'void *drvdata' for hwmon_device_register_groups.
    Additional parameter 'name' for hwmon_device_register_groups.
    Introduce devm_hwmon_device_register_with_groups().
    Various fixes in hwmon driver conversions.
