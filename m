Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3GOQzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:55:41 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42076 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3GOQzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:55:39 -0400
Subject: [PATCH 02/11] pstore: Add new argument 'compressed' in pstore write
 callback
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:25:28 +0530
Message-ID: <20130715165528.1520.15583.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-5564-0000-0000-000008CD50AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addition of new argument 'compressed' in the write call back will
help the backend to know if the data passed from pstore is compressed
or not (In case where compression fails.). If compressed, the backend
can add a tag indicating the data is compressed while writing to
persistent store.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |    4 ++--
 drivers/acpi/apei/erst.c               |    4 ++--
 drivers/firmware/efi/efi-pstore.c      |    2 +-
 fs/pstore/platform.c                   |    7 ++++---
 fs/pstore/ram.c                        |    2 +-
 include/linux/pstore.h                 |    4 ++--
 6 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 07c3c07..c5c9d78 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -613,7 +613,7 @@ static int nvram_pstore_open(struct pstore_info *psi)
  * @part:               pstore writes data to registered buffer in parts,
  *                      part number will indicate the same.
  * @count:              Indicates oops count
- * @hsize:              Size of header added by pstore
+ * @compressed:         Flag to indicate the log is compressed
  * @size:               number of bytes written to the registered buffer
  * @psi:                registered pstore_info structure
  *
@@ -624,7 +624,7 @@ static int nvram_pstore_open(struct pstore_info *psi)
 static int nvram_pstore_write(enum pstore_type_id type,
 				enum kmsg_dump_reason reason,
 				u64 *id, unsigned int part, int count,
-				size_t hsize, size_t size,
+				bool compressed, size_t size,
 				struct pstore_info *psi)
 {
 	int rc;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 88d0b0f..5e90796 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -935,7 +935,7 @@ static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 			   struct timespec *time, char **buf,
 			   struct pstore_info *psi);
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
-		       u64 *id, unsigned int part, int count, size_t hsize,
+		       u64 *id, unsigned int part, int count, bool compressed,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id, int count,
 			struct timespec time, struct pstore_info *psi);
@@ -1055,7 +1055,7 @@ out:
 }
 
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
-		       u64 *id, unsigned int part, int count, size_t hsize,
+		       u64 *id, unsigned int part, int count, bool compressed,
 		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 73de5a9..fab6892 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -103,7 +103,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 
 static int efi_pstore_write(enum pstore_type_id type,
 		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t hsize, size_t size,
+		unsigned int part, int count, bool compressed, size_t size,
 		struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 422962a..20fa686 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -149,6 +149,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		unsigned long size;
 		int hsize;
 		size_t len;
+		bool compressed = false;
 
 		dst = psinfo->buf;
 		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part);
@@ -159,7 +160,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			break;
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
-				    oopscount, hsize, hsize + len, psinfo);
+				    oopscount, compressed, hsize + len, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
 
@@ -221,10 +222,10 @@ static void pstore_register_console(void) {}
 static int pstore_write_compat(enum pstore_type_id type,
 			       enum kmsg_dump_reason reason,
 			       u64 *id, unsigned int part, int count,
-			       size_t hsize, size_t size,
+			       bool compressed, size_t size,
 			       struct pstore_info *psi)
 {
-	return psi->write_buf(type, reason, id, part, psinfo->buf, hsize,
+	return psi->write_buf(type, reason, id, part, psinfo->buf, compressed,
 			     size, psi);
 }
 
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index a6119f9..fe7188f 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -196,7 +196,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 					    enum kmsg_dump_reason reason,
 					    u64 *id, unsigned int part,
 					    const char *buf,
-					    size_t hsize, size_t size,
+					    bool compressed, size_t size,
 					    struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 4aa80ba..abfca4f 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -58,11 +58,11 @@ struct pstore_info {
 			struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
-			unsigned int part, int count, size_t hsize,
+			unsigned int part, int count, bool compressed,
 			size_t size, struct pstore_info *psi);
 	int		(*write_buf)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
-			unsigned int part, const char *buf, size_t hsize,
+			unsigned int part, const char *buf, bool compressed,
 			size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			int count, struct timespec time,

