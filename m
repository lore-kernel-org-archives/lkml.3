Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3IYBNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:13:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3IYAQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 033/110] ACPI / LPSS: dont crash if a device has no MMIO resources
Date: Tue, 24 Sep 2013 17:14:31 -0700
Message-Id: <20130925001326.995090407@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit af65cfe9aeae03e0682bebdf4db94582d75562dd upstream.

Intel LPSS devices that are enumerated from ACPI have both MMIO and IRQ
resources returned in their _CRS method. However, Apple Macbook Air with
Haswell has LPSS devices enumerated from PCI bus instead and _CRS method
returns only an interrupt number (but the device has _HID set that causes
the scan handler to match it).

The current ACPI / LPSS code sets pdata->dev_desc only when MMIO resource
is found for the device and in case of Macbook Air it is never found. That
leads to a NULL pointer dereference in register_device_clock().

Correct this by always setting the pdata->dev_desc.

Reported-and-tested-by: Imre Kaloz <kaloz@openwrt.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -155,12 +155,13 @@ static int acpi_lpss_create_device(struc
 			pdata->mmio_size = resource_size(&rentry->res);
 			pdata->mmio_base = ioremap(rentry->res.start,
 						   pdata->mmio_size);
-			pdata->dev_desc = dev_desc;
 			break;
 		}
 
 	acpi_dev_free_resource_list(&resource_list);
 
+	pdata->dev_desc = dev_desc;
+
 	if (dev_desc->clk_required) {
 		ret = register_device_clock(adev, pdata);
 		if (ret) {


