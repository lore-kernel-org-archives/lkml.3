Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356Ab3HBKLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab3HBKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 60/99] ACPI / scan: Do not try to attach scan handlers to devices having them
Date: Fri,  2 Aug 2013 18:08:13 +0800
Message-Id: <20130802100234.403761635@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 3a391a39593b48341f0908511590a6c0e55cc069 upstream.

In acpi_bus_device_attach(), if there is an ACPI device object
for the given handle and that device object has a scan handler
attached to it already, there's nothing more to do for that handle.
Moreover, if acpi_scan_attach_handler() is called then, it may
execute the .attach() callback of the ACPI scan handler already
attached to the device object and that may lead to interesting
breakage.

For this reason, make acpi_bus_device_attach() return success
immediately when the handle's device object has a scan handler
attached to it.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1892,6 +1892,9 @@ static acpi_status acpi_bus_device_attac
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
+	if (device->handler)
+		return AE_OK;
+
 	ret = acpi_scan_attach_handler(device);
 	if (ret)
 		return ret > 0 ? AE_OK : AE_CTRL_DEPTH;


