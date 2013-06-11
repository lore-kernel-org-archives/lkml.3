Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3FKMzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:55:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31382 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3FKMz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:55:29 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-11-51b71e40f885
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2] security: smack: add a hash table to quicken smk_find_entry()
Date: Tue, 11 Jun 2013 14:55:13 +0200
Message-id: <1370955313-3605-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com>
References: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e+xgK6D3PZAg4PftS3ubfvFZnG26Q27
	xeVdc9gsPvQ8YrNYe+Quu8XbSSuYLea1v2R1YPfo27KK0ePo/kVsHp83yQUwR3HZpKTmZJal
	FunbJXBlbP6ylKngkX7FrUOKDYxL1bsYOTkkBEwknl7dwwxhi0lcuLeeDcQWEljEKHFmTUYX
	IxeQ3cUk8XTWXSaQBBtQw7ElnxlBbBEBTYlj00EauDiYBbYxSnS8mApWJCzgJzGtfSkLiM0i
	oCqxf/t1VhCbV8Bd4vShb4wQ2+Qlnt7vA9vGKeAhcfZ4KzPEZneJCU+62Scw8i5gZFjFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJERxAz6R2MK5ssDjEKMDBqMTDm8C4LVCINbGsuDL3EKME
	B7OSCK+Z8PZAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxS
	DYwsXi85wl7uZdOJeawx7yCHffYJuYrjKVMd+15ETr/f3/h/0SXNWQzJk3IEXOR3Wlce2p/6
	Z/+mvMNWJxk/6IsLrhf5X8fzWumZ6Jz31y98zPK/Zse7fuLC20q8e48aqUwvcHCKYn+iui9K
	om9LJCdXNNMmvUW3zirI/TB9uviMjNlR9af7kqqUWIozEg21mIuKEwGGKDiLHAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a hash table to quicken searching of a smack label by its name.

Basically, the patch improves performance of SMACK initialization.  Parsing of
rules involves translation from a string to a smack_known (aka label) entity
which is done in smk_find_entry().

The current implementation of the function iterates over a global list of
smack_known resulting in O(N) complexity for smk_find_entry().  The total
complexity of SMACK initialization becomes O(rules * labels).  Therefore it
scales quadratically with a complexity of a system.

Applying the patch reduced the complexity of smk_find_entry() to O(1) as long
as number of label is in hundreds. If the number of labels is increased please
update SMACK_HASH_SLOTS constant defined in security/smack/smack.h. Introducing
the configuration of this constant with Kconfig or cmdline might be a good
idea.

The size of the hash table was adjusted experimentally.  The rule set used by
TIZEN contains circa 17K rules for 500 labels.  The table above contains
results of SMACK initialization using 'time smackctl apply' bash command.
The 'Ref' is a kernel without this patch applied. The consecutive values
refers to value of SMACK_HASH_SLOTS.  Every measurement was repeated three
times to reduce noise.

     |  Ref  |   1   |   2   |   4   |   8   |   16  |   32  |   64  |  128  |  256  |  512
--------------------------------------------------------------------------------------------
Run1 | 1.156 | 1.096 | 0.883 | 0.764 | 0.692 | 0.667 | 0.649 | 0.633 | 0.634 | 0.629 | 0.620
Run2 | 1.156 | 1.111 | 0.885 | 0.764 | 0.694 | 0.661 | 0.649 | 0.651 | 0.634 | 0.638 | 0.623
Run3 | 1.160 | 1.107 | 0.886 | 0.764 | 0.694 | 0.671 | 0.661 | 0.638 | 0.631 | 0.624 | 0.638
AVG  | 1.157 | 1.105 | 0.885 | 0.764 | 0.693 | 0.666 | 0.653 | 0.641 | 0.633 | 0.630 | 0.627

Surprisingly, a single hlist is slightly faster than a double-linked list.
The speed-up saturates near 64 slots.  Therefore I chose value 128 to provide
some margin if more labels were used.
It looks that IO becomes a new bottleneck.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smack.h        |    5 +++++
 security/smack/smack_access.c |   30 +++++++++++++++++++++++++++---
 security/smack/smack_lsm.c    |   12 ++++++------
 3 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 339614c..b1d9441 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -53,6 +53,7 @@
  */
 struct smack_known {
 	struct list_head		list;
+	struct hlist_node		smk_hashed;
 	char				*smk_known;
 	u32				smk_secid;
 	struct netlbl_lsm_secattr	smk_netlabel;	/* on wire labels */
@@ -222,6 +223,7 @@ char *smk_parse_smack(const char *string, int len);
 int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
 char *smk_import(const char *, int);
 struct smack_known *smk_import_entry(const char *, int);
+void smk_insert_entry(struct smack_known *skp);
 struct smack_known *smk_find_entry(const char *);
 u32 smack_to_secid(const char *);
 
@@ -247,6 +249,9 @@ extern struct list_head smk_netlbladdr_list;
 
 extern struct security_operations smack_ops;
 
+#define SMACK_HASH_SLOTS 128
+extern struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
+
 /*
  * Is the directory transmuting?
  */
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 6a0377f..b598c32 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -325,6 +325,25 @@ void smack_log(char *subject_label, char *object_label, int request,
 
 DEFINE_MUTEX(smack_known_lock);
 
+struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
+
+/**
+ * smk_insert_entry - insert a smack label into a hash map,
+ *
+ * this function must be called under smack_known_lock
+ */
+void smk_insert_entry(struct smack_known *skp)
+{
+	unsigned int hash;
+	struct hlist_head *head;
+
+	hash = full_name_hash(skp->smk_known, strlen(skp->smk_known));
+	head = &smack_known_hash[hash & (SMACK_HASH_SLOTS - 1)];
+
+	hlist_add_head_rcu(&skp->smk_hashed, head);
+	list_add_rcu(&skp->list, &smack_known_list);
+}
+
 /**
  * smk_find_entry - find a label on the list, return the list entry
  * @string: a text string that might be a Smack label
@@ -334,12 +353,17 @@ DEFINE_MUTEX(smack_known_lock);
  */
 struct smack_known *smk_find_entry(const char *string)
 {
+	unsigned int hash;
+	struct hlist_head *head;
+	struct hlist_node *cursor;
 	struct smack_known *skp;
 
-	list_for_each_entry_rcu(skp, &smack_known_list, list) {
+	hash = full_name_hash(string, strlen(string));
+	head = &smack_known_hash[hash & (SMACK_HASH_SLOTS - 1)];
+
+	hlist_for_each_entry_rcu(skp, cursor, head, smk_hashed)
 		if (strcmp(skp->smk_known, string) == 0)
 			return skp;
-	}
 
 	return NULL;
 }
@@ -475,7 +499,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
 		 * Make sure that the entry is actually
 		 * filled before putting it on the list.
 		 */
-		list_add_rcu(&skp->list, &smack_known_list);
+		smk_insert_entry(skp);
 		goto unlockout;
 	}
 	/*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6a08330..6cabca6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3868,12 +3868,12 @@ static __init void init_smack_known_list(void)
 	/*
 	 * Create the known labels list
 	 */
-	list_add(&smack_known_huh.list, &smack_known_list);
-	list_add(&smack_known_hat.list, &smack_known_list);
-	list_add(&smack_known_star.list, &smack_known_list);
-	list_add(&smack_known_floor.list, &smack_known_list);
-	list_add(&smack_known_invalid.list, &smack_known_list);
-	list_add(&smack_known_web.list, &smack_known_list);
+	smk_insert_entry(&smack_known_huh);
+	smk_insert_entry(&smack_known_hat);
+	smk_insert_entry(&smack_known_star);
+	smk_insert_entry(&smack_known_floor);
+	smk_insert_entry(&smack_known_invalid);
+	smk_insert_entry(&smack_known_web);
 }
 
 /**
-- 
1.7.9.5

