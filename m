Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3DYKS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:18:56 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38878 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab3DYKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:18:51 -0400
Subject: [PATCH v3 4/8] powerpc/pseries: Read/Write oops nvram partition via
 pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Thu, 25 Apr 2013 15:48:37 +0530
Message-ID: <20130425101837.21017.97072.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042510-0260-0000-0000-000002DD714F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IBM's p series machines provide persistent storage for LPARs through NVRAM.
NVRAM's lnx,oops-log partition is used to log oops messages.
Currently the kernel provides the contents of p-series NVRAM only as a
simple stream of bytes via /dev/nvram, which must be interpreted in user
space by the nvram command in the powerpc-utils package.

This patch set exploits the pstore subsystem to expose oops partition in
NVRAM as a separate file in /dev/pstore. For instance, Oops messages will be
stored in a file named [dmesg-nvram-2]. In case pstore registration fails it
will fall back to kmsg_dump mechanism.

This patch will read/write the oops messages from/to this partition via pstore.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |  172 +++++++++++++++++++++++++++++---
 1 file changed, 157 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 088f023..9edec8e 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/kmsg_dump.h>
+#include <linux/pstore.h>
 #include <linux/ctype.h>
 #include <linux/zlib.h>
 #include <asm/uaccess.h>
@@ -127,6 +128,14 @@ static size_t oops_data_sz;
 #define MEM_LEVEL 4
 static struct z_stream_s stream;
 
+#ifdef CONFIG_PSTORE
+static enum pstore_type_id nvram_type_ids[] = {
+	PSTORE_TYPE_DMESG,
+	-1
+};
+static int read_type;
+#endif
+
 static ssize_t pSeries_nvram_read(char *buf, size_t count, loff_t *index)
 {
 	unsigned int i;
@@ -430,6 +439,149 @@ static int __init pseries_nvram_init_os_partition(struct nvram_os_partition
 	return 0;
 }
 
+/*
+ * Are we using the ibm,rtas-log for oops/panic reports?  And if so,
+ * would logging this oops/panic overwrite an RTAS event that rtas_errd
+ * hasn't had a chance to read and process?  Return 1 if so, else 0.
+ *
+ * We assume that if rtas_errd hasn't read the RTAS event in
+ * NVRAM_RTAS_READ_TIMEOUT seconds, it's probably not going to.
+ */
+static int clobbering_unread_rtas_event(void)
+{
+	return (oops_log_partition.index == rtas_log_partition.index
+		&& last_unread_rtas_event
+		&& get_seconds() - last_unread_rtas_event <=
+						NVRAM_RTAS_READ_TIMEOUT);
+}
+
+#ifdef CONFIG_PSTORE
+static int nvram_pstore_open(struct pstore_info *psi)
+{
+	/* Reset the iterator to start reading partitions again */
+	read_type = -1;
+	return 0;
+}
+
+/**
+ * nvram_pstore_write - pstore write callback for nvram
+ * @type:               Type of message logged
+ * @reason:             reason behind dump (oops/panic)
+ * @id:                 identifier to indicate the write performed
+ * @part:               pstore writes data to registered buffer in parts,
+ *                      part number will indicate the same.
+ * @count:              Indicates oops count
+ * @size:               number of bytes written to the registered buffer
+ * @psi:                registered pstore_info structure
+ *
+ * Called by pstore_dump() when an oops or panic report is logged in the
+ * printk buffer.
+ * Returns 0 on successful write.
+ */
+static int nvram_pstore_write(enum pstore_type_id type,
+				enum kmsg_dump_reason reason,
+				u64 *id, unsigned int part, int count,
+				size_t size, struct pstore_info *psi)
+{
+	int rc;
+	struct oops_log_info *oops_hdr = (struct oops_log_info *) oops_buf;
+
+	/* part 1 has the recent messages from printk buffer */
+	if (part > 1 || type != PSTORE_TYPE_DMESG ||
+				clobbering_unread_rtas_event())
+		return -1;
+
+	oops_hdr->version = OOPS_HDR_VERSION;
+	oops_hdr->report_length = (u16) size;
+	oops_hdr->timestamp = get_seconds();
+	rc = nvram_write_os_partition(&oops_log_partition, oops_buf,
+		(int) (sizeof(*oops_hdr) + size), ERR_TYPE_KERNEL_PANIC,
+		count);
+
+	if (rc != 0)
+		return rc;
+
+	*id = part;
+	return 0;
+}
+
+/*
+ * Reads the oops/panic report.
+ * Returns the length of the data we read from each partition.
+ * Returns 0 if we've been called before.
+ */
+static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
+				int *count, struct timespec *time, char **buf,
+				struct pstore_info *psi)
+{
+	struct oops_log_info *oops_hdr;
+	unsigned int err_type, id_no;
+	struct nvram_os_partition *part = NULL;
+	char *buff = NULL;
+
+	read_type++;
+
+	switch (nvram_type_ids[read_type]) {
+	case PSTORE_TYPE_DMESG:
+		part = &oops_log_partition;
+		*type = PSTORE_TYPE_DMESG;
+		break;
+	default:
+		return 0;
+	}
+
+	buff = kmalloc(part->size, GFP_KERNEL);
+
+	if (!buff)
+		return -ENOMEM;
+
+	if (nvram_read_partition(part, buff, part->size, &err_type, &id_no)) {
+		kfree(buff);
+		return 0;
+	}
+
+	*count = 0;
+	*id = id_no;
+	oops_hdr = (struct oops_log_info *)buff;
+	*buf = buff + sizeof(*oops_hdr);
+	time->tv_sec = oops_hdr->timestamp;
+	time->tv_nsec = 0;
+	return oops_hdr->report_length;
+}
+
+static struct pstore_info nvram_pstore_info = {
+	.owner = THIS_MODULE,
+	.name = "nvram",
+	.open = nvram_pstore_open,
+	.read = nvram_pstore_read,
+	.write = nvram_pstore_write,
+};
+
+static int nvram_pstore_init(void)
+{
+	int rc = 0;
+
+	nvram_pstore_info.buf = oops_data;
+	nvram_pstore_info.bufsize = oops_data_sz;
+
+	rc = pstore_register(&nvram_pstore_info);
+	if (rc != 0)
+		pr_err("nvram: pstore_register() failed, defaults to "
+				"kmsg_dump; returned %d\n", rc);
+	else
+		/*TODO: Support compression when pstore is configured */
+		pr_info("nvram: Compression of oops text supported only when "
+				"pstore is not configured");
+
+	return rc;
+}
+#else
+static int nvram_pstore_init(void)
+{
+	return -1;
+}
+#endif
+
 static void __init nvram_init_oops_partition(int rtas_partition_exists)
 {
 	int rc;
@@ -453,6 +605,11 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
 	oops_data = oops_buf + sizeof(struct oops_log_info);
 	oops_data_sz = oops_log_partition.size - sizeof(struct oops_log_info);
 
+	rc = nvram_pstore_init();
+
+	if (!rc)
+		return;
+
 	/*
 	 * Figure compression (preceded by elimination of each line's <n>
 	 * severity prefix) will reduce the oops/panic report to at most
@@ -525,21 +682,6 @@ int __init pSeries_nvram_init(void)
 	return 0;
 }
 
-/*
- * Are we using the ibm,rtas-log for oops/panic reports?  And if so,
- * would logging this oops/panic overwrite an RTAS event that rtas_errd
- * hasn't had a chance to read and process?  Return 1 if so, else 0.
- *
- * We assume that if rtas_errd hasn't read the RTAS event in
- * NVRAM_RTAS_READ_TIMEOUT seconds, it's probably not going to.
- */
-static int clobbering_unread_rtas_event(void)
-{
-	return (oops_log_partition.index == rtas_log_partition.index
-		&& last_unread_rtas_event
-		&& get_seconds() - last_unread_rtas_event <=
-						NVRAM_RTAS_READ_TIMEOUT);
-}
 
 /* Derived from logfs_compress() */
 static int nvram_compress(const void *in, void *out, size_t inlen,

