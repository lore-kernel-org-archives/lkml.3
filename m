Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab3CRBqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61494 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3CRBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:04 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:02 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 0/8] hwmon: Add devres support
Date: Sun, 17 Mar 2013 18:45:49 -0700
Message-Id: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide devres functions for hwmon_register_device.

Besides providing the devres function, the new API automates sysfs attribute
file creation and attaches attribute files to the hwmon device instead of
the hardware device.

Some driver conversions are provided as examples. Only the patches for
max16065, max6697, and ina209 have been tested so far, the others are
informational only.

An open question is if the new API function names should reflect that the sysfs
attribute groups are provided as parameter, and, if so, if a matching non-devres
API function should be provided as well.

----------------------------------------------------------------

Guenter Roeck (8):
      hwmon: Add devres support
      hwmon: (ina209) Convert to devm_hwmon_device_register API
      hwmon: (ltc4215) Convert to devm_hwmon_device_register API
      hwmon: (ltc4261) convert to devm_hwmon_device_register API
      hwmon: (max6697) Convert to devm_hwmon_device_register API
      hwmon: (lm90) Convert to devm_hwmon_device_register API
      hwmon: (max16065) Convert to devm_hwmon_device_register API
      hwmon: (tmp401) Convert to devm_hwmon_device_register API

 drivers/hwmon/hwmon.c    |  123 +++++++++++++++++++++++++++++---
 drivers/hwmon/ina209.c   |   29 ++++----
 drivers/hwmon/lm90.c     |  106 ++++++++++++---------------
 drivers/hwmon/ltc4215.c  |   38 +++------
 drivers/hwmon/ltc4261.c  |   39 +++------
 drivers/hwmon/max16065.c |  107 ++++++++++++---------------
 drivers/hwmon/max6697.c  |  157 +++++++++++++++++++++------------------
 drivers/hwmon/tmp401.c   |  184 +++++++++++++++++++++++-----------------------
 include/linux/hwmon.h    |    5 ++
 9 files changed, 424 insertions(+), 364 deletions(-)

----------------------------------------------------------------

Object file size comparisons (x86_64) against 3.9-rc3. Mileage varies
from substantial object file size reductions (lm90) to substantial
increases (max6697). This largely depends on the number of is_visible()
calls which have to be added to the code. Also, if a driver did not use
attribute groups, savings are consumed by the need to declare those;
essentially, code is replaced with data. The tmp401 driver is a good
example for this phenomen.

size old:
   text    data     bss     dec     hex filename
   1297     776     352    2425     979 drivers/hwmon/hwmon.o
   4133    4033    1040    9206    23f6 drivers/hwmon/ina209.o
  11623    5504    3184   20311    4f57 drivers/hwmon/lm90.o
   1923    1833     496    4252    109c drivers/hwmon/ltc4215.o
   1868    1657     496    4021     fb5 drivers/hwmon/ltc4261.o
   4172    6816     872   11860    2e54 drivers/hwmon/max16065.o
   4788    4769    1088   10645    2995 drivers/hwmon/max6697.o
   5240    3232    1376    9848    2678 drivers/hwmon/tmp401.o

size new:
   text    data     bss     dec     hex filename
   2327    1432    1440    5199    144f drivers/hwmon/hwmon.o
   4084    4049    1024    9157    23c5 drivers/hwmon/ina209.o
  11280    5472    2960   19712    4d00 drivers/hwmon/lm90.o
   1781    1785     448    4014     fae drivers/hwmon/ltc4215.o
   1720    1625     432    3777     ec1 drivers/hwmon/ltc4261.o
   3957    6816     784   11557    2d25 drivers/hwmon/max16065.o
   4847    5233    1088   11168    2ba0 drivers/hwmon/max6697.o
   4955    3520    1240    9715    25f3 drivers/hwmon/tmp401.o
