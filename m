Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3JUWul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:50:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3JUWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:31 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 07/23] ima: differentiate between template hash and file data hash sizes
Date: Mon, 21 Oct 2013 18:42:52 -0400
Message-Id: <1382395388-8108-8-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-0928-0000-0000-000002A8F4F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPM v1.2 limits the template hash size to 20 bytes.  This
patch differentiates between the template hash size, as defined
in the ima_template_entry, and the file data hash size, as
defined in the ima_template_data.  Subsequent patches add support
for different file data hash algorithms.

Change log:
- hash digest definition in ima_store_template() should be TPM_DIGEST_SIZE

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima.h        |  2 +-
 security/integrity/ima/ima_api.c    |  2 +-
 security/integrity/ima/ima_crypto.c |  4 ++--
 security/integrity/ima/ima_fs.c     | 10 +++++-----
 security/integrity/ima/ima_init.c   |  2 +-
 security/integrity/ima/ima_queue.c  |  4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index efcdef2..52393ed 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -49,7 +49,7 @@ struct ima_template_data {
 };
 
 struct ima_template_entry {
-	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
+	u8 digest[TPM_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
 	const char *template_name;
 	int template_len;
 	struct ima_template_data template;
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 5a7942e..2cc5dcc 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -46,7 +46,7 @@ int ima_store_template(struct ima_template_entry *entry,
 	int result;
 	struct {
 		struct ima_digest_data hdr;
-		char digest[IMA_MAX_DIGEST_SIZE];
+		char digest[TPM_DIGEST_SIZE];
 	} hash;
 
 	memset(entry->digest, 0, sizeof(entry->digest));
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 2fd1786..872c669 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -155,7 +155,7 @@ static void __init ima_pcrread(int idx, u8 *pcr)
  */
 int __init ima_calc_boot_aggregate(char *digest)
 {
-	u8 pcr_i[IMA_DIGEST_SIZE];
+	u8 pcr_i[TPM_DIGEST_SIZE];
 	int rc, i;
 	struct {
 		struct shash_desc shash;
@@ -173,7 +173,7 @@ int __init ima_calc_boot_aggregate(char *digest)
 	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, pcr_i);
 		/* now accumulate with current aggregate */
-		rc = crypto_shash_update(&desc.shash, pcr_i, IMA_DIGEST_SIZE);
+		rc = crypto_shash_update(&desc.shash, pcr_i, TPM_DIGEST_SIZE);
 	}
 	if (!rc)
 		crypto_shash_final(&desc.shash, digest);
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 5f0fd11..c35cfb5 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -133,7 +133,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	ima_putc(m, &pcr, sizeof pcr);
 
 	/* 2nd: template digest */
-	ima_putc(m, e->digest, IMA_DIGEST_SIZE);
+	ima_putc(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3rd: template name size */
 	namelen = strlen(e->template_name);
@@ -167,11 +167,11 @@ static const struct file_operations ima_measurements_ops = {
 	.release = seq_release,
 };
 
-static void ima_print_digest(struct seq_file *m, u8 *digest)
+static void ima_print_digest(struct seq_file *m, u8 *digest, int size)
 {
 	int i;
 
-	for (i = 0; i < IMA_DIGEST_SIZE; i++)
+	for (i = 0; i < size; i++)
 		seq_printf(m, "%02x", *(digest + i));
 }
 
@@ -182,7 +182,7 @@ void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show)
 
 	switch (show) {
 	case IMA_SHOW_ASCII:
-		ima_print_digest(m, entry->digest);
+		ima_print_digest(m, entry->digest, IMA_DIGEST_SIZE);
 		seq_printf(m, " %s\n", entry->file_name);
 		break;
 	case IMA_SHOW_BINARY:
@@ -212,7 +212,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
 
 	/* 2nd: SHA1 template hash */
-	ima_print_digest(m, e->digest);
+	ima_print_digest(m, e->digest, TPM_DIGEST_SIZE);
 
 	/* 3th:  template name */
 	seq_printf(m, " %s ", e->template_name);
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 162ea72..9d0243c 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -74,7 +74,7 @@ err_out:
 
 int __init ima_init(void)
 {
-	u8 pcr_i[IMA_DIGEST_SIZE];
+	u8 pcr_i[TPM_DIGEST_SIZE];
 	int rc;
 
 	ima_used_chip = 0;
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index ff63fe0..e63ff33 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -50,7 +50,7 @@ static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
 	key = ima_hash_key(digest_value);
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(qe, &ima_htable.queue[key], hnext) {
-		rc = memcmp(qe->entry->digest, digest_value, IMA_DIGEST_SIZE);
+		rc = memcmp(qe->entry->digest, digest_value, TPM_DIGEST_SIZE);
 		if (rc == 0) {
 			ret = qe;
 			break;
@@ -106,7 +106,7 @@ static int ima_pcr_extend(const u8 *hash)
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode)
 {
-	u8 digest[IMA_DIGEST_SIZE];
+	u8 digest[TPM_DIGEST_SIZE];
 	const char *audit_cause = "hash_added";
 	char tpm_audit_cause[AUDIT_CAUSE_LEN_MAX];
 	int audit_info = 1;
-- 
1.8.1.4

