Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3H0BV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:21:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3H0BHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Wu <zlinuxkernel@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Wu <lekensteyn@gmail.com>
Subject: [ 03/74] ACPI: add _STA evaluation at do_acpi_find_child()
Date: Mon, 26 Aug 2013 18:08:01 -0700
Message-Id: <20130827010425.389060276@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Wu <zlinuxkernel@gmail.com>

commit c7d9ca90aa9497f0b6e301ec67c52dd4b57a7852 upstream.

Once do_acpi_find_child() has found the first matching handle, it
makes the acpi_get_child() loop stop and return that handle.  On some
platforms, though, there are multiple devices with the same value of
"_ADR" in the same namespace scope, and if one of them is enabled,
the others will be disabled.  For example:

 Address : 0x1FFFF ; path : SB_PCI0.SATA.DEV0
 Address : 0x1FFFF ; path : SB_PCI0.SATA.DEV1
 Address : 0x1FFFF ; path : SB_PCI0.SATA.DEV2

If DEV0 and DEV1 are disabled and DEV2 is enabled, the handle of DEV2
should be returned, but actually the function always returns the
handle of DEV0.

To address that issue, make do_acpi_find_child() evaluate _STA to
check the device status.  If a matching device object exists, but is
disabled, acpi_get_child() will continue to walk the namespace in the
hope of finding an enabled one.  If one is found, its handle will be
returned, but otherwise the function will return the handle of the
disabled object found before (in case it is enabled going forward).

[rjw: Changelog]
Signed-off-by: Jeff Wu <zlinuxkernel@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Peter Wu <lekensteyn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/glue.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -81,13 +81,15 @@ static struct acpi_bus_type *acpi_get_bu
 static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
 				      void *addr_p, void **ret_p)
 {
-	unsigned long long addr;
+	unsigned long long addr, sta;
 	acpi_status status;
 
 	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
 	if (ACPI_SUCCESS(status) && addr == *((u64 *)addr_p)) {
 		*ret_p = handle;
-		return AE_CTRL_TERMINATE;
+		status = acpi_bus_get_status_handle(handle, &sta);
+		if (ACPI_SUCCESS(status) && (sta & ACPI_STA_DEVICE_ENABLED))
+			return AE_CTRL_TERMINATE;
 	}
 	return AE_OK;
 }


