Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaKYLwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:52:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:41588 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaKYLwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,455,1413270000"; 
   d="scan'208";a="637739926"
Message-ID: <54746D7F.1020104@intel.com>
Date: Tue, 25 Nov 2014 19:52:31 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Support PMIC operation region for CrystalCove
 and XPower
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com> <1987897.BgdIEqPdlH@vostro.rjw.lan>
In-Reply-To: <1987897.BgdIEqPdlH@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 09:47 AM, Rafael J. Wysocki wrote:
> On Friday, November 21, 2014 03:11:48 PM Aaron Lu wrote:
>> v3:
>> Only some function/variable name changes, no functiona changes:
>> - Replace the dptf/DPTF word originate from the BIOS ACPI table with more
>>   meaningful word thermal/THERMAL in all places;
>> - Eliminate the soc part in various structure and function names to make
>>   them shorter:
>>   intel_soc_pmic_opregion -> intel_pmic_opregion
>>   intel_soc_pmic_pmop_handler -> intel_pmic_pmop_handler
>>   intel_soc_pmic_install_opregion_handler -> intel_pmic_install_opregion_handler
>>   etc.
>>
>>
>> v2:
>> Place PMIC operation files under drivers/acpi/pmic instead of
>> drivers/acpi/pmic_opregion as suggested by Rafael;
>> Rename PMIC operation files to make them shorter as suggested by Rafael.
>>
>> v1:
>> On Intel Baytrail-T and Baytrail-T-CR platforms, there are two customized
>> ACPI operation regions defined for the Power Management Integrated Circuit
>> device, one is for power resource handling and one is for thermal: sensor
>> temperature reporting, trip point setting, etc. There are different PMIC
>> chips used on those platforms and though each has the same two operation
>> regions and functionality, their implementation is different so every PMIC
>> will need a driver. But since their functionality is similar, some common
>> code is abstracted into the intel_soc_pmic_opregion.c.
>>
>> The last version is posted here:
>> https://lkml.org/lkml/2014/9/8/801
>>
>> Changes since then:
>> 1 Move to drivers/acpi as discussed on the above thread;
>> 2 Added support for XPower AXP288 PMIC operation region support;
>> 3 Since operation region handler can not be removed(at the moment at least),
>>   use bool for the two operation region driver configs instead of tristate;
>>   Another reason to do this is that, with Mika's MFD ACPI support patch, all
>>   those MFD cell devices created will have the same modalias as their parent's
>>   so it doesn't make much sense to compile these drivers into modules.
>>
>> Patch 1 applies on top of Rafael's pm-next branch, and then patch 2 and
>> patch 3 needs merge of Lee's mfd/ib-mfd-iio-3.19 branch where the PMIC
>> driver XPower AXP288 and iio driver axp288_adc is located.
>>
>>
>> Aaron Lu (3):
>>   ACPI / PMIC: support PMIC operation region for CrystalCove
>>   ACPI / PMIC: support PMIC operation region for XPower AXP288
>>   ACPI / PMIC: AXP288: support virtual GPIO in ACPI table
> 
> OK
> 
> I've pulled the Lee's 'mfd/ib-mfd-iio-3.19' branch and applied your updated
> three on top of that.  Please check the bleeding-edge branch of linux-pm.git
> for the result.

Thanks, and a fix patch is here:

From: Aaron Lu <aaron.lu@intel.com>
Date: Tue, 25 Nov 2014 14:35:38 +0800
Subject: [PATCH] ACPI / PMIC: Make it possible to build PMIC driver as a module

This can solve a problem that when axp288_adc driver is built as a
module and the PMIC driver is builtin, following error would ocur:
 drivers/built-in.o: In function `intel_xpower_pmic_get_raw_temp':
 intel_pmic_xpower.c:(.text+0xdfaa7): undefined reference to `iio_channel_get'
 intel_pmic_xpower.c:(.text+0xdfb24): undefined reference to `iio_read_channel_raw'
 intel_pmic_xpower.c:(.text+0xdfb4e): undefined reference to `iio_channel_release'

Also, with the fix commit: 52870786ff5d ("ACPI: Use ACPI companion to
match only the first physical device"), the MFD cell device will have
its own platform modalias instead of its parent's ACPI modalias, this
made it possible for the module to be autoloaded.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/Kconfig                  |  6 +++---
 drivers/acpi/pmic/intel_pmic_crc.c    | 12 +++++++++++-
 drivers/acpi/pmic/intel_pmic_xpower.c | 12 +++++++++++-
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 227f0692cbff..f9459ba4ce59 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -394,7 +394,7 @@ config ACPI_EXTLOG
 	  tracepoint which carries that information to userspace.
 
 menuconfig PMIC_OPREGION
-	bool "PMIC (Power Management Integrated Circuit) operation region support"
+	tristate "PMIC (Power Management Integrated Circuit) operation region support"
 	help
 	  Select this option to enable support for ACPI operation
 	  region of the PMIC chip. The operation region can be used
@@ -403,13 +403,13 @@ menuconfig PMIC_OPREGION
 
 if PMIC_OPREGION
 config CRC_PMIC_OPREGION
-	bool "ACPI operation region support for CrystalCove PMIC"
+	tristate "ACPI operation region support for CrystalCove PMIC"
 	depends on INTEL_SOC_PMIC
 	help
 	  This config adds ACPI operation region support for CrystalCove PMIC.
 
 config XPOWER_PMIC_OPREGION
-	bool "ACPI operation region support for XPower AXP288 PMIC"
+	tristate "ACPI operation region support for XPower AXP288 PMIC"
 	depends on AXP288_ADC
 	help
 	  This config adds ACPI operation region support for XPower AXP288 PMIC.
diff --git a/drivers/acpi/pmic/intel_pmic_crc.c b/drivers/acpi/pmic/intel_pmic_crc.c
index 8955e5b41195..8a193381b5ee 100644
--- a/drivers/acpi/pmic/intel_pmic_crc.c
+++ b/drivers/acpi/pmic/intel_pmic_crc.c
@@ -194,13 +194,23 @@ static int intel_crc_pmic_opregion_probe(struct platform_device *pdev)
 			&intel_crc_pmic_opregion_data);
 }
 
+#define DRV_NAME "crystal_cove_region"
+
+static struct platform_device_id crc_opregion_id_table[] = {
+	{ .name = DRV_NAME },
+	{},
+};
+
 static struct platform_driver intel_crc_pmic_opregion_driver = {
 	.probe = intel_crc_pmic_opregion_probe,
+	.id_table = crc_opregion_id_table,
 	.driver = {
-		.name = "crystal_cove_region",
+		.name = DRV_NAME,
 	},
 };
 
+MODULE_DEVICE_TABLE(platform, crc_opregion_id_table);
+
 static int __init intel_crc_pmic_opregion_driver_init(void)
 {
 	return platform_driver_register(&intel_crc_pmic_opregion_driver);
diff --git a/drivers/acpi/pmic/intel_pmic_xpower.c b/drivers/acpi/pmic/intel_pmic_xpower.c
index 9ec57ebd81c9..4debcbbd6285 100644
--- a/drivers/acpi/pmic/intel_pmic_xpower.c
+++ b/drivers/acpi/pmic/intel_pmic_xpower.c
@@ -251,13 +251,23 @@ static int intel_xpower_pmic_opregion_probe(struct platform_device *pdev)
 	return result;
 }
 
+#define DRV_NAME "axp288_opregion"
+
+static struct platform_device_id xpower_opregion_id_table[] = {
+	{ .name = DRV_NAME },
+	{},
+};
+
 static struct platform_driver intel_xpower_pmic_opregion_driver = {
 	.probe = intel_xpower_pmic_opregion_probe,
+	.id_table = xpower_opregion_id_table,
 	.driver = {
-		.name = "axp288_opregion",
+		.name = DRV_NAME,
 	},
 };
 
+MODULE_DEVICE_TABLE(platform, xpower_opregion_id_table);
+
 static int __init intel_xpower_pmic_opregion_driver_init(void)
 {
 	return platform_driver_register(&intel_xpower_pmic_opregion_driver);
-- 
1.9.3

