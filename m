Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3IKE6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3IKE44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:56 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=AYcbVwpvMgsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XJLWFqsDE5gA:10 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=TYw0uB23wB3PbwDU80MA:9 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=chhSAiW_p1zha75H:21 a=xtbTbsFlzXbHwUXA:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042928.205019984@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Wu <zlinuxkernel@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [216/251] ACPI: add _STA evaluation at do_acpi_find_child()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0216-ACPI-add-_STA-evaluation-at-do_acpi_find_child.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jeff Wu <zlinuxkernel@gmail.com>

[ Upstream commit c7d9ca90aa9497f0b6e301ec67c52dd4b57a7852 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/glue.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 6eff12f..a166b9d 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -91,13 +91,15 @@ static int acpi_find_bridge_device(struct device *dev, acpi_handle * handle)
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
-- 
1.7.10.4


