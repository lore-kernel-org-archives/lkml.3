Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3HPNS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:18:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43603 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3HPNSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:18:23 -0400
Subject: [RFC PATCH v2 05/11] pstore: Introduce new argument 'compressed' in
 the read callback
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:48:13 +0530
Message-ID: <20130816131813.3338.15295.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-5564-0000-0000-0000094BECCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backends will set the flag 'compressed' after reading the log from
persistent store to indicate the data being returned to pstore is
compressed or not.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |    2 +-
 drivers/acpi/apei/erst.c               |    4 ++--
 drivers/firmware/efi/efi-pstore.c      |    3 ++-
 fs/pstore/platform.c                   |    4 +++-
 fs/pstore/ram.c                        |    3 ++-
 include/linux/pstore.h                 |    2 +-
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index dbe5dad..6c4dc52a 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -598,7 +598,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
  */
 static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 				int *count, struct timespec *time, char **buf,
-				struct pstore_info *psi)
+				bool *compressed, struct pstore_info *psi)
 {
 	struct oops_log_info *oops_hdr;
 	unsigned int err_type, id_no, size = 0;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 5e90796..b0dca8e 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -933,7 +933,7 @@ static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 			   struct timespec *time, char **buf,
-			   struct pstore_info *psi);
+			   bool *compressed, struct pstore_info *psi);
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 		       u64 *id, unsigned int part, int count, bool compressed,
 		       size_t size, struct pstore_info *psi);
@@ -989,7 +989,7 @@ static int erst_close_pstore(struct pstore_info *psi)
 
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 			   struct timespec *time, char **buf,
-			   struct pstore_info *psi)
+			   bool *compressed, struct pstore_info *psi)
 {
 	int rc;
 	ssize_t len = 0;
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index fab6892..9a5425f 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -87,7 +87,8 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
+			       char **buf, bool *compressed,
+			       struct pstore_info *psi)
 {
 	struct pstore_read_data data;
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 56218cb..6418eb7 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -428,6 +428,7 @@ void pstore_get_records(int quiet)
 	enum pstore_type_id	type;
 	struct timespec		time;
 	int			failed = 0, rc;
+	bool			compressed;
 
 	if (!psi)
 		return;
@@ -436,7 +437,8 @@ void pstore_get_records(int quiet)
 	if (psi->open && psi->open(psi))
 		goto out;
 
-	while ((size = psi->read(&id, &type, &count, &time, &buf, psi)) > 0) {
+	while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
+				psi)) > 0) {
 		rc = pstore_mkfile(type, psi->name, id, count, buf,
 				  (size_t)size, time, psi);
 		kfree(buf);
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index fe7188f..2927223 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -133,7 +133,8 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
 
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   int *count, struct timespec *time,
-				   char **buf, struct pstore_info *psi)
+				   char **buf, bool *compressed,
+				   struct pstore_info *psi)
 {
 	ssize_t size;
 	ssize_t ecc_notice_size;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index abfca4f..abd437d 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -55,7 +55,7 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			int *count, struct timespec *time, char **buf,
-			struct pstore_info *psi);
+			bool *compressed, struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, int count, bool compressed,

