Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3KZAKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:10:38 -0500
Received: from tundra.namei.org ([65.99.196.166]:41909 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3KZAKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:10:34 -0500
Date: Tue, 26 Nov 2013 11:20:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Fixes for IMA code
Message-ID: <alpine.LRH.2.02.1311261116120.11921@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches fix regressions in the IMA code in your current tree.

The first fixes a couple of bugs in template_desc_init_fields(), and the 
other two ensure that changes in this kernel don't break userspace.

Please pull.

--

The following changes since commit 7e3528c3660a2e8602abc7858b0994d611f74bc3:

  slab.h: remove duplicate kmalloc declaration and fix kernel-doc warnings (2013-11-24 11:01:16 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      Merge branch 'for-linus' of git://git.kernel.org/.../zohar/linux-integrity into for-linus

Roberto Sassu (3):
      ima: do not include field length in template digest calc for ima template
      ima: do not send field length to userspace for digest of ima template
      ima: make a copy of template_fmt in template_desc_init_fields()

 security/integrity/ima/ima.h              |    6 ++++--
 security/integrity/ima/ima_api.c          |    1 +
 security/integrity/ima/ima_crypto.c       |   17 ++++++++++++-----
 security/integrity/ima/ima_fs.c           |   14 +++++++++++---
 security/integrity/ima/ima_template.c     |   21 ++++++++++++++-------
 security/integrity/ima/ima_template_lib.c |    6 +++++-
 6 files changed, 47 insertions(+), 18 deletions(-)

---


commit dbc335d2dc3c437649eb6b39f4e9aee2a13eb0af
Author: Roberto Sassu <roberto.sassu@polito.it>
Date:   Mon Nov 25 20:18:52 2013 +0100

    ima: make a copy of template_fmt in template_desc_init_fields()
    
    This patch makes a copy of the 'template_fmt' function argument so that
    the latter will not be modified by strsep(), which does the splitting by
    replacing the given separator with '\0'.
    
    ??IMA: No TPM chip found, activating TPM-bypass!
    ??Unable to handle kernel pointer dereference at virtual kernel address 0000000000842000
    ??Oops: 0004 [#1] SMP
    ??Modules linked in:
    ??CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc2-00098-g3ce1217d6cd5 #17
    ??task: 000000003ffa0000 ti: 000000003ff84000 task.ti: 000000003ff84000
    ??Krnl PSW : 0704e00180000000 000000000044bf88 (strsep+0x7c/0xa0)
    ?????????????????????? R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:3
    ??Krnl GPRS: 000000000000007c 000000000000007c 000000003ff87d90 0000000000821fd8
    ?????????????????????? 0000000000000000 000000000000007c 0000000000aa37e0 0000000000aa9008
    ?????????????????????? 0000000000000051 0000000000a114d8 0000000100000002 0000000000842bde
    ?????????????????????? 0000000000842bdf 00000000006f97f0 000000000040062c 000000003ff87cf0
    ??Krnl Code: 000000000044bf7c: a7f4000a???????????????????? brc???????? 15,44bf90
    ?????????????????????? 000000000044bf80: b90200cc???????????????????? ltgr?????? %r12,%r12
    ???????????????????? #000000000044bf84: a7840006???????????????????? brc???????? 8,44bf90
    ???????????????????? >000000000044bf88: 9200c000???????????????????? mvi???????? 0(%r12),0
    ?????????????????????? 000000000044bf8c: 41c0c001???????????????????? la?????????? %r12,1(%r12)
    ?????????????????????? 000000000044bf90: e3c020000024???????????? stg???????? %r12,0(%r2)
    ?????????????????????? 000000000044bf96: b904002b???????????????????? lgr???????? %r2,%r11
    ?????????????????????? 000000000044bf9a: ebbcf0700004???????????? lmg???????? %r11,%r12,112(%r15)
    ??Call Trace:
    ??([<00000000004005fe>] ima_init_template+0xa2/0x1bc)
    ?? [<0000000000a7c896>] ima_init+0x7a/0xa8
    ?? [<0000000000a7c938>] init_ima+0x24/0x40
    ?? [<00000000001000e8>] do_one_initcall+0x68/0x128
    ?? [<0000000000a4eb56>] kernel_init_freeable+0x20a/0x2b4
    ?? [<00000000006a1ff4>] kernel_init+0x30/0x178
    ?? [<00000000006b69fe>] kernel_thread_starter+0x6/0xc
    ?? [<00000000006b69f8>] kernel_thread_starter+0x0/0xc
    ??Last Breaking-Event-Address:
    ?? [<000000000044bf42>] strsep+0x36/0xa0
    
    Fixes commit: adf53a7 ima: new templates management mechanism
    
    Changelog v1:
    - make template_fmt 'const char *' (reported-by James Morris)
    - fix kstrdup memory leak (reported-by James Morris)
    
    Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
    Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 4e5da99..913e192 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -90,7 +90,7 @@ static struct ima_template_field *lookup_template_field(const char *field_id)
 	return NULL;
 }
 
-static int template_fmt_size(char *template_fmt)
+static int template_fmt_size(const char *template_fmt)
 {
 	char c;
 	int template_fmt_len = strlen(template_fmt);
@@ -106,23 +106,28 @@ static int template_fmt_size(char *template_fmt)
 	return j + 1;
 }
 
-static int template_desc_init_fields(char *template_fmt,
+static int template_desc_init_fields(const char *template_fmt,
 				     struct ima_template_field ***fields,
 				     int *num_fields)
 {
-	char *c, *template_fmt_ptr = template_fmt;
+	char *c, *template_fmt_copy;
 	int template_num_fields = template_fmt_size(template_fmt);
 	int i, result = 0;
 
 	if (template_num_fields > IMA_TEMPLATE_NUM_FIELDS_MAX)
 		return -EINVAL;
 
+	/* copying is needed as strsep() modifies the original buffer */
+	template_fmt_copy = kstrdup(template_fmt, GFP_KERNEL);
+	if (template_fmt_copy == NULL)
+		return -ENOMEM;
+
 	*fields = kzalloc(template_num_fields * sizeof(*fields), GFP_KERNEL);
 	if (*fields == NULL) {
 		result = -ENOMEM;
 		goto out;
 	}
-	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
+	for (i = 0; (c = strsep(&template_fmt_copy, "|")) != NULL &&
 	     i < template_num_fields; i++) {
 		struct ima_template_field *f = lookup_template_field(c);
 
@@ -133,10 +138,12 @@ static int template_desc_init_fields(char *template_fmt,
 		(*fields)[i] = f;
 	}
 	*num_fields = i;
-	return 0;
 out:
-	kfree(*fields);
-	*fields = NULL;
+	if (result < 0) {
+		kfree(*fields);
+		*fields = NULL;
+	}
+	kfree(template_fmt_copy);
 	return result;
 }
 

commit 3e8e5503a33577d89bdb7469b851b11f507bbed6
Author: Roberto Sassu <roberto.sassu@polito.it>
Date:   Fri Nov 8 19:21:40 2013 +0100

    ima: do not send field length to userspace for digest of ima template
    
    This patch defines a new value for the 'ima_show_type' enumerator
    (IMA_SHOW_BINARY_NO_FIELD_LEN) to prevent that the field length
    is transmitted through the 'binary_runtime_measurements' interface
    for the digest field of the 'ima' template.
    
    Fixes commit: 3ce1217 ima: define template fields library and new helpers
    
    Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index a21cf70..9636e17 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -26,7 +26,8 @@
 
 #include "../integrity.h"
 
-enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_ASCII };
+enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_BINARY_NO_FIELD_LEN,
+		     IMA_SHOW_ASCII };
 enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 
 /* digest size for IMA, fits SHA1 or MD5 */
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index d47a7c8..db01125 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -120,6 +120,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	struct ima_template_entry *e;
 	int namelen;
 	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
+	bool is_ima_template = false;
 	int i;
 
 	/* get entry */
@@ -145,14 +146,21 @@ static int ima_measurements_show(struct seq_file *m, void *v)
 	ima_putc(m, e->template_desc->name, namelen);
 
 	/* 5th:  template length (except for 'ima' template) */
-	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
+	if (strcmp(e->template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0)
+		is_ima_template = true;
+
+	if (!is_ima_template)
 		ima_putc(m, &e->template_data_len,
 			 sizeof(e->template_data_len));
 
 	/* 6th:  template specific data */
 	for (i = 0; i < e->template_desc->num_fields; i++) {
-		e->template_desc->fields[i]->field_show(m, IMA_SHOW_BINARY,
-							&e->template_data[i]);
+		enum ima_show_type show = IMA_SHOW_BINARY;
+		struct ima_template_field *field = e->template_desc->fields[i];
+
+		if (is_ima_template && strcmp(field->field_id, "d") == 0)
+			show = IMA_SHOW_BINARY_NO_FIELD_LEN;
+		field->field_show(m, show, &e->template_data[i]);
 	}
 	return 0;
 }
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 6d66ad6..c38adcc 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -109,9 +109,12 @@ static void ima_show_template_data_binary(struct seq_file *m,
 					  enum data_formats datafmt,
 					  struct ima_field_data *field_data)
 {
-	ima_putc(m, &field_data->len, sizeof(u32));
+	if (show != IMA_SHOW_BINARY_NO_FIELD_LEN)
+		ima_putc(m, &field_data->len, sizeof(u32));
+
 	if (!field_data->len)
 		return;
+
 	ima_putc(m, field_data->data, field_data->len);
 }
 
@@ -125,6 +128,7 @@ static void ima_show_template_field_data(struct seq_file *m,
 		ima_show_template_data_ascii(m, show, datafmt, field_data);
 		break;
 	case IMA_SHOW_BINARY:
+	case IMA_SHOW_BINARY_NO_FIELD_LEN:
 		ima_show_template_data_binary(m, show, datafmt, field_data);
 		break;
 	default:

commit b6f8f16f41d92861621b043389ef49de1c52d613
Author: Roberto Sassu <roberto.sassu@polito.it>
Date:   Fri Nov 8 19:21:39 2013 +0100

    ima: do not include field length in template digest calc for ima template
    
    To maintain compatibility with userspace tools, the field length must not
    be included in the template digest calculation for the 'ima' template.
    
    Fixes commit: a71dc65 ima: switch to new template management mechanism
    
    Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index bf03c6a..a21cf70 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -97,7 +97,8 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
 			   const unsigned char *filename);
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
-int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
+int ima_calc_field_array_hash(struct ima_field_data *field_data,
+			      struct ima_template_desc *desc, int num_fields,
 			      struct ima_digest_data *hash);
 int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 0e75408..8037484 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -94,6 +94,7 @@ int ima_store_template(struct ima_template_entry *entry,
 		/* this function uses default algo */
 		hash.hdr.algo = HASH_ALGO_SHA1;
 		result = ima_calc_field_array_hash(&entry->template_data[0],
+						   entry->template_desc,
 						   num_fields, &hash.hdr);
 		if (result < 0) {
 			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 676e029..fdf60de 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -140,6 +140,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
  * Calculate the hash of template data
  */
 static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
+					 struct ima_template_desc *td,
 					 int num_fields,
 					 struct ima_digest_data *hash,
 					 struct crypto_shash *tfm)
@@ -160,9 +161,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 		return rc;
 
 	for (i = 0; i < num_fields; i++) {
-		rc = crypto_shash_update(&desc.shash,
-					 (const u8 *) &field_data[i].len,
-					 sizeof(field_data[i].len));
+		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
+			rc = crypto_shash_update(&desc.shash,
+						(const u8 *) &field_data[i].len,
+						sizeof(field_data[i].len));
+			if (rc)
+				break;
+		}
 		rc = crypto_shash_update(&desc.shash, field_data[i].data,
 					 field_data[i].len);
 		if (rc)
@@ -175,7 +180,8 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 	return rc;
 }
 
-int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
+int ima_calc_field_array_hash(struct ima_field_data *field_data,
+			      struct ima_template_desc *desc, int num_fields,
 			      struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
@@ -185,7 +191,8 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
-	rc = ima_calc_field_array_hash_tfm(field_data, num_fields, hash, tfm);
+	rc = ima_calc_field_array_hash_tfm(field_data, desc, num_fields,
+					   hash, tfm);
 
 	ima_free_tfm(tfm);
 
