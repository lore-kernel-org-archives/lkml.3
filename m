Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbaCTMy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:54:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaCTMyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:54:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 02/12] KEYS: struct key_preparsed_payload should have two
 payload pointers
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:04:49 +0000
Message-ID: <20140320120449.21635.85802.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct key_preparsed_payload should have two payload pointers to correspond
with those in struct key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c |    2 +-
 crypto/asymmetric_keys/x509_public_key.c |    2 +-
 include/linux/key-type.h                 |    2 +-
 security/keys/encrypted-keys/encrypted.c |    2 +-
 security/keys/key.c                      |    6 ++++--
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index c1fe0fcee8e3..21960a4e74e8 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -156,7 +156,7 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 	pr_devel("==>%s()\n", __func__);
 
 	if (subtype) {
-		subtype->destroy(prep->payload);
+		subtype->destroy(prep->payload[0]);
 		module_put(subtype->owner);
 	}
 	kfree(prep->type_data[1]);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 382ef0d2ff2e..3fc8a0634ed7 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -177,7 +177,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	__module_get(public_key_subtype.owner);
 	prep->type_data[0] = &public_key_subtype;
 	prep->type_data[1] = cert->fingerprint;
-	prep->payload = cert->pub;
+	prep->payload[0] = cert->pub;
 	prep->description = desc;
 	prep->quotalen = 100;
 
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 88503dca2a57..d2b4845d74bf 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -41,7 +41,7 @@ struct key_construction {
 struct key_preparsed_payload {
 	char		*description;	/* Proposed key description (or NULL) */
 	void		*type_data[2];	/* Private key-type data */
-	void		*payload;	/* Proposed payload */
+	void		*payload[2];	/* Proposed payload */
 	const void	*data;		/* Raw data */
 	size_t		datalen;	/* Raw datalen */
 	size_t		quotalen;	/* Quota length for proposed payload */
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 9e1e005c7596..9a3b29175530 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -811,7 +811,7 @@ static int encrypted_instantiate(struct key *key,
 		goto out;
 	}
 
-	rcu_assign_keypointer(key, epayload);
+	prep->payload[0] = epayload;
 out:
 	kfree(datablob);
 	return ret;
diff --git a/security/keys/key.c b/security/keys/key.c
index ee74c882d36d..686b10e81054 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -1043,10 +1043,12 @@ int generic_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 	if (ret == 0) {
 		key->type_data.p[0] = prep->type_data[0];
 		key->type_data.p[1] = prep->type_data[1];
-		rcu_assign_keypointer(key, prep->payload);
+		rcu_assign_keypointer(key, prep->payload[0]);
+		key->payload.data2[1] = prep->payload[1];
 		prep->type_data[0] = NULL;
 		prep->type_data[1] = NULL;
-		prep->payload = NULL;
+		prep->payload[0] = NULL;
+		prep->payload[1] = NULL;
 	}
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;

