Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3FYTHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:07:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3FYSds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [ 35/95] ACPI / PM: Fix error code path for power resources initialization
Date: Tue, 25 Jun 2013 11:32:22 -0700
Message-Id: <20130625182157.599952566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 6ee22e9d59151550a55d370b14109bdae8b58bda upstream.

Commit 781d737 (ACPI: Drop power resources driver) introduced a
bug in the power resources initialization error code path causing
a NULL pointer to be referenced in acpi_release_power_resource()
if there's an error triggering a jump to the 'err' label in
acpi_add_power_resource().  This happens because the list_node
field of struct acpi_power_resource has not been initialized yet
at this point and doing a list_del() on it is a bad idea.

To prevent this problem from occuring, initialize the list_node
field of struct acpi_power_resource upfront.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/power.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -865,6 +865,7 @@ int acpi_add_power_resource(acpi_handle
 				ACPI_STA_DEFAULT);
 	mutex_init(&resource->resource_lock);
 	INIT_LIST_HEAD(&resource->dependent);
+	INIT_LIST_HEAD(&resource->list_node);
 	resource->name = device->pnp.bus_id;
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);


