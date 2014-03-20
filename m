Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbaCTMFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbaCTMFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:05:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 05/12] KEYS: user: Use key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:13 +0000
Message-ID: <20140320120513.21635.97584.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of key preparsing in user-defined and logon keys so that quota size
determination can take place prior to keyring locking when a key is being
added.

Also the idmapper key types need to change to match as they use the
user-defined key type routines.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/idmap.c               |    8 ++++++--
 include/keys/user-type.h     |    3 ++-
 security/keys/user_defined.c |   41 ++++++++++++++++++++++-------------------
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 567983d2c0eb..59b217a3266d 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -174,7 +174,9 @@ static int nfs_map_numeric_to_string(__u32 id, char *buf, size_t buflen)
 
 static struct key_type key_type_id_resolver = {
 	.name		= "id_resolver",
-	.instantiate	= user_instantiate,
+	.preparse	= user_preparse,
+	.free_preparse	= user_free_preparse,
+	.instantiate	= generic_key_instantiate,
 	.match		= user_match,
 	.revoke		= user_revoke,
 	.destroy	= user_destroy,
@@ -394,7 +396,9 @@ static const struct rpc_pipe_ops idmap_upcall_ops = {
 
 static struct key_type key_type_id_resolver_legacy = {
 	.name		= "id_legacy",
-	.instantiate	= user_instantiate,
+	.preparse	= user_preparse,
+	.free_preparse	= user_free_preparse,
+	.instantiate	= generic_key_instantiate,
 	.match		= user_match,
 	.revoke		= user_revoke,
 	.destroy	= user_destroy,
diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index 5e452c84f1e6..3ab1873a4bfa 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -37,7 +37,8 @@ extern struct key_type key_type_logon;
 
 struct key_preparsed_payload;
 
-extern int user_instantiate(struct key *key, struct key_preparsed_payload *prep);
+extern int user_preparse(struct key_preparsed_payload *prep);
+extern void user_free_preparse(struct key_preparsed_payload *prep);
 extern int user_update(struct key *key, struct key_preparsed_payload *prep);
 extern int user_match(const struct key *key, const void *criterion);
 extern void user_revoke(struct key *key);
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index faa2caeb593f..eee340011f2b 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -27,7 +27,9 @@ static int logon_vet_description(const char *desc);
 struct key_type key_type_user = {
 	.name			= "user",
 	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
-	.instantiate		= user_instantiate,
+	.preparse		= user_preparse,
+	.free_preparse		= user_free_preparse,
+	.instantiate		= generic_key_instantiate,
 	.update			= user_update,
 	.match			= user_match,
 	.revoke			= user_revoke,
@@ -47,7 +49,9 @@ EXPORT_SYMBOL_GPL(key_type_user);
 struct key_type key_type_logon = {
 	.name			= "logon",
 	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
-	.instantiate		= user_instantiate,
+	.preparse		= user_preparse,
+	.free_preparse		= user_free_preparse,
+	.instantiate		= generic_key_instantiate,
 	.update			= user_update,
 	.match			= user_match,
 	.revoke			= user_revoke,
@@ -58,38 +62,37 @@ struct key_type key_type_logon = {
 EXPORT_SYMBOL_GPL(key_type_logon);
 
 /*
- * instantiate a user defined key
+ * Preparse a user defined key payload
  */
-int user_instantiate(struct key *key, struct key_preparsed_payload *prep)
+int user_preparse(struct key_preparsed_payload *prep)
 {
 	struct user_key_payload *upayload;
 	size_t datalen = prep->datalen;
-	int ret;
 
-	ret = -EINVAL;
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
-		goto error;
-
-	ret = key_payload_reserve(key, datalen);
-	if (ret < 0)
-		goto error;
+		return -EINVAL;
 
-	ret = -ENOMEM;
 	upayload = kmalloc(sizeof(*upayload) + datalen, GFP_KERNEL);
 	if (!upayload)
-		goto error;
+		return -ENOMEM;
 
 	/* attach the data */
+	prep->quotalen = datalen;
+	prep->payload[0] = upayload;
 	upayload->datalen = datalen;
 	memcpy(upayload->data, prep->data, datalen);
-	rcu_assign_keypointer(key, upayload);
-	ret = 0;
-
-error:
-	return ret;
+	return 0;
 }
+EXPORT_SYMBOL_GPL(user_preparse);
 
-EXPORT_SYMBOL_GPL(user_instantiate);
+/*
+ * Free a preparse of a user defined key payload
+ */
+void user_free_preparse(struct key_preparsed_payload *prep)
+{
+	kfree(prep->payload[0]);
+}
+EXPORT_SYMBOL_GPL(user_free_preparse);
 
 /*
  * update a user defined key

