Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaAES7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:59:30 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:61991 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaAES73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:59:29 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: gregkh@linuxfoundation.org
Cc: omar.ramirez@copitl.com, pali.rohar@gmail.com, pavel@ucw.cz,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Ivaylo Dimitrov <freemangordon@abv.bg>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH v2] Staging: tidspbridge: Use hashtable implementation
Date: Sun,  5 Jan 2014 20:58:12 +0200
Message-Id: <1388948292-5084-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <52C9AAB3.6050300@gmail.com>
References: <52C9AAB3.6050300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

Use upstream hashtable implementation instead of generic code

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/staging/tidspbridge/gen/gh.c               |  148 ++++++++------------
 drivers/staging/tidspbridge/include/dspbridge/gh.h |   12 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |   78 +++++------
 3 files changed, 99 insertions(+), 139 deletions(-)

diff --git a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
index 25eaef7..936470c 100644
--- a/drivers/staging/tidspbridge/gen/gh.c
+++ b/drivers/staging/tidspbridge/gen/gh.c
@@ -14,56 +14,45 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/hashtable.h>
+#include <linux/slab.h>
 
-#include <dspbridge/host_os.h>
-#include <dspbridge/gh.h>
-
-struct element {
-	struct element *next;
-	u8 data[1];
+struct gh_node {
+	struct hlist_node hl;
+	u8 data[0];
 };
 
+#define GH_HASH_ORDER 8
+
 struct gh_t_hash_tab {
-	u16 max_bucket;
-	u16 val_size;
-	struct element **buckets;
-	 u16(*hash) (void *, u16);
-	 bool(*match) (void *, void *);
-	void (*delete) (void *);
+	u32 val_size;
+	DECLARE_HASHTABLE(hash_table, GH_HASH_ORDER);
+	u32 (*hash)(const void *key);
+	bool (*match)(const void *key, const void *value);
+	void (*delete)(void *key);
 };
 
-static void noop(void *p);
-
 /*
  *  ======== gh_create ========
  */
 
-struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
-				u16(*hash) (void *, u16), bool(*match) (void *,
-									void *),
-				void (*delete) (void *))
+struct gh_t_hash_tab *gh_create(u32 val_size, u32 (*hash)(const void *),
+				bool (*match)(const void *, const void *),
+				void (*delete)(void *))
 {
 	struct gh_t_hash_tab *hash_tab;
-	u16 i;
+
 	hash_tab = kzalloc(sizeof(struct gh_t_hash_tab), GFP_KERNEL);
-	if (hash_tab == NULL)
-		return NULL;
-	hash_tab->max_bucket = max_bucket;
+	if (!hash_tab)
+		return ERR_PTR(-ENOMEM);
+
+	hash_init(hash_tab->hash_table);
+
 	hash_tab->val_size = val_size;
 	hash_tab->hash = hash;
 	hash_tab->match = match;
-	hash_tab->delete = delete == NULL ? noop : delete;
-
-	hash_tab->buckets =
-	    kzalloc(sizeof(struct element *) * max_bucket, GFP_KERNEL);
-	if (hash_tab->buckets == NULL) {
-		gh_delete(hash_tab);
-		return NULL;
-	}
-
-	for (i = 0; i < max_bucket; i++)
-		hash_tab->buckets[i] = NULL;
+	hash_tab->delete = delete;
 
 	return hash_tab;
 }
@@ -73,21 +62,16 @@ struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
  */
 void gh_delete(struct gh_t_hash_tab *hash_tab)
 {
-	struct element *elem, *next;
-	u16 i;
-
-	if (hash_tab != NULL) {
-		if (hash_tab->buckets != NULL) {
-			for (i = 0; i < hash_tab->max_bucket; i++) {
-				for (elem = hash_tab->buckets[i]; elem != NULL;
-				     elem = next) {
-					next = elem->next;
-					(*hash_tab->delete) (elem->data);
-					kfree(elem);
-				}
-			}
-
-			kfree(hash_tab->buckets);
+	struct gh_node *n;
+	struct hlist_node *tmp;
+	u32 i;
+
+	if (hash_tab) {
+		hash_for_each_safe(hash_tab->hash_table, i, tmp, n, hl) {
+			hash_del(&n->hl);
+			if (hash_tab->delete)
+				hash_tab->delete(n->data);
+			kfree(n);
 		}
 
 		kfree(hash_tab);
@@ -98,56 +82,39 @@ void gh_delete(struct gh_t_hash_tab *hash_tab)
  *  ======== gh_find ========
  */
 
-void *gh_find(struct gh_t_hash_tab *hash_tab, void *key)
+void *gh_find(struct gh_t_hash_tab *hash_tab, const void *key)
 {
-	struct element *elem;
+	struct gh_node *n;
+	u32 key_hash = hash_tab->hash(key);
 
-	elem = hash_tab->buckets[(*hash_tab->hash) (key, hash_tab->max_bucket)];
-
-	for (; elem; elem = elem->next) {
-		if ((*hash_tab->match) (key, elem->data))
-			return elem->data;
+	hash_for_each_possible(hash_tab->hash_table, n, hl, key_hash) {
+		if (hash_tab->match(key, n->data))
+			return n->data;
 	}
 
-	return NULL;
+	return ERR_PTR(-ENODATA);
 }
 
 /*
  *  ======== gh_insert ========
  */
 
-void *gh_insert(struct gh_t_hash_tab *hash_tab, void *key, void *value)
+void *gh_insert(struct gh_t_hash_tab *hash_tab, const void *key,
+		const void *value)
 {
-	struct element *elem;
-	u16 i;
-	char *src, *dst;
+	struct gh_node *n;
 
-	elem = kzalloc(sizeof(struct element) - 1 + hash_tab->val_size,
+	n = kmalloc(sizeof(struct gh_node) + hash_tab->val_size,
 			GFP_KERNEL);
-	if (elem != NULL) {
-
-		dst = (char *)elem->data;
-		src = (char *)value;
-		for (i = 0; i < hash_tab->val_size; i++)
-			*dst++ = *src++;
 
-		i = (*hash_tab->hash) (key, hash_tab->max_bucket);
-		elem->next = hash_tab->buckets[i];
-		hash_tab->buckets[i] = elem;
+	if (!n)
+		return ERR_PTR(-ENOMEM);
 
-		return elem->data;
-	}
-
-	return NULL;
-}
+	INIT_HLIST_NODE(&n->hl);
+	hash_add(hash_tab->hash_table, &n->hl, hash_tab->hash(key));
+	memcpy(n->data, value, hash_tab->val_size);
 
-/*
- *  ======== noop ========
- */
-/* ARGSUSED */
-static void noop(void *p)
-{
-	p = p;			/* stifle compiler warning */
+	return n->data;
 }
 
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
@@ -162,16 +129,13 @@ static void noop(void *p)
 void gh_iterate(struct gh_t_hash_tab *hash_tab,
 		void (*callback)(void *, void *), void *user_data)
 {
-	struct element *elem;
+	struct gh_node *n;
 	u32 i;
 
-	if (hash_tab && hash_tab->buckets)
-		for (i = 0; i < hash_tab->max_bucket; i++) {
-			elem = hash_tab->buckets[i];
-			while (elem) {
-				callback(&elem->data, user_data);
-				elem = elem->next;
-			}
-		}
+	if (!hash_tab)
+		return;
+
+	hash_for_each(hash_tab->hash_table, i, n, hl)
+		callback(&n->data, user_data);
 }
 #endif
diff --git a/drivers/staging/tidspbridge/include/dspbridge/gh.h b/drivers/staging/tidspbridge/include/dspbridge/gh.h
index da85079..e4303b4 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/gh.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/gh.h
@@ -18,13 +18,13 @@
 #define GH_
 #include <dspbridge/host_os.h>
 
-extern struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
-				       u16(*hash) (void *, u16),
-				       bool(*match) (void *, void *),
-				       void (*delete) (void *));
+extern struct gh_t_hash_tab *gh_create(u32 val_size,
+	u32 (*hash)(const void *), bool (*match)(const void *,
+	const void *), void (*delete) (void *));
 extern void gh_delete(struct gh_t_hash_tab *hash_tab);
-extern void *gh_find(struct gh_t_hash_tab *hash_tab, void *key);
-extern void *gh_insert(struct gh_t_hash_tab *hash_tab, void *key, void *value);
+extern void *gh_find(struct gh_t_hash_tab *hash_tab, const void *key);
+extern void *gh_insert(struct gh_t_hash_tab *hash_tab, const void *key,
+		       const void *value);
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 void gh_iterate(struct gh_t_hash_tab *hash_tab,
 	void (*callback)(void *, void *), void *user_data);
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 41e88ab..764dbe5 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -33,9 +33,6 @@
 #include <dspbridge/dbll.h>
 #include <dspbridge/rmm.h>
 
-/* Number of buckets for symbol hash table */
-#define MAXBUCKETS 211
-
 /* Max buffer length */
 #define MAXEXPR 128
 
@@ -183,8 +180,8 @@ static int execute(struct dynamic_loader_initialize *this, ldr_addr start);
 static void release(struct dynamic_loader_initialize *this);
 
 /* symbol table hash functions */
-static u16 name_hash(void *key, u16 max_bucket);
-static bool name_match(void *key, void *sp);
+static u32 name_hash(const void *key);
+static bool name_match(const void *key, const void *sp);
 static void sym_delete(void *value);
 
 /* Symbol Redefinition */
@@ -277,17 +274,16 @@ bool dbll_get_addr(struct dbll_library_obj *zl_lib, char *name,
 		   struct dbll_sym_val **sym_val)
 {
 	struct dbll_symbol *sym;
-	bool status = false;
 
 	sym = (struct dbll_symbol *)gh_find(zl_lib->sym_tab, name);
-	if (sym != NULL) {
-		*sym_val = &sym->value;
-		status = true;
-	}
+	if (IS_ERR(sym))
+		return false;
 
-	dev_dbg(bridge, "%s: lib: %p name: %s paddr: %p, status 0x%x\n",
-		__func__, zl_lib, name, sym_val, status);
-	return status;
+	*sym_val = &sym->value;
+
+	dev_dbg(bridge, "%s: lib: %p name: %s paddr: %p\n",
+		__func__, zl_lib, name, sym_val);
+	return true;
 }
 
 /*
@@ -312,7 +308,6 @@ bool dbll_get_c_addr(struct dbll_library_obj *zl_lib, char *name,
 {
 	struct dbll_symbol *sym;
 	char cname[MAXEXPR + 1];
-	bool status = false;
 
 	cname[0] = '_';
 
@@ -321,13 +316,12 @@ bool dbll_get_c_addr(struct dbll_library_obj *zl_lib, char *name,
 
 	/* Check for C name, if not found */
 	sym = (struct dbll_symbol *)gh_find(zl_lib->sym_tab, cname);
+	if (IS_ERR(sym))
+		return false;
 
-	if (sym != NULL) {
-		*sym_val = &sym->value;
-		status = true;
-	}
+	*sym_val = &sym->value;
 
-	return status;
+	return true;
 }
 
 /*
@@ -416,12 +410,13 @@ int dbll_load(struct dbll_library_obj *lib, dbll_flags flags,
 		/* Create a hash table for symbols if not already created */
 		if (zl_lib->sym_tab == NULL) {
 			got_symbols = false;
-			zl_lib->sym_tab = gh_create(MAXBUCKETS,
-						    sizeof(struct dbll_symbol),
+			zl_lib->sym_tab = gh_create(sizeof(struct dbll_symbol),
 						    name_hash,
 						    name_match, sym_delete);
-			if (zl_lib->sym_tab == NULL)
-				status = -ENOMEM;
+			if (IS_ERR(zl_lib->sym_tab)) {
+				status = PTR_ERR(zl_lib->sym_tab);
+				zl_lib->sym_tab = NULL;
+			}
 
 		}
 		/*
@@ -593,10 +588,11 @@ int dbll_open(struct dbll_tar_obj *target, char *file, dbll_flags flags,
 		goto func_cont;
 
 	zl_lib->sym_tab =
-	    gh_create(MAXBUCKETS, sizeof(struct dbll_symbol), name_hash,
-		      name_match, sym_delete);
-	if (zl_lib->sym_tab == NULL) {
-		status = -ENOMEM;
+	    gh_create(sizeof(struct dbll_symbol), name_hash, name_match,
+		      sym_delete);
+	if (IS_ERR(zl_lib->sym_tab)) {
+		status = PTR_ERR(zl_lib->sym_tab);
+		zl_lib->sym_tab = NULL;
 	} else {
 		/* Do a fake load to get symbols - set write func to no_op */
 		zl_lib->init.dl_init.writemem = no_op;
@@ -793,11 +789,10 @@ static int dof_open(struct dbll_library_obj *zl_lib)
 /*
  *  ======== name_hash ========
  */
-static u16 name_hash(void *key, u16 max_bucket)
+static u32 name_hash(const void *key)
 {
-	u16 ret;
-	u16 hash;
-	char *name = (char *)key;
+	u32 hash;
+	const char *name = (const char *)key;
 
 	hash = 0;
 
@@ -806,19 +801,17 @@ static u16 name_hash(void *key, u16 max_bucket)
 		hash ^= *name++;
 	}
 
-	ret = hash % max_bucket;
-
-	return ret;
+	return hash;
 }
 
 /*
  *  ======== name_match ========
  */
-static bool name_match(void *key, void *sp)
+static bool name_match(const void *key, const void *sp)
 {
 	if ((key != NULL) && (sp != NULL)) {
-		if (strcmp((char *)key, ((struct dbll_symbol *)sp)->name) ==
-		    0)
+		if (strcmp((const char *)key,
+			   ((const struct dbll_symbol *)sp)->name) == 0)
 			return true;
 	}
 	return false;
@@ -937,7 +930,6 @@ static struct dynload_symbol *find_in_symbol_table(struct dynamic_loader_sym
 						   *this, const char *name,
 						   unsigned moduleid)
 {
-	struct dynload_symbol *ret_sym;
 	struct ldr_symbol *ldr_sym = (struct ldr_symbol *)this;
 	struct dbll_library_obj *lib;
 	struct dbll_symbol *sym;
@@ -945,8 +937,10 @@ static struct dynload_symbol *find_in_symbol_table(struct dynamic_loader_sym
 	lib = ldr_sym->lib;
 	sym = (struct dbll_symbol *)gh_find(lib->sym_tab, (char *)name);
 
-	ret_sym = (struct dynload_symbol *)&sym->value;
-	return ret_sym;
+	if (IS_ERR(sym))
+		return NULL;
+
+	return (struct dynload_symbol *)&sym->value;
 }
 
 /*
@@ -991,8 +985,10 @@ static struct dynload_symbol *dbll_add_to_symbol_table(struct dynamic_loader_sym
 		sym_ptr =
 		    (struct dbll_symbol *)gh_insert(lib->sym_tab, (void *)name,
 						    (void *)&symbol);
-		if (sym_ptr == NULL)
+		if (IS_ERR(sym_ptr)) {
 			kfree(symbol.name);
+			sym_ptr = NULL;
+		}
 
 	}
 	if (sym_ptr != NULL)
-- 
1.5.6.1

