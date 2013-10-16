Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab3JPNvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:51:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60963 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934297Ab3JPNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:51:29 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Wed, 16 Oct 2013 14:51:00 +0100
Message-Id: <1381931460-6999-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The EFI capsule mechanism allows data blobs to be passed to the EFI
firmware. By setting the EFI_CAPSULE_POPULATE_SYSTEM_TABLE and the
EFI_CAPSULE_PERSIST_ACROSS_REBOOT flags, the firmware will place a
pointer to our data blob in the EFI System Table on the next boot. We
can get access to the array of EFI capsules when parsing the
configuration tables the next time we boot.

We can utilise this facility to save crash dumps, call traces, etc in a
region of memory and have them preserved by the firmware across a
reboot.

Once a capsule has been passed to the firmware, the next reboot will
always be performed using the ResetSystem() EFI runtime service, which
may involve overriding the reboot type specified by reboot=. This
ensures the reset value returned by QueryCapsuleCapabilities() is used
to reset the system, which is required for the capsule to be processed.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/reboot.c       |   7 +
 drivers/firmware/efi/Kconfig   |  19 +
 drivers/firmware/efi/Makefile  |   1 +
 drivers/firmware/efi/capsule.c | 802 +++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c     |   4 +
 drivers/firmware/efi/reboot.c  |  12 +
 include/linux/efi.h            |  17 +
 7 files changed, 862 insertions(+)
 create mode 100644 drivers/firmware/efi/capsule.c

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 78a1c67..af540a0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -458,6 +458,13 @@ static void native_machine_emergency_restart(void)
 	mode = reboot_mode == REBOOT_WARM ? 0x1234 : 0;
 	*((unsigned short *)__va(0x472)) = mode;
 
+	/*
+	 * If an EFI capsule has been registered with the firmware then
+	 * override the reboot= parameter.
+	 */
+	if (efi_capsule_pending(NULL))
+		reboot_type = BOOT_EFI;
+
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index b0fc7c7..62ace0e 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -36,4 +36,23 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 	  backend for pstore by default. This setting can be overridden
 	  using the efivars module's pstore_disable parameter.
 
+config EFI_CAPSULE_PSTORE
+	bool "EFI capsule pstore backend"
+	depends on EFI && PSTORE
+	help
+	  The EFI capsule mechanism can be used to store crash dumps and
+	  function tracing data by passing the data to the firmware, which
+	  will be preserved across a reboot.
+
+	  It should be noted that enabling this opton will pass a capsule
+	  to the firmware on every boot. Some firmware will not allow a
+	  user to enter the BIOS setup when a capsule has been registered
+	  on the previous boot.
+
+	  Many EFI machines have buggy implementations of the UpdateCapsule()
+	  runtime service. This option will enable code that may not function
+	  correctly with your firmware.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 6375e14..102d6e4 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -4,3 +4,4 @@
 obj-y					+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_EFI_CAPSULE_PSTORE)	+= capsule.o
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
new file mode 100644
index 0000000..89f054e
--- /dev/null
+++ b/drivers/firmware/efi/capsule.c
@@ -0,0 +1,802 @@
+/*
+ * EFI capsule support.
+ *
+ * Copyright 2013 Intel Corporation <matt.fleming@intel.com>
+ *
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License version 2.
+ */
+
+#define pr_fmt(fmt) "efi-capsule: " fmt
+
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/highmem.h>
+#include <linux/efi.h>
+
+typedef struct {
+	u64 length;
+	u64 data;
+} efi_capsule_block_desc_t;
+
+static bool capsule_pending;
+static int efi_reset_type = -1;
+
+/*
+ * capsule_mutex serialises access to both 'capsule_pending' and
+ * 'efi_reset_type'.
+ *
+ * This mutex must be held across calls to efi_capsule_supported() and
+ * efi_update_capsule() so that the operation is atomic. This ensures
+ * that efi_update_capsule() isn't called with a capsule that requires a
+ * different reset type to the registered 'efi_reset_type'.
+ */
+static DEFINE_MUTEX(capsule_mutex);
+
+static int efi_update_capsule(efi_capsule_header_t *capsule,
+			      struct page **pages, size_t size, int reset);
+
+/**
+ * efi_capsule_pending - has a capsule been passed to the firmware?
+ * @reset_type: store the type of EFI reset if capsule is pending
+ *
+ * To ensure that the registered capsule is processed correctly by the
+ * firmware we need to perform a specific type of reset. If a capsule is
+ * pending return the reset type in @reset_type.
+ */
+bool efi_capsule_pending(int *reset_type)
+{
+	bool rv = false;
+
+	mutex_lock(&capsule_mutex);
+	if (!capsule_pending)
+		goto out;
+
+	if (reset_type)
+		*reset_type = efi_reset_type;
+	rv = true;
+
+out:
+	mutex_unlock(&capsule_mutex);
+	return rv;
+}
+
+/**
+ * efi_capsule_supported - does the firmware support the capsule?
+ * @guid: vendor guid of capsule
+ * @flags: capsule flags
+ * @size: size of capsule data
+ * @reset: the reset type required for this capsule
+ *
+ * Check whether a capsule with @flags is supported and that @size
+ * doesn't exceed the maximum size for a capsule, and that the reset
+ * type of the capsule is compatible with any that have previously been
+ * registered.
+ *
+ * We must be called with capsule_mutex held.
+ */
+static int efi_capsule_supported(efi_guid_t guid, u32 flags,
+				 size_t size, int *reset)
+{
+	efi_capsule_header_t *capsule;
+	efi_status_t status;
+	u64 max_size;
+	int rv = 0;
+
+	capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
+	if (!capsule)
+		return -ENOMEM;
+
+	capsule->headersize = capsule->imagesize = sizeof(*capsule);
+	memcpy(&capsule->guid, &guid, sizeof(efi_guid_t));
+	capsule->flags = flags;
+
+	status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
+	if (status != EFI_SUCCESS) {
+		rv = efi_status_to_err(status);
+		goto out;
+	}
+
+	if (size > max_size) {
+		rv = -ENOSPC;
+		goto out;
+	}
+
+	if (efi_reset_type >= 0 && efi_reset_type != *reset) {
+		pr_err("Incompatible capsule reset type %d\n", *reset);
+		rv = -EINVAL;
+	}
+
+out:
+	kfree(capsule);
+	return rv;
+}
+
+struct efi_capsule_ctx {
+	struct page **pages;
+	unsigned int nr_pages;
+	efi_capsule_header_t *capsule;
+	size_t capsule_size;
+	void *data;
+	size_t data_size;
+};
+
+struct efi_capsule_pstore_buf {
+	void *data;
+	size_t size;
+	atomic_long_t offset;
+};
+
+struct efi_capsule_pstore {
+	/* Previous records */
+	efi_capsule_header_t **hdrs;
+	uint32_t nr_hdrs;
+	uint32_t hdr_index;	/* Index of current header in 'hdrs' */
+	off_t hdr_offset;	/* Offset into current header */
+
+	/* New records */
+	struct efi_capsule_pstore_buf console;
+	struct efi_capsule_pstore_buf ftrace;
+	struct efi_capsule_pstore_buf dmesg;
+};
+
+struct efi_capsule_pstore_record {
+	u64 timestamp;
+	u64 id;
+	enum pstore_type_id type;
+	size_t size;
+	int count;
+	bool inuse;
+	char data[];
+} __packed;
+
+static struct pstore_info efi_capsule_info;
+
+/**
+ * efi_build_pstore_capsule - alloc capsule and send to firmware
+ * @size: size in bytes of the capsule data
+ *
+ * This is a helper function for allocating enough room for user data
+ * + the size of an EFI capsule header, and passing that capsule to the
+ * firmware.
+ *
+ * Returns a pointer to the capsule on success, an ERR_PTR() value on
+ * error. If an error is returned we guarantee that the capsule has not
+ * been passed to the firmware.
+ */
+static efi_capsule_header_t *
+efi_build_pstore_capsule(size_t size)
+{
+	efi_capsule_header_t *capsule = NULL;
+	unsigned int nr_pages = 0;
+	size_t capsule_size;
+	struct page **pages;
+	int i, rv = -ENOMEM;
+	int reset_type;
+	efi_guid_t guid = LINUX_EFI_CRASH_GUID;
+	u32 flags = EFI_CAPSULE_PERSIST_ACROSS_RESET |
+		EFI_CAPSULE_POPULATE_SYSTEM_TABLE;
+
+	capsule_size = size + sizeof(*capsule);
+
+	mutex_lock(&capsule_mutex);
+	rv = efi_capsule_supported(guid, flags, capsule_size, &reset_type);
+	if (rv) {
+		mutex_unlock(&capsule_mutex);
+		return ERR_PTR(rv);
+	}
+
+	nr_pages = ALIGN(capsule_size, PAGE_SIZE) >> PAGE_SHIFT;
+	pages = kzalloc(nr_pages * sizeof(void *), GFP_KERNEL);
+	if (!pages)
+		goto fail;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page;
+
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			goto fail;
+
+		pages[i] = page;
+	}
+
+	capsule = vmap(pages, nr_pages, 0, PAGE_KERNEL);
+	if (!capsule)
+		goto fail;
+
+	/*
+	 * Setup the EFI capsule header.
+	 */
+	memcpy(&capsule->guid, &guid, sizeof(guid));
+
+	capsule->headersize = sizeof(*capsule);
+	capsule->imagesize = capsule_size;
+	capsule->flags = flags;
+
+	memset((void *)capsule + capsule->headersize, 0, size);
+
+	rv = efi_update_capsule(capsule, pages, capsule_size, reset_type);
+	if (rv)
+		goto fail;
+
+out:
+	mutex_unlock(&capsule_mutex);
+	kfree(pages);
+	return capsule;
+
+fail:
+	vunmap(capsule);
+	for (i = 0; i < nr_pages; i++) {
+		if (!pages[i])
+			break;
+
+		__free_page(pages[i]);
+	}
+	capsule = ERR_PTR(rv);
+	goto out;
+}
+
+/**
+ * efi_capsule_lookup - search capsule array for entries.
+ * @caps: the array of capsules to search.
+ * @nr_caps: the number of capsules in @caps.
+ * @guid: the guid to search for.
+ * @nr_found: the number of entries found.
+ *
+ * Map each capsule header into the kernel's virtual address space and
+ * inspect the guid. Build an array of capsule headers with every
+ * capsule that is found with @guid. If a match is found the capsule
+ * remains mapped, otherwise it is unmapped.
+ *
+ * Returns an array of capsule headers, each element of which has the
+ * guid @guid. The number of elements in the array is stored in
+ * @nr_found. Returns %NULL and stores zero in @nr_found if no capsules
+ * were found.
+ */
+static efi_capsule_header_t **
+efi_capsule_lookup(efi_capsule_header_t **caps, uint32_t nr_caps,
+		   efi_guid_t guid, uint32_t *nr_found)
+{
+	efi_capsule_header_t **capsules = NULL;
+	size_t capsules_size = 0;
+	int i;
+
+	*nr_found = 0;
+	for (i = 0; i < nr_caps; i++) {
+		efi_capsule_header_t *c;
+		size_t size;
+
+		c = ioremap((resource_size_t)caps[i], sizeof(*c));
+		if (!c) {
+			pr_err("failed to ioremap capsule\n");
+			goto fail;
+		}
+
+		size = c->imagesize;
+		iounmap(c);
+
+		c = ioremap((resource_size_t)caps[i], size);
+		if (!c) {
+			pr_err("failed to ioremap header + data\n");
+			goto fail;
+		}
+
+		if (!efi_guidcmp(c->guid, guid)) {
+			void *new;
+
+			capsules_size += sizeof(**capsules);
+			new = krealloc(capsules, capsules_size, GFP_KERNEL);
+			if (!new) {
+				pr_err("failed to realloc capsule array\n");
+				iounmap(c);
+				goto fail;
+			}
+
+			capsules = new;
+			capsules[(*nr_found)++] = c;
+			continue;
+		}
+
+		iounmap(c);
+	}
+
+	return capsules;
+
+fail:
+	for (i = 0; i < *nr_found; i++)
+		iounmap(capsules[i]);
+	*nr_found = 0;
+
+	kfree(capsules);
+	return ERR_PTR(-ENOMEM);
+}
+
+static efi_capsule_header_t *
+efi_setup_pstore_buffer(struct efi_capsule_pstore_buf *buf,
+			size_t size, enum pstore_type_id type)
+{
+	struct efi_capsule_pstore_record *rec;
+	efi_capsule_header_t *capsule;
+
+	capsule = efi_build_pstore_capsule(size);
+	if (IS_ERR(capsule))
+		return capsule;
+
+	rec = (void *)capsule + capsule->headersize;
+	rec->size = size - offsetof(typeof(*rec), data);
+	rec->type = type;
+
+	rec->inuse = false;
+
+	buf->size = rec->size;
+	atomic_long_set(&buf->offset, 0);
+	buf->data = rec->data;
+
+	return capsule;
+}
+
+/*
+ * We may not be in a position to allocate memory at the time of a
+ * crash, so pre-allocate some space now and register it with the
+ * firmware via efi_capsule_update().
+ *
+ * Also, iterate through the array of capsules pointed to from the EFI
+ * system table and take note of any LINUX_EFI_CRASH_GUID
+ * capsules. They will be parsed by efi_capsule_pstore_read().
+ */
+static int efi_capsule_pstore_setup(void)
+{
+	struct efi_capsule_pstore *pctx = NULL;
+	struct efi_capsule_pstore_buf *buf;
+	efi_capsule_header_t *capsule;
+	void *crash_buf = NULL;
+	size_t size, crash_size;
+	int rv;
+
+	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
+	if (!pctx)
+		return -ENOMEM;
+
+	size = 65536;
+	capsule = efi_build_pstore_capsule(size);
+	if (IS_ERR(capsule)) {
+		rv = PTR_ERR(capsule);
+		goto fail;
+	}
+
+	pctx->dmesg.data = (void *)capsule + capsule->headersize;
+	atomic_long_set(&pctx->dmesg.offset, 0);
+	pctx->dmesg.size = size;
+
+	buf = &pctx->console;
+	capsule = efi_setup_pstore_buffer(buf, size, PSTORE_TYPE_CONSOLE);
+	if (IS_ERR(capsule)) {
+		rv = PTR_ERR(capsule);
+		goto fail;
+	}
+
+	buf = &pctx->ftrace;
+	capsule = efi_setup_pstore_buffer(buf, size, PSTORE_TYPE_FTRACE);
+	if (IS_ERR(capsule)) {
+		rv = PTR_ERR(capsule);
+		goto fail;
+	}
+
+	crash_size = 4096;
+	crash_buf = kmalloc(crash_size, GFP_KERNEL);
+	if (!crash_buf) {
+		rv = -ENOMEM;
+		goto fail;
+	}
+
+	/*
+	 * Register the capsule backend with pstore.
+	 */
+	spin_lock_init(&efi_capsule_info.buf_lock);
+
+	efi_capsule_info.buf = crash_buf;
+	efi_capsule_info.bufsize = crash_size;
+	efi_capsule_info.data = pctx;
+
+	rv = pstore_register(&efi_capsule_info);
+	if (rv) {
+		pr_err("pstore registration failed: %d\n", rv);
+		goto fail;
+	}
+
+	return rv;
+
+fail:
+	kfree(crash_buf);
+	kfree(pctx);
+	return rv;
+}
+
+static int efi_capsule_pstore_open(struct pstore_info *psi)
+{
+	struct efi_capsule_pstore *pctx = psi->data;
+	efi_capsule_header_t **capsules;
+	uint32_t nr_capsules;
+	size_t size;
+	void *cap;
+	int rv = 0;
+
+	/*
+	 * Read any pstore entries that were passed across a reboot.
+	 */
+	if (efi.capsule == EFI_INVALID_TABLE_ADDR)
+		return -ENODEV;
+
+	cap = ioremap(efi.capsule, sizeof(nr_capsules));
+	if (!cap)
+		return -ENOMEM;
+
+	/*
+	 * The array of capsules is prefixed with the number of
+	 * capsule entries in the array.
+	 */
+	nr_capsules = *(uint32_t *)cap;
+	iounmap(cap);
+
+	if (!nr_capsules)
+		return -ENODEV;
+
+	size = nr_capsules * sizeof(*cap);
+	cap = ioremap(efi.capsule, size);
+	if (!cap)
+		return -ENOMEM;
+
+	capsules = cap + sizeof(uint32_t *);
+
+	pctx->hdrs = efi_capsule_lookup(capsules, nr_capsules,
+					LINUX_EFI_CRASH_GUID,
+					&pctx->nr_hdrs);
+	if (IS_ERR(pctx->hdrs)) {
+		rv = PTR_ERR(pctx->hdrs);
+		pctx->hdrs = NULL;
+	}
+
+	iounmap(cap);
+	return rv;
+}
+
+static int efi_capsule_pstore_close(struct pstore_info *psi)
+{
+	struct efi_capsule_pstore *pctx = psi->data;
+	int i;
+
+	for (i = 0; i < pctx->nr_hdrs; i++)
+		iounmap(pctx->hdrs[i]);
+
+	pctx->nr_hdrs = 0;
+	pctx->hdr_index = 0;
+	kfree(pctx->hdrs);
+
+	return 0;
+}
+
+/*
+ * Return the next pstore record that was passed to us across a reboot
+ * in an EFI capsule.
+ *
+ * This is expected to be called under the pstore
+ * read_mutex. Therefore, no serialisation is done here.
+ */
+static struct efi_capsule_pstore_record *
+get_pstore_read_record(struct efi_capsule_pstore *pctx)
+{
+	struct efi_capsule_pstore_record *rec;
+	efi_capsule_header_t *hdr;
+	off_t remaining;
+
+next:
+	if (pctx->hdr_index == pctx->nr_hdrs)
+		return NULL;
+
+	hdr = pctx->hdrs[pctx->hdr_index];
+	rec = (void *)hdr + hdr->headersize + pctx->hdr_offset;
+
+	remaining = hdr->imagesize - hdr->headersize -
+		pctx->hdr_offset - offsetof(typeof(*rec), data);
+
+	/*
+	 * A single EFI capsule may contain multiple pstore records, but
+	 * there is no guarantee it will be filled completely, so we
+	 * need to handle partial records.
+	 *
+	 * If there are no more entries in this capsule try the next.
+	 */
+	if (!rec->inuse) {
+		pctx->hdr_index++;
+		pctx->hdr_offset = 0;
+		goto next;
+	}
+
+	/*
+	 * If we've finished parsing all records in this capsule, move
+	 * onto the next. Otherwise, increment the offset into the
+	 * current capsule (pctx->hdr_offset).
+	 */
+	if (rec->size == remaining) {
+		pctx->hdr_index++;
+		pctx->hdr_offset = 0;
+	} else
+		pctx->hdr_offset += rec->size + offsetof(typeof(*rec), data);
+
+	return rec;
+}
+
+static ssize_t efi_capsule_pstore_read(u64 *id, enum pstore_type_id *type,
+				       int *count, struct timespec *time,
+				       char **buf, struct pstore_info *psi)
+{
+	struct efi_capsule_pstore_record *rec;
+	struct efi_capsule_pstore *pctx = psi->data;
+	ssize_t size;
+
+	rec = get_pstore_read_record(pctx);
+	if (!rec)
+		return 0;
+
+	*type = rec->type;
+	time->tv_sec = rec->timestamp;
+	time->tv_nsec = 0;
+	size = rec->size;
+	*id = rec->id;
+	*count = rec->count;
+
+	*buf = kmalloc(size, GFP_KERNEL);
+	if (!*buf)
+		return -ENOMEM;
+
+	memcpy(*buf, rec->data, size);
+
+	return size;
+}
+
+/*
+ * We expect to be called with ->buf_lock held, and so don't perform
+ * any serialisation.
+ */
+static struct notrace efi_capsule_pstore_record *
+get_pstore_write_record(struct efi_capsule_pstore_buf *pbuf, size_t size)
+{
+	struct efi_capsule_pstore_record *rec;
+	long offset = atomic_long_read(&pbuf->offset);
+
+	if (offset + size > pbuf->size)
+		return NULL;
+
+	rec = pbuf->data + offset;
+
+	atomic_long_add(offsetof(typeof(*rec), data) + size, &pbuf->offset);
+	rec->inuse = true;
+
+	return rec;
+}
+
+static int notrace
+efi_capsule_pstore_write(enum pstore_type_id type,
+			 enum kmsg_dump_reason reason, u64 *id,
+			 unsigned int part, int count, size_t hsize,
+			 size_t size, struct pstore_info *psi)
+{
+	struct efi_capsule_pstore_record *rec;
+	struct efi_capsule_pstore *pctx = psi->data;
+
+	if (!size)
+		return -EINVAL;
+
+	rec = get_pstore_write_record(&pctx->dmesg, size);
+	if (!rec)
+		return -ENOSPC;
+
+	rec->type = type;
+	rec->timestamp = get_seconds();
+	rec->size = size;
+	*id = rec->id = part;
+	rec->count = count;
+	memcpy(rec->data, psi->buf, size);
+
+	return 0;
+}
+
+static inline void buf_inuse(struct efi_capsule_pstore_buf *pbuf)
+{
+	struct efi_capsule_pstore_record *rec;
+
+	rec = pbuf->data - sizeof(*rec);
+	rec->inuse = true;
+}
+
+static notrace void *
+get_pstore_buf(struct efi_capsule_pstore_buf *pbuf, size_t size)
+{
+	long next, curr;
+
+	if (size > pbuf->size)
+		return NULL;
+
+	buf_inuse(pbuf);
+
+	do {
+		curr = atomic_long_read(&pbuf->offset);
+		next = curr + size;
+
+		/* Wrap? */
+		if (next > pbuf->size) {
+			next = size;
+			if (atomic_long_cmpxchg(&pbuf->offset, curr, next)) {
+				curr = 0;
+				break;
+			}
+
+			continue;
+		}
+
+	} while (atomic_long_cmpxchg(&pbuf->offset, curr, next) != curr);
+
+	return pbuf->data + curr;
+}
+
+static int notrace
+efi_capsule_pstore_write_buf(enum pstore_type_id type,
+			     enum kmsg_dump_reason reason,
+			     u64 *id, unsigned int part,
+			     const char *buf, size_t hsize,
+			     size_t size, struct pstore_info *psi)
+{
+	struct efi_capsule_pstore *pctx = psi->data;
+	void *dst;
+
+	if (type == PSTORE_TYPE_FTRACE)
+		dst = get_pstore_buf(&pctx->ftrace, size);
+	else if (type == PSTORE_TYPE_CONSOLE)
+		dst = get_pstore_buf(&pctx->console, size);
+	else
+		return -EINVAL;
+
+	if (!dst)
+		return -ENOSPC;
+
+	memcpy(dst, buf, size);
+	return 0;
+}
+
+static struct pstore_info efi_capsule_info = {
+	.owner     = THIS_MODULE,
+	.name      = "capsule",
+	.open      = efi_capsule_pstore_open,
+	.close     = efi_capsule_pstore_close,
+	.read      = efi_capsule_pstore_read,
+	.write     = efi_capsule_pstore_write,
+	.write_buf = efi_capsule_pstore_write_buf,
+};
+
+#define BLOCKS_PER_PAGE	(PAGE_SIZE / sizeof(efi_capsule_block_desc_t))
+
+/*
+ * How many pages of block descriptors do we need to map 'nr_pages'?
+ *
+ * Every list of block descriptors in a page must end with a
+ * continuation pointer. The last continuation pointer of the lage page
+ * must be zero to mark the end of the chain.
+ */
+static inline unsigned int num_block_pages(unsigned int nr_pages)
+{
+	return DIV_ROUND_UP(nr_pages, BLOCKS_PER_PAGE - 1);
+}
+
+/**
+ * efi_update_capsule - pass a single capsule to the firmware.
+ * @capsule: capsule to send to the firmware.
+ * @pages: an array of capsule data.
+ * @size: total size of capsule data + headers in @capsule.
+ * @reset: the reset type required for @capsule
+ *
+ * Map @capsule with EFI capsule block descriptors in PAGE_SIZE chunks.
+ * @size needn't necessarily be a multiple of PAGE_SIZE - we can handle
+ * a trailing chunk that is smaller than PAGE_SIZE.
+ *
+ * @capsule MUST be virtually contiguous.
+ *
+ * Return 0 on success.
+ */
+static int efi_update_capsule(efi_capsule_header_t *capsule,
+			      struct page **pages, size_t size, int reset)
+{
+	efi_capsule_block_desc_t *block = NULL;
+	struct page **block_pgs, *page;
+	efi_status_t status;
+	unsigned int nr_data_pgs, nr_block_pgs;
+	int i, j, err = -ENOMEM;
+
+	nr_data_pgs = DIV_ROUND_UP(size, PAGE_SIZE);
+	nr_block_pgs = num_block_pages(nr_data_pgs);
+
+	block_pgs = kzalloc(nr_block_pgs * sizeof(page), GFP_KERNEL);
+	if (!block_pgs)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_block_pgs; i++) {
+		block_pgs[i] = alloc_page(GFP_KERNEL);
+		if (!block_pgs[i])
+			goto fail;
+	}
+
+	page = pages[0];
+	for (i = 0; i < nr_block_pgs; i++) {
+		block = kmap(block_pgs[i]);
+		if (!block)
+			goto fail;
+
+		for (j = 0; j < BLOCKS_PER_PAGE - 1 && nr_data_pgs > 0; j++) {
+			u64 sz = min_t(u64, size, PAGE_SIZE);
+
+			block[j].length = sz;
+			block[j].data = page_to_phys(page);
+
+			size -= sz;
+			nr_data_pgs--;
+			page++;
+		}
+
+		/* Continuation pointer */
+		block[j].length = 0;
+
+		if (i + 1 == nr_block_pgs)
+			block[j].data = 0;
+		else
+			block[j].data = page_to_phys(block_pgs[i + 1]);
+
+		kunmap(block_pgs[i]);
+	}
+
+	status = efi.update_capsule(&capsule, 1, page_to_phys(block_pgs[0]));
+	if (status != EFI_SUCCESS) {
+		pr_err("update_capsule fail: 0x%lx\n", status);
+		err = efi_status_to_err(status);
+		goto fail;
+	}
+
+	capsule_pending = true;
+	efi_reset_type = reset;
+
+	kfree(block_pgs);
+	return 0;
+
+fail:
+	for (i = 0; i < nr_block_pgs; i++) {
+		if (block_pgs[i])
+			__free_page(block_pgs[i]);
+	}
+
+	kfree(block_pgs);
+	return err;
+}
+
+/*
+ * efi_capsule_init - initialise the EFI capsule system
+ */
+static __init int efi_capsule_init(void)
+{
+	int rv, reset;
+	u32 flags = EFI_CAPSULE_PERSIST_ACROSS_RESET |
+		EFI_CAPSULE_POPULATE_SYSTEM_TABLE;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
+	mutex_lock(&capsule_mutex);
+	rv = efi_capsule_supported(LINUX_EFI_CRASH_GUID, flags, 0, &reset);
+	mutex_unlock(&capsule_mutex);
+
+	if (rv)
+		return rv;
+
+	efi_capsule_pstore_setup();
+
+	return 0;
+}
+device_initcall(efi_capsule_init);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 772f559..46a96a3 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -32,6 +32,7 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.capsule    = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -72,6 +73,8 @@ static ssize_t systab_show(struct kobject *kobj,
 		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
 	if (efi.uga != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
+	if (efi.capsule != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "CAPSULE=0x%lx\n", efi.capsule);
 
 	return str - buf;
 }
@@ -198,6 +201,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
 	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
+	{LINUX_EFI_CRASH_GUID, "CAPSULE", &efi.capsule},
 	{NULL_GUID, NULL, 0},
 };
 
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index f9f34eb..d6ea42a 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -10,6 +10,9 @@
 
 void efi_reboot(int mode)
 {
+	const char *str[] = { "cold", "warm", "shutdown", "platform" };
+	int cap_reset_mode;
+
 	switch (mode) {
 	case EFI_RESET_COLD:
 	case EFI_RESET_WARM:
@@ -21,5 +24,14 @@ void efi_reboot(int mode)
 		return;
 	}
 
+	if (efi_capsule_pending(&cap_reset_mode)) {
+		if (mode != cap_reset_mode)
+			printk("efi: %s reset requested but pending capsule "
+			       "update requires %s reset... Performing "
+			       "%s reset\n", str[mode], str[cap_reset_mode],
+			       str[cap_reset_mode]);
+		mode = cap_reset_mode;
+	}
+
 	efi.reset_system(mode, EFI_SUCCESS, 0, NULL);
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6a10640..5ce71ca 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -117,6 +117,13 @@ typedef struct {
 } efi_capsule_header_t;
 
 /*
+ * EFI capsule flags
+ */
+#define EFI_CAPSULE_PERSIST_ACROSS_RESET	0x00010000
+#define EFI_CAPSULE_POPULATE_SYSTEM_TABLE	0x00020000
+#define EFI_CAPSULE_INITIATE_RESET		0x00040000
+
+/*
  * Allocation types for calls to boottime->allocate_pages.
  */
 #define EFI_ALLOCATE_ANY_PAGES		0
@@ -557,6 +564,7 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long capsule;		/* EFI capsule table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
@@ -905,4 +913,13 @@ int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
+#ifdef CONFIG_EFI_CAPSULE_PSTORE
+extern bool efi_capsule_pending(int *reset_type);
+#else
+static inline bool efi_capsule_pending(int *reset_type)
+{
+	return false;
+}
+#endif /* CONFIG_EFI_CAPSULE_PSTORE */
+
 #endif /* _LINUX_EFI_H */
-- 
1.8.1.4

