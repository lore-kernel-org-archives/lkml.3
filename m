Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3KDR01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:26:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KDR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:26:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 9/9] KEYS: Fix encrypted key type update method
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:23:21 +0000
Message-ID: <20131104162321.10177.34033.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The encrypted key type was using the update method to change the master key
used to encrypt a key without passing in all the requisite parameters to
completely replace the key contents (it was taking some parameters from the
old key contents).  Unfortunately, this has a number of problems:

 (1) Update is conceptually meant to be the same as add_key() except that it
     replaces the contents of the nominated key completely rather than creating
     a new key.

 (2) add_key() can call ->update() if it detects that the key exists.  This can
     cause the operation to fail if the caller embedded the wrong command in
     the payload when they called it.  The caller cannot know what the right
     command is without someway to lock the keyring.

 (3) keyctl_update() and add_key() can thus race with adding, linking,
     requesting and unlinking a key.

The best way to fix this is to offload this operation to keyctl_control() and
make encrypted_update() just replace the contents of a key entirely (or maybe
just not permit updates if this would be a problem).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/encrypted-keys/encrypted.c |  101 ++++++++++++++----------------
 1 file changed, 47 insertions(+), 54 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index f9e7b808fa47..c9e4fa5b1e2c 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -595,7 +595,7 @@ out:
 }
 
 /* Allocate memory for decrypted key and datablob. */
-static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
+static struct encrypted_key_payload *encrypted_key_alloc(size_t *_quotalen,
 							 const char *format,
 							 const char *master_desc,
 							 const char *datalen)
@@ -632,10 +632,7 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 	datablob_len = format_len + 1 + strlen(master_desc) + 1
 	    + strlen(datalen) + 1 + ivsize + 1 + encrypted_datalen;
 
-	ret = key_payload_reserve(key, payload_datalen + datablob_len
-				  + HASH_SIZE + 1);
-	if (ret < 0)
-		return ERR_PTR(ret);
+	*_quotalen = payload_datalen + datablob_len + HASH_SIZE + 1;
 
 	epayload = kzalloc(sizeof(*epayload) + payload_datalen +
 			   datablob_len + HASH_SIZE + 1, GFP_KERNEL);
@@ -773,8 +770,7 @@ static int encrypted_init(struct encrypted_key_payload *epayload,
  *
  * On success, return 0. Otherwise return errno.
  */
-static int encrypted_instantiate(struct key *key,
-				 struct key_preparsed_payload *prep)
+static int encrypted_preparse(struct key_preparsed_payload *prep)
 {
 	struct encrypted_key_payload *epayload = NULL;
 	char *datablob = NULL;
@@ -798,25 +794,55 @@ static int encrypted_instantiate(struct key *key,
 	if (ret < 0)
 		goto out;
 
-	epayload = encrypted_key_alloc(key, format, master_desc,
+	epayload = encrypted_key_alloc(&prep->quotalen, format, master_desc,
 				       decrypted_datalen);
 	if (IS_ERR(epayload)) {
 		ret = PTR_ERR(epayload);
 		goto out;
 	}
-	ret = encrypted_init(epayload, key->description, format, master_desc,
+	ret = encrypted_init(epayload, prep->description, format, master_desc,
 			     decrypted_datalen, hex_encoded_iv);
 	if (ret < 0) {
 		kfree(epayload);
 		goto out;
 	}
 
-	rcu_assign_keypointer(key, epayload);
+	prep->payload[0] = epayload;
+
 out:
 	kfree(datablob);
 	return ret;
 }
 
+/*
+ * encrypted_free_preparse - Clean up preparse data for an encrypted key
+ */
+static void encrypted_free_preparse(struct key_preparsed_payload *prep)
+{
+	struct encrypted_key_payload *epayload = prep->payload[0];
+
+	if (epayload) {
+		memset(epayload->decrypted_data, 0,
+		       epayload->decrypted_datalen);
+		kfree(epayload);
+	}
+}
+
+static int encrypted_instantiate(struct key *key,
+				 struct key_preparsed_payload *prep)
+{
+	struct encrypted_key_payload *epayload = prep->payload[0];
+	int ret;
+
+	ret = key_payload_reserve(key, prep->quotalen);
+	if (ret < 0)
+		return ret;
+
+	rcu_assign_keypointer(key, epayload);
+	prep->payload[0] = NULL;
+	return 0;
+}
+
 static void encrypted_rcu_free(struct rcu_head *rcu)
 {
 	struct encrypted_key_payload *epayload;
@@ -837,50 +863,15 @@ static void encrypted_rcu_free(struct rcu_head *rcu)
  */
 static int encrypted_update(struct key *key, struct key_preparsed_payload *prep)
 {
-	struct encrypted_key_payload *epayload = key->payload.data;
-	struct encrypted_key_payload *new_epayload;
-	char *buf;
-	char *new_master_desc = NULL;
-	const char *format = NULL;
-	size_t datalen = prep->datalen;
-	int ret = 0;
-
-	if (datalen <= 0 || datalen > 32767 || !prep->data)
-		return -EINVAL;
+	struct encrypted_key_payload *old;
+	struct encrypted_key_payload *new = prep->payload[0];
 
-	buf = kmalloc(datalen + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	buf[datalen] = 0;
-	memcpy(buf, prep->data, datalen);
-	ret = datablob_parse(buf, &format, &new_master_desc, NULL, NULL);
-	if (ret < 0)
-		goto out;
+	old = rcu_dereference_protected(key->payload.rcudata, &key->sem);
 
-	ret = valid_master_desc(new_master_desc, epayload->master_desc);
-	if (ret < 0)
-		goto out;
-
-	new_epayload = encrypted_key_alloc(key, epayload->format,
-					   new_master_desc, epayload->datalen);
-	if (IS_ERR(new_epayload)) {
-		ret = PTR_ERR(new_epayload);
-		goto out;
-	}
-
-	__ekey_init(new_epayload, epayload->format, new_master_desc,
-		    epayload->datalen);
-
-	memcpy(new_epayload->iv, epayload->iv, ivsize);
-	memcpy(new_epayload->payload_data, epayload->payload_data,
-	       epayload->payload_datalen);
-
-	rcu_assign_keypointer(key, new_epayload);
-	call_rcu(&epayload->rcu, encrypted_rcu_free);
-out:
-	kfree(buf);
-	return ret;
+	rcu_assign_keypointer(key, new);
+	prep->payload[0] = NULL;
+	call_rcu(&old->rcu, encrypted_rcu_free);
+	return 0;
 }
 
 /*
@@ -893,7 +884,7 @@ static long encrypted_control(struct key *key, char *command,
 	struct encrypted_key_payload *epayload, *new_epayload;
 	char *new_master_desc = NULL;
 	const char *format = NULL;
-	size_t datalen;
+	size_t datalen, quotalen;
 	int ret;
 
 	if (memcmp(command, expected_command, sizeof(expected_command) - 1) != 0)
@@ -917,7 +908,7 @@ static long encrypted_control(struct key *key, char *command,
 		return ret;
 	}
 
-	new_epayload = encrypted_key_alloc(key, epayload->format,
+	new_epayload = encrypted_key_alloc(&quotalen, epayload->format,
 					   new_master_desc, epayload->datalen);
 	if (IS_ERR(new_epayload)) {
 		up_write(&key->sem);
@@ -1023,6 +1014,8 @@ static void encrypted_destroy(struct key *key)
 
 struct key_type key_type_encrypted = {
 	.name = "encrypted",
+	.preparse = encrypted_preparse,
+	.free_preparse = encrypted_free_preparse,
 	.instantiate = encrypted_instantiate,
 	.update = encrypted_update,
 	.match = user_match,

