Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3IJVpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab3IJVpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 03/16] ima: Allow adding more memory locking metadata after digital signature v2
Date: Tue, 10 Sep 2013 17:44:18 -0400
Message-Id: <1378849471-10521-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now user space tools should be able to append more metadata after digital
signature in security.ima attribute. I intend to add an structure which
tells whether to memory lock a file or not during execution.

This will allow only selected files to be memory locked while signing
all user space. This will make sure that current IMA installations are
not broken as we don't want to lock down every executable in memory.

I intend to add following structure after digital signature.

struct memlock_hdr {
	uint8_t magic_str[8];   /* magic to detect memlock hdr presence */
	uint8_t version;        /* memlock info hdr version */
	uint8_t memlock_file;   /* If set, run executable locked in memory */
} __attribute__ ((packed));

Will use magic string "MEMLOCK" to identify memlock_hdr. This will allow
to append more metadata in future.

version will allow adding more fields to to this structure.

This patch exports a function which tells whether IMA signature tells
to memlock a file or not. This can be used by executable loader to
lock a file.

Unfortunately, adding more metadata is not forward compatible. That
is if we sign a file with new ima/evm tools with memlock_hdr attached,
old kernel version will not recognize that and will consider whole thing
as digital signature and signature verification will fail. So one will
need to operate with new kernel if signing happens with new tools and
some file is signed for memory locking. Not sure how can I add more metadata
in fully forward compatible manner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/ima.h              |  6 ++++++
 security/integrity/ima/ima_api.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 1b7f268..3c40b5e 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -19,6 +19,7 @@ extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern int ima_module_check(struct file *file);
+extern bool ima_memlock_file(char *sig, unsigned int siglen);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -46,6 +47,11 @@ static inline int ima_module_check(struct file *file)
 	return 0;
 }
 
+static inline bool ima_memlock_file(char *sig, unsigned int siglen)
+{
+	return false;
+}
+
 #endif /* CONFIG_IMA */
 
 #ifdef CONFIG_IMA_APPRAISE
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 1c03e8f1..0f30cf1 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -254,3 +254,39 @@ const char *ima_d_path(struct path *path, char **pathbuf)
 	}
 	return pathname;
 }
+
+/* Given the signature check whether file should be memlocked or not */
+bool ima_memlock_file(char *sig, unsigned int siglen)
+{
+	struct evm_ima_xattr_data *ima_xattr = (struct evm_ima_xattr_data *)sig;
+	char *sptr;
+	unsigned int dsiglen;
+	uint8_t version;
+
+	dsiglen = integrity_get_digsig_size((char *)ima_xattr->digest);
+
+	if (siglen <= dsiglen)
+		return false;
+
+	/*
+	 * Make sure atleast 9 more bytes are there to scan for magic string
+	 * and version info
+	 */
+	if (siglen <= dsiglen + 9)
+		return false;
+
+	sptr = (char *)ima_xattr->digest + dsiglen;
+
+	if (strncmp(sptr, "MEMLOCK", 7))
+		return false;
+
+	sptr += 8;
+	version = sptr[0];
+	if (version != 1)
+		return false;
+	sptr++;
+	if (sptr[0] != 1)
+		return false;
+
+	return true;
+}
-- 
1.8.3.1

