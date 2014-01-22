Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaAVJ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:27:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:46412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaAVJ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:27:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="468911939"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Kim Milo <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: [PATCH v3 0/4] power_supply: Introduce power supply charging driver
Date: Wed, 22 Jan 2014 22:49:50 +0530
Message-Id: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: introduced feature as a framework within power supply class driver with
	separate files for battid framework and charging framework
v2: fixed review comments, moved macros and inline functions to power_supply.h
v3: moved the feature as a separate driver, combined battid framework and
	charging framework inside the power supply charging driver. Moved
	charger specific properties to power_supply_charger.h and plugged the
	driver with power supply subsystem using power_supply_notifier
	introduced in my previous patch. Also a sample charger chip driver
	(bq24261) patch added to give more idea on the psy charging driver
	usage

The Power Supply charging driver connects multiple subsystems
to do charging in a generic way. The subsystems involves power_supply,
thermal and battery communication subsystems (1wire).
With this the charging is handled in a generic way.

The driver makes use of different new features - Battery Identification
interfaces, pluggable charging algorithms, charger cable arbitrations etc.

At present the charging is done based on the static battery characteristics.
This is done at the boot time by passing the battery properties (max_voltage,
capacity) etc. as a platform data to the charger/battery driver.
But new generation high volt batteries needs to be identified dynamically
to do charging in a safe manner. The batteries are coming with different
communication protocols (BSI/SDQ/MIPI BIF). It become necessary to communicate
with battery and identify it's charging profiles before setup charging.

Also the charging algorithms can vary based on the battery characteristics
and the platform characteristics. To handle charging in a generic way it's
necessary to support pluggable charging algorithms. Power Supply Charging
driver selects algorithms based on the type of battery charging profile.
This is a simple binding and can be improved later. This may be improved to
select the algorithms based on the platform requirements. Also we can extend
this driver to plug algorithms from the user space.

The driver also introduces the charger cable arbitration. A charger may
supports multiple cables, but it may not be able to charge with multiple
cables at a time (USB/AC/Wireless etc). The arbitration logic inside the
driver selects the cable based on it's capabilities and the maximum
charge current the platform can support. Also the driver arbitrates between
different charger chip drivers based on their priority.

Also the driver exposes features to control charging on different platform
states. One such feature is thermal. The driver handles the thermal
throttling requests for charging and control charging based on the thermal
subsystem requirements.

The patch also introduces generic interface for charger cable notifications.
Charger cable events and capabilities can be notified using the generic
power_supply_notifier chain.

Overall this driver removes the charging logic out of the charger chip driver
and the charger chip driver can just listen to the request from the power
supply charging driver to set the charger properties. This can be implemented
by exposing get_property and set property callbacks.

Jenny TC (4):
  power_supply: Add inlmt,iterm, min/max temp props
  power_supply: Introduce Generic Power Supply charging driver
  power_supply: Introduce PSE compliant algorithm
  power_supply: bq24261 charger driver

 Documentation/power/power_supply_charger.txt |  332 ++++++
 Documentation/power/power_supply_class.txt   |    6 +
 drivers/power/Kconfig                        |   30 +
 drivers/power/Makefile                       |    3 +
 drivers/power/bq24261_charger.c              | 1447 ++++++++++++++++++++++++++
 drivers/power/charging_algo_pse.c            |  198 ++++
 drivers/power/power_supply_charger.c         | 1191 +++++++++++++++++++++
 drivers/power/power_supply_charger.h         |  218 ++++
 drivers/power/power_supply_core.c            |    3 +
 drivers/power/power_supply_sysfs.c           |    4 +
 include/linux/power/bq24261_charger.h        |   33 +
 include/linux/power/power_supply_charger.h   |  234 +++++
 include/linux/power_supply.h                 |  162 +++
 13 files changed, 3861 insertions(+)
 create mode 100644 Documentation/power/power_supply_charger.txt
 create mode 100644 drivers/power/bq24261_charger.c
 create mode 100644 drivers/power/charging_algo_pse.c
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h
 create mode 100644 include/linux/power/bq24261_charger.h
 create mode 100644 include/linux/power/power_supply_charger.h

-- 
1.7.9.5

