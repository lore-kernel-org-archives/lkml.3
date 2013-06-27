Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3F0IdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:33:08 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51395 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3F0IdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:33:05 -0400
Subject: [PATCH v2 1/3] Pass header size in the pstore write callback
To: tony.luck@intel.com, keescook@chromium.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        paulus@samba.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, anton@samba.org, ccross@android.com
Date: Thu, 27 Jun 2013 14:02:56 +0530
Message-ID: <20130627083256.16749.28039.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
References: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062708-5140-0000-0000-000003702CCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header size is needed to distinguish between header and the dump data.
Incorporate the addition of new argument (hsize) in the pstore write
callback.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |    4 +++-
 drivers/acpi/apei/erst.c               |    4 ++--
 drivers/firmware/efi/efi-pstore.c      |    2 +-
 fs/pstore/platform.c                   |   10 ++++++----
 fs/pstore/ram.c                        |    3 ++-
 include/linux/pstore.h                 |    8 ++++----
 6 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 14cc486..3f0e7d6 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -502,6 +502,7 @@ static int nvram_pstore_open(struct pstore_info *psi)
  * @part:               pstore writes data to registered buffer in parts,
  *                      part number will indicate the same.
  * @count:              Indicates oops count
+ * @hsize:              Size of header added by pstore
  * @size:               number of bytes written to the registered buffer
  * @psi:                registered pstore_info structure
  *
@@ -512,7 +513,8 @@ static int nvram_pstore_open(struct pstore_info *psi)
 static int nvram_pstore_write(enum pstore_type_id type,
 				enum kmsg_dump_reason reason,
 				u64 *id, unsigned int part, int count,
-				size_t size, struct pstore_info *psi)
+				size_t hsize, size_t size,
+				struct pstore_info *psi)
 {
 	int rc;
 	struct oops_log_info *oops_hdr = (struct oops_log_info *) oops_buf;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 6d894bf..a9cf960 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -935,7 +935,7 @@ static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 			   struct timespec *time, char **buf,
 			   struct pstore_info *psi);
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
-		       u64 *id, unsigned int part, int count,
+		       u64 *id, unsigned int part, int count, size_t hsize,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id, int count,
 			struct timespec time, struct pstore_info *psi);
@@ -1055,7 +1055,7 @@ out:
 }
 
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
-		       u64 *id, unsigned int part, int count,
+		       u64 *id, unsigned int part, int count, size_t hsize,
 		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 202d2c8..452800e0 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -104,7 +104,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 
 static int efi_pstore_write(enum pstore_type_id type,
 		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
+		unsigned int part, int count, size_t hsize, size_t size,
 		struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 86d1038..4637ec4 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -159,7 +159,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			break;
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
-				    oopscount, hsize + len, psinfo);
+				    oopscount, hsize, hsize + len, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
 
@@ -196,7 +196,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
 		memcpy(psinfo->buf, s, c);
-		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, 0, c, psinfo);
+		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, 0, 0, c, psinfo);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
@@ -221,9 +221,11 @@ static void pstore_register_console(void) {}
 static int pstore_write_compat(enum pstore_type_id type,
 			       enum kmsg_dump_reason reason,
 			       u64 *id, unsigned int part, int count,
-			       size_t size, struct pstore_info *psi)
+			       size_t hsize, size_t size,
+			       struct pstore_info *psi)
 {
-	return psi->write_buf(type, reason, id, part, psinfo->buf, size, psi);
+	return psi->write_buf(type, reason, id, part, psinfo->buf, hsize,
+			     size, psi);
 }
 
 /*
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1376e5a..c6bb77c 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -195,7 +195,8 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 					    enum kmsg_dump_reason reason,
 					    u64 *id, unsigned int part,
-					    const char *buf, size_t size,
+					    const char *buf,
+					    size_t hsize, size_t size,
 					    struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 656699f..4aa80ba 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -58,12 +58,12 @@ struct pstore_info {
 			struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
-			unsigned int part, int count, size_t size,
-			struct pstore_info *psi);
+			unsigned int part, int count, size_t hsize,
+			size_t size, struct pstore_info *psi);
 	int		(*write_buf)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
-			unsigned int part, const char *buf, size_t size,
-			struct pstore_info *psi);
+			unsigned int part, const char *buf, size_t hsize,
+			size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			int count, struct timespec time,
 			struct pstore_info *psi);

