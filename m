Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3DKUx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:53:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935873Ab3DKUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:31 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_qIFQ5jD3aUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mTwAkanW7F0A:10 a=QyXUC8HyAAAA:8 a=klgB0MMPG5ptXD9YpV0A:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=gVYdi1RkTh040z5e:21 a=TyMX6_5--YLiefQ6:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202557.512819785@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 069/171 ] ACPI: Rework acpi_get_child() to be more efficient
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0069-ACPI-Rework-acpi_get_child-to-be-more-efficient.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 33f767d767e9a684e9cd60704d4c049a2014c8d5 ]

Observe that acpi_get_child() doesn't need to use the helper
struct acpi_find_child structure and change it to work without it.
Also, using acpi_get_object_info() to get the output of _ADR for the
given device is overkill, because that function does much more than
just evaluating _ADR (let alone the additional memory allocation
done by it).

Moreover, acpi_get_child() doesn't need to loop any more once it has
found a matching handle, so make it stop in that case.  To prevent
the results from changing, make it use do_acpi_find_child() as
a post-order callback.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/glue.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 243ee85..6eff12f 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -88,40 +88,31 @@ static int acpi_find_bridge_device(struct device *dev, acpi_handle * handle)
 	return ret;
 }
 
-/* Get device's handler per its address under its parent */
-struct acpi_find_child {
-	acpi_handle handle;
-	u64 address;
-};
-
-static acpi_status
-do_acpi_find_child(acpi_handle handle, u32 lvl, void *context, void **rv)
+static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
+				      void *addr_p, void **ret_p)
 {
+	unsigned long long addr;
 	acpi_status status;
-	struct acpi_device_info *info;
-	struct acpi_find_child *find = context;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_SUCCESS(status)) {
-		if ((info->address == find->address)
-			&& (info->valid & ACPI_VALID_ADR))
-			find->handle = handle;
-		kfree(info);
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
+	if (ACPI_SUCCESS(status) && addr == *((u64 *)addr_p)) {
+		*ret_p = handle;
+		return AE_CTRL_TERMINATE;
 	}
 	return AE_OK;
 }
 
 acpi_handle acpi_get_child(acpi_handle parent, u64 address)
 {
-	struct acpi_find_child find = { NULL, address };
+	void *ret = NULL;
 
 	if (!parent)
 		return NULL;
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent,
-			    1, do_acpi_find_child, NULL, &find, NULL);
-	return find.handle;
-}
 
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, NULL,
+			    do_acpi_find_child, &address, &ret);
+	return (acpi_handle)ret;
+}
 EXPORT_SYMBOL(acpi_get_child);
 
 /* Link ACPI devices with physical devices */
-- 
1.7.10.4


