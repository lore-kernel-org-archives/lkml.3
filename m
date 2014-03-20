Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaCTMyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:54:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaCTMyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:54:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 04/12] KEYS: Call ->free_preparse() even after ->preparse()
 returns an error
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:05 +0000
Message-ID: <20140320120505.21635.1726.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
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
index 6a37856d428d..c6c0e162c4ba 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -494,7 +494,7 @@ int key_instantiate_and_link(struct key *key,
 	if (keyring) {
 		ret = __key_link_begin(keyring, &key->index_key, &edit);
 		if (ret < 0)
-			goto error_free_preparse;
+			goto error;
 	}
 
 	ret = __key_instantiate_and_link(key, &prep, keyring, authkey, &edit);
@@ -502,10 +502,9 @@ int key_instantiate_and_link(struct key *key,
 	if (keyring)
 		__key_link_end(keyring, &key->index_key, edit);
 
-error_free_preparse:
+error:
 	if (key->type->preparse)
 		key->type->free_preparse(&prep);
-error:
 	return ret;
 }
 
@@ -822,7 +821,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 		ret = index_key.type->preparse(&prep);
 		if (ret < 0) {
 			key_ref = ERR_PTR(ret);
-			goto error_put_type;
+			goto error_free_prep;
 		}
 		if (!index_key.description)
 			index_key.description = prep.description;
@@ -964,9 +963,9 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 
 	up_write(&key->sem);
 
+error:
 	if (key->type->preparse)
 		key->type->free_preparse(&prep);
-error:
 	return ret;
 }
 EXPORT_SYMBOL(key_update);

