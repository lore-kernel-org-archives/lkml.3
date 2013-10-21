Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3JUWuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:50:01 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58995 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3JUWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:35 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 12/23] ima: pass the filename argument up to ima_add_template_entry()
Date: Mon, 21 Oct 2013 18:42:57 -0400
Message-Id: <1382395388-8108-13-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-8236-0000-0000-000002F7D1CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

Pass the filename argument to ima_add_template_entry() in order to
eliminate a dependency on template specific data (third argument of
integrity_audit_msg).

This change is required because, with the new template management
mechanism, the generation of a new measurement entry will be performed
by new specific functions (introduced in next patches) and the current IMA
code will not be aware anymore of how data is stored in the entry payload.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h       | 5 +++--
 security/integrity/ima/ima_api.c   | 9 +++++----
 security/integrity/ima/ima_init.c  | 3 ++-
 security/integrity/ima/ima_queue.c | 6 +++---
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d7bec6f..27d2ffb 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -69,7 +69,8 @@ int ima_fs_init(void);
 void ima_fs_cleanup(void);
 int ima_inode_alloc(struct inode *inode);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
-			   const char *op, struct inode *inode);
+			   const char *op, struct inode *inode,
+			   const unsigned char *filename);
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
 int ima_calc_buffer_hash(const void *data, int len,
 			 struct ima_digest_data *hash);
@@ -107,7 +108,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_store_template(struct ima_template_entry *entry, int violation,
-		       struct inode *inode);
+		       struct inode *inode, const unsigned char *filename);
 void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show);
 const char *ima_d_path(struct path *path, char **pathbuf);
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 98160a3..a0fe504 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -40,7 +40,8 @@ static const char *IMA_TEMPLATE_NAME = "ima";
  * Returns 0 on success, error code otherwise
  */
 int ima_store_template(struct ima_template_entry *entry,
-		       int violation, struct inode *inode)
+		       int violation, struct inode *inode,
+		       const unsigned char *filename)
 {
 	const char *op = "add_template_measure";
 	const char *audit_cause = "hashing_error";
@@ -67,7 +68,7 @@ int ima_store_template(struct ima_template_entry *entry,
 		}
 		memcpy(entry->digest, hash.hdr.digest, hash.hdr.length);
 	}
-	result = ima_add_template_entry(entry, violation, op, inode);
+	result = ima_add_template_entry(entry, violation, op, inode, filename);
 	return result;
 }
 
@@ -96,7 +97,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	}
 	memset(&entry->template, 0, sizeof(entry->template));
 	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
-	result = ima_store_template(entry, violation, inode);
+	result = ima_store_template(entry, violation, inode, filename);
 	if (result < 0)
 		kfree(entry);
 err_out:
@@ -248,7 +249,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	       (strlen(filename) > IMA_EVENT_NAME_LEN_MAX) ?
 	       file->f_dentry->d_name.name : filename);
 
-	result = ima_store_template(entry, violation, inode);
+	result = ima_store_template(entry, violation, inode, filename);
 	if (!result || result == -EEXIST)
 		iint->flags |= IMA_MEASURED;
 	if (result < 0)
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 77cd500..d42fac3 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -71,7 +71,8 @@ static void __init ima_add_boot_aggregate(void)
 		memcpy(entry->template.digest, hash.hdr.digest,
 		       hash.hdr.length);
 	}
-	result = ima_store_template(entry, violation, NULL);
+	result = ima_store_template(entry, violation, NULL,
+				    boot_aggregate_name);
 	if (result < 0)
 		kfree(entry);
 	return;
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index e63ff33..d85e997 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -104,7 +104,8 @@ static int ima_pcr_extend(const u8 *hash)
  * and extend the pcr.
  */
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
-			   const char *op, struct inode *inode)
+			   const char *op, struct inode *inode,
+			   const unsigned char *filename)
 {
 	u8 digest[TPM_DIGEST_SIZE];
 	const char *audit_cause = "hash_added";
@@ -141,8 +142,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 	}
 out:
 	mutex_unlock(&ima_extend_list_mutex);
-	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
-			    entry->template.file_name,
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 			    op, audit_cause, result, audit_info);
 	return result;
 }
-- 
1.8.1.4

