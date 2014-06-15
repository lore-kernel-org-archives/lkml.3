Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaFOODA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 10:03:00 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54311 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaFOOC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 10:02:58 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>
Cc: selinux@tycho.nsa.gov, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] selinux: introduce str_read() helper
Date: Sun, 15 Jun 2014 23:02:51 +0900
Message-Id: <1402840971-24226-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There're some code duplication for reading a string value during
policydb_read().  Add str_read() helper to fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 security/selinux/ss/policydb.c | 133 ++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 96 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 9c5cdc2caaef..26a8ea7773b7 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1080,6 +1080,26 @@ out:
  * binary representation file.
  */
 
+static int str_read(char **strp, gfp_t flags, void *fp, u32 len)
+{
+	int rc;
+	char *str;
+
+	str = kmalloc(len + 1, flags);
+	if (!str)
+		return -ENOMEM;
+
+	/* it's expected the caller should free the str */
+	*strp = str;
+
+	rc = next_entry(str, fp, len);
+	if (rc)
+		return rc;
+
+	str[len] = '\0';
+	return 0;
+}
+
 static int perm_read(struct policydb *p, struct hashtab *h, void *fp)
 {
 	char *key = NULL;
@@ -1100,15 +1120,9 @@ static int perm_read(struct policydb *p, struct hashtab *h, void *fp)
 	len = le32_to_cpu(buf[0]);
 	perdatum->value = le32_to_cpu(buf[1]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto bad;
-
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	rc = hashtab_insert(h, key, perdatum);
 	if (rc)
@@ -1146,15 +1160,9 @@ static int common_read(struct policydb *p, struct hashtab *h, void *fp)
 	comdatum->permissions.nprim = le32_to_cpu(buf[2]);
 	nel = le32_to_cpu(buf[3]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto bad;
-
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	for (i = 0; i < nel; i++) {
 		rc = perm_read(p, comdatum->permissions.table, fp);
@@ -1321,25 +1329,14 @@ static int class_read(struct policydb *p, struct hashtab *h, void *fp)
 
 	ncons = le32_to_cpu(buf[5]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto bad;
-
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	if (len2) {
-		rc = -ENOMEM;
-		cladatum->comkey = kmalloc(len2 + 1, GFP_KERNEL);
-		if (!cladatum->comkey)
-			goto bad;
-		rc = next_entry(cladatum->comkey, fp, len2);
+		rc = str_read(&cladatum->comkey, GFP_KERNEL, fp, len2);
 		if (rc)
 			goto bad;
-		cladatum->comkey[len2] = '\0';
 
 		rc = -EINVAL;
 		cladatum->comdatum = hashtab_search(p->p_commons.table, cladatum->comkey);
@@ -1422,15 +1419,9 @@ static int role_read(struct policydb *p, struct hashtab *h, void *fp)
 	if (p->policyvers >= POLICYDB_VERSION_BOUNDARY)
 		role->bounds = le32_to_cpu(buf[2]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto bad;
-
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	rc = ebitmap_read(&role->dominates, fp);
 	if (rc)
@@ -1495,14 +1486,9 @@ static int type_read(struct policydb *p, struct hashtab *h, void *fp)
 		typdatum->primary = le32_to_cpu(buf[2]);
 	}
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto bad;
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	rc = hashtab_insert(h, key, typdatum);
 	if (rc)
@@ -1565,14 +1551,9 @@ static int user_read(struct policydb *p, struct hashtab *h, void *fp)
 	if (p->policyvers >= POLICYDB_VERSION_BOUNDARY)
 		usrdatum->bounds = le32_to_cpu(buf[2]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_KERNEL);
-	if (!key)
-		goto bad;
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	rc = ebitmap_read(&usrdatum->roles, fp);
 	if (rc)
@@ -1616,14 +1597,9 @@ static int sens_read(struct policydb *p, struct hashtab *h, void *fp)
 	len = le32_to_cpu(buf[0]);
 	levdatum->isalias = le32_to_cpu(buf[1]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_ATOMIC);
-	if (!key)
-		goto bad;
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_ATOMIC, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	rc = -ENOMEM;
 	levdatum->level = kmalloc(sizeof(struct mls_level), GFP_ATOMIC);
@@ -1664,14 +1640,9 @@ static int cat_read(struct policydb *p, struct hashtab *h, void *fp)
 	catdatum->value = le32_to_cpu(buf[1]);
 	catdatum->isalias = le32_to_cpu(buf[2]);
 
-	rc = -ENOMEM;
-	key = kmalloc(len + 1, GFP_ATOMIC);
-	if (!key)
-		goto bad;
-	rc = next_entry(key, fp, len);
+	rc = str_read(&key, GFP_ATOMIC, fp, len);
 	if (rc)
 		goto bad;
-	key[len] = '\0';
 
 	rc = hashtab_insert(h, key, catdatum);
 	if (rc)
@@ -1968,18 +1939,12 @@ static int filename_trans_read(struct policydb *p, void *fp)
 			goto out;
 		len = le32_to_cpu(buf[0]);
 
-		rc = -ENOMEM;
-		name = kmalloc(len + 1, GFP_KERNEL);
-		if (!name)
-			goto out;
-
-		ft->name = name;
-
 		/* path component string */
-		rc = next_entry(name, fp, len);
+		rc = str_read(&name, GFP_KERNEL, fp, len);
 		if (rc)
 			goto out;
-		name[len] = 0;
+
+		ft->name = name;
 
 		rc = next_entry(buf, fp, sizeof(u32) * 4);
 		if (rc)
@@ -2045,17 +2010,10 @@ static int genfs_read(struct policydb *p, void *fp)
 		if (!newgenfs)
 			goto out;
 
-		rc = -ENOMEM;
-		newgenfs->fstype = kmalloc(len + 1, GFP_KERNEL);
-		if (!newgenfs->fstype)
-			goto out;
-
-		rc = next_entry(newgenfs->fstype, fp, len);
+		rc = str_read(&newgenfs->fstype, GFP_KERNEL, fp, len);
 		if (rc)
 			goto out;
 
-		newgenfs->fstype[len] = 0;
-
 		for (genfs_p = NULL, genfs = p->genfs; genfs;
 		     genfs_p = genfs, genfs = genfs->next) {
 			rc = -EINVAL;
@@ -2091,15 +2049,9 @@ static int genfs_read(struct policydb *p, void *fp)
 			if (!newc)
 				goto out;
 
-			rc = -ENOMEM;
-			newc->u.name = kmalloc(len + 1, GFP_KERNEL);
-			if (!newc->u.name)
-				goto out;
-
-			rc = next_entry(newc->u.name, fp, len);
+			rc = str_read(&newc->u.name, GFP_KERNEL, fp, len);
 			if (rc)
 				goto out;
-			newc->u.name[len] = 0;
 
 			rc = next_entry(buf, fp, sizeof(u32));
 			if (rc)
@@ -2189,16 +2141,10 @@ static int ocontext_read(struct policydb *p, struct policydb_compat_info *info,
 					goto out;
 				len = le32_to_cpu(buf[0]);
 
-				rc = -ENOMEM;
-				c->u.name = kmalloc(len + 1, GFP_KERNEL);
-				if (!c->u.name)
-					goto out;
-
-				rc = next_entry(c->u.name, fp, len);
+				rc = str_read(&c->u.name, GFP_KERNEL, fp, len);
 				if (rc)
 					goto out;
 
-				c->u.name[len] = 0;
 				rc = context_read_and_validate(&c->context[0], p, fp);
 				if (rc)
 					goto out;
@@ -2240,16 +2186,11 @@ static int ocontext_read(struct policydb *p, struct policydb_compat_info *info,
 				if (c->v.behavior > SECURITY_FS_USE_MAX)
 					goto out;
 
-				rc = -ENOMEM;
 				len = le32_to_cpu(buf[1]);
-				c->u.name = kmalloc(len + 1, GFP_KERNEL);
-				if (!c->u.name)
-					goto out;
-
-				rc = next_entry(c->u.name, fp, len);
+				rc = str_read(&c->u.name, GFP_KERNEL, fp, len);
 				if (rc)
 					goto out;
-				c->u.name[len] = 0;
+
 				rc = context_read_and_validate(&c->context[0], p, fp);
 				if (rc)
 					goto out;
-- 
2.0.0

