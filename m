Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3LDXvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:51:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36860 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3LDXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:51:52 -0500
Date: Wed, 4 Dec 2013 15:50:41 -0800
Message-Id: <201312042350.rB4NofnB031607@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 and EFI fixes for v3.13-rc3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: cxie@redhat.com, dyoung@redhat.com, hjl.tools@gmail.com,
        hpa@linux.intel.com, hpa@zytor.com, jesse.brandeburg@intel.com,
        kevin.b.smith@intel.com, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, mingo@kernel.org, peterz@infradead.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, tony.luck@intel.com
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 15:50:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to e0f6dec35f9286e78879fe1ac92803fd69fc4fdc:

  x86, bitops: Correct the assembly constraints to testing bitops (2013-12-04 14:31:28 -0800)

Half of these are EFI-related:

The by far biggest change is the change to hold off the deletion of a
sysfs entry while a backend scan is in progress.  This is to avoid
calling kmemdup() while under a spinlock.

The other major change is for each entry in the EFI pstore backend to
get a unique identifier, as required by the pstore filesystem proper.

The other changes are a fix to the recent consolidation and
optimization of using "asm goto" with read-modify-write operation,
which broke the bitops; specifically in such a way that we could end
up generating invalid code.

Finally, a build hack to make sure we compile with -mno-sse.  icc, and
most likely future versions of gcc, can generate SSE instructions
unless we tell it not to.

----------------------------------------------------------------
H. Peter Anvin (2):
      x86-64, build: Always pass in -mno-sse
      x86, bitops: Correct the assembly constraints to testing bitops

Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Matt Fleming (1):
      x86/efi: Fix earlyprintk off-by-one bug

Seiji Aguchi (1):
      efivars, efi-pstore: Hold off deletion of sysfs entry until the scan is completed

 arch/x86/Makefile                    |   8 +-
 arch/x86/include/asm/atomic.h        |   4 +-
 arch/x86/include/asm/atomic64_64.h   |   4 +-
 arch/x86/include/asm/bitops.h        |   6 +-
 arch/x86/include/asm/local.h         |   4 +-
 arch/x86/include/asm/rmwcc.h         |   8 +-
 arch/x86/platform/efi/early_printk.c |   2 +-
 drivers/firmware/efi/efi-pstore.c    | 163 +++++++++++++++++++++++++++++++----
 drivers/firmware/efi/efivars.c       |  12 ++-
 drivers/firmware/efi/vars.c          |  12 ++-
 include/linux/efi.h                  |   4 +
 11 files changed, 190 insertions(+), 37 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41250fb..eda00f9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -31,6 +31,9 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
+        # Don't autogenerate SSE instructions
+	KBUILD_CFLAGS += -mno-sse
+
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
         KBUILD_CFLAGS += -fno-pic
@@ -57,8 +60,11 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
+        # Don't autogenerate SSE instructions
+	KBUILD_CFLAGS += -mno-sse
+
 	# Use -mpreferred-stack-boundary=3 if supported.
-	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
+	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
 
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index da31c8b..b17f4f4 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -77,7 +77,7 @@ static inline void atomic_sub(int i, atomic_t *v)
  */
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, i, "%0", "e");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, "er", i, "%0", "e");
 }
 
 /**
@@ -141,7 +141,7 @@ static inline int atomic_inc_and_test(atomic_t *v)
  */
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, i, "%0", "s");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, "er", i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 3f065c9..46e9052 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -72,7 +72,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
  */
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, i, "%0", "e");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, "er", i, "%0", "e");
 }
 
 /**
@@ -138,7 +138,7 @@ static inline int atomic64_inc_and_test(atomic64_t *v)
  */
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, i, "%0", "s");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, "er", i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 6d76d09..9fc1af7 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -205,7 +205,7 @@ static inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, nr, "%0", "c");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", "c");
 }
 
 /**
@@ -251,7 +251,7 @@ static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, nr, "%0", "c");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", "c");
 }
 
 /**
@@ -304,7 +304,7 @@ static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, nr, "%0", "c");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", "c");
 }
 
 static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 5b23e60..4ad6560 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -52,7 +52,7 @@ static inline void local_sub(long i, local_t *l)
  */
 static inline int local_sub_and_test(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, i, "%0", "e");
+	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, "er", i, "%0", "e");
 }
 
 /**
@@ -92,7 +92,7 @@ static inline int local_inc_and_test(local_t *l)
  */
 static inline int local_add_negative(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, i, "%0", "s");
+	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, "er", i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 1ff990f..8f7866a 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -16,8 +16,8 @@ cc_label:								\
 #define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
 	__GEN_RMWcc(op " " arg0, var, cc)
 
-#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
-	__GEN_RMWcc(op " %1, " arg0, var, cc, "er" (val))
+#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
+	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
 
 #else /* !CC_HAVE_ASM_GOTO */
 
@@ -33,8 +33,8 @@ do {									\
 #define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
 	__GEN_RMWcc(op " " arg0, var, cc)
 
-#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, "er" (val))
+#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
+	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
 
 #endif /* CC_HAVE_ASM_GOTO */
 
diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
index 6599a00..81b506d 100644
--- a/arch/x86/platform/efi/early_printk.c
+++ b/arch/x86/platform/efi/early_printk.c
@@ -142,7 +142,7 @@ early_efi_write(struct console *con, const char *str, unsigned int num)
 			efi_y += font->height;
 		}
 
-		if (efi_y + font->height >= si->lfb_height) {
+		if (efi_y + font->height > si->lfb_height) {
 			u32 i;
 
 			efi_y -= font->height;
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 5002d50..743fd42 100644
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
@@ -39,6 +37,12 @@ struct pstore_read_data {
 	char **buf;
 };
 
+static inline u64 generic_id(unsigned long timestamp,
+			     unsigned int part, int count)
+{
+	return (timestamp * 100 + part) * 1000 + count;
+}
+
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
@@ -57,7 +61,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 
 	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
 		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -67,7 +71,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 			*cb_data->compressed = false;
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -79,7 +83,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		 * which doesn't support holding
 		 * multiple logs, remains.
 		 */
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, 0);
 		*cb_data->count = 0;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -91,19 +95,125 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 	__efivar_entry_get(entry, &entry->var.Attributes,
 			   &entry->var.DataSize, entry->var.Data);
 	size = entry->var.DataSize;
+	memcpy(*cb_data->buf, entry->var.Data,
+	       (size_t)min_t(unsigned long, EFIVARS_DATA_SIZE_MAX, size));
 
-	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
-	if (*cb_data->buf == NULL)
-		return -ENOMEM;
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
+/**
+ * efi_pstore_read
+ *
+ * This function returns a size of NVRAM entry logged via efi_pstore_write().
+ * The meaning and behavior of efi_pstore/pstore are as below.
+ *
+ * size > 0: Got data of an entry logged via efi_pstore_write() successfully,
+ *           and pstore filesystem will continue reading subsequent entries.
+ * size == 0: Entry was not logged via efi_pstore_write(),
+ *            and efi_pstore driver will continue reading subsequent entries.
+ * size < 0: Failed to get data of entry logging via efi_pstore_write(),
+ *           and pstore will stop reading entry.
+ */
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
 			       char **buf, bool *compressed,
 			       struct pstore_info *psi)
 {
 	struct pstore_read_data data;
+	ssize_t size;
 
 	data.id = id;
 	data.type = type;
@@ -112,8 +222,17 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.compressed = compressed;
 	data.buf = buf;
 
-	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
-				   (struct efivar_entry **)&psi->data);
+	*data.buf = kzalloc(EFIVARS_DATA_SIZE_MAX, GFP_KERNEL);
+	if (!*data.buf)
+		return -ENOMEM;
+
+	efivar_entry_iter_begin();
+	size = efi_pstore_sysfs_entry_iter(&data,
+					   (struct efivar_entry **)&psi->data);
+	efivar_entry_iter_end();
+	if (size <= 0)
+		kfree(*data.buf);
+	return size;
 }
 
 static int efi_pstore_write(enum pstore_type_id type,
@@ -184,9 +303,17 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
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
@@ -199,14 +326,16 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	int found, i;
+	unsigned int part;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
+	do_div(id, 1000);
+	part = do_div(id, 100);
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	edata.id = id;
+	edata.id = part;
 	edata.type = type;
 	edata.count = count;
 	edata.time = time;
@@ -214,10 +343,12 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 	efivar_entry_iter_begin();
 	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
-	efivar_entry_iter_end();
 
-	if (found)
+	if (found && !entry->scanning) {
+		efivar_entry_iter_end();
 		efivar_unregister(entry);
+	} else
+		efivar_entry_iter_end();
 
 	return 0;
 }
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 933eb02..3dc2482 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -383,12 +383,16 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	else if (__efivar_entry_delete(entry))
 		err = -EIO;
 
-	efivar_entry_iter_end();
-
-	if (err)
+	if (err) {
+		efivar_entry_iter_end();
 		return err;
+	}
 
-	efivar_unregister(entry);
+	if (!entry->scanning) {
+		efivar_entry_iter_end();
+		efivar_unregister(entry);
+	} else
+		efivar_entry_iter_end();
 
 	/* It's dead Jim.... */
 	return count;
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 391c67b..b22659c 100644
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index bc5687d..11ce678 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -801,6 +801,8 @@ struct efivar_entry {
 	struct efi_variable var;
 	struct list_head list;
 	struct kobject kobj;
+	bool scanning;
+	bool deleting;
 };
 
 
@@ -866,6 +868,8 @@ void efivar_run_worker(void);
 #if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
 int efivars_sysfs_init(void);
 
+#define EFIVARS_DATA_SIZE_MAX 1024
+
 #endif /* CONFIG_EFI_VARS */
 
 #endif /* _LINUX_EFI_H */
