Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3FMP3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:29:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57789 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3FMP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:29:47 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-c5-51b9e569d7f1
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 5/5] security: smack: add kmem_cache for smack_master_list
 allocations
Date: Thu, 13 Jun 2013 17:29:12 +0200
Message-id: <1371137352-31273-6-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e+xgG7m052BBi2t6hb3tv1iszjb9Ibd
	4vKuOWwWH3oesVmsPXKX3eLtpBXMFvPaX7I6sHv0bVnF6HF0/yI2j8+b5AKYo7hsUlJzMstS
	i/TtErgypj2MK7glUfFtygnGBsZlIl2MnBwSAiYSO/ZfZoGwxSQu3FvP1sXIxSEksIhR4v+s
	B0wQTheTxPWdF5lAqtiAOo4t+cwIYosIaEocmw7RwSywjVGi48VUsCJhgTCJgwensnYxcnCw
	CKhKTDnpARLmFfCQmHR7DdQ2eYmn9/vYQGxOAU+Jt7c2gsWFgGqOPlnMPIGRdwEjwypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4AB6Jr2DcVWDxSFGAQ5GJR7ehAs7A4VYE8uKK3MPMUpw
	MCuJ8Ko/BArxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg
	LI6bVVXw/ZSQ76yL0bo9y79w5F0WX2yW/FfrBkvACc7ZNkZxvCorY5KlW018XrloKz5UvGYu
	fDO/9tnbWb/ifhzhqux4ONEo7snLW5eFghl/9f0WLtTwvxAqOZ2B7a9YK9Ob5a+CIpMWWvbs
	un3qku4z3l8XbM4s3nbynM2lhpxsFlP/nF/FSizFGYmGWsxFxYkAa7aUtRwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, sizeof(struct smack_master_list) == 12. Allocation by kmalloc() uses a
32-byte-long chunk to allocate 12 bytes. Just ask ksize().  It means that 63%
of memory is simply wasted for padding bytes.

The problem is fixed in this patch by using kmem_cache. The cache allocates
struct smack_master_list using 16-byte-long chunks according to ksize(). This
reduces amount of used memory by 50%.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smack.h     |    7 +++++++
 security/smack/smack_lsm.c |    8 ++++++++
 security/smack/smackfs.c   |    8 ++------
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 38ba673..463f818 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -194,6 +194,12 @@ struct smk_audit_info {
 	struct smack_audit_data sad;
 #endif
 };
+
+struct smack_master_list {
+	struct list_head	list;
+	struct smack_rule	*smk_rule;
+};
+
 /*
  * These functions are in smack_lsm.c
  */
@@ -235,6 +241,7 @@ extern struct list_head smk_netlbladdr_list;
 
 /* Cache for fast and thrifty allocations */
 extern struct kmem_cache *smack_rule_cache;
+extern struct kmem_cache *smack_master_list_cache;
 
 extern struct security_operations smack_ops;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7aa696a..1d4a1b0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3566,6 +3566,7 @@ static __init void init_smack_known_list(void)
 
 /* KMEM caches for fast and thrifty allocations */
 struct kmem_cache *smack_rule_cache;
+struct kmem_cache *smack_master_list_cache;
 
 /**
  * smack_init - initialize the smack system
@@ -3584,9 +3585,16 @@ static __init int smack_init(void)
 	if (!smack_rule_cache)
 		return -ENOMEM;
 
+	smack_master_list_cache = KMEM_CACHE(smack_master_list, 0);
+	if (!smack_master_list_cache) {
+		kmem_cache_destroy(smack_rule_cache);
+		return -ENOMEM;
+	}
+
 	tsp = new_task_smack(smack_known_floor.smk_known,
 				smack_known_floor.smk_known, GFP_KERNEL);
 	if (tsp == NULL) {
+		kmem_cache_destroy(smack_master_list_cache);
 		kmem_cache_destroy(smack_rule_cache);
 		return -ENOMEM;
 	}
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index c08b1ec..c7a1b0d 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -104,11 +104,6 @@ LIST_HEAD(smk_netlbladdr_list);
  * Rule lists are maintained for each label.
  * This master list is just for reading /smack/load and /smack/load2.
  */
-struct smack_master_list {
-	struct list_head	list;
-	struct smack_rule	*smk_rule;
-};
-
 LIST_HEAD(smack_rule_list);
 
 struct smack_parsed_rule {
@@ -233,7 +228,8 @@ static int smk_set_access(struct smack_parsed_rule *srp,
 		 * it needs to get added for reporting.
 		 */
 		if (global) {
-			smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
+			smlp = kmem_cache_zalloc(smack_master_list_cache,
+							GFP_KERNEL);
 			if (smlp != NULL) {
 				smlp->smk_rule = sp;
 				list_add_rcu(&smlp->list, &smack_rule_list);
-- 
1.7.9.5

