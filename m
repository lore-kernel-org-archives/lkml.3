Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbaCTMhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757281AbaCTMhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:37:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 10/12] KEYS: big_key: Use key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:49 +0000
Message-ID: <20140320120549.21635.97439.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of key preparsing in the big key type so that quota size determination
can take place prior to keyring locking when a key is being added.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/keys/big_key-type.h |    3 ++-
 security/keys/big_key.c     |   41 +++++++++++++++++++++++++----------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/keys/big_key-type.h b/include/keys/big_key-type.h
index d69bc8af3292..e0970a578188 100644
--- a/include/keys/big_key-type.h
+++ b/include/keys/big_key-type.h
@@ -16,7 +16,8 @@
 
 extern struct key_type key_type_big_key;
 
-extern int big_key_instantiate(struct key *key, struct key_preparsed_payload *prep);
+extern int big_key_preparse(struct key_preparsed_payload *prep);
+extern void big_key_free_preparse(struct key_preparsed_payload *prep);
 extern void big_key_revoke(struct key *key);
 extern void big_key_destroy(struct key *key);
 extern void big_key_describe(const struct key *big_key, struct seq_file *m);
diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 8137b27d641d..c2f91a0cf889 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -34,7 +34,9 @@ MODULE_LICENSE("GPL");
 struct key_type key_type_big_key = {
 	.name			= "big_key",
 	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
-	.instantiate		= big_key_instantiate,
+	.preparse		= big_key_preparse,
+	.free_preparse		= big_key_free_preparse,
+	.instantiate		= generic_key_instantiate,
 	.match			= user_match,
 	.revoke			= big_key_revoke,
 	.destroy		= big_key_destroy,
@@ -43,11 +45,11 @@ struct key_type key_type_big_key = {
 };
 
 /*
- * Instantiate a big key
+ * Preparse a big key
  */
-int big_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
+int big_key_preparse(struct key_preparsed_payload *prep)
 {
-	struct path *path = (struct path *)&key->payload.data2;
+	struct path *path = (struct path *)&prep->payload;
 	struct file *file;
 	ssize_t written;
 	size_t datalen = prep->datalen;
@@ -58,11 +60,9 @@ int big_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 		goto error;
 
 	/* Set an arbitrary quota */
-	ret = key_payload_reserve(key, 16);
-	if (ret < 0)
-		goto error;
+	prep->quotalen = 16;
 
-	key->type_data.x[1] = datalen;
+	prep->type_data[1] = (void *)(unsigned long)datalen;
 
 	if (datalen > BIG_KEY_FILE_THRESHOLD) {
 		/* Create a shmem file to store the data in.  This will permit the data
@@ -73,7 +73,7 @@ int big_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 		file = shmem_kernel_file_setup("", datalen, 0);
 		if (IS_ERR(file)) {
 			ret = PTR_ERR(file);
-			goto err_quota;
+			goto error;
 		}
 
 		written = kernel_write(file, prep->data, prep->datalen, 0);
@@ -93,24 +93,33 @@ int big_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 	} else {
 		/* Just store the data in a buffer */
 		void *data = kmalloc(datalen, GFP_KERNEL);
-		if (!data) {
-			ret = -ENOMEM;
-			goto err_quota;
-		}
+		if (!data)
+			return -ENOMEM;
 
-		key->payload.data = memcpy(data, prep->data, prep->datalen);
+		prep->payload[0] = memcpy(data, prep->data, prep->datalen);
 	}
 	return 0;
 
 err_fput:
 	fput(file);
-err_quota:
-	key_payload_reserve(key, 0);
 error:
 	return ret;
 }
 
 /*
+ * Clear preparsement.
+ */
+void big_key_free_preparse(struct key_preparsed_payload *prep)
+{
+	if (prep->datalen > BIG_KEY_FILE_THRESHOLD) {
+		struct path *path = (struct path *)&prep->payload;
+		path_put(path);
+	} else {
+		kfree(prep->payload[0]);
+	}
+}
+
+/*
  * dispose of the links from a revoked keyring
  * - called with the key sem write-locked
  */

