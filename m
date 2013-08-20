Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab3HTVWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:22:55 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:41930 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3HTVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:22:53 -0400
Message-ID: <5213DE20.5040405@hds.com>
Date: Tue, 20 Aug 2013 17:22:40 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        tony.luck@intel.com, matt.fleming@intel.com
CC: dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [RFC][PATCH] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-20_08:2013-08-20,2013-08-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308200144
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when mounting pstore file system, a read callback of efi_pstore
driver runs mutiple times as below.

- In the first read callback, scan efivar_sysfs_list from head and pass
  a kmsg buffer of a entry to an upper pstore layer.
- In the second read callback, rescan efivar_sysfs_list from the entry and pass
  another kmsg buffer to it.
- Repeat the scan and pass until the end of efivar_sysfs_list.

In this process, an entry is read across the multiple read function calls.
To avoid race between the read and erasion, the whole process above is
protected by a spinlock, holding in open() and releasing in close().

At the same time, kmemdup() is called to pass the buffer to pstore filesystem
during it.
And then, it causes a following lockdep warning.

To make the read callback runnable without taking spinlok,
holding off a deletion of sysfs entry if it happens while scanning it
via efi_pstore, and deleting it after the scan is completed.

To implement it, this patch introduces two flags, scanning and deleting,
to efivar_entry.
Also, __efivar_entry_get() is removed because it was used in efi_pstore only.

[    1.143710] ------------[ cut here ]------------
[    1.144058] WARNING: CPU: 1 PID: 1 at kernel/lockdep.c:2740
lockdep_trace_alloc+0x104/0x110()
[    1.144058] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[    1.144058] Modules linked in:

[    1.144058] CPU: 1 PID: 1 Comm: systemd Not tainted 3.11.0-rc5 #2
[    1.144058]  0000000000000009 ffff8800797e9ae0 ffffffff816614a5
ffff8800797e9b28
[    1.144058]  ffff8800797e9b18 ffffffff8105510d 0000000000000080
0000000000000046
[    1.144058]  00000000000000d0 00000000000003af ffffffff81ccd0c0
ffff8800797e9b78
[    1.144058] Call Trace:
[    1.144058]  [<ffffffff816614a5>] dump_stack+0x54/0x74
[    1.144058]  [<ffffffff8105510d>] warn_slowpath_common+0x7d/0xa0
[    1.144058]  [<ffffffff8105517c>] warn_slowpath_fmt+0x4c/0x50
[    1.144058]  [<ffffffff8131290f>] ? vsscanf+0x57f/0x7b0
[    1.144058]  [<ffffffff810bbd74>] lockdep_trace_alloc+0x104/0x110
[    1.144058]  [<ffffffff81192da0>] __kmalloc_track_caller+0x50/0x280
[    1.144058]  [<ffffffff815147bb>] ?
efi_pstore_read_func.part.1+0x12b/0x170
[    1.144058]  [<ffffffff8115b260>] kmemdup+0x20/0x50
[    1.144058]  [<ffffffff815147bb>] efi_pstore_read_func.part.1+0x12b/0x170
[    1.144058]  [<ffffffff81514800>] ?
efi_pstore_read_func.part.1+0x170/0x170
[    1.144058]  [<ffffffff815148b4>] efi_pstore_read_func+0xb4/0xe0
[    1.144058]  [<ffffffff81512b7b>] __efivar_entry_iter+0xfb/0x120
[    1.144058]  [<ffffffff8151428f>] efi_pstore_read+0x3f/0x50
[    1.144058]  [<ffffffff8128d7ba>] pstore_get_records+0x9a/0x150
[    1.158207]  [<ffffffff812af25c>] ? selinux_d_instantiate+0x1c/0x20
[    1.158207]  [<ffffffff8128ce30>] ? parse_options+0x80/0x80
[    1.158207]  [<ffffffff8128ced5>] pstore_fill_super+0xa5/0xc0
[    1.158207]  [<ffffffff811ae7d2>] mount_single+0xa2/0xd0
[    1.158207]  [<ffffffff8128ccf8>] pstore_mount+0x18/0x20
[    1.158207]  [<ffffffff811ae8b9>] mount_fs+0x39/0x1b0
[    1.158207]  [<ffffffff81160550>] ? __alloc_percpu+0x10/0x20
[    1.158207]  [<ffffffff811c9493>] vfs_kern_mount+0x63/0xf0
[    1.158207]  [<ffffffff811cbb0e>] do_mount+0x23e/0xa20
[    1.158207]  [<ffffffff8115b51b>] ? strndup_user+0x4b/0xf0
[    1.158207]  [<ffffffff811cc373>] SyS_mount+0x83/0xc0
[    1.158207]  [<ffffffff81673cc2>] system_call_fastpath+0x16/0x1b
[    1.158207] ---[ end trace 61981bc62de9f6f4 ]---

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efi/efi-pstore.c | 145 +++++++++++++++++++++++++++++++++++---
 drivers/firmware/efi/efivars.c    |   3 +-
 drivers/firmware/efi/vars.c       |  39 +++-------
 include/linux/efi.h               |   4 +-
 4 files changed, 151 insertions(+), 40 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 73de5a9..db96b0d 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -18,14 +18,12 @@ module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
-	efivar_entry_iter_begin();
 	psi->data = NULL;
 	return 0;
 }
 
 static int efi_pstore_close(struct pstore_info *psi)
 {
-	efivar_entry_iter_end();
 	psi->data = NULL;
 	return 0;
 }
@@ -38,6 +36,23 @@ struct pstore_read_data {
 	char **buf;
 };
 
+/**
+ * efi_pstore_read_func
+ * @entry: reading entry
+ * @data:  data of the entry
+ *
+ * This function runs in non-atomic context.
+ *
+ * Also, it returns a size of NVRAM entry logged via efi_pstore_write().
+ * pstore in accordance with the returned value as below.
+ *
+ * size > 0: Got data of an entry logged via efi_pstore_write() successfully,
+ *           and pstore filesystem will continue reading subsequent entries.
+ * size == 0: Entry was not logged via efi_pstore_write(),
+ *            and efi_pstore driver will continue reading subsequent entries.
+ * size < 0: Failed to get data of entry logging via efi_pstore_write(),
+ *           and pstore will stop reading entry.
+ */
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
@@ -75,8 +90,9 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		return 0;
 
 	entry->var.DataSize = 1024;
-	__efivar_entry_get(entry, &entry->var.Attributes,
-			   &entry->var.DataSize, entry->var.Data);
+	efivar_entry_get(entry, &entry->var.Attributes,
+			 &entry->var.DataSize, entry->var.Data);
+
 	size = entry->var.DataSize;
 
 	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
@@ -85,11 +101,113 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 	return size;
 }
 
+/**
+ * efi_pstore_scan_sysfs_enter
+ * @entry: scanning entry
+ * @next: next entry
+ * @head: list head
+ */
+static void efi_pstore_scan_sysfs_enter(struct efivar_entry *pos,
+					struct efivar_entry *next,
+					struct list_head *head)
+{
+	pos->scanning = true;
+	if (&next->list != head)
+		next->scanning = true;
+
+	/*
+	 * Release a spin_lock because efi_pstore_read_func() should
+	 * run in non-atomic context to allocate buffer dynamically.
+	 */
+	efivar_entry_iter_end();
+}
+
+/**
+ * __efi_pstore_scan_sysfs_exit
+ * @entry: deleting entry
+ * @turn_off_scanning: Check if a scanning flag should be turned off
+ */
+static inline void __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
+						bool turn_off_scanning)
+{
+	if (entry->deleting) {
+		list_del(&entry->list);
+		efivar_entry_iter_end();
+		efivar_unregister(entry);
+		efivar_entry_iter_begin();
+	} else if (turn_off_scanning)
+		entry->scanning = false;
+}
+
+/**
+ * efi_pstore_scan_sysfs_exit
+ * @pos: scanning entry
+ * @next: next entry
+ * @head: list head
+ * @stop: a flag checking if scanning will stop
+ */
+static void efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
+				       struct efivar_entry *next,
+				       struct list_head *head, bool stop)
+{
+	/* Hold a spinlock to access efivar_entry safely. */
+	efivar_entry_iter_begin();
+	__efi_pstore_scan_sysfs_exit(pos, true);
+	if (stop)
+		__efi_pstore_scan_sysfs_exit(next, &next->list != head);
+}
+
+/**
+ * efi_pstore_sysfs_entry_iter
+ *
+ * @data: function-specific data to pass to callback
+ * @pos: entry to begin iterating from
+ *
+ * You MUST call efivar_enter_iter_begin() before this function, and
+ * efivar_entry_iter_end() afterwards.
+ *
+ * It is possible to begin iteration from an arbitrary entry within
+ * the list by passing @pos. @pos is updated on return to point to
+ * the next entry of the last one passed to efi_pstore_read_func().
+ * To begin iterating from the beginning of the list @pos must be %NULL.
+ */
+static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
+{
+	struct efivar_entry *entry, *n;
+	struct list_head *head = &efivar_sysfs_list;
+	int size = 0;
+
+	if (!*pos) {
+		list_for_each_entry_safe(entry, n, head, list) {
+			efi_pstore_scan_sysfs_enter(entry, n, head);
+
+			size = efi_pstore_read_func(entry, data);
+			efi_pstore_scan_sysfs_exit(entry, n, head, size < 0);
+			if (size)
+				break;
+		}
+		*pos = n;
+		return size;
+	}
+
+	list_for_each_entry_safe_from((*pos), n, head, list) {
+		efi_pstore_scan_sysfs_enter((*pos), n, head);
+
+		size = efi_pstore_read_func((*pos), data);
+		efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
+		if (size)
+			break;
+	}
+	*pos = n;
+	return size;
+}
+
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
 			       char **buf, struct pstore_info *psi)
 {
 	struct pstore_read_data data;
+	ssize_t size;
 
 	data.id = id;
 	data.type = type;
@@ -97,8 +215,11 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.timespec = timespec;
 	data.buf = buf;
 
-	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
-				   (struct efivar_entry **)&psi->data);
+	efivar_entry_iter_begin();
+	size = efi_pstore_sysfs_entry_iter(&data,
+					   (struct efivar_entry **)&psi->data);
+	efivar_entry_iter_end();
+	return size;
 }
 
 static int efi_pstore_write(enum pstore_type_id type,
@@ -169,9 +290,17 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 			return 0;
 	}
 
+	if (entry->scanning) {
+		/*
+		 * Skip deletion because this entry will be deleted
+		 * after scanning is completed.
+		 */
+		entry->deleting = true;
+	} else
+		list_del(&entry->list);
+
 	/* found */
 	__efivar_entry_delete(entry);
-	list_del(&entry->list);
 
 	return 1;
 }
@@ -201,7 +330,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
 	efivar_entry_iter_end();
 
-	if (found)
+	if (found && !entry->scanning)
 		efivar_unregister(entry);
 
 	return 0;
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 8a7432a..831bc5c 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -388,7 +388,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (err)
 		return err;
 
-	efivar_unregister(entry);
+	if (!entry->scanning)
+		efivar_unregister(entry);
 
 	/* It's dead Jim.... */
 	return count;
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 391c67b..573ed92 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -683,8 +683,16 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	if (!found)
 		return NULL;
 
-	if (remove)
-		list_del(&entry->list);
+	if (remove) {
+		if (entry->scanning) {
+			/*
+			 * The entry will be deleted
+			 * after scanning is completed.
+			 */
+			entry->deleting = true;
+		} else
+			list_del(&entry->list);
+	}
 
 	return entry;
 }
@@ -715,33 +723,6 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 EXPORT_SYMBOL_GPL(efivar_entry_size);
 
 /**
- * __efivar_entry_get - call get_variable()
- * @entry: read data for this variable
- * @attributes: variable attributes
- * @size: size of @data buffer
- * @data: buffer to store variable data
- *
- * The caller MUST call efivar_entry_iter_begin() and
- * efivar_entry_iter_end() before and after the invocation of this
- * function, respectively.
- */
-int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
-		       unsigned long *size, void *data)
-{
-	const struct efivar_operations *ops = __efivars->ops;
-	efi_status_t status;
-
-	WARN_ON(!spin_is_locked(&__efivars->lock));
-
-	status = ops->get_variable(entry->var.VariableName,
-				   &entry->var.VendorGuid,
-				   attributes, size, data);
-
-	return efi_status_to_err(status);
-}
-EXPORT_SYMBOL_GPL(__efivar_entry_get);
-
-/**
  * efivar_entry_get - call get_variable()
  * @entry: read data for this variable
  * @attributes: variable attributes
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..1e3388e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -782,6 +782,8 @@ struct efivar_entry {
 	struct efi_variable var;
 	struct list_head list;
 	struct kobject kobj;
+	bool scanning;
+	bool deleting;
 };
 
 extern struct list_head efivar_sysfs_list;
@@ -809,8 +811,6 @@ int __efivar_entry_delete(struct efivar_entry *entry);
 int efivar_entry_delete(struct efivar_entry *entry);
 
 int efivar_entry_size(struct efivar_entry *entry, unsigned long *size);
-int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
-		       unsigned long *size, void *data);
 int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 		     unsigned long *size, void *data);
 int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
-- 
1.8.2.1

