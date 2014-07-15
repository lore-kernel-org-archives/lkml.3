Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbaGOM4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:56:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32821 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbaGOM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:20 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-a8-53c524ebf1cd
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 2/4] integrity: provide file reading API
Date: Tue, 15 Jul 2014 15:54:21 +0300
Message-id: <aecf373145701e2e946b1937de39147415202d42.1405428802.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xK7qvVY4GG5zeymoxZ/0aNotbf/cy
	W7xr+s1i8WVpncXLGfPYLS7vmsNm8aHnEZvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yeP9vqtsHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJVx99gMloJ2kYo/cz+wNjBuE+hi5OSQ
	EDCRaLm6hRnCFpO4cG89WxcjF4eQwFJGib33JrNCOJ1MEie/32IHqWIT0JPY0PyDHSQhItDO
	KHHg+mmwBLNAjcTDnkUsILawgLXEnKbXTCA2i4CqxJWebYwgNq9AnETDgTWMEOvkJE4eA9nA
	ycEpYCVxeekhoDkcQNssJa5dCMAhPIGRfwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2M
	kAD9uoNx6TGrQ4wCHIxKPLw3ph0JFmJNLCuuzD3EKMHBrCTCW6h0NFiINyWxsiq1KD++qDQn
	tfgQIxMHp1QDY+7RIOUfRy5Ovc9vxvXlxiH7qXdLA+4nPjrYGSOwjz/80dKtBlflmLXepJXM
	/t/zx+LZM7eD116Fq37MPKIVzMLM+mDHx+8NOc/nTdwzU+r6lZ+1grk1IUGld1WbLj5J6n9Y
	yDPBIn1FukzqzakW2kY3l1nGpltEZW+KYNwd5fbAQpSVNZbNX4mlOCPRUIu5qDgRALAnhRMu	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig     |  3 +++
 security/integrity/digsig.c    | 41 +++++++++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h |  2 +-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 463219b..1f000c4 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -50,6 +50,9 @@ config INTEGRITY_AUDIT
 	  be enabled by specifying 'integrity_audit=1' on the kernel
 	  command line.
 
+config INTEGRITY_FILE_READ
+	def_bool n
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
 
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 8d4fbff..85d6662 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -18,6 +18,8 @@
 #include <linux/cred.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
+#include <linux/slab.h>
+#include <linux/file.h>
 
 #include "integrity.h"
 
@@ -63,6 +65,45 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return -EOPNOTSUPP;
 }
 
+#ifdef CONFIG_INTEGRITY_FILE_READ
+int integrity_read_file(const char *path, char **data)
+{
+	struct file *file;
+	loff_t size;
+	char *buf;
+	int rc = -EINVAL;
+
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		pr_err("Unable to open file: %s (%d)", path, rc);
+		return rc;
+	}
+
+	size = i_size_read(file_inode(file));
+	if (size <= 0)
+		goto out;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* should be ima_kernel_read */
+	rc = kernel_read(file, 0, buf, size);
+	if (rc < 0)
+		kfree(buf);
+	else if (rc != size)
+		rc = -EIO;
+	else
+		*data = buf;
+out:
+	fput(file);
+	return rc;
+}
+#endif
+
 int integrity_init_keyring(const unsigned int id)
 {
 	const struct cred *cred = current_cred();
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 7656d47..f77de68 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -130,7 +130,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
-
+int integrity_read_file(const char *path, char **data);
 int integrity_init_keyring(const unsigned int id);
 #else
 
-- 
1.9.1

