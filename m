Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbaCTNFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbaCTNFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:05:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 11/12] KEYS: keyring: Provide key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:06:10 +0000
Message-ID: <20140320120610.21635.52036.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide key preparsing in the keyring so that we can make preparsing
mandatory.  For keyrings, however, only an empty payload is permitted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyring.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 2fb2576dc644..610c50a18db0 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -73,6 +73,8 @@ static inline unsigned keyring_hash(const char *desc)
  * can be treated as ordinary keys in addition to having their own special
  * operations.
  */
+static int keyring_preparse(struct key_preparsed_payload *prep);
+static void keyring_free_preparse(struct key_preparsed_payload *prep);
 static int keyring_instantiate(struct key *keyring,
 			       struct key_preparsed_payload *prep);
 static void keyring_revoke(struct key *keyring);
@@ -84,6 +86,8 @@ static long keyring_read(const struct key *keyring,
 struct key_type key_type_keyring = {
 	.name		= "keyring",
 	.def_datalen	= 0,
+	.preparse	= keyring_preparse,
+	.free_preparse	= keyring_free_preparse,
 	.instantiate	= keyring_instantiate,
 	.match		= user_match,
 	.revoke		= keyring_revoke,
@@ -123,6 +127,21 @@ static void keyring_publish_name(struct key *keyring)
 }
 
 /*
+ * Preparse a keyring payload
+ */
+static int keyring_preparse(struct key_preparsed_payload *prep)
+{
+	return prep->datalen != 0 ? -EINVAL : 0;
+}
+
+/*
+ * Free a preparse of a user defined key payload
+ */
+static void keyring_free_preparse(struct key_preparsed_payload *prep)
+{
+}
+
+/*
  * Initialise a keyring.
  *
  * Returns 0 on success, -EINVAL if given any data.
@@ -130,17 +149,10 @@ static void keyring_publish_name(struct key *keyring)
 static int keyring_instantiate(struct key *keyring,
 			       struct key_preparsed_payload *prep)
 {
-	int ret;
-
-	ret = -EINVAL;
-	if (prep->datalen == 0) {
-		assoc_array_init(&keyring->keys);
-		/* make the keyring available by name if it has one */
-		keyring_publish_name(keyring);
-		ret = 0;
-	}
-
-	return ret;
+	assoc_array_init(&keyring->keys);
+	/* make the keyring available by name if it has one */
+	keyring_publish_name(keyring);
+	return 0;
 }
 
 /*

