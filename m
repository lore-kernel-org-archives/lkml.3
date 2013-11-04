Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3KDSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:22:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab3KDSWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:22:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/9] KEYS: Allow expiry time to be set when preparsing a key
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:22:46 +0000
Message-ID: <20131104162245.10177.44435.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a key type's preparsing routine to set the expiry time for a key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt |   10 +++++++---
 include/linux/key-type.h        |    1 +
 security/keys/key.c             |    8 ++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index a4c33f1a7c6d..315cf96a41a2 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -1150,20 +1150,24 @@ The structure has a number of fields, some of which are mandatory:
 		const void	*data;
 		size_t		datalen;
 		size_t		quotalen;
+		time_t		expiry;
 	};
 
      Before calling the method, the caller will fill in data and datalen with
      the payload blob parameters; quotalen will be filled in with the default
-     quota size from the key type and the rest will be cleared.
+     quota size from the key type; expiry will be set to TIME_T_MAX and the
+     rest will be cleared.
 
      If a description can be proposed from the payload contents, that should be
      attached as a string to the description field.  This will be used for the
      key description if the caller of add_key() passes NULL or "".
 
      The method can attach anything it likes to type_data[] and payload.  These
-     are merely passed along to the instantiate() or update() operations.
+     are merely passed along to the instantiate() or update() operations.  If
+     set, the expiry time will be applied to the key if it is instantiated from
+     this data.
 
-     The method should return 0 if success ful or a negative error code
+     The method should return 0 if successful or a negative error code
      otherwise.
 
      
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index d2b4845d74bf..44792ee649de 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -45,6 +45,7 @@ struct key_preparsed_payload {
 	const void	*data;		/* Raw data */
 	size_t		datalen;	/* Raw datalen */
 	size_t		quotalen;	/* Quota length for proposed payload */
+	time_t		expiry;		/* Expiry time of key */
 	bool		trusted;	/* True if key is trusted */
 };
 
diff --git a/security/keys/key.c b/security/keys/key.c
index 64dc9cf6848e..1af0edacd804 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -443,6 +443,11 @@ static int __key_instantiate_and_link(struct key *key,
 			/* disable the authorisation key */
 			if (authkey)
 				key_revoke(authkey);
+
+			if (prep->expiry != TIME_T_MAX) {
+				key->expiry = prep->expiry;
+				key_schedule_gc(prep->expiry + key_gc_delay);
+			}
 		}
 	}
 
@@ -485,6 +490,7 @@ int key_instantiate_and_link(struct key *key,
 	prep.data = data;
 	prep.datalen = datalen;
 	prep.quotalen = key->type->def_datalen;
+	prep.expiry = TIME_T_MAX;
 	if (key->type->preparse) {
 		ret = key->type->preparse(&prep);
 		if (ret < 0)
@@ -817,6 +823,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	prep.datalen = plen;
 	prep.quotalen = index_key.type->def_datalen;
 	prep.trusted = flags & KEY_ALLOC_TRUSTED;
+	prep.expiry = TIME_T_MAX;
 	if (index_key.type->preparse) {
 		ret = index_key.type->preparse(&prep);
 		if (ret < 0) {
@@ -947,6 +954,7 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 	prep.data = payload;
 	prep.datalen = plen;
 	prep.quotalen = key->type->def_datalen;
+	prep.expiry = TIME_T_MAX;
 	if (key->type->preparse) {
 		ret = key->type->preparse(&prep);
 		if (ret < 0)

