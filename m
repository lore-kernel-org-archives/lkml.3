Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3CZWuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:50:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3CZWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 92/98] ACPI: Rework acpi_get_child() to be more efficient
Date: Tue, 26 Mar 2013 15:43:21 -0700
Message-Id: <20130326224252.009272374@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 33f767d767e9a684e9cd60704d4c049a2014c8d5 upstream.

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
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/acpi/glue.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -95,40 +95,31 @@ static int acpi_find_bridge_device(struc
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
 
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_SUCCESS(status)) {
-		if ((info->address == find->address)
-			&& (info->valid & ACPI_VALID_ADR))
-			find->handle = handle;
-		kfree(info);
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
 
 static int acpi_bind_one(struct device *dev, acpi_handle handle)


