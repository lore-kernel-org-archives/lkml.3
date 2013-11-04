Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3KDRjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:39:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3KDRjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:39:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 5/9] KEYS: Call ->free_preparse() even after ->preparse()
 returns an error
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:22:53 +0000
Message-ID: <20131104162253.10177.71310.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the ->free_preparse() key type op even after ->preparse() returns an
error as it does cleaning up type stuff.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt |    4 +++-
 security/keys/key.c             |    9 ++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 315cf96a41a2..3bbec087fc5f 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -1176,7 +1176,9 @@ The structure has a number of fields, some of which are mandatory:
      This method is only required if the preparse() method is provided,
      otherwise it is unused.  It cleans up anything attached to the
      description, type_data and payload fields of the key_preparsed_payload
-     struct as filled in by the preparse() method.
+     struct as filled in by the preparse() method.  If will always be called
+     after preparse() returns successfully, even if instantiate() or update()
+     succeed.
 
 
  (*) int (*instantiate)(struct key *key, struct key_preparsed_payload *prep);
diff --git a/security/keys/key.c b/security/keys/key.c
index 1af0edacd804..d77c09f0c48e 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -500,7 +500,7 @@ int key_instantiate_and_link(struct key *key,
 	if (keyring) {
 		ret = __key_link_begin(keyring, &key->index_key, &edit);
 		if (ret < 0)
-			goto error_free_preparse;
+			goto error;
 	}
 
 	ret = __key_instantiate_and_link(key, &prep, keyring, authkey, &edit);
@@ -508,10 +508,9 @@ int key_instantiate_and_link(struct key *key,
 	if (keyring)
 		__key_link_end(keyring, &key->index_key, edit);
 
-error_free_preparse:
+error:
 	if (key->type->preparse)
 		key->type->free_preparse(&prep);
-error:
 	return ret;
 }
 
@@ -828,7 +827,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		ret = index_key.type->preparse(&prep);
 		if (ret < 0) {
 			key_ref = ERR_PTR(ret);
-			goto error_put_type;
+			goto error_free_prep;
 		}
 		if (!index_key.description)
 			index_key.description = prep.description;
@@ -970,9 +969,9 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 
 	up_write(&key->sem);
 
+error:
 	if (key->type->preparse)
 		key->type->free_preparse(&prep);
-error:
 	return ret;
 }
 EXPORT_SYMBOL(key_update);

