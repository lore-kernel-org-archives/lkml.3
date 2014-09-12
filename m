Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaILTFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaILTFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:05:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/9] KEYS: Preparse match data
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 20:05:20 +0100
Message-ID: <20140912190520.13239.67255.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
References: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparse the match data.  This provides several advantages:

 (1) The preparser can reject invalid criteria up front.

 (2) The preparser can convert the criteria to binary data if necessary (the
     asymmetric key type really wants to do binary comparison of the key IDs).

 (3) The preparser can set the type of search to be performed.  This means
     that it's not then a one-off setting in the key type.

 (4) The preparser can set an appropriate comparator function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c |   31 ++++++++++++++++++-
 include/keys/user-type.h                 |    4 ++
 include/linux/key-type.h                 |   31 +++++++++++++++++--
 net/dns_resolver/dns_key.c               |    5 ++-
 security/keys/internal.h                 |    8 ++---
 security/keys/keyring.c                  |   49 ++++++++++++++++++------------
 security/keys/proc.c                     |    8 ++---
 security/keys/process_keys.c             |   13 ++++----
 security/keys/request_key.c              |   21 ++++++++++---
 security/keys/request_key_auth.c         |    6 ++--
 security/keys/user_defined.c             |    4 +-
 11 files changed, 129 insertions(+), 51 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index eb8cd46961a5..f666b4e8d256 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -59,9 +59,11 @@ EXPORT_SYMBOL_GPL(asymmetric_keyid_match);
  *	"id:<id>"	- request a key matching the ID
  *	"<subtype>:<id>" - request a key of a subtype
  */
-static int asymmetric_key_match(const struct key *key, const void *description)
+static int asymmetric_key_match(const struct key *key,
+				const struct key_match_data *match_data)
 {
 	const struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
+	const char *description = match_data->raw_data;
 	const char *spec = description;
 	const char *id;
 	ptrdiff_t speclen;
@@ -94,6 +96,31 @@ static int asymmetric_key_match(const struct key *key, const void *description)
 }
 
 /*
+ * Preparse the match criterion.  If we don't set lookup_type and cmp,
+ * the default will be an exact match on the key description.
+ *
+ * There are some specifiers for matching key IDs rather than by the key
+ * description:
+ *
+ *	"id:<id>" - request a key by any available ID
+ *
+ * These have to be searched by iteration rather than by direct lookup because
+ * the key is hashed according to its description.
+ */
+static int asymmetric_key_match_preparse(struct key_match_data *match_data)
+{
+	match_data->lookup_type = KEYRING_SEARCH_LOOKUP_ITERATE;
+	return 0;
+}
+
+/*
+ * Free the preparsed the match criterion.
+ */
+static void asymmetric_key_match_free(struct key_match_data *match_data)
+{
+}
+
+/*
  * Describe the asymmetric key
  */
 static void asymmetric_key_describe(const struct key *key, struct seq_file *m)
@@ -196,7 +223,9 @@ struct key_type key_type_asymmetric = {
 	.preparse	= asymmetric_key_preparse,
 	.free_preparse	= asymmetric_key_free_preparse,
 	.instantiate	= generic_key_instantiate,
+	.match_preparse	= asymmetric_key_match_preparse,
 	.match		= asymmetric_key_match,
+	.match_free	= asymmetric_key_match_free,
 	.destroy	= asymmetric_key_destroy,
 	.describe	= asymmetric_key_describe,
 	.def_lookup_type = KEYRING_SEARCH_LOOKUP_ITERATE,
diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index 3ab1873a4bfa..66d92af30e7c 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -36,11 +36,13 @@ extern struct key_type key_type_user;
 extern struct key_type key_type_logon;
 
 struct key_preparsed_payload;
+struct key_match_data;
 
 extern int user_preparse(struct key_preparsed_payload *prep);
 extern void user_free_preparse(struct key_preparsed_payload *prep);
 extern int user_update(struct key *key, struct key_preparsed_payload *prep);
-extern int user_match(const struct key *key, const void *criterion);
+extern int user_match(const struct key *key,
+		      const struct key_match_data *match_data);
 extern void user_revoke(struct key *key);
 extern void user_destroy(struct key *key);
 extern void user_describe(const struct key *user, struct seq_file *m);
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 44792ee649de..8aba688a451a 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -53,6 +53,22 @@ typedef int (*request_key_actor_t)(struct key_construction *key,
 				   const char *op, void *aux);
 
 /*
+ * Preparsed matching criterion.
+ */
+struct key_match_data {
+	/* Comparison function, defaults to type->match, but can be replaced by
+	 * type->match_preparse(). */
+	int (*cmp)(const struct key *key,
+		   const struct key_match_data *match_data);
+
+	const void	*raw_data;	/* Raw match data */
+	void		*preparsed;	/* For ->match_preparse() to stash stuff */
+	unsigned	lookup_type;	/* Type of lookup for this search. */
+#define KEYRING_SEARCH_LOOKUP_DIRECT	0x0000	/* Direct lookup by description. */
+#define KEYRING_SEARCH_LOOKUP_ITERATE	0x0001	/* Iterative search. */
+};
+
+/*
  * kernel managed key type definition
  */
 struct key_type {
@@ -67,8 +83,6 @@ struct key_type {
 
 	/* Default key search algorithm. */
 	unsigned def_lookup_type;
-#define KEYRING_SEARCH_LOOKUP_DIRECT	0x0000	/* Direct lookup by description. */
-#define KEYRING_SEARCH_LOOKUP_ITERATE	0x0001	/* Iterative search. */
 
 	/* vet a description */
 	int (*vet_description)(const char *description);
@@ -96,8 +110,19 @@ struct key_type {
 	 */
 	int (*update)(struct key *key, struct key_preparsed_payload *prep);
 
+	/* Preparse the data supplied to ->match() (optional).  The
+	 * data to be preparsed can be found in match_data->raw_data.
+	 * The lookup type can also be set by this function.
+	 */
+	int (*match_preparse)(struct key_match_data *match_data);
+
 	/* match a key against a description */
-	int (*match)(const struct key *key, const void *desc);
+	int (*match)(const struct key *key,
+		     const struct key_match_data *match_data);
+
+	/* Free preparsed match data (optional).  This should be supplied it
+	 * ->match_preparse() is supplied. */
+	void (*match_free)(struct key_match_data *match_data);
 
 	/* clear some of the data from a key on revokation (optional)
 	 * - the key's semaphore will be write-locked by the caller
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index f380b2c58178..92df6e508ae7 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -177,10 +177,11 @@ static void dns_resolver_free_preparse(struct key_preparsed_payload *prep)
  * should end with a period).  The domain name is case-independent.
  */
 static int
-dns_resolver_match(const struct key *key, const void *description)
+dns_resolver_match(const struct key *key,
+		   const struct key_match_data *match_data)
 {
 	int slen, dlen, ret = 0;
-	const char *src = key->description, *dsp = description;
+	const char *src = key->description, *dsp = match_data->raw_data;
 
 	kenter("%s,%s", src, dsp);
 
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 5f20da01fd8d..805e60b0b87e 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -107,13 +107,10 @@ extern int iterate_over_keyring(const struct key *keyring,
 				int (*func)(const struct key *key, void *data),
 				void *data);
 
-typedef int (*key_match_func_t)(const struct key *, const void *);
-
 struct keyring_search_context {
 	struct keyring_index_key index_key;
 	const struct cred	*cred;
-	key_match_func_t	match;
-	const void		*match_data;
+	struct key_match_data	match_data;
 	unsigned		flags;
 #define KEYRING_SEARCH_LOOKUP_TYPE	0x0001	/* [as type->def_lookup_type] */
 #define KEYRING_SEARCH_NO_STATE_CHECK	0x0002	/* Skip state checks */
@@ -152,7 +149,8 @@ extern struct key *request_key_and_link(struct key_type *type,
 					struct key *dest_keyring,
 					unsigned long flags);
 
-extern int lookup_user_key_possessed(const struct key *key, const void *target);
+extern int lookup_user_key_possessed(const struct key *key,
+				     const struct key_match_data *match_data);
 extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
 				 key_perm_t perm);
 #define KEY_LOOKUP_CREATE	0x01
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 8314a7d2104d..10f0a5f2d362 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -545,7 +545,7 @@ static int keyring_search_iterator(const void *object, void *iterator_data)
 	}
 
 	/* keys that don't match */
-	if (!ctx->match(key, ctx->match_data)) {
+	if (!ctx->match_data.cmp(key, &ctx->match_data)) {
 		kleave(" = 0 [!match]");
 		return 0;
 	}
@@ -585,8 +585,7 @@ skipped:
  */
 static int search_keyring(struct key *keyring, struct keyring_search_context *ctx)
 {
-	if ((ctx->flags & KEYRING_SEARCH_LOOKUP_TYPE) ==
-	    KEYRING_SEARCH_LOOKUP_DIRECT) {
+	if (ctx->match_data.lookup_type == KEYRING_SEARCH_LOOKUP_DIRECT) {
 		const void *object;
 
 		object = assoc_array_find(&keyring->keys,
@@ -627,7 +626,7 @@ static bool search_nested_keyrings(struct key *keyring,
 	/* Check to see if this top-level keyring is what we are looking for
 	 * and whether it is valid or not.
 	 */
-	if (ctx->flags & KEYRING_SEARCH_LOOKUP_ITERATE ||
+	if (ctx->match_data.lookup_type == KEYRING_SEARCH_LOOKUP_ITERATE ||
 	    keyring_compare_object(keyring, &ctx->index_key)) {
 		ctx->skipped_ret = 2;
 		ctx->flags |= KEYRING_SEARCH_DO_STATE_CHECK;
@@ -885,16 +884,28 @@ key_ref_t keyring_search(key_ref_t keyring,
 		.index_key.type		= type,
 		.index_key.description	= description,
 		.cred			= current_cred(),
-		.match			= type->match,
-		.match_data		= description,
-		.flags			= (type->def_lookup_type |
-					   KEYRING_SEARCH_DO_STATE_CHECK),
+		.match_data.cmp		= type->match,
+		.match_data.raw_data	= description,
+		.match_data.lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.flags			= KEYRING_SEARCH_DO_STATE_CHECK,
 	};
+	key_ref_t key;
+	int ret;
 
-	if (!ctx.match)
+	if (!ctx.match_data.cmp)
 		return ERR_PTR(-ENOKEY);
 
-	return keyring_search_aux(keyring, &ctx);
+	if (type->match_preparse) {
+		ret = type->match_preparse(&ctx.match_data);
+		if (ret < 0)
+			return ERR_PTR(ret);
+	}
+
+	key = keyring_search_aux(keyring, &ctx);
+
+	if (type->match_free)
+		type->match_free(&ctx.match_data);
+	return key;
 }
 EXPORT_SYMBOL(keyring_search);
 
@@ -1014,7 +1025,7 @@ static int keyring_detect_cycle_iterator(const void *object,
 
 	/* We might get a keyring with matching index-key that is nonetheless a
 	 * different keyring. */
-	if (key != ctx->match_data)
+	if (key != ctx->match_data.raw_data)
 		return 0;
 
 	ctx->result = ERR_PTR(-EDEADLK);
@@ -1031,14 +1042,14 @@ static int keyring_detect_cycle_iterator(const void *object,
 static int keyring_detect_cycle(struct key *A, struct key *B)
 {
 	struct keyring_search_context ctx = {
-		.index_key	= A->index_key,
-		.match_data	= A,
-		.iterator	= keyring_detect_cycle_iterator,
-		.flags		= (KEYRING_SEARCH_LOOKUP_DIRECT |
-				   KEYRING_SEARCH_NO_STATE_CHECK |
-				   KEYRING_SEARCH_NO_UPDATE_TIME |
-				   KEYRING_SEARCH_NO_CHECK_PERM |
-				   KEYRING_SEARCH_DETECT_TOO_DEEP),
+		.index_key		= A->index_key,
+		.match_data.raw_data	= A,
+		.match_data.lookup_type = KEYRING_SEARCH_LOOKUP_DIRECT,
+		.iterator		= keyring_detect_cycle_iterator,
+		.flags			= (KEYRING_SEARCH_NO_STATE_CHECK |
+					   KEYRING_SEARCH_NO_UPDATE_TIME |
+					   KEYRING_SEARCH_NO_CHECK_PERM |
+					   KEYRING_SEARCH_DETECT_TOO_DEEP),
 	};
 
 	rcu_read_lock();
diff --git a/security/keys/proc.c b/security/keys/proc.c
index d3f6f2fd21db..972eeb336b81 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -194,10 +194,10 @@ static int proc_keys_show(struct seq_file *m, void *v)
 		.index_key.type		= key->type,
 		.index_key.description	= key->description,
 		.cred			= current_cred(),
-		.match			= lookup_user_key_possessed,
-		.match_data		= key,
-		.flags			= (KEYRING_SEARCH_NO_STATE_CHECK |
-					   KEYRING_SEARCH_LOOKUP_DIRECT),
+		.match_data.cmp		= lookup_user_key_possessed,
+		.match_data.raw_data	= key,
+		.match_data.lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.flags			= KEYRING_SEARCH_NO_STATE_CHECK,
 	};
 
 	key_ref = make_key_ref(key, 0);
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 0cf8a130a267..08bd533d014f 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -489,9 +489,10 @@ found:
 /*
  * See if the key we're looking at is the target key.
  */
-int lookup_user_key_possessed(const struct key *key, const void *target)
+int lookup_user_key_possessed(const struct key *key,
+			      const struct key_match_data *match_data)
 {
-	return key == target;
+	return key == match_data->raw_data;
 }
 
 /*
@@ -516,9 +517,9 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 			  key_perm_t perm)
 {
 	struct keyring_search_context ctx = {
-		.match	= lookup_user_key_possessed,
-		.flags	= (KEYRING_SEARCH_NO_STATE_CHECK |
-			   KEYRING_SEARCH_LOOKUP_DIRECT),
+		.match_data.cmp		= lookup_user_key_possessed,
+		.match_data.lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.flags			= KEYRING_SEARCH_NO_STATE_CHECK,
 	};
 	struct request_key_auth *rka;
 	struct key *key;
@@ -673,7 +674,7 @@ try_again:
 		ctx.index_key.type		= key->type;
 		ctx.index_key.description	= key->description;
 		ctx.index_key.desc_len		= strlen(key->description);
-		ctx.match_data			= key;
+		ctx.match_data.raw_data		= key;
 		kdebug("check possessed");
 		skey_ref = search_process_keyrings(&ctx);
 		kdebug("possessed=%p", skey_ref);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 26a94f18af94..5dd2088ade23 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -513,9 +513,9 @@ struct key *request_key_and_link(struct key_type *type,
 		.index_key.type		= type,
 		.index_key.description	= description,
 		.cred			= current_cred(),
-		.match			= type->match,
-		.match_data		= description,
-		.flags			= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.match_data.cmp		= type->match,
+		.match_data.raw_data	= description,
+		.match_data.lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	};
 	struct key *key;
 	key_ref_t key_ref;
@@ -525,6 +525,14 @@ struct key *request_key_and_link(struct key_type *type,
 	       ctx.index_key.type->name, ctx.index_key.description,
 	       callout_info, callout_len, aux, dest_keyring, flags);
 
+	if (type->match_preparse) {
+		ret = type->match_preparse(&ctx.match_data);
+		if (ret < 0) {
+			key = ERR_PTR(ret);
+			goto error;
+		}
+	}
+
 	/* search all the process keyrings for a key */
 	key_ref = search_process_keyrings(&ctx);
 
@@ -537,7 +545,7 @@ struct key *request_key_and_link(struct key_type *type,
 			if (ret < 0) {
 				key_put(key);
 				key = ERR_PTR(ret);
-				goto error;
+				goto error_free;
 			}
 		}
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
@@ -547,12 +555,15 @@ struct key *request_key_and_link(struct key_type *type,
 		 * should consult userspace if we can */
 		key = ERR_PTR(-ENOKEY);
 		if (!callout_info)
-			goto error;
+			goto error_free;
 
 		key = construct_key_and_link(&ctx, callout_info, callout_len,
 					     aux, dest_keyring, flags);
 	}
 
+error_free:
+	if (type->match_free)
+		type->match_free(&ctx.match_data);
 error:
 	kleave(" = %p", key);
 	return key;
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 739e7455d388..9ae02819cc06 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -246,9 +246,9 @@ struct key *key_get_instantiation_authkey(key_serial_t target_id)
 		.index_key.type		= &key_type_request_key_auth,
 		.index_key.description	= description,
 		.cred			= current_cred(),
-		.match			= user_match,
-		.match_data		= description,
-		.flags			= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.match_data.cmp		= user_match,
+		.match_data.raw_data	= description,
+		.match_data.lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	};
 	struct key *authkey;
 	key_ref_t authkey_ref;
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index eee340011f2b..ec8a56063b02 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -141,9 +141,9 @@ EXPORT_SYMBOL_GPL(user_update);
 /*
  * match users on their name
  */
-int user_match(const struct key *key, const void *description)
+int user_match(const struct key *key, const struct key_match_data *match_data)
 {
-	return strcmp(key->description, description) == 0;
+	return strcmp(key->description, match_data->raw_data) == 0;
 }
 
 EXPORT_SYMBOL_GPL(user_match);

