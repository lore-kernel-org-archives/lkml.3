Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab3EWMRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:17:05 -0400
Received: from mail1.ams.com ([212.166.112.31]:37902 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004Ab3EWMRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:17:03 -0400
X-IronPort-AV: E=Sophos;i="4.87,728,1363129200"; 
   d="scan'208";a="2797469"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 May 2013 14:07:37 +0200
Subject: [PATCH 03/07] Documentation patch of ams AS3722 PMIC against
 linux_3.8.8
Thread-Topic: [PATCH 03/07] Documentation patch of ams AS3722 PMIC against
 linux_3.8.8
Thread-Index: Ac5XrNs3OrLYkr5HQbCSlTm8BIheKQ==
Message-ID: <EB31996D403C2C48A47628A08DCCFD29018405708B@SUX2182.office.amsiag.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Lobmaier <florian.lobmaier@ams.com>

Added multi-function device driver support for ams AS3722 PMIC
Includes modules gpio, regulator, rtc, and watchdog

Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

---
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/Documentation/mfd-as3722.txt ./Documentation/mfd-as3722.txt
--- ../kernel_3.8.8/linux-kernel/Documentation/mfd-as3722.txt	1970-01-01 01:00:00.000000000 +0100
+++ ./Documentation/mfd-as3722.txt	2013-05-23 13:12:35.000000000 +0200
@@ -0,0 +1,133 @@
+AS3722 PMIC Driver documentation
+--------------------------------
+Author: Florian Lobmaier <florian.lobmaier@ams.com>
+Last update: 2013-04-12
+
+This document describes how to use the multi-function device driver for
+AS3722 PMICs. The AS3722 PMICs are accessed via i2c.
+
+Version info:
+=============
+Linux kernel: 3.4.38
+Patch created with: $ git diff f3b5af9a6e2a873110bb8546b42ae7c51f2213b3 > as3722_driver_v0.0.1.patch
+Apply patch with:  $ patch -p0 < as3722_driver_v0.0.1.patch
+
+Description of files:
+=====================
+
+as3722_platform-data.c:
+Platform data and as3722 regulator initialisation support. 
+
+drivers/mfd/as3722-core.c:
+AS3722 communication and device management
+
+drivers/regulator/as3722-regulator.c:
+Adds the LDO's DCDC's and current regulators to /sys/class/regulator.
+
+drivers/gpio/gpio-as3722.c:
+Adds the GPIOs of AS3722 to /sys/class/gpio and to GPIO framework.
+
+drivers/rtc/rtc-as3722.c:
+Adds the RTC functionality of AS3722 to RTC framework.
+
+drivers/mfd/as3722-test.c:
+Regulator test framework. Exports some tests to userspace (see below)
+
+include/linux/mfd/as3722-reg.h:
+Register definitions
+
+include/linux/mfd/as3722-plat.h:
+platform data struct definitions
+
+How do I configure it?
+======================
+
+1. Configure it in config by selecting
+
+CONFIG_MFD_CORE=y
+CONFIG_MFD_AS3722=y
+CONFIG_REGULATOR=y
+CONFIG_REGULATOR_AS3722=y 
+CONFIG_GPIO_AS3722=y
+CONFIG_RTC_DRV_AS3722=y
+
+2. Configure the driver according to the schematic  by filling out the
+as3722_platform_data. Additionally regulator initial data and initial register
+setup can be done here. Add it to the list of attached devices when 
+registering the proper i2c bus.
+
+Testing Regulators:
+===================
+
+# insmod as3722-core.ko
+# insmod as3722-regulators.ko
+
+Regulators using the linux kernel regulator framework can be found at
+/sys/class/regulator. Via sysfs its possible to get some status information:
+
+# cd /sys/class/regulator/regulator.9
+# ls
+# ls
+device          microvolts      num_users       type
+max_microamps   min_microamps   power           uevent
+max_microvolts  min_microvolts  state
+microamps       name            subsystem
+
+We can perform the testing by using the as3722-test.ko modules which provides
+a testframework to userspace: 
+
+Mount debugfs 
+# mount -t debugfs none /sys/kernel/debug/
+
+Load test modules (needed for regulator tests)
+# insmod as3722-test.ko
+
+Use the provided test-scripts. Transfer the scripts and the respective 
+command text files to the rowboat board via adb:
+
+(win cygwin) $ adb shell mkdir -p /testing/ && adb push regtest.sh /testing/regtest.sh 
+(win cygwin) $ adb push test-dig-ldo.txt /testing/test-dig-ldo.txt 
+
+Run the script on the beagle-board testing the ldo3:
+# sh /testing/regtest.sh as3722-ldo3 /testing/test-dig-ldo.txt
+
+Example testing the sd1 (using test-sd.txt):
+# sh /testing/regtest.sh as3722-sd1 /testing/test-sd.txt
+
+Testing gpio:
+=============
+For testing the gpio framework the sysFS functions are used. Of course
+all gpio framework functionality exists as well.
+# cd /sys/class/gpio/
+
+Now "export" and "unexport" files should be available. Use export function
+to create a gpio211 node for GPIO #211 if that is not requested by kernel
+code yet. (GPIO #211 is used as an example number, please substitute with
+a valid AS3722 gpio number):
+# echo 211 > export
+
+The gpio signal for gpio #211 should now be available at:
+# ls /sys/class/gpio/gpio211/
+direction	edge
+value		active_low
+
+This gpio framework files may now be used to setup and test the gpio.
+Please refer to gpio.txt documentation on how to use the gpio framework
+attributes.
+
+Testing rtc:
+============
+The sysfs interface under /sys/class/rtc/rtcN provides access to various
+rtc attributes without requiring the use of ioctls. All dates and times
+are in the RTC's timezone, rather than in system time.
+# cd /sys/class/rtc/rtc0/
+date		max_user_freq	since_epoch	wakealarm
+hctosys		name		time
+
+In order to set the current time or alarm time, IOCTL interface should
+be used. The ioctl calls are supported by /dev/rtc and by the RTC class
+framework.
+
+To test the rtc via IOCTL interface calls, the file rtctest.c copied from 
+kernel/Documentation/rtc.txt can be used.
+
