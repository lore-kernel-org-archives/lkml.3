Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3KDQeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:34:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab3KDQeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:34:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 6/9] KEYS: Trusted: Use key preparsing
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:23:00 +0000
Message-ID: <20131104162300.10177.20700.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of key preparsing in trusted keys so that quota size determination
can take place prior to keyring locking when a key is being added.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/trusted.c |  190 ++++++++++++++++++++++-------------------------
 1 file changed, 90 insertions(+), 100 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index e13fcf7636f7..ac444e3cfaa7 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -859,52 +859,22 @@ static int datablob_parse(char *datablob, struct trusted_key_payload *p,
 	return ret;
 }
 
-static struct trusted_key_options *trusted_options_alloc(void)
-{
-	struct trusted_key_options *options;
-
-	options = kzalloc(sizeof *options, GFP_KERNEL);
-	if (options) {
-		/* set any non-zero defaults */
-		options->keytype = SRK_keytype;
-		options->keyhandle = SRKHANDLE;
-	}
-	return options;
-}
-
-static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
-{
-	struct trusted_key_payload *p = NULL;
-	int ret;
-
-	ret = key_payload_reserve(key, sizeof *p);
-	if (ret < 0)
-		return p;
-	p = kzalloc(sizeof *p, GFP_KERNEL);
-	if (p)
-		p->migratable = 1; /* migratable by default */
-	return p;
-}
-
 /*
- * trusted_instantiate - create a new trusted key
+ * trusted_preparse - Preparse data for an trusted key
  *
- * Unseal an existing trusted blob or, for a new key, get a
- * random key, then seal and create a trusted key-type key,
- * adding it to the specified keyring.
+ * Decrypt an existing encrypted datablob or create a new encrypted key
+ * based on a kernel random number.
  *
  * On success, return 0. Otherwise return errno.
  */
-static int trusted_instantiate(struct key *key,
-			       struct key_preparsed_payload *prep)
+static int trusted_preparse(struct key_preparsed_payload *prep)
 {
 	struct trusted_key_payload *payload = NULL;
 	struct trusted_key_options *options = NULL;
 	size_t datalen = prep->datalen;
 	char *datablob;
-	int ret = 0;
-	int key_cmd;
-	size_t key_len;
+	long key_cmd;
+	int ret = -ENOMEM;
 
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
@@ -915,16 +885,20 @@ static int trusted_instantiate(struct key *key,
 	memcpy(datablob, prep->data, datalen);
 	datablob[datalen] = '\0';
 
-	options = trusted_options_alloc();
-	if (!options) {
-		ret = -ENOMEM;
+	payload = kzalloc(sizeof(*payload), GFP_KERNEL);
+	if (!payload)
 		goto out;
-	}
-	payload = trusted_payload_alloc(key);
-	if (!payload) {
-		ret = -ENOMEM;
+	prep->payload[0] = payload;
+
+	options = kzalloc(sizeof(*options), GFP_KERNEL);
+	if (!options)
 		goto out;
-	}
+	prep->type_data[0] = options;
+
+	/* set any non-zero defaults */
+	payload->migratable = 1; /* migratable by default */
+	options->keytype = SRK_keytype;
+	options->keyhandle = SRKHANDLE;
 
 	key_cmd = datablob_parse(datablob, payload, options);
 	if (key_cmd < 0) {
@@ -932,42 +906,81 @@ static int trusted_instantiate(struct key *key,
 		goto out;
 	}
 
+	prep->type_data[1] = (void *)key_cmd;
+
 	dump_payload(payload);
 	dump_options(options);
+out:
+	kfree(datablob);
+	return ret;
+}
+
+static void trusted_free_preparse(struct key_preparsed_payload *prep)
+{
+	struct trusted_key_payload *p = prep->payload[0];
+	struct trusted_key_options *o = prep->type_data[0];
+
+	if (p) {
+		memset(p->key, 0, p->key_len);
+		kfree(p);
+	}
+	kfree(o);
+}
+
+/*
+ * trusted_instantiate - create a new trusted key
+ *
+ * Unseal an existing trusted blob or, for a new key, get a
+ * random key, then seal and create a trusted key-type key,
+ * adding it to the specified keyring.
+ *
+ * On success, return 0. Otherwise return errno.
+ */
+static int trusted_instantiate(struct key *key,
+			       struct key_preparsed_payload *prep)
+{
+	struct trusted_key_payload *payload = prep->payload[0];
+	struct trusted_key_options *options = prep->type_data[0];
+	long key_cmd = (unsigned long)prep->type_data[1];
+	int ret;
+	size_t key_len;
 
 	switch (key_cmd) {
 	case Opt_load:
 		ret = key_unseal(payload, options);
 		dump_payload(payload);
 		dump_options(options);
-		if (ret < 0)
+		if (ret < 0) {
 			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
+			return ret;
+		}
 		break;
 	case Opt_new:
 		key_len = payload->key_len;
 		ret = tpm_get_random(TPM_ANY_NUM, payload->key, key_len);
 		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
-			goto out;
+			return ret;
 		}
 		ret = key_seal(payload, options);
-		if (ret < 0)
+		if (ret < 0) {
 			pr_info("trusted_key: key_seal failed (%d)\n", ret);
+			return ret;
+		}
 		break;
 	default:
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
-	if (!ret && options->pcrlock)
+
+	if (options->pcrlock) {
 		ret = pcrlock(options->pcrlock);
-out:
-	kfree(datablob);
-	kfree(options);
-	if (!ret)
-		rcu_assign_keypointer(key, payload);
-	else
-		kfree(payload);
-	return ret;
+		if (ret < 0)
+			return ret;
+	}
+
+	rcu_assign_keypointer(key, prep->payload[0]);
+	prep->payload[0] = NULL;
+	return 0;
 }
 
 static void trusted_rcu_free(struct rcu_head *rcu)
@@ -985,39 +998,17 @@ static void trusted_rcu_free(struct rcu_head *rcu)
 static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct trusted_key_payload *p = key->payload.data;
-	struct trusted_key_payload *new_p;
-	struct trusted_key_options *new_o;
-	size_t datalen = prep->datalen;
-	char *datablob;
+	struct trusted_key_payload *new_p = prep->payload[0];
+	struct trusted_key_options *new_o = prep->type_data[0];
+	long key_cmd = (unsigned long)prep->type_data[1];
 	int ret = 0;
 
 	if (!p->migratable)
 		return -EPERM;
-	if (datalen <= 0 || datalen > 32767 || !prep->data)
-		return -EINVAL;
 
-	datablob = kmalloc(datalen + 1, GFP_KERNEL);
-	if (!datablob)
-		return -ENOMEM;
-	new_o = trusted_options_alloc();
-	if (!new_o) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	new_p = trusted_payload_alloc(key);
-	if (!new_p) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (key_cmd != Opt_update)
+		return -EINVAL;
 
-	memcpy(datablob, prep->data, datalen);
-	datablob[datalen] = '\0';
-	ret = datablob_parse(datablob, new_p, new_o);
-	if (ret != Opt_update) {
-		ret = -EINVAL;
-		kfree(new_p);
-		goto out;
-	}
 	/* copy old key values, and reseal with new pcrs */
 	new_p->migratable = p->migratable;
 	new_p->key_len = p->key_len;
@@ -1028,23 +1019,19 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = key_seal(new_p, new_o);
 	if (ret < 0) {
 		pr_info("trusted_key: key_seal failed (%d)\n", ret);
-		kfree(new_p);
-		goto out;
+		return ret;
 	}
 	if (new_o->pcrlock) {
 		ret = pcrlock(new_o->pcrlock);
 		if (ret < 0) {
 			pr_info("trusted_key: pcrlock failed (%d)\n", ret);
-			kfree(new_p);
-			goto out;
+			return ret;
 		}
 	}
 	rcu_assign_keypointer(key, new_p);
 	call_rcu(&p->rcu, trusted_rcu_free);
-out:
-	kfree(datablob);
-	kfree(new_o);
-	return ret;
+	prep->payload[0] = NULL;
+	return 0;
 }
 
 /*
@@ -1093,13 +1080,16 @@ static void trusted_destroy(struct key *key)
 }
 
 struct key_type key_type_trusted = {
-	.name = "trusted",
-	.instantiate = trusted_instantiate,
-	.update = trusted_update,
-	.match = user_match,
-	.destroy = trusted_destroy,
-	.describe = user_describe,
-	.read = trusted_read,
+	.name		= "trusted",
+	.def_datalen	= sizeof(struct trusted_key_payload),
+	.preparse	= trusted_preparse,
+	.free_preparse	= trusted_free_preparse,
+	.instantiate	= trusted_instantiate,
+	.update		= trusted_update,
+	.match		= user_match,
+	.destroy	= trusted_destroy,
+	.describe	= user_describe,
+	.read		= trusted_read,
 };
 
 EXPORT_SYMBOL_GPL(key_type_trusted);

