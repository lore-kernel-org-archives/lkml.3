Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbaIOUpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336AbaIOUpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:45:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 08/10] KEYS: Overhaul key identification when searching for
 asymmetric keys [ver #2]
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 21:45:39 +0100
Message-ID: <20140915204539.27499.6081.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
References: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new match string preparsing to overhaul key identification
when searching for asymmetric keys.  The following changes are made:

 (1) Use the previously created asymmetric_key_id struct to hold the following
     key IDs derived from the X.509 certificate or PKCS#7 message:

	id: serial number + issuer
	skid: subjKeyId + subject
	authority: authKeyId + issuer

 (2) Replace the hex fingerprint attached to key->type_data[1] with an
     asymmetric_key_ids struct containing the id and the skid (if present).

 (3) Make the asymmetric_type match data preparse select one of two searches:

     (a) An iterative search for the key ID given if prefixed with "id:".  The
     	 prefix is expected to be followed by a hex string giving the ID to
     	 search for.  The criterion key ID is checked against all key IDs
     	 recorded on the key.

     (b) A direct search if the key ID is not prefixed with "id:".  This will
     	 look for an exact match on the key description.

 (4) Make x509_request_asymmetric_key() take a key ID.  This is then converted
     into "id:<hex>" and passed into keyring_search() where match preparsing
     will turn it back into a binary ID.

 (5) X.509 certificate verification then takes the authority key ID and looks
     up a key that matches it to find the public key for the certificate
     signature.

 (6) PKCS#7 certificate verification then takes the id key ID and looks up a
     key that matches it to find the public key for the signed information
     block signature.

Additional changes:

 (1) Multiple subjKeyId and authKeyId values on an X.509 certificate cause the
     cert to be rejected with -EBADMSG.

 (2) The 'fingerprint' ID is gone.  This was primarily intended to convey PGP
     public key fingerprints.  If PGP is supported in future, this should
     generate a key ID that carries the fingerprint.

 (3) Th ca_keyid= kernel command line option is now converted to a key ID and
     used to match the authority key ID.  Possibly this should only match the
     actual authKeyId part and not the issuer as well.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_keys.h  |    4 -
 crypto/asymmetric_keys/asymmetric_type.c  |  133 ++++++++++++-----------------
 crypto/asymmetric_keys/pkcs7_parser.c     |   38 ++++++--
 crypto/asymmetric_keys/pkcs7_parser.h     |    5 -
 crypto/asymmetric_keys/pkcs7_trust.c      |    6 -
 crypto/asymmetric_keys/pkcs7_verify.c     |   44 ++++------
 crypto/asymmetric_keys/x509_cert_parser.c |   55 +++++++-----
 crypto/asymmetric_keys/x509_parser.h      |    5 +
 crypto/asymmetric_keys/x509_public_key.c  |   89 +++++++++++--------
 include/crypto/public_key.h               |    5 +
 10 files changed, 198 insertions(+), 186 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
index 917be6b985e7..fd21ac28e0a0 100644
--- a/crypto/asymmetric_keys/asymmetric_keys.h
+++ b/crypto/asymmetric_keys/asymmetric_keys.h
@@ -9,13 +9,13 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-int asymmetric_keyid_match(const char *kid, const char *id);
 extern bool asymmetric_match_key_ids(const struct asymmetric_key_ids *kids,
 				     const struct asymmetric_key_id *match_id);
 
 extern struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id);
 
-static inline const char *asymmetric_key_id(const struct key *key)
+static inline
+const struct asymmetric_key_ids *asymmetric_key_ids(const struct key *key)
 {
 	return key->type_data.p[1];
 }
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 92bfc438dd1d..718e779a010e 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -112,76 +112,15 @@ struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
 }
 
 /*
- * Match asymmetric key id with partial match
- * @id:		key id to match in a form "id:<id>"
- */
-int asymmetric_keyid_match(const char *kid, const char *id)
-{
-	size_t idlen, kidlen;
-
-	if (!kid || !id)
-		return 0;
-
-	/* make it possible to use id as in the request: "id:<id>" */
-	if (strncmp(id, "id:", 3) == 0)
-		id += 3;
-
-	/* Anything after here requires a partial match on the ID string */
-	idlen = strlen(id);
-	kidlen = strlen(kid);
-	if (idlen > kidlen)
-		return 0;
-
-	kid += kidlen - idlen;
-	if (strcasecmp(id, kid) != 0)
-		return 0;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(asymmetric_keyid_match);
-
-/*
- * Match asymmetric keys on (part of) their name
- * We have some shorthand methods for matching keys.  We allow:
- *
- *	"<desc>"	- request a key by description
- *	"id:<id>"	- request a key matching the ID
- *	"<subtype>:<id>" - request a key of a subtype
+ * Match asymmetric keys by ID.
  */
 static bool asymmetric_key_cmp(const struct key *key,
 			       const struct key_match_data *match_data)
 {
-	const struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
-	const char *description = match_data->raw_data;
-	const char *spec = description;
-	const char *id;
-	ptrdiff_t speclen;
-
-	if (!subtype || !spec || !*spec)
-		return 0;
-
-	/* See if the full key description matches as is */
-	if (key->description && strcmp(key->description, description) == 0)
-		return 1;
-
-	/* All tests from here on break the criterion description into a
-	 * specifier, a colon and then an identifier.
-	 */
-	id = strchr(spec, ':');
-	if (!id)
-		return 0;
-
-	speclen = id - spec;
-	id++;
-
-	if (speclen == 2 && memcmp(spec, "id", 2) == 0)
-		return asymmetric_keyid_match(asymmetric_key_id(key), id);
+	const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
+	const struct asymmetric_key_id *match_id = match_data->preparsed;
 
-	if (speclen == subtype->name_len &&
-	    memcmp(spec, subtype->name, speclen) == 0)
-		return 1;
-
-	return 0;
+	return asymmetric_match_key_ids(kids, match_id);
 }
 
 /*
@@ -198,8 +137,30 @@ static bool asymmetric_key_cmp(const struct key *key,
  */
 static int asymmetric_key_match_preparse(struct key_match_data *match_data)
 {
-	match_data->lookup_type = KEYRING_SEARCH_LOOKUP_ITERATE;
+	struct asymmetric_key_id *match_id;
+	const char *spec = match_data->raw_data;
+	const char *id;
+
+	if (!spec || !*spec)
+		return -EINVAL;
+	if (spec[0] == 'i' &&
+	    spec[1] == 'd' &&
+	    spec[2] == ':') {
+		id = spec + 3;
+	} else {
+		goto default_match;
+	}
+
+	match_id = asymmetric_key_hex_to_key_id(id);
+	if (!match_id)
+		return -ENOMEM;
+
+	match_data->preparsed = match_id;
 	match_data->cmp = asymmetric_key_cmp;
+	match_data->lookup_type = KEYRING_SEARCH_LOOKUP_ITERATE;
+	return 0;
+
+default_match:
 	return 0;
 }
 
@@ -208,6 +169,7 @@ static int asymmetric_key_match_preparse(struct key_match_data *match_data)
  */
 static void asymmetric_key_match_free(struct key_match_data *match_data)
 {
+	kfree(match_data->preparsed);
 }
 
 /*
@@ -216,8 +178,10 @@ static void asymmetric_key_match_free(struct key_match_data *match_data)
 static void asymmetric_key_describe(const struct key *key, struct seq_file *m)
 {
 	const struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
-	const char *kid = asymmetric_key_id(key);
-	size_t n;
+	const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
+	const struct asymmetric_key_id *kid;
+	const unsigned char *p;
+	int n;
 
 	seq_puts(m, key->description);
 
@@ -225,13 +189,16 @@ static void asymmetric_key_describe(const struct key *key, struct seq_file *m)
 		seq_puts(m, ": ");
 		subtype->describe(key, m);
 
-		if (kid) {
+		if (kids && kids->id[0]) {
+			kid = kids->id[0];
 			seq_putc(m, ' ');
-			n = strlen(kid);
-			if (n <= 8)
-				seq_puts(m, kid);
-			else
-				seq_puts(m, kid + n - 8);
+			n = kid->len;
+			p = kid->data;
+			if (n > 8) {
+				p += n - 8;
+				n = 8;
+			}
+			seq_printf(m, "%*phN", n, p);
 		}
 
 		seq_puts(m, " [");
@@ -282,6 +249,7 @@ static int asymmetric_key_preparse(struct key_preparsed_payload *prep)
 static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 {
 	struct asymmetric_key_subtype *subtype = prep->type_data[0];
+	struct asymmetric_key_ids *kids = prep->type_data[1];
 
 	pr_devel("==>%s()\n", __func__);
 
@@ -289,7 +257,11 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 		subtype->destroy(prep->payload[0]);
 		module_put(subtype->owner);
 	}
-	kfree(prep->type_data[1]);
+	if (kids) {
+		kfree(kids->id[0]);
+		kfree(kids->id[1]);
+		kfree(kids);
+	}
 	kfree(prep->description);
 }
 
@@ -299,13 +271,20 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 static void asymmetric_key_destroy(struct key *key)
 {
 	struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
+	struct asymmetric_key_ids *kids = key->type_data.p[1];
+
 	if (subtype) {
 		subtype->destroy(key->payload.data);
 		module_put(subtype->owner);
 		key->type_data.p[0] = NULL;
 	}
-	kfree(key->type_data.p[1]);
-	key->type_data.p[1] = NULL;
+
+	if (kids) {
+		kfree(kids->id[0]);
+		kfree(kids->id[1]);
+		kfree(kids);
+		key->type_data.p[1] = NULL;
+	}
 }
 
 struct key_type key_type_asymmetric = {
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 1e9861da7ee4..3bd5a1e4c493 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -29,6 +29,10 @@ struct pkcs7_parse_context {
 	enum OID	last_oid;		/* Last OID encountered */
 	unsigned	x509_index;
 	unsigned	sinfo_index;
+	const void	*raw_serial;
+	unsigned	raw_serial_size;
+	unsigned	raw_issuer_size;
+	const void	*raw_issuer;
 };
 
 /*
@@ -39,6 +43,7 @@ static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
 	if (sinfo) {
 		mpi_free(sinfo->sig.mpi[0]);
 		kfree(sinfo->sig.digest);
+		kfree(sinfo->signing_cert_id);
 		kfree(sinfo);
 	}
 }
@@ -251,10 +256,10 @@ int pkcs7_extract_cert(void *context, size_t hdrlen,
 	if (IS_ERR(x509))
 		return PTR_ERR(x509);
 
-	pr_debug("Got cert for %s\n", x509->subject);
-	pr_debug("- fingerprint %s\n", x509->fingerprint);
-
 	x509->index = ++ctx->x509_index;
+	pr_debug("Got cert %u for %s\n", x509->index, x509->subject);
+	pr_debug("- fingerprint %*phN\n", x509->id->len, x509->id->data);
+
 	*ctx->ppcerts = x509;
 	ctx->ppcerts = &x509->next;
 	return 0;
@@ -343,8 +348,8 @@ int pkcs7_sig_note_serial(void *context, size_t hdrlen,
 			  const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
-	ctx->sinfo->raw_serial = value;
-	ctx->sinfo->raw_serial_size = vlen;
+	ctx->raw_serial = value;
+	ctx->raw_serial_size = vlen;
 	return 0;
 }
 
@@ -356,8 +361,8 @@ int pkcs7_sig_note_issuer(void *context, size_t hdrlen,
 			  const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
-	ctx->sinfo->raw_issuer = value;
-	ctx->sinfo->raw_issuer_size = vlen;
+	ctx->raw_issuer = value;
+	ctx->raw_issuer_size = vlen;
 	return 0;
 }
 
@@ -390,10 +395,21 @@ int pkcs7_note_signed_info(void *context, size_t hdrlen,
 			   const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
-
-	ctx->sinfo->index = ++ctx->sinfo_index;
-	*ctx->ppsinfo = ctx->sinfo;
-	ctx->ppsinfo = &ctx->sinfo->next;
+	struct pkcs7_signed_info *sinfo = ctx->sinfo;
+	struct asymmetric_key_id *kid;
+
+	/* Generate cert issuer + serial number key ID */
+	kid = asymmetric_key_generate_id(ctx->raw_serial,
+					 ctx->raw_serial_size,
+					 ctx->raw_issuer,
+					 ctx->raw_issuer_size);
+	if (IS_ERR(kid))
+		return PTR_ERR(kid);
+
+	sinfo->signing_cert_id = kid;
+	sinfo->index = ++ctx->sinfo_index;
+	*ctx->ppsinfo = sinfo;
+	ctx->ppsinfo = &sinfo->next;
 	ctx->sinfo = kzalloc(sizeof(struct pkcs7_signed_info), GFP_KERNEL);
 	if (!ctx->sinfo)
 		return -ENOMEM;
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index d25f4d15370f..91949f92bc72 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -33,10 +33,7 @@ struct pkcs7_signed_info {
 	const void	*authattrs;
 
 	/* Issuing cert serial number and issuer's name */
-	const void	*raw_serial;
-	unsigned	raw_serial_size;
-	unsigned	raw_issuer_size;
-	const void	*raw_issuer;
+	struct asymmetric_key_id *signing_cert_id;
 
 	/* Message signature.
 	 *
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index fad888ea4fad..09197e50fa82 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -49,8 +49,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		/* Look to see if this certificate is present in the trusted
 		 * keys.
 		 */
-		key = x509_request_asymmetric_key(trust_keyring, x509->subject,
-						  x509->fingerprint);
+		key = x509_request_asymmetric_key(trust_keyring, x509->id);
 		if (!IS_ERR(key))
 			/* One of the X.509 certificates in the PKCS#7 message
 			 * is apparently the same as one we already trust.
@@ -82,8 +81,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		return -ENOKEY;
 	}
 
-	key = x509_request_asymmetric_key(trust_keyring, last->issuer,
-					  last->authority);
+	key = x509_request_asymmetric_key(trust_keyring, last->authority);
 	if (IS_ERR(key))
 		return PTR_ERR(key) == -ENOMEM ? -ENOMEM : -ENOKEY;
 	x509 = last;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index c62cf8006e1f..57e90fa17f2b 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -131,8 +131,7 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 	struct x509_certificate *x509;
 	unsigned certix = 1;
 
-	kenter("%u,%u,%u",
-	       sinfo->index, sinfo->raw_serial_size, sinfo->raw_issuer_size);
+	kenter("%u", sinfo->index);
 
 	for (x509 = pkcs7->certs; x509; x509 = x509->next, certix++) {
 		/* I'm _assuming_ that the generator of the PKCS#7 message will
@@ -140,21 +139,11 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		 * PKCS#7 message - but I can't be 100% sure of that.  It's
 		 * possible this will need element-by-element comparison.
 		 */
-		if (x509->raw_serial_size != sinfo->raw_serial_size ||
-		    memcmp(x509->raw_serial, sinfo->raw_serial,
-			   sinfo->raw_serial_size) != 0)
+		if (!asymmetric_key_id_same(x509->id, sinfo->signing_cert_id))
 			continue;
 		pr_devel("Sig %u: Found cert serial match X.509[%u]\n",
 			 sinfo->index, certix);
 
-		if (x509->raw_issuer_size != sinfo->raw_issuer_size ||
-		    memcmp(x509->raw_issuer, sinfo->raw_issuer,
-			   sinfo->raw_issuer_size) != 0) {
-			pr_warn("Sig %u: X.509 subject and PKCS#7 issuer don't match\n",
-				sinfo->index);
-			continue;
-		}
-
 		if (x509->pub->pkey_algo != sinfo->sig.pkey_algo) {
 			pr_warn("Sig %u: X.509 algo and PKCS#7 sig algo don't match\n",
 				sinfo->index);
@@ -164,8 +153,10 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		sinfo->signer = x509;
 		return 0;
 	}
+
 	pr_warn("Sig %u: Issuing X.509 cert not found (#%*ph)\n",
-		sinfo->index, sinfo->raw_serial_size, sinfo->raw_serial);
+		sinfo->index,
+		sinfo->signing_cert_id->len, sinfo->signing_cert_id->data);
 	return -ENOKEY;
 }
 
@@ -184,7 +175,9 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		p->seen = false;
 
 	for (;;) {
-		pr_debug("verify %s: %s\n", x509->subject, x509->fingerprint);
+		pr_debug("verify %s: %*phN\n",
+			 x509->subject,
+			 x509->raw_serial_size, x509->raw_serial);
 		x509->seen = true;
 		ret = x509_get_sig_params(x509);
 		if (ret < 0)
@@ -192,7 +185,8 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 
 		pr_debug("- issuer %s\n", x509->issuer);
 		if (x509->authority)
-			pr_debug("- authkeyid %s\n", x509->authority);
+			pr_debug("- authkeyid %*phN\n",
+				 x509->authority->len, x509->authority->data);
 
 		if (!x509->authority ||
 		    strcmp(x509->subject, x509->issuer) == 0) {
@@ -218,13 +212,14 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		/* Look through the X.509 certificates in the PKCS#7 message's
 		 * list to see if the next one is there.
 		 */
-		pr_debug("- want %s\n", x509->authority);
+		pr_debug("- want %*phN\n",
+			 x509->authority->len, x509->authority->data);
 		for (p = pkcs7->certs; p; p = p->next) {
-			pr_debug("- cmp [%u] %s\n", p->index, p->fingerprint);
-			if (p->raw_subject_size == x509->raw_issuer_size &&
-			    strcmp(p->fingerprint, x509->authority) == 0 &&
-			    memcmp(p->raw_subject, x509->raw_issuer,
-				   x509->raw_issuer_size) == 0)
+			if (!p->skid)
+				continue;
+			pr_debug("- cmp [%u] %*phN\n",
+				 p->index, p->skid->len, p->skid->data);
+			if (asymmetric_key_id_same(p->skid, x509->authority))
 				goto found_issuer;
 		}
 
@@ -233,7 +228,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		return 0;
 
 	found_issuer:
-		pr_debug("- issuer %s\n", p->subject);
+		pr_debug("- subject %s\n", p->subject);
 		if (p->seen) {
 			pr_warn("Sig %u: X.509 chain contains loop\n",
 				sinfo->index);
@@ -304,7 +299,8 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 		ret = x509_get_sig_params(x509);
 		if (ret < 0)
 			return ret;
-		pr_debug("X.509[%u] %s\n", n, x509->authority);
+		pr_debug("X.509[%u] %*phN\n",
+			 n, x509->authority->len, x509->authority->data);
 	}
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index ac72348c186a..96151b2b91a2 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -46,7 +46,8 @@ void x509_free_certificate(struct x509_certificate *cert)
 		public_key_destroy(cert->pub);
 		kfree(cert->issuer);
 		kfree(cert->subject);
-		kfree(cert->fingerprint);
+		kfree(cert->id);
+		kfree(cert->skid);
 		kfree(cert->authority);
 		kfree(cert->sig.digest);
 		mpi_free(cert->sig.rsa.s);
@@ -62,6 +63,7 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 {
 	struct x509_certificate *cert;
 	struct x509_parse_context *ctx;
+	struct asymmetric_key_id *kid;
 	long ret;
 
 	ret = -ENOMEM;
@@ -89,6 +91,17 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	if (ret < 0)
 		goto error_decode;
 
+	/* Generate cert issuer + serial number key ID */
+	kid = asymmetric_key_generate_id(cert->raw_serial,
+					 cert->raw_serial_size,
+					 cert->raw_issuer,
+					 cert->raw_issuer_size);
+	if (IS_ERR(kid)) {
+		ret = PTR_ERR(kid);
+		goto error_decode;
+	}
+	cert->id = kid;
+
 	kfree(ctx);
 	return cert;
 
@@ -407,36 +420,34 @@ int x509_process_extension(void *context, size_t hdrlen,
 			   const void *value, size_t vlen)
 {
 	struct x509_parse_context *ctx = context;
+	struct asymmetric_key_id *kid;
 	const unsigned char *v = value;
-	char *f;
 	int i;
 
 	pr_debug("Extension: %u\n", ctx->last_oid);
 
 	if (ctx->last_oid == OID_subjectKeyIdentifier) {
 		/* Get hold of the key fingerprint */
-		if (vlen < 3)
+		if (ctx->cert->skid || vlen < 3)
 			return -EBADMSG;
 		if (v[0] != ASN1_OTS || v[1] != vlen - 2)
 			return -EBADMSG;
 		v += 2;
 		vlen -= 2;
 
-		f = kmalloc(vlen * 2 + 1, GFP_KERNEL);
-		if (!f)
-			return -ENOMEM;
-		for (i = 0; i < vlen; i++)
-			sprintf(f + i * 2, "%02x", v[i]);
-		pr_debug("fingerprint %s\n", f);
-		ctx->cert->fingerprint = f;
+		kid = asymmetric_key_generate_id(v, vlen,
+						 ctx->cert->raw_subject,
+						 ctx->cert->raw_subject_size);
+		if (IS_ERR(kid))
+			return PTR_ERR(kid);
+		ctx->cert->skid = kid;
+		pr_debug("subjkeyid %*phN\n", kid->len, kid->data);
 		return 0;
 	}
 
 	if (ctx->last_oid == OID_authorityKeyIdentifier) {
-		size_t key_len;
-
 		/* Get hold of the CA key fingerprint */
-		if (vlen < 5)
+		if (ctx->cert->authority || vlen < 5)
 			return -EBADMSG;
 
 		/* Authority Key Identifier must be a Constructed SEQUENCE */
@@ -454,7 +465,7 @@ int x509_process_extension(void *context, size_t hdrlen,
 			    v[3] > vlen - 4)
 				return -EBADMSG;
 
-			key_len = v[3];
+			vlen = v[3];
 			v += 4;
 		} else {
 			/* Long Form length */
@@ -476,17 +487,17 @@ int x509_process_extension(void *context, size_t hdrlen,
 			    v[sub + 1] > vlen - 4 - sub)
 				return -EBADMSG;
 
-			key_len = v[sub + 1];
+			vlen = v[sub + 1];
 			v += (sub + 2);
 		}
 
-		f = kmalloc(key_len * 2 + 1, GFP_KERNEL);
-		if (!f)
-			return -ENOMEM;
-		for (i = 0; i < key_len; i++)
-			sprintf(f + i * 2, "%02x", v[i]);
-		pr_debug("authority   %s\n", f);
-		ctx->cert->authority = f;
+		kid = asymmetric_key_generate_id(v, vlen,
+						 ctx->cert->raw_issuer,
+						 ctx->cert->raw_issuer_size);
+		if (IS_ERR(kid))
+			return PTR_ERR(kid);
+		pr_debug("authkeyid %*phN\n", kid->len, kid->data);
+		ctx->cert->authority = kid;
 		return 0;
 	}
 
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 1b76f207c1f3..0e8d59b010fb 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -19,8 +19,9 @@ struct x509_certificate {
 	struct public_key_signature sig;	/* Signature parameters */
 	char		*issuer;		/* Name of certificate issuer */
 	char		*subject;		/* Name of certificate subject */
-	char		*fingerprint;		/* Key fingerprint as hex */
-	char		*authority;		/* Authority key fingerprint as hex */
+	struct asymmetric_key_id *id;		/* Issuer + serial number */
+	struct asymmetric_key_id *skid;		/* Subject key identifier */
+	struct asymmetric_key_id *authority;	/* Authority key identifier */
 	struct tm	valid_from;
 	struct tm	valid_to;
 	const void	*tbs;			/* Signed data */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index f3d62307e6ee..c60905c3f4d2 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -25,7 +25,7 @@
 #include "x509_parser.h"
 
 static bool use_builtin_keys;
-static char *ca_keyid;
+static struct asymmetric_key_id *ca_keyid;
 
 #ifndef MODULE
 static int __init ca_keys_setup(char *str)
@@ -33,10 +33,16 @@ static int __init ca_keys_setup(char *str)
 	if (!str)		/* default system keyring */
 		return 1;
 
-	if (strncmp(str, "id:", 3) == 0)
-		ca_keyid = str;	/* owner key 'id:xxxxxx' */
-	else if (strcmp(str, "builtin") == 0)
+	if (strncmp(str, "id:", 3) == 0) {
+		struct asymmetric_key_id *p;
+		p = asymmetric_key_hex_to_key_id(str);
+		if (p == ERR_PTR(-EINVAL))
+			pr_err("Unparsable hex string in ca_keys\n");
+		else if (!IS_ERR(p))
+			ca_keyid = p;	/* owner key 'id:xxxxxx' */
+	} else if (strcmp(str, "builtin") == 0) {
 		use_builtin_keys = true;
+	}
 
 	return 1;
 }
@@ -46,31 +52,28 @@ __setup("ca_keys=", ca_keys_setup);
 /**
  * x509_request_asymmetric_key - Request a key by X.509 certificate params.
  * @keyring: The keys to search.
- * @subject: The name of the subject to whom the key belongs.
- * @key_id: The subject key ID as a hex string.
+ * @kid: The key ID.
  *
  * Find a key in the given keyring by subject name and key ID.  These might,
  * for instance, be the issuer name and the authority key ID of an X.509
  * certificate that needs to be verified.
  */
 struct key *x509_request_asymmetric_key(struct key *keyring,
-					const char *subject,
-					const char *key_id)
+					const struct asymmetric_key_id *kid)
 {
 	key_ref_t key;
-	size_t subject_len = strlen(subject), key_id_len = strlen(key_id);
-	char *id;
+	char *id, *p;
 
-	/* Construct an identifier "<subjname>:<keyid>". */
-	id = kmalloc(subject_len + 2 + key_id_len + 1, GFP_KERNEL);
+	/* Construct an identifier "id:<keyid>". */
+	p = id = kmalloc(2 + 1 + kid->len * 2 + 1, GFP_KERNEL);
 	if (!id)
 		return ERR_PTR(-ENOMEM);
 
-	memcpy(id, subject, subject_len);
-	id[subject_len + 0] = ':';
-	id[subject_len + 1] = ' ';
-	memcpy(id + subject_len + 2, key_id, key_id_len);
-	id[subject_len + 2 + key_id_len] = 0;
+	*p++ = 'i';
+	*p++ = 'd';
+	*p++ = ':';
+	p = bin2hex(p, kid->data, kid->len);
+	*p = 0;
 
 	pr_debug("Look up: \"%s\"\n", id);
 
@@ -195,11 +198,10 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
-	if (ca_keyid && !asymmetric_keyid_match(cert->authority, ca_keyid))
+	if (ca_keyid && !asymmetric_key_id_same(cert->authority, ca_keyid))
 		return -EPERM;
 
-	key = x509_request_asymmetric_key(trust_keyring,
-					  cert->issuer, cert->authority);
+	key = x509_request_asymmetric_key(trust_keyring, cert->authority);
 	if (!IS_ERR(key))  {
 		if (!use_builtin_keys
 		    || test_bit(KEY_FLAG_BUILTIN, &key->flags))
@@ -214,9 +216,11 @@ static int x509_validate_trust(struct x509_certificate *cert,
  */
 static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
+	struct asymmetric_key_ids *kids;
 	struct x509_certificate *cert;
+	const char *q;
 	size_t srlen, sulen;
-	char *desc = NULL;
+	char *desc = NULL, *p;
 	int ret;
 
 	cert = x509_cert_parse(prep->data, prep->datalen);
@@ -249,19 +253,12 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 pkey_algo_name[cert->sig.pkey_algo],
 		 hash_algo_name[cert->sig.pkey_hash_algo]);
 
-	if (!cert->fingerprint) {
-		pr_warn("Cert for '%s' must have a SubjKeyId extension\n",
-			cert->subject);
-		ret = -EKEYREJECTED;
-		goto error_free_cert;
-	}
-
 	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
 	if (!cert->authority ||
-	    strcmp(cert->fingerprint, cert->authority) == 0) {
+	    asymmetric_key_id_same(cert->skid, cert->authority)) {
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
@@ -273,31 +270,47 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 
 	/* Propose a description */
 	sulen = strlen(cert->subject);
-	srlen = strlen(cert->fingerprint);
+	srlen = cert->raw_serial_size;
+	q = cert->raw_serial;
+	if (srlen > 1 && *q == 0) {
+		srlen--;
+		q++;
+	}
+
 	ret = -ENOMEM;
-	desc = kmalloc(sulen + 2 + srlen + 1, GFP_KERNEL);
+	desc = kmalloc(sulen + 2 + srlen * 2 + 1, GFP_KERNEL);
 	if (!desc)
 		goto error_free_cert;
-	memcpy(desc, cert->subject, sulen);
-	desc[sulen] = ':';
-	desc[sulen + 1] = ' ';
-	memcpy(desc + sulen + 2, cert->fingerprint, srlen);
-	desc[sulen + 2 + srlen] = 0;
+	p = memcpy(desc, cert->subject, sulen);
+	p += sulen;
+	*p++ = ':';
+	*p++ = ' ';
+	p = bin2hex(p, q, srlen);
+	*p = 0;
+
+	kids = kmalloc(sizeof(struct asymmetric_key_ids), GFP_KERNEL);
+	if (!kids)
+		goto error_free_desc;
+	kids->id[0] = cert->id;
+	kids->id[1] = cert->skid;
 
 	/* We're pinning the module by being linked against it */
 	__module_get(public_key_subtype.owner);
 	prep->type_data[0] = &public_key_subtype;
-	prep->type_data[1] = cert->fingerprint;
+	prep->type_data[1] = kids;
 	prep->payload[0] = cert->pub;
 	prep->description = desc;
 	prep->quotalen = 100;
 
 	/* We've finished with the certificate */
 	cert->pub = NULL;
-	cert->fingerprint = NULL;
+	cert->id = NULL;
+	cert->skid = NULL;
 	desc = NULL;
 	ret = 0;
 
+error_free_desc:
+	kfree(desc);
 error_free_cert:
 	x509_free_certificate(cert);
 	return ret;
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 0d164c6af539..fa73a6fd536c 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -15,6 +15,7 @@
 #define _LINUX_PUBLIC_KEY_H
 
 #include <linux/mpi.h>
+#include <keys/asymmetric-type.h>
 #include <crypto/hash_info.h>
 
 enum pkey_algo {
@@ -98,8 +99,8 @@ struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
 
+struct asymmetric_key_id;
 extern struct key *x509_request_asymmetric_key(struct key *keyring,
-					       const char *issuer,
-					       const char *key_id);
+					       const struct asymmetric_key_id *kid);
 
 #endif /* _LINUX_PUBLIC_KEY_H */

