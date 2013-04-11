Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161591Ab3DKIrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:47:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46111 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161568Ab3DKIrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:47:36 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-c7-516678a69fe2
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC] security: smack: add hash table for smack for quick label
 searching
Date: Thu, 11 Apr 2013 10:46:12 +0200
Message-id: <1365669972-21461-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com>
References: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t9jAd1lFWmBBptn6lqcbXrDbnF51xw2
	iw89j9gs1h65y27xdtIKZot57S9ZHdg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2PSLMmC
	yRoVK7uesTcwzlLsYuTkkBAwkVgy8xsrhC0mceHeerYuRi4OIYFFjBINl/YzQThdTBI7Jm9k
	B6liA+o4tuQzI4gtIqApcWw6SAcnB7PAHEaJg5tluxg5OIQFQiTmn+AFCbMIqErcvzmVCcTm
	FfCQmNxxkgVimbzE0/t9YK2cAp4Sz499B4sLAdX8+7+acQIj7wJGhlWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwaHyTGoH48oGi0OMAhyMSjy8JxpSA4VYE8uKK3MPMUpwMCuJ8HLtBArx
	piRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgnG5zh1uhfMEs
	0cwI4+iZOflGXYfOiS7L4UnLlw655fn41bPrtcb3nu80E5+9lrf+7ySb768e6s/bYmEV5ias
	0mH6IHXmhV+6DLlz5N4fn2e/je2t29pJz5Zf+tK0RuyQN8PTkFuPz57vedETefF5ostSoSq+
	83JfZQ/Uh8YIWKw8N/2D3D73ZUosxRmJhlrMRcWJAM1aFeERAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a hash table to quicken searching of a smack label by its name.

For a typical idle for TIZEN the CPU wastes circa 5-10% of its cycles for
processing the smk_find_entry function. This patch adds a hash map that should
speed up searches by a factor of up to 500 at the cost of additional 4kiB
memory for the hash table.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smack.h        |    5 +++++
 security/smack/smack_access.c |   33 +++++++++++++++++++++++++++++++--
 security/smack/smack_lsm.c    |   21 +++++++++++++++------
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 99b3612..8df667e 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -118,6 +118,7 @@ struct smk_netlbladdr {
  */
 struct smack_known {
 	struct list_head		list;
+	struct list_head		htab_list;
 	char				*smk_known;
 	u32				smk_secid;
 	struct netlbl_lsm_secattr	smk_netlabel;	/* on wire labels */
@@ -215,6 +216,7 @@ char *smk_parse_smack(const char *string, int len);
 int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
 char *smk_import(const char *, int);
 struct smack_known *smk_import_entry(const char *, int);
+void __smk_insert_entry(struct smack_known *skp);
 struct smack_known *smk_find_entry(const char *);
 u32 smack_to_secid(const char *);
 
@@ -238,6 +240,9 @@ extern struct mutex	smack_known_lock;
 extern struct list_head smack_known_list;
 extern struct list_head smk_netlbladdr_list;
 
+#define SMACK_KNOWN_SIZE 512
+extern struct list_head smack_known_htab[SMACK_KNOWN_SIZE];
+
 extern struct security_operations smack_ops;
 
 /*
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index db14689..0490c0d 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -48,6 +48,8 @@ struct smack_known smack_known_web = {
 
 LIST_HEAD(smack_known_list);
 
+struct list_head smack_known_htab[SMACK_KNOWN_SIZE];
+
 /*
  * The initial value needs to be bigger than any of the
  * known values above.
@@ -322,6 +324,30 @@ void smack_log(char *subject_label, char *object_label, int request,
 
 DEFINE_MUTEX(smack_known_lock);
 
+/* simple Dan Bernstein string hashing function */
+static u32 strhash(const char *s)
+{
+	u32 hash = 5381;
+	for (; *s; ++s)
+		hash = hash * 33 + *s;
+	return hash;
+}
+
+/**
+ * smk_insert_entry - insert a smack label into a hash map,
+ *
+ * this function must be called under smack_known_lock
+ */
+void __smk_insert_entry(struct smack_known *skp)
+{
+	u32 hash = strhash(skp->smk_known);
+	struct list_head *head = &smack_known_htab[
+		hash & (SMACK_KNOWN_SIZE - 1)];
+
+	list_add_rcu(&skp->htab_list, head);
+	list_add_rcu(&skp->list, &smack_known_list);
+}
+
 /**
  * smk_find_entry - find a label on the list, return the list entry
  * @string: a text string that might be a Smack label
@@ -331,9 +357,12 @@ DEFINE_MUTEX(smack_known_lock);
  */
 struct smack_known *smk_find_entry(const char *string)
 {
+	u32 hash = strhash(string);
+	struct list_head *head = &smack_known_htab[
+		hash & (SMACK_KNOWN_SIZE - 1)];
 	struct smack_known *skp;
 
-	list_for_each_entry_rcu(skp, &smack_known_list, list) {
+	list_for_each_entry_rcu(skp, head, htab_list) {
 		if (strcmp(skp->smk_known, string) == 0)
 			return skp;
 	}
@@ -470,7 +499,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
 		 * Make sure that the entry is actually
 		 * filled before putting it on the list.
 		 */
-		list_add_rcu(&skp->list, &smack_known_list);
+		__smk_insert_entry(skp);
 		goto unlockout;
 	}
 	/*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fa64740..38f5884 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3535,6 +3535,8 @@ struct security_operations smack_ops = {
 
 static __init void init_smack_known_list(void)
 {
+	int i;
+
 	/*
 	 * Initialize rule list locks
 	 */
@@ -3553,15 +3555,22 @@ static __init void init_smack_known_list(void)
 	INIT_LIST_HEAD(&smack_known_floor.smk_rules);
 	INIT_LIST_HEAD(&smack_known_invalid.smk_rules);
 	INIT_LIST_HEAD(&smack_known_web.smk_rules);
+
+	/*
+	 * Initialize a hash map for a quick search of SMACK labels
+	 */
+	for (i = 0; i < SMACK_KNOWN_SIZE; ++i)
+		INIT_LIST_HEAD(&smack_known_htab[i]);
+
 	/*
 	 * Create the known labels list
 	 */
-	list_add(&smack_known_huh.list, &smack_known_list);
-	list_add(&smack_known_hat.list, &smack_known_list);
-	list_add(&smack_known_star.list, &smack_known_list);
-	list_add(&smack_known_floor.list, &smack_known_list);
-	list_add(&smack_known_invalid.list, &smack_known_list);
-	list_add(&smack_known_web.list, &smack_known_list);
+	__smk_insert_entry(&smack_known_huh);
+	__smk_insert_entry(&smack_known_hat);
+	__smk_insert_entry(&smack_known_star);
+	__smk_insert_entry(&smack_known_floor);
+	__smk_insert_entry(&smack_known_invalid);
+	__smk_insert_entry(&smack_known_web);
 }
 
 /**
-- 
1.7.9.5

