Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199AbaE3UFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:15 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:65021 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaE3UFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [RFC 09/32] fs/pstore: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:33 +0200
Message-Id: <1401480116-1973111-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zioybHsu0W/v9VJuyHlSJFGhycvYbG1UNsMa6ZnvjSg
 A/PlKaM+JnYViwmbAD5TXlkVZaP7PGzmkM3PWmuXOJq02ees77
 eYgJrUL3rVf3yxDYksTnUVXcU1vVnTNXyodBE8I+Ui22VDk4Mm
 +r3xyqYTry29b7GBoSnKktal9uXXDOAj8F7nHXM84ArwYkXiI9
 /eBJ6n+iTPVcdKGeeUyOwu2MIuG2av8NXHpAfBwEAutygWdlEu
 GmsQzFqCgJx6mqzQp6JGCHrF9ad/H2JCGqWC3zSdgl+KdQW/cQ
 8Mj3aJfQi9jWE15bqp33Sbmzsht/i+dw5XEco91+pPNFuGgzR4
 7JOppXdFlW2cAzwfNvcnpm6BymKoPnDFUED4pTCP0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore uses timestamps encoded in a string as seconds, but on 32-bit systems
cannot go beyond year 2038 because of the limits of struct timespec.

This converts the pstore code to use the new struct inode_time for timestamps.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
---
 drivers/firmware/efi/efi-pstore.c | 28 ++++++++++++++--------------
 fs/pstore/inode.c                 |  2 +-
 fs/pstore/internal.h              |  2 +-
 fs/pstore/platform.c              |  2 +-
 fs/pstore/ram.c                   | 18 ++++++++++--------
 include/linux/pstore.h            |  4 ++--
 6 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 4b9dc83..a1e4153 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -32,7 +32,7 @@ struct pstore_read_data {
 	u64 *id;
 	enum pstore_type_id *type;
 	int *count;
-	struct timespec *timespec;
+	struct inode_time *inode_time;
 	bool *compressed;
 	char **buf;
 };
@@ -63,8 +63,8 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
 		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
+		cb_data->inode_time->tv_sec = time;
+		cb_data->inode_time->tv_nsec = 0;
 		if (data_type == 'C')
 			*cb_data->compressed = true;
 		else
@@ -73,8 +73,8 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		   cb_data->type, &part, &cnt, &time) == 4) {
 		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
+		cb_data->inode_time->tv_sec = time;
+		cb_data->inode_time->tv_nsec = 0;
 		*cb_data->compressed = false;
 	} else if (sscanf(name, "dump-type%u-%u-%lu",
 			  cb_data->type, &part, &time) == 3) {
@@ -85,8 +85,8 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		 */
 		*cb_data->id = generic_id(time, part, 0);
 		*cb_data->count = 0;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
+		cb_data->inode_time->tv_sec = time;
+		cb_data->inode_time->tv_nsec = 0;
 		*cb_data->compressed = false;
 	} else
 		return 0;
@@ -208,7 +208,7 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
  *           and pstore will stop reading entry.
  */
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
+			       int *count, struct inode_time *inode_time,
 			       char **buf, bool *compressed,
 			       struct pstore_info *psi)
 {
@@ -218,7 +218,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.id = id;
 	data.type = type;
 	data.count = count;
-	data.timespec = timespec;
+	data.inode_time = inode_time;
 	data.compressed = compressed;
 	data.buf = buf;
 
@@ -266,7 +266,7 @@ struct pstore_erase_data {
 	u64 id;
 	enum pstore_type_id type;
 	int count;
-	struct timespec time;
+	struct inode_time time;
 	efi_char16_t *name;
 };
 
@@ -292,8 +292,8 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 		 * Check if an old format, which doesn't support
 		 * holding multiple logs, remains.
 		 */
-		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
-			(unsigned int)ed->id, ed->time.tv_sec);
+		sprintf(name_old, "dump-type%u-%u-%llu", ed->type,
+			(unsigned int)ed->id, (u64)ed->time.tv_sec);
 
 		for (i = 0; i < DUMP_NAME_LEN; i++)
 			efi_name_old[i] = name_old[i];
@@ -319,7 +319,7 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 }
 
 static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
+			    struct inode_time time, struct pstore_info *psi)
 {
 	struct pstore_erase_data edata;
 	struct efivar_entry *entry = NULL;
@@ -330,7 +330,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 	do_div(id, 1000);
 	part = do_div(id, 100);
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
+	sprintf(name, "dump-type%u-%u-%d-%llu", type, part, count, (u64)time.tv_sec);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 192297b..6f3925f 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -277,7 +277,7 @@ int pstore_is_mounted(void)
  */
 int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		  char *data, bool compressed, size_t size,
-		  struct timespec time, struct pstore_info *psi)
+		  struct inode_time time, struct pstore_info *psi)
 {
 	struct dentry		*root = pstore_sb->s_root;
 	struct dentry		*dentry;
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 3b3d305..eb9c4eb 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -51,7 +51,7 @@ extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(int);
 extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
 			      int count, char *data, bool compressed,
-			      size_t size, struct timespec time,
+			      size_t size, struct inode_time time,
 			      struct pstore_info *psi);
 extern int	pstore_is_mounted(void);
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 0a9b72c..06f2628 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -475,7 +475,7 @@ void pstore_get_records(int quiet)
 	u64			id;
 	int			count;
 	enum pstore_type_id	type;
-	struct timespec		time;
+	struct inode_time	time;
 	int			failed = 0, rc;
 	bool			compressed;
 	int			unzipped_len = -1;
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 3b57443..50d7298 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -135,29 +135,31 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
 	return prz;
 }
 
-static void ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
+static void ramoops_read_kmsg_hdr(char *buffer, struct inode_time *time,
 				  bool *compressed)
 {
 	char data_type;
+	u64 seconds;
 
-	if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu-%c\n",
-			&time->tv_sec, &time->tv_nsec, &data_type) == 3) {
+	if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%llu.%lu-%c\n",
+			&seconds, &time->tv_nsec, &data_type) == 3) {
 		if (data_type == 'C')
 			*compressed = true;
 		else
 			*compressed = false;
-	} else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
-			&time->tv_sec, &time->tv_nsec) == 2) {
+	} else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%llu.%lu\n",
+			&seconds, &time->tv_nsec) == 2) {
 			*compressed = false;
 	} else {
-		time->tv_sec = 0;
+		seconds = 0;
 		time->tv_nsec = 0;
 		*compressed = false;
 	}
+	time->tv_sec = seconds;
 }
 
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
-				   int *count, struct timespec *time,
+				   int *count, struct inode_time *time,
 				   char **buf, bool *compressed,
 				   struct pstore_info *psi)
 {
@@ -278,7 +280,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 }
 
 static int ramoops_pstore_erase(enum pstore_type_id type, u64 id, int count,
-				struct timespec time, struct pstore_info *psi)
+				struct inode_time time, struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index ece0c6b..f293905 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -55,7 +55,7 @@ struct pstore_info {
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
-			int *count, struct timespec *time, char **buf,
+			int *count, struct inode_time *time, char **buf,
 			bool *compressed, struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
@@ -66,7 +66,7 @@ struct pstore_info {
 			unsigned int part, const char *buf, bool compressed,
 			size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
-			int count, struct timespec time,
+			int count, struct inode_time time,
 			struct pstore_info *psi);
 	void		*data;
 };
-- 
1.8.3.2

