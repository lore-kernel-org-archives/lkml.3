Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab3BKSAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:00:53 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:51509 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506Ab3BKSAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:00:51 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "Matt Fleming (matt@console-pimps.org)" <matt@console-pimps.org>,
        "mikew@google.com" <mikew@google.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v6 -next 2/2]efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Topic: [PATCH v6 -next 2/2]efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Index: Ac4IgZvIgER9Cx6qSuiELPU09Wp/zQ==
Date: Mon, 11 Feb 2013 18:00:23 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A922C2@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-11_03:2013-02-11,2013-02-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302110163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
efi_pstore creates sysfs entries, which enable users to access to NVRAM,
in a write callback. If a kernel panic happens in an interrupt context,
it may fail because it could sleep due to dynamic memory allocations during
creating sysfs entries.

[Patch Description]
This patch removes sysfs operations from a write callback by introducing
a workqueue updating sysfs entries which is scheduled after the write
callback is called.

Also, the workqueue is kicked in a just oops case.
A system will go down in other cases such as panic, clean shutdown and emergency
restart. And we don't need to create sysfs entries because there is no chance for
users to access to them.

efi_pstore will be robust against a kernel panic in an interrupt context with this patch.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efivars.c |   85 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/efi.h        |    3 +-
 2 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b962553..fed08b6 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -158,6 +158,13 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 			  efi_char16_t *variable_name,
 			  efi_guid_t *vendor_guid);
 
+/*
+ * Prototype for workqueue functions updating sysfs entry
+ */
+
+static void efivar_update_sysfs_entries(struct work_struct *);
+static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
+
 /* Return the number of unicode characters in data */
 static unsigned long
 utf16_strnlen(efi_char16_t *s, size_t maxlength)
@@ -1249,11 +1256,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock_irqrestore(&efivars->lock, flags);
 
-	if (size)
-		ret = efivar_create_sysfs_entry(efivars,
-					  utf16_strsize(efi_name,
-							DUMP_NAME_LEN * 2),
-					  efi_name, &vendor);
+	if (reason == KMSG_DUMP_OOPS)
+		schedule_work(&efivar_work);
 
 	*id = part;
 	return ret;
@@ -1497,6 +1501,75 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
+static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
+{
+	struct efivar_entry *entry, *n;
+	struct efivars *efivars = &__efivars;
+	unsigned long strsize1, strsize2;
+	bool found = false;
+
+	strsize1 = utf16_strsize(variable_name, 1024);
+	list_for_each_entry_safe(entry, n, &efivars->list, list) {
+		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
+		if (strsize1 == strsize2 &&
+			!memcmp(variable_name, &(entry->var.VariableName),
+				strsize2) &&
+			!efi_guidcmp(entry->var.VendorGuid,
+				*vendor)) {
+			found = true;
+			break;
+		}
+	}
+	return found;
+}
+
+static void efivar_update_sysfs_entries(struct work_struct *work)
+{
+	struct efivars *efivars = &__efivars;
+	efi_guid_t vendor;
+	efi_char16_t *variable_name;
+	unsigned long variable_name_size = 1024;
+	efi_status_t status = EFI_NOT_FOUND;
+	bool found;
+
+	/* Add new sysfs entries */
+	while (1) {
+		variable_name = kzalloc(variable_name_size, GFP_KERNEL);
+		if (!variable_name) {
+			pr_err("efivars: Memory allocation failed.\n");
+			return;
+		}
+
+		spin_lock_irq(&efivars->lock);
+		found = false;
+		while (1) {
+			variable_name_size = 1024;
+			status = efivars->ops->get_next_variable(
+							&variable_name_size,
+							variable_name,
+							&vendor);
+			if (status != EFI_SUCCESS) {
+				break;
+			} else {
+				if (!variable_is_present(variable_name,
+				    &vendor)) {
+					found = true;
+					break;
+				}
+			}
+		}
+		spin_unlock_irq(&efivars->lock);
+
+		if (!found) {
+			kfree(variable_name);
+			break;
+		} else
+			efivar_create_sysfs_entry(efivars,
+						  variable_name_size,
+						  variable_name, &vendor);
+	}
+}
+
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -1834,6 +1907,8 @@ err_put:
 static void __exit
 efivars_exit(void)
 {
+	cancel_work_sync(&efivar_work);
+
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
 		unregister_efivars(&__efivars);
 		kobject_put(efi_kobj);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7a9498a..9bf2f1f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -740,7 +740,8 @@ struct efivars {
 	 * 1) ->list - adds, removals, reads, writes
 	 * 2) ops.[gs]et_variable() calls.
 	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * ops.get_next_variable() is only called from register_efivars(),
+	 * ops.get_next_variable() is only called from register_efivars()
+	 * or efivar_update_sysfs_entries(),
 	 * which is protected by the BKL, so that path is safe.
 	 */
 	spinlock_t lock;
-- 1.7.1


