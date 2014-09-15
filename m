Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbaIOUpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758315AbaIOUpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:45:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 06/10] KEYS: Update the keyrings documentation for match
 changes [ver #2]
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 21:45:28 +0100
Message-ID: <20140915204528.27499.34138.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
References: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 Documentation/security/keys.txt |   65 +++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 13 deletions(-)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 8727c194ca16..821c936e1a63 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -888,11 +888,11 @@ payload contents" for more information.
 				const char *callout_info);
 
     This is used to request a key or keyring with a description that matches
-    the description specified according to the key type's match function. This
-    permits approximate matching to occur. If callout_string is not NULL, then
-    /sbin/request-key will be invoked in an attempt to obtain the key from
-    userspace. In that case, callout_string will be passed as an argument to
-    the program.
+    the description specified according to the key type's match_preparse()
+    method. This permits approximate matching to occur. If callout_string is
+    not NULL, then /sbin/request-key will be invoked in an attempt to obtain
+    the key from userspace. In that case, callout_string will be passed as an
+    argument to the program.
 
     Should the function fail error ENOKEY, EKEYEXPIRED or EKEYREVOKED will be
     returned.
@@ -1170,7 +1170,7 @@ The structure has a number of fields, some of which are mandatory:
      The method should return 0 if successful or a negative error code
      otherwise.
 
-     
+
  (*) void (*free_preparse)(struct key_preparsed_payload *prep);
 
      This method is only required if the preparse() method is provided,
@@ -1225,16 +1225,55 @@ The structure has a number of fields, some of which are mandatory:
      It is safe to sleep in this method.
 
 
- (*) int (*match)(const struct key *key, const void *desc);
+ (*) int (*match_preparse)(struct key_match_data *match_data);
+
+     This method is optional.  It is called when a key search is about to be
+     performed.  It is given the following structure:
 
-     This method is called to match a key against a description. It should
-     return non-zero if the two match, zero if they don't.
+	struct key_match_data {
+		bool (*cmp)(const struct key *key,
+			    const struct key_match_data *match_data);
+		const void	*raw_data;
+		void		*preparsed;
+		unsigned	lookup_type;
+	};
 
-     This method should not need to lock the key in any way. The type and
-     description can be considered invariant, and the payload should not be
-     accessed (the key may not yet be instantiated).
+     On entry, raw_data will be pointing to the criteria to be used in matching
+     a key by the caller and should not be modified.  (*cmp)() will be pointing
+     to the default matcher function (which does an exact description match
+     against raw_data) and lookup_type will be set to indicate a direct lookup.
 
-     It is not safe to sleep in this method; the caller may hold spinlocks.
+     The following lookup_type values are available:
+
+      [*] KEYRING_SEARCH_LOOKUP_DIRECT - A direct lookup hashes the type and
+      	  description to narrow down the search to a small number of keys.
+
+      [*] KEYRING_SEARCH_LOOKUP_ITERATE - An iterative lookup walks all the
+      	  keys in the keyring until one is matched.  This must be used for any
+      	  search that's not doing a simple direct match on the key description.
+
+     The method may set cmp to point to a function of its choice that does some
+     other form of match, may set lookup_type to KEYRING_SEARCH_LOOKUP_ITERATE
+     and may attach something to the preparsed pointer for use by (*cmp)().
+     (*cmp)() should return true if a key matches and false otherwise.
+
+     If preparsed is set, it may be necessary to use the match_free() method to
+     clean it up.
+
+     The method should return 0 if successful or a negative error code
+     otherwise.
+
+     It is permitted to sleep in this method, but (*cmp)() may not sleep as
+     locks will be held over it.
+
+     If match_preparse() is not provided, keys of this type will be matched
+     exactly by their description.
+
+
+ (*) void (*match_free)(struct key_match_data *match_data);
+
+     This method is optional.  If given, it called to clean up
+     match_data->preparsed after a successful call to match_preparse().
 
 
  (*) void (*revoke)(struct key *key);

