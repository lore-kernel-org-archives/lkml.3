Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161705Ab3LFOUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:20:05 -0500
Received: from tundra.namei.org ([65.99.196.166]:49209 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161088Ab3LFOT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:19:59 -0500
Date: Sat, 7 Dec 2013 01:34:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] IMA fixes
Message-ID: <alpine.LRH.2.02.1312070133100.5584@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are two more fixes for IMA, for your current tree.  Please pull.

The following changes since commit 002acf1fc16cf60e60345bd68e03734628505b83:

  Merge tag 'pm-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2013-12-05 18:26:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Christoph Paasch (1):
      ima: Do not free 'entry' before it is initialized

James Morris (1):
      Merge branch 'free-memory' of git://git.kernel.org/.../zohar/linux-integrity into for-linus

Roberto Sassu (1):
      ima: properly free ima_template_entry structures

 security/integrity/ima/ima.h      |    1 +
 security/integrity/ima/ima_api.c  |   21 +++++++++++++++++----
 security/integrity/ima/ima_init.c |    3 +--
 3 files changed, 19 insertions(+), 6 deletions(-)


---

commit a7ed7c60e14df5b986f93549717235b882643e7e
Author: Roberto Sassu <roberto.sassu@polito.it>
Date:   Mon Dec 2 19:40:34 2013 +0100

    ima: properly free ima_template_entry structures
    
    The new templates management mechanism records information associated
    to an event into an array of 'ima_field_data' structures and makes it
    available through the 'template_data' field of the 'ima_template_entry'
    structure (the element of the measurements list created by IMA).
    
    Since 'ima_field_data' contains dynamically allocated data (which length
    varies depending on the data associated to a selected template field),
    it is not enough to just free the memory reserved for a
    'ima_template_entry' structure if something goes wrong.
    
    This patch creates the new function ima_free_template_entry() which
    walks the array of 'ima_field_data' structures, frees the memory
    referenced by the 'data' pointer and finally the space reserved for
    the 'ima_template_entry' structure. Further, it replaces existing kfree()
    that have a pointer to an 'ima_template_entry' structure as argument
    with calls to the new function.
    
    Fixes: a71dc65: ima: switch to new template management mechanism
    Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
    Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 9636e17..0356e1d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -148,6 +148,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 			    int xattr_len, struct ima_template_entry **entry);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode, const unsigned char *filename);
+void ima_free_template_entry(struct ima_template_entry *entry);
 const char *ima_d_path(struct path *path, char **pathbuf);
 
 /* rbtree tree calls to lookup, insert, delete
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 8037484..c38bbce 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -22,6 +22,19 @@
 #include "ima.h"
 
 /*
+ * ima_free_template_entry - free an existing template entry
+ */
+void ima_free_template_entry(struct ima_template_entry *entry)
+{
+	int i;
+
+	for (i = 0; i < entry->template_desc->num_fields; i++)
+		kfree(entry->template_data[i].data);
+
+	kfree(entry);
+}
+
+/*
  * ima_alloc_init_template - create and initialize a new template entry
  */
 int ima_alloc_init_template(struct integrity_iint_cache *iint,
@@ -37,6 +50,7 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 	if (!*entry)
 		return -ENOMEM;
 
+	(*entry)->template_desc = template_desc;
 	for (i = 0; i < template_desc->num_fields; i++) {
 		struct ima_template_field *field = template_desc->fields[i];
 		u32 len;
@@ -51,10 +65,9 @@ int ima_alloc_init_template(struct integrity_iint_cache *iint,
 		(*entry)->template_data_len += sizeof(len);
 		(*entry)->template_data_len += len;
 	}
-	(*entry)->template_desc = template_desc;
 	return 0;
 out:
-	kfree(*entry);
+	ima_free_template_entry(*entry);
 	*entry = NULL;
 	return result;
 }
@@ -134,7 +147,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 	}
 	result = ima_store_template(entry, violation, inode, filename);
 	if (result < 0)
-		kfree(entry);
+		ima_free_template_entry(entry);
 err_out:
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 			    op, cause, result, 0);
@@ -269,7 +282,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	if (!result || result == -EEXIST)
 		iint->flags |= IMA_MEASURED;
 	if (result < 0)
-		kfree(entry);
+		ima_free_template_entry(entry);
 }
 
 void ima_audit_measurement(struct integrity_iint_cache *iint,
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 76b8e2c..3712276 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -75,7 +75,7 @@ static void __init ima_add_boot_aggregate(void)
 	result = ima_store_template(entry, violation, NULL,
 				    boot_aggregate_name);
 	if (result < 0)
-		kfree(entry);
+		ima_free_template_entry(entry);
 	return;
 err_out:
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL, boot_aggregate_name, op,

commit 09ae6345721afbb7cf3e0920209b140cbe7bff0d
Author: Christoph Paasch <christoph.paasch@uclouvain.be>
Date:   Mon Dec 2 00:05:20 2013 +0100

    ima: Do not free 'entry' before it is initialized
    
    7bc5f447ce9d0 (ima: define new function ima_alloc_init_template() to
    API) moved the initialization of 'entry' in ima_add_boot_aggregate() a
    bit more below, after the if (ima_used_chip).
    
    So, 'entry' is not initialized while being inside this if-block. So, we
    should not attempt to free it.
    
    Found by Coverity (CID: 1131971)
    
    Fixes: 7bc5f447ce9d0 (ima: define new function ima_alloc_init_template() to API)
    Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
    Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 15f34bd..76b8e2c 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -63,7 +63,6 @@ static void __init ima_add_boot_aggregate(void)
 		result = ima_calc_boot_aggregate(&hash.hdr);
 		if (result < 0) {
 			audit_cause = "hashing_error";
-			kfree(entry);
 			goto err_out;
 		}
 	}
