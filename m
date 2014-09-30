Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaI3QOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:14:46 -0400
Received: from auth-4.ukservers.net ([217.10.138.158]:50193 "EHLO
	auth-4.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaI3QOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:14:45 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2014 12:14:44 EDT
Date: Tue, 30 Sep 2014 17:06:22 +0100 (BST)
From: Carl Hetherington <cth@carlh.net>
X-X-Sender: carl@main.carlh.net
To: linux-kernel@vger.kernel.org
Message-ID: <alpine.DEB.2.02.1409301704020.27485@main.carlh.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: cth@carlh.net
Subject: [PATCH] nfs/keys/idmap: intermittent erroneous uid/gid bug
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on main.carlh.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am investigating this bug:
https://bugs.launchpad.net/ubuntu/+source/nfs-utils/+bug/1124250
which is also:
https://bugzilla.redhat.com/show_bug.cgi?id=876705
and:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=758870

After the keys which map NFS uid/gid to names expire there is sometimes a 
delay in them being recreated.  I believe this is because 
nfs_idmap_request_key calls request_key_with_auxdata which returns expired 
keys if they exist.  If this happens there is no-one to re-create the key.

I think, instead, nfs_idmap_request_key should request a new key with a 
userspace upcall if its key for a particular name has expired.

I have made the attached patch which fixes the problem in my tests.  It 
adds request_valid_key_with_auxdata() which does the same as 
request_key_with_auxdata() except that it ignores expired, revoked and 
invalidated keys.  It does this by passing KEYRING_SEARCH_DO_STATE_CHECK 
into the context for search_process_keyrings inside request_key_and_link. 
If all keys are expired, this function then asks userspace for an updated 
key.

I have no previous experience in the kernel, so please be gentle :)  I am 
happy to change and re-test the patch to anyone's whim.

Thanks & best regards,
Carl

Signed-off-by: Carl Hetherington <cth@carlh.net>
---
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 567983d..744e40f 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -278,8 +278,8 @@ static struct key *nfs_idmap_request_key(const char 
*name, size_t namelen,
  	rkey = request_key(&key_type_id_resolver, desc, "");
  	if (IS_ERR(rkey)) {
  		mutex_lock(&idmap->idmap_mutex);
-		rkey = request_key_with_auxdata(&key_type_id_resolver_legacy,
-						desc, "", 0, idmap);
+		rkey = request_valid_key_with_auxdata(&key_type_id_resolver_legacy,
+						      desc, "", 0, idmap);
  		mutex_unlock(&idmap->idmap_mutex);
  	}

diff --git a/include/linux/key.h b/include/linux/key.h
index 80d6774..6a4ef03 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -252,6 +252,12 @@ extern struct key *request_key_with_auxdata(struct 
key_type *type,
  					    size_t callout_len,
  					    void *aux);

+extern struct key *request_valid_key_with_auxdata(struct key_type *type,
+						  const char *description,
+						  const void *callout_info,
+						  size_t callout_len,
+						  void *aux);
+
  extern struct key *request_key_async(struct key_type *type,
  				     const char *description,
  				     const void *callout_info,
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 80b2aac..5c9bc62 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -150,7 +150,8 @@ extern struct key *request_key_and_link(struct 
key_type *type,
  					size_t callout_len,
  					void *aux,
  					struct key *dest_keyring,
-					unsigned long flags);
+					unsigned long key_alloc_flags,
+					unsigned long 
keyring_search_flags);

  extern int lookup_user_key_possessed(const struct key *key, const void *target);
  extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index cee72ce..25a12bc 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -212,7 +212,7 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
  	/* do the search */
  	key = request_key_and_link(ktype, description, callout_info,
  				   callout_len, NULL, key_ref_to_ptr(dest_ref),
-				   KEY_ALLOC_IN_QUOTA);
+				   KEY_ALLOC_IN_QUOTA, 0);
  	if (IS_ERR(key)) {
  		ret = PTR_ERR(key);
  		goto error5;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 3814119..af8345c 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -500,7 +500,11 @@ couldnt_alloc_key:
   * @callout_len: The length of callout_info.
   * @aux: Auxiliary data for the upcall.
   * @dest_keyring: Where to cache the key.
- * @flags: Flags to key_alloc().
+ * @key_alloc_flags: Flags to key_alloc().
+ * @keyring_search_flags: Flags to pass in the keyring search context
+ * (in addition to KEYRING_SEARCH_LOOKUP_DIRECT).  For example, passing
+ * KEYRING_SEARCH_DO_STATE_CHECK here will stop the function returning
+ * invalidated, revoked or expired keys.
   *
   * A key matching the specified criteria is searched for in the process's
   * keyrings and returned with its usage count incremented if found. 
Otherwise,
@@ -525,7 +529,8 @@ struct key *request_key_and_link(struct key_type *type,
  				 size_t callout_len,
  				 void *aux,
  				 struct key *dest_keyring,
-				 unsigned long flags)
+				 unsigned long key_alloc_flags,
+				 unsigned long keyring_search_flags)
  {
  	struct keyring_search_context ctx = {
  		.index_key.type		= type,
@@ -533,7 +538,7 @@ struct key *request_key_and_link(struct key_type *type,
  		.cred			= current_cred(),
  		.match			= type->match,
  		.match_data		= description,
-		.flags			= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.flags			= KEYRING_SEARCH_LOOKUP_DIRECT | keyring_search_flags
  	};
  	struct key *key;
  	key_ref_t key_ref;
@@ -541,7 +546,7 @@ struct key *request_key_and_link(struct key_type *type,

  	kenter("%s,%s,%p,%zu,%p,%p,%lx",
  	       ctx.index_key.type->name, ctx.index_key.description,
-	       callout_info, callout_len, aux, dest_keyring, flags);
+	       callout_info, callout_len, aux, dest_keyring, key_alloc_flags);

  	/* search all the process keyrings for a key */
  	key_ref = search_process_keyrings(&ctx);
@@ -568,7 +573,7 @@ struct key *request_key_and_link(struct key_type *type,
  			goto error;

  		key = construct_key_and_link(&ctx, callout_info, callout_len,
-					     aux, dest_keyring, flags);
+					     aux, dest_keyring, 
key_alloc_flags);
  	}

  error:
@@ -629,7 +634,7 @@ struct key *request_key(struct key_type *type,
  	if (callout_info)
  		callout_len = strlen(callout_info);
  	key = request_key_and_link(type, description, callout_info, 
callout_len,
-				   NULL, NULL, KEY_ALLOC_IN_QUOTA);
+				   NULL, NULL, KEY_ALLOC_IN_QUOTA, 0);
  	if (!IS_ERR(key)) {
  		ret = wait_for_key_construction(key, false);
  		if (ret < 0) {
@@ -665,7 +670,7 @@ struct key *request_key_with_auxdata(struct key_type 
*type,
  	int ret;

  	key = request_key_and_link(type, description, callout_info,
callout_len,
-				   aux, NULL, KEY_ALLOC_IN_QUOTA);
+				   aux, NULL, KEY_ALLOC_IN_QUOTA, 0);
  	if (!IS_ERR(key)) {
  		ret = wait_for_key_construction(key, false);
  		if (ret < 0) {
@@ -677,6 +682,42 @@ struct key *request_key_with_auxdata(struct key_type 
*type,
  }
  EXPORT_SYMBOL(request_key_with_auxdata);

+/**
+ * request_valid_key_with_auxdata - Request a key with auxiliary data for the upcaller
+ * @type: The type of key we want.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ * @callout_len: The length of callout_info.
+ * @aux: Auxiliary data for the upcall.
+ *
+ * As for request_key_with_auxdata() except that existing invalidated, revoked and expired
+ * keys are ignored during the search for the requested key.
+ *
+ * Furthermore, it then works as wait_for_key_construction() to wait for the
+ * completion of keys undergoing construction with a non-interruptible wait.
+ */
+struct key *request_valid_key_with_auxdata(struct key_type *type,
+				     const char *description,
+				     const void *callout_info,
+				     size_t callout_len,
+				     void *aux)
+{
+	struct key *key;
+	int ret;
+
+	key = request_key_and_link(type, description, callout_info, callout_len,
+				   aux, NULL, KEY_ALLOC_IN_QUOTA, KEYRING_SEARCH_DO_STATE_CHECK);
+	if (!IS_ERR(key)) {
+		ret = wait_for_key_construction(key, false);
+		if (ret < 0) {
+			key_put(key);
+			return ERR_PTR(ret);
+		}
+	}
+	return key;
+}
+EXPORT_SYMBOL(request_valid_key_with_auxdata);
+
  /*
   * request_key_async - Request a key (allow async construction)
   * @type: Type of key.
@@ -698,7 +739,7 @@ struct key *request_key_async(struct key_type *type,
  {
  	return request_key_and_link(type, description, callout_info,
  				    callout_len, NULL, NULL,
-				    KEY_ALLOC_IN_QUOTA);
+				    KEY_ALLOC_IN_QUOTA, 0);
  }
  EXPORT_SYMBOL(request_key_async);

@@ -723,6 +764,6 @@ struct key *request_key_async_with_auxdata(struct 
key_type *type,
  					   void *aux)
  {
  	return request_key_and_link(type, description, callout_info,
-				    callout_len, aux, NULL, KEY_ALLOC_IN_QUOTA);
+				    callout_len, aux, NULL, KEY_ALLOC_IN_QUOTA, 0);
  }
  EXPORT_SYMBOL(request_key_async_with_auxdata);

