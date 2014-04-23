Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaDWNiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:38:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56873 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaDWN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:59 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-9c-5357c056793b
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 18/20] evm: added kernel parameter for disabling EVM
Date: Wed, 23 Apr 2014 16:30:36 +0300
Message-id: <8382d218eb0debfff621f9561156aa56cee5f88d.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7phB8KDDX62MVrc+ruX2eJd028W
	i3XrFzNZXN41h83iQ88jNouXu76xW3xaMYnZgd3jwaHNLB4935M9Tq8s9ni/7yqbR9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGVc2biGteCWWMWP5vtMDYz3hboYOTkkBEwkVl9/yQZhi0lc
	uLceyObiEBJYyihx7NxaJgink0nic9N5dpAqNgE9iQ3NP8BsEQEXid1z+sCKmAV6GCV2/1nM
	DJIQBkr0Na5kAbFZBFQlNh26wgpi8wrESew71cEEsU5BYtmXtWD1nAJWEn+ap4MNFRKwlPg+
	aTJO8QmM/AsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITjlx2Mi49ZHWIU4GBU4uGV
	WB4WLMSaWFZcmXuIUYKDWUmEd8mi8GAh3pTEyqrUovz4otKc1OJDjEwcnFINjOyXz21W3WSX
	cuX6Xr8Zf3bM6b7YmynQo+BQ6H/F/NID4UeTV69v3Od8MNye+cmJB+K+PLnrFue9iI6fybdv
	yWqvHBlXxlcMj200o+Wvyx1ySuztkt7OnHv98tw2oTtlrC/Ctu3mW2QZ6XrHScbCNKmzbl/r
	vsOHnfh7r37YVCE84RnvUsvbykosxRmJhlrMRcWJAMF5MfwlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EVM remained to be disabled until evm-key is initialized via sysfs.
When the key is loaded from the kernel, EVM becomes enabled from start.
Distributions might want to compile EVM support, but leave for the user
to decide if to enable or disable EVM functionality.

This patch provides kernel parameter 'evm=off' that allows to disable EVM.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/evm.h       |  5 +++++
 security/integrity/evm/evm_main.c  | 19 +++++++++++++------
 security/integrity/evm/evm_secfs.c |  3 ++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 88bfe77..1db78b8 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -21,6 +21,11 @@
 
 #include "../integrity.h"
 
+#define EVM_MODE_OFF	0
+#define EVM_MODE_ON	1
+#define EVM_MODE_FIX	2
+
+extern int evm_mode;
 extern int evm_initialized;
 extern char *evm_hmac;
 extern char *evm_hash;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 0f1b489..ad5e641 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -53,14 +53,17 @@ char *evm_config_xattrnames[] = {
 	NULL
 };
 
-static int evm_fixmode;
-static int __init evm_set_fixmode(char *str)
+int evm_mode = EVM_MODE_ON;
+
+static int __init evm_setup(char *str)
 {
-	if (strncmp(str, "fix", 3) == 0)
-		evm_fixmode = 1;
+	if (strncmp(str, "off", 3) == 0)
+		evm_mode = EVM_MODE_OFF;
+	else if (strncmp(str, "fix", 3) == 0)
+		evm_mode = EVM_MODE_FIX;
 	return 0;
 }
-__setup("evm=", evm_set_fixmode);
+__setup("evm=", evm_setup);
 
 static void __init evm_init_config(void)
 {
@@ -249,7 +252,8 @@ static enum integrity_status evm_verify_current_integrity(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (!evm_initialized || !S_ISREG(inode->i_mode) || evm_fixmode)
+	if (!evm_initialized || !S_ISREG(inode->i_mode) ||
+		    evm_mode == EVM_MODE_FIX)
 		return 0;
 	return evm_verify_hmac(dentry, NULL, NULL, 0, NULL);
 }
@@ -445,6 +449,9 @@ static int __init init_evm(void)
 {
 	int error;
 
+	if (evm_mode == EVM_MODE_OFF)
+		return 0;
+
 	evm_init_config();
 
 	integrity_init_keyring(INTEGRITY_KEYRING_EVM);
diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index cf12a04..4c81ef6 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -64,7 +64,8 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
 	char temp[80];
 	int i, error;
 
-	if (!capable(CAP_SYS_ADMIN) || evm_initialized)
+	if (!capable(CAP_SYS_ADMIN) || evm_initialized ||
+		    evm_mode == EVM_MODE_OFF)
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
-- 
1.8.3.2

