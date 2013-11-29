Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3K2AO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:14:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63718 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752362Ab3K2AO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:14:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
Date: Fri, 29 Nov 2013 01:27:17 +0100
Message-ID: <1428241.LXfdTjYkng@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2569408.tI2CNPgMRh@vostro.rjw.lan>
References: <2610478.KxPMyuOMok@vostro.rjw.lan> <1385516428.1791.198.camel@misato.fc.hp.com> <2569408.tI2CNPgMRh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 02:58:54 AM Rafael J. Wysocki wrote:
> On Tuesday, November 26, 2013 06:40:28 PM Toshi Kani wrote:

[...]

> > 
> > Yes, the system booted fine with 3/4 & 4/4. :-)
> 
> Thanks for the verification!

In fact, I've made one more mistake in that patch.  Namely, acpi_find_child()
has to return an ACPI handle and it returned a pointer to struct acpi_device
after it.

That has been fixed in my tree already, but the updated patch follows for
completness (it requires patch [3/4] to be changed, but that is just a trivial
rebase, so I don't think it is necessary to resend it too).

Thanks,
Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / bind: Simplify child device lookups

Now that we create a struct acpi_device object for every ACPI
namespace node representing a device, it is not necessary to
use acpi_walk_namespace() for child device lookup in
acpi_find_child() any more.  Instead, we can simply walk the
list of children of the given struct acpi_device object and
return the matching one (or the one which is the best match if
there are more of them).  The checks done during the matching
loop can be simplified too so that the secondary namespace walks
in find_child_checks() are not necessary any more.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c     |  135 +++++++++++++++++++-----------------------------
 include/acpi/acpi_bus.h |    3 +
 2 files changed, 57 insertions(+), 81 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -82,107 +82,80 @@ static struct acpi_bus_type *acpi_get_bu
 #define FIND_CHILD_MIN_SCORE	1
 #define FIND_CHILD_MAX_SCORE	2
 
-static acpi_status acpi_dev_present(acpi_handle handle, u32 lvl_not_used,
-				  void *not_used, void **ret_p)
-{
-	struct acpi_device *adev = NULL;
-
-	acpi_bus_get_device(handle, &adev);
-	if (adev) {
-		*ret_p = handle;
-		return AE_CTRL_TERMINATE;
-	}
-	return AE_OK;
-}
-
-static int do_find_child_checks(acpi_handle handle, bool is_bridge)
+static int find_child_checks(struct acpi_device *adev, bool check_children)
 {
 	bool sta_present = true;
 	unsigned long long sta;
 	acpi_status status;
 
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+	status = acpi_evaluate_integer(adev->handle, "_STA", NULL, &sta);
 	if (status == AE_NOT_FOUND)
 		sta_present = false;
 	else if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_ENABLED))
 		return -ENODEV;
 
-	if (is_bridge) {
-		void *test = NULL;
+	if (check_children && list_empty(&adev->children))
+		return -ENODEV;
 
-		/* Check if this object has at least one child device. */
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
-				    acpi_dev_present, NULL, NULL, &test);
-		if (!test)
-			return -ENODEV;
-	}
 	return sta_present ? FIND_CHILD_MAX_SCORE : FIND_CHILD_MIN_SCORE;
 }
 
-struct find_child_context {
-	u64 addr;
-	bool is_bridge;
-	acpi_handle ret;
-	int ret_score;
-};
-
-static acpi_status do_find_child(acpi_handle handle, u32 lvl_not_used,
-				 void *data, void **not_used)
+struct acpi_device *acpi_find_child_device(struct acpi_device *parent,
+					   u64 address, bool check_children)
 {
-	struct find_child_context *context = data;
-	unsigned long long addr;
-	acpi_status status;
-	int score;
+	struct acpi_device *adev, *ret = NULL;
+	int ret_score = 0;
 
-	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
-	if (ACPI_FAILURE(status) || addr != context->addr)
-		return AE_OK;
-
-	if (!context->ret) {
-		/* This is the first matching object.  Save its handle. */
-		context->ret = handle;
-		return AE_OK;
-	}
-	/*
-	 * There is more than one matching object with the same _ADR value.
-	 * That really is unexpected, so we are kind of beyond the scope of the
-	 * spec here.  We have to choose which one to return, though.
-	 *
-	 * First, check if the previously found object is good enough and return
-	 * its handle if so.  Second, check the same for the object that we've
-	 * just found.
-	 */
-	if (!context->ret_score) {
-		score = do_find_child_checks(context->ret, context->is_bridge);
-		if (score == FIND_CHILD_MAX_SCORE)
-			return AE_CTRL_TERMINATE;
-		else
-			context->ret_score = score;
-	}
-	score = do_find_child_checks(handle, context->is_bridge);
-	if (score == FIND_CHILD_MAX_SCORE) {
-		context->ret = handle;
-		return AE_CTRL_TERMINATE;
-	} else if (score > context->ret_score) {
-		context->ret = handle;
-		context->ret_score = score;
+	list_for_each_entry(adev, &parent->children, node) {
+		unsigned long long addr;
+		acpi_status status;
+		int score;
+
+		status = acpi_evaluate_integer(adev->handle, METHOD_NAME__ADR,
+					       NULL, &addr);
+		if (ACPI_FAILURE(status) || addr != address)
+			continue;
+
+		if (!ret) {
+			/* This is the first matching object.  Save it. */
+			ret = adev;
+			continue;
+		}
+		/*
+		 * There is more than one matching device object with the same
+		 * _ADR value.  That really is unexpected, so we are kind of
+		 * beyond the scope of the spec here.  We have to choose which
+		 * one to return, though.
+		 *
+		 * First, check if the previously found object is good enough
+		 * and return it if so.  Second, do the same for the object that
+		 * we've just found.
+		 */
+		if (!ret_score) {
+			ret_score = find_child_checks(ret, check_children);
+			if (ret_score == FIND_CHILD_MAX_SCORE)
+				return ret;
+		}
+		score = find_child_checks(adev, check_children);
+		if (score == FIND_CHILD_MAX_SCORE) {
+			return adev;
+		} else if (score > ret_score) {
+			ret = adev;
+			ret_score = score;
+		}
 	}
-	return AE_OK;
+	return ret;
 }
 
-acpi_handle acpi_find_child(acpi_handle parent, u64 addr, bool is_bridge)
+acpi_handle acpi_find_child(acpi_handle handle, u64 addr, bool is_bridge)
 {
-	if (parent) {
-		struct find_child_context context = {
-			.addr = addr,
-			.is_bridge = is_bridge,
-		};
-
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, do_find_child,
-				    NULL, &context, NULL);
-		return context.ret;
-	}
-	return NULL;
+	struct acpi_device *adev;
+
+	if (!handle || acpi_bus_get_device(handle, &adev))
+		return NULL;
+
+	adev = acpi_find_child_device(adev, addr, is_bridge);
+	return adev ? adev->handle : NULL;
 }
 EXPORT_SYMBOL_GPL(acpi_find_child);
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -433,6 +433,9 @@ struct acpi_pci_root {
 };
 
 /* helper */
+
+struct acpi_device *acpi_find_child_device(struct acpi_device *parent,
+					   u64 address, bool check_children);
 acpi_handle acpi_find_child(acpi_handle, u64, bool);
 static inline acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
 {

