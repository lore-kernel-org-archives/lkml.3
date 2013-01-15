Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3AOVfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:35:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab3AOVe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:34:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, zohar@linux.vnet.ibm.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com,
        vgoyal@redhat.com
Subject: [PATCH 1/3] module: export couple of functions for use in process signature verification
Date: Tue, 15 Jan 2013 16:34:53 -0500
Message-Id: <1358285695-26173-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This probably is not the right thing to do. May be module keyring and
functions to retrieve key and mpi array should be moved into separate file
so that it could be shared.

But for the time being as quick RFC, just export couple of functions
from module_signing.c

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/module.h  |    8 ++++++++
 kernel/module_signing.c |    4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 7760c6d..fd121f9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
 #include <linux/export.h>
+#include <crypto/public_key.h>
 
 #include <linux/percpu.h>
 #include <asm/module.h>
@@ -450,6 +451,13 @@ extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
 
+#ifdef CONFIG_MODULE_SIG
+extern struct key *request_asymmetric_key(const char *signer, size_t signer_len,
+				const u8 *key_id, size_t key_id_len);
+extern int mod_extract_mpi_array(struct public_key_signature *pks,
+				const void *data, size_t len);
+#endif
+
 #ifdef CONFIG_MODULE_UNLOAD
 unsigned long module_refcount(struct module *mod);
 void __symbol_put(const char *symbol);
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index f2970bd..4362a35 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -104,7 +104,7 @@ error_no_pks:
  *
  * RSA signatures only have one MPI, so currently we only read one.
  */
-static int mod_extract_mpi_array(struct public_key_signature *pks,
+int mod_extract_mpi_array(struct public_key_signature *pks,
 				 const void *data, size_t len)
 {
 	size_t nbytes;
@@ -129,7 +129,7 @@ static int mod_extract_mpi_array(struct public_key_signature *pks,
 /*
  * Request an asymmetric key.
  */
-static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
+struct key *request_asymmetric_key(const char *signer, size_t signer_len,
 					  const u8 *key_id, size_t key_id_len)
 {
 	key_ref_t key;
-- 
1.7.7.6

