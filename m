Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbaCTMH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbaCTMG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:06:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 09/12] KEYS: RxRPC: Use key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:42 +0000
Message-ID: <20140320120542.21635.54335.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of key preparsing in the RxRPC protocol so that quota size
determination can take place prior to keyring locking when a key is being
added.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-key.c |  165 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 68 deletions(-)

diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 7633a752c65e..58a3641227d4 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -26,8 +26,10 @@
 #include "ar-internal.h"
 
 static int rxrpc_vet_description_s(const char *);
-static int rxrpc_instantiate(struct key *, struct key_preparsed_payload *);
-static int rxrpc_instantiate_s(struct key *, struct key_preparsed_payload *);
+static int rxrpc_preparse(struct key_preparsed_payload *);
+static int rxrpc_preparse_s(struct key_preparsed_payload *);
+static void rxrpc_free_preparse(struct key_preparsed_payload *);
+static void rxrpc_free_preparse_s(struct key_preparsed_payload *);
 static void rxrpc_destroy(struct key *);
 static void rxrpc_destroy_s(struct key *);
 static void rxrpc_describe(const struct key *, struct seq_file *);
@@ -39,7 +41,9 @@ static long rxrpc_read(const struct key *, char __user *, size_t);
  */
 struct key_type key_type_rxrpc = {
 	.name		= "rxrpc",
-	.instantiate	= rxrpc_instantiate,
+	.preparse	= rxrpc_preparse,
+	.free_preparse	= rxrpc_free_preparse,
+	.instantiate	= generic_key_instantiate,
 	.match		= user_match,
 	.destroy	= rxrpc_destroy,
 	.describe	= rxrpc_describe,
@@ -54,7 +58,9 @@ EXPORT_SYMBOL(key_type_rxrpc);
 struct key_type key_type_rxrpc_s = {
 	.name		= "rxrpc_s",
 	.vet_description = rxrpc_vet_description_s,
-	.instantiate	= rxrpc_instantiate_s,
+	.preparse	= rxrpc_preparse_s,
+	.free_preparse	= rxrpc_free_preparse_s,
+	.instantiate	= generic_key_instantiate,
 	.match		= user_match,
 	.destroy	= rxrpc_destroy_s,
 	.describe	= rxrpc_describe,
@@ -81,13 +87,13 @@ static int rxrpc_vet_description_s(const char *desc)
  * parse an RxKAD type XDR format token
  * - the caller guarantees we have at least 4 words
  */
-static int rxrpc_instantiate_xdr_rxkad(struct key *key, const __be32 *xdr,
-				       unsigned int toklen)
+static int rxrpc_preparse_xdr_rxkad(struct key_preparsed_payload *prep,
+				    size_t datalen,
+				    const __be32 *xdr, unsigned int toklen)
 {
 	struct rxrpc_key_token *token, **pptoken;
 	size_t plen;
 	u32 tktlen;
-	int ret;
 
 	_enter(",{%x,%x,%x,%x},%u",
 	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
@@ -103,9 +109,7 @@ static int rxrpc_instantiate_xdr_rxkad(struct key *key, const __be32 *xdr,
 		return -EKEYREJECTED;
 
 	plen = sizeof(*token) + sizeof(*token->kad) + tktlen;
-	ret = key_payload_reserve(key, key->datalen + plen);
-	if (ret < 0)
-		return ret;
+	prep->quotalen = datalen + plen;
 
 	plen -= sizeof(*token);
 	token = kzalloc(sizeof(*token), GFP_KERNEL);
@@ -146,16 +150,16 @@ static int rxrpc_instantiate_xdr_rxkad(struct key *key, const __be32 *xdr,
 		       token->kad->ticket[6], token->kad->ticket[7]);
 
 	/* count the number of tokens attached */
-	key->type_data.x[0]++;
+	prep->type_data[0] = (void *)((unsigned long)prep->type_data[0] + 1);
 
 	/* attach the data */
-	for (pptoken = (struct rxrpc_key_token **)&key->payload.data;
+	for (pptoken = (struct rxrpc_key_token **)&prep->payload[0];
 	     *pptoken;
 	     pptoken = &(*pptoken)->next)
 		continue;
 	*pptoken = token;
-	if (token->kad->expiry < key->expiry)
-		key->expiry = token->kad->expiry;
+	if (token->kad->expiry < prep->expiry)
+		prep->expiry = token->kad->expiry;
 
 	_leave(" = 0");
 	return 0;
@@ -418,8 +422,9 @@ static int rxrpc_krb5_decode_ticket(u8 **_ticket, u16 *_tktlen,
  * parse an RxK5 type XDR format token
  * - the caller guarantees we have at least 4 words
  */
-static int rxrpc_instantiate_xdr_rxk5(struct key *key, const __be32 *xdr,
-				      unsigned int toklen)
+static int rxrpc_preparse_xdr_rxk5(struct key_preparsed_payload *prep,
+				   size_t datalen,
+				   const __be32 *xdr, unsigned int toklen)
 {
 	struct rxrpc_key_token *token, **pptoken;
 	struct rxk5_key *rxk5;
@@ -432,9 +437,7 @@ static int rxrpc_instantiate_xdr_rxk5(struct key *key, const __be32 *xdr,
 
 	/* reserve some payload space for this subkey - the length of the token
 	 * is a reasonable approximation */
-	ret = key_payload_reserve(key, key->datalen + toklen);
-	if (ret < 0)
-		return ret;
+	prep->quotalen = datalen + toklen;
 
 	token = kzalloc(sizeof(*token), GFP_KERNEL);
 	if (!token)
@@ -520,14 +523,14 @@ static int rxrpc_instantiate_xdr_rxk5(struct key *key, const __be32 *xdr,
 	if (toklen != 0)
 		goto inval;
 
-	/* attach the payload to the key */
-	for (pptoken = (struct rxrpc_key_token **)&key->payload.data;
+	/* attach the payload */
+	for (pptoken = (struct rxrpc_key_token **)&prep->payload[0];
 	     *pptoken;
 	     pptoken = &(*pptoken)->next)
 		continue;
 	*pptoken = token;
-	if (token->kad->expiry < key->expiry)
-		key->expiry = token->kad->expiry;
+	if (token->kad->expiry < prep->expiry)
+		prep->expiry = token->kad->expiry;
 
 	_leave(" = 0");
 	return 0;
@@ -545,16 +548,17 @@ error:
  * attempt to parse the data as the XDR format
  * - the caller guarantees we have more than 7 words
  */
-static int rxrpc_instantiate_xdr(struct key *key, const void *data, size_t datalen)
+static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 {
-	const __be32 *xdr = data, *token;
+	const __be32 *xdr = prep->data, *token;
 	const char *cp;
 	unsigned int len, tmp, loop, ntoken, toklen, sec_ix;
+	size_t datalen = prep->datalen;
 	int ret;
 
 	_enter(",{%x,%x,%x,%x},%zu",
 	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
-	       datalen);
+	       prep->datalen);
 
 	if (datalen > AFSTOKEN_LENGTH_MAX)
 		goto not_xdr;
@@ -635,13 +639,13 @@ static int rxrpc_instantiate_xdr(struct key *key, const void *data, size_t datal
 
 		switch (sec_ix) {
 		case RXRPC_SECURITY_RXKAD:
-			ret = rxrpc_instantiate_xdr_rxkad(key, xdr, toklen);
+			ret = rxrpc_preparse_xdr_rxkad(prep, datalen, xdr, toklen);
 			if (ret != 0)
 				goto error;
 			break;
 
 		case RXRPC_SECURITY_RXK5:
-			ret = rxrpc_instantiate_xdr_rxk5(key, xdr, toklen);
+			ret = rxrpc_preparse_xdr_rxk5(prep, datalen, xdr, toklen);
 			if (ret != 0)
 				goto error;
 			break;
@@ -665,8 +669,9 @@ error:
 }
 
 /*
- * instantiate an rxrpc defined key
- * data should be of the form:
+ * Preparse an rxrpc defined key.
+ *
+ * Data should be of the form:
  *	OFFSET	LEN	CONTENT
  *	0	4	key interface version number
  *	4	2	security index (type)
@@ -678,7 +683,7 @@ error:
  *
  * if no data is provided, then a no-security key is made
  */
-static int rxrpc_instantiate(struct key *key, struct key_preparsed_payload *prep)
+static int rxrpc_preparse(struct key_preparsed_payload *prep)
 {
 	const struct rxrpc_key_data_v1 *v1;
 	struct rxrpc_key_token *token, **pp;
@@ -686,7 +691,7 @@ static int rxrpc_instantiate(struct key *key, struct key_preparsed_payload *prep
 	u32 kver;
 	int ret;
 
-	_enter("{%x},,%zu", key_serial(key), prep->datalen);
+	_enter("%zu", prep->datalen);
 
 	/* handle a no-security key */
 	if (!prep->data && prep->datalen == 0)
@@ -694,7 +699,7 @@ static int rxrpc_instantiate(struct key *key, struct key_preparsed_payload *prep
 
 	/* determine if the XDR payload format is being used */
 	if (prep->datalen > 7 * 4) {
-		ret = rxrpc_instantiate_xdr(key, prep->data, prep->datalen);
+		ret = rxrpc_preparse_xdr(prep);
 		if (ret != -EPROTO)
 			return ret;
 	}
@@ -743,9 +748,7 @@ static int rxrpc_instantiate(struct key *key, struct key_preparsed_payload *prep
 		goto error;
 
 	plen = sizeof(*token->kad) + v1->ticket_length;
-	ret = key_payload_reserve(key, plen + sizeof(*token));
-	if (ret < 0)
-		goto error;
+	prep->quotalen = plen + sizeof(*token);
 
 	ret = -ENOMEM;
 	token = kzalloc(sizeof(*token), GFP_KERNEL);
@@ -762,15 +765,16 @@ static int rxrpc_instantiate(struct key *key, struct key_preparsed_payload *prep
 	memcpy(&token->kad->session_key, &v1->session_key, 8);
 	memcpy(&token->kad->ticket, v1->ticket, v1->ticket_length);
 
-	/* attach the data */
-	key->type_data.x[0]++;
+	/* count the number of tokens attached */
+	prep->type_data[0] = (void *)((unsigned long)prep->type_data[0] + 1);
 
-	pp = (struct rxrpc_key_token **)&key->payload.data;
+	/* attach the data */
+	pp = (struct rxrpc_key_token **)&prep->payload[0];
 	while (*pp)
 		pp = &(*pp)->next;
 	*pp = token;
-	if (token->kad->expiry < key->expiry)
-		key->expiry = token->kad->expiry;
+	if (token->kad->expiry < prep->expiry)
+		prep->expiry = token->kad->expiry;
 	token = NULL;
 	ret = 0;
 
@@ -781,20 +785,55 @@ error:
 }
 
 /*
- * instantiate a server secret key
- * data should be a pointer to the 8-byte secret key
+ * Free token list.
  */
-static int rxrpc_instantiate_s(struct key *key,
-			       struct key_preparsed_payload *prep)
+static void rxrpc_free_token_list(struct rxrpc_key_token *token)
+{
+	struct rxrpc_key_token *next;
+
+	for (; token; token = next) {
+		next = token->next;
+		switch (token->security_index) {
+		case RXRPC_SECURITY_RXKAD:
+			kfree(token->kad);
+			break;
+		case RXRPC_SECURITY_RXK5:
+			if (token->k5)
+				rxrpc_rxk5_free(token->k5);
+			break;
+		default:
+			printk(KERN_ERR "Unknown token type %x on rxrpc key\n",
+			       token->security_index);
+			BUG();
+		}
+
+		kfree(token);
+	}
+}
+
+/*
+ * Clean up preparse data.
+ */
+static void rxrpc_free_preparse(struct key_preparsed_payload *prep)
+{
+	rxrpc_free_token_list(prep->payload[0]);
+}
+
+/*
+ * Preparse a server secret key.
+ *
+ * The data should be the 8-byte secret key.
+ */
+static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
 {
 	struct crypto_blkcipher *ci;
 
-	_enter("{%x},,%zu", key_serial(key), prep->datalen);
+	_enter("%zu", prep->datalen);
 
 	if (prep->datalen != 8)
 		return -EINVAL;
 
-	memcpy(&key->type_data, prep->data, 8);
+	memcpy(&prep->type_data, prep->data, 8);
 
 	ci = crypto_alloc_blkcipher("pcbc(des)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(ci)) {
@@ -805,36 +844,26 @@ static int rxrpc_instantiate_s(struct key *key,
 	if (crypto_blkcipher_setkey(ci, prep->data, 8) < 0)
 		BUG();
 
-	key->payload.data = ci;
+	prep->payload[0] = ci;
 	_leave(" = 0");
 	return 0;
 }
 
 /*
+ * Clean up preparse data.
+ */
+static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
+{
+	if (prep->payload[0])
+		crypto_free_blkcipher(prep->payload[0]);
+}
+
+/*
  * dispose of the data dangling from the corpse of a rxrpc key
  */
 static void rxrpc_destroy(struct key *key)
 {
-	struct rxrpc_key_token *token;
-
-	while ((token = key->payload.data)) {
-		key->payload.data = token->next;
-		switch (token->security_index) {
-		case RXRPC_SECURITY_RXKAD:
-			kfree(token->kad);
-			break;
-		case RXRPC_SECURITY_RXK5:
-			if (token->k5)
-				rxrpc_rxk5_free(token->k5);
-			break;
-		default:
-			printk(KERN_ERR "Unknown token type %x on rxrpc key\n",
-			       token->security_index);
-			BUG();
-		}
-
-		kfree(token);
-	}
+	rxrpc_free_token_list(key->payload.data);
 }
 
 /*

