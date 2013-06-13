Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3FMP3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:29:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34288 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3FMP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:29:40 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-54-51b9e562ed9e
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 4/5] security: smack: add kmem_cache for smack_rule allocations
Date: Thu, 13 Jun 2013 17:29:11 +0200
Message-id: <1371137352-31273-5-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e+xgG7y052BBhs/sFjc2/aLzeJs0xt2
	i8u75rBZfOh5xGax9shddou3k1YwW8xrf8nqwO7Rt2UVo8fR/YvYPD5vkgtgjuKySUnNySxL
	LdK3S+DK2DPlBlPBCuGKfU8uMjYwfufvYuTkkBAwkTi/8i8rhC0mceHeerYuRi4OIYFFjBJN
	Xc2MEE4Xk8S2K9OYQarYgDqOLfnMCGKLCGhKHJsO0cEssI1RouPFVCaQhLCAr8SzXVfAGlgE
	VCWWvVzGAmLzCnhInFt4kh1inbzE0/t9bCA2p4CnxNtbG8FqhIBqjj5ZzDyBkXcBI8MqRtHU
	guSC4qT0XEO94sTc4tK8dL3k/NxNjOAgeia1g3Flg8UhRgEORiUe3oQLOwOFWBPLiitzDzFK
	cDArifCqPwQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRq
	YLQ+6pG0MXlDm1Bf/52UNt00x2cXfY6bBthMCOt5f0LxxZG99ooPPoqqBS9gc/n26PCd8mQ+
	u77Alhx93SAlMfOfhazbV5imTzJcIrLUvZht9wqplTOM+x3//T5g63500p6HsqyNbkxKZf/d
	l0VJ27/a4bK6OS2IU0Mj/JL4dc4PaXLLddxOKbEUZyQaajEXFScCADNyvWweAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, sizeof(struct smack_rule)==20. Allocation by kmalloc() uses a
32-byte-long chunk to allocate 20 bytes. Just ask ksize().  It means that 40%
of memory is simply wasted for padding bytes.

The problem is fixed in this patch by using kmem_cache. The cache allocates
struct smack_rule using 24-byte-long chunks according to ksize(). This reduces
amount of used memory by 25%.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smack.h     |    3 +++
 security/smack/smack_lsm.c |   11 ++++++++++-
 security/smack/smackfs.c   |    2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 8ad3095..38ba673 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -233,6 +233,9 @@ extern struct mutex	smack_known_lock;
 extern struct list_head smack_known_list;
 extern struct list_head smk_netlbladdr_list;
 
+/* Cache for fast and thrifty allocations */
+extern struct kmem_cache *smack_rule_cache;
+
 extern struct security_operations smack_ops;
 
 /*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d52c780..7aa696a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3564,6 +3564,9 @@ static __init void init_smack_known_list(void)
 	list_add(&smack_known_web.list, &smack_known_list);
 }
 
+/* KMEM caches for fast and thrifty allocations */
+struct kmem_cache *smack_rule_cache;
+
 /**
  * smack_init - initialize the smack system
  *
@@ -3577,10 +3580,16 @@ static __init int smack_init(void)
 	if (!security_module_enable(&smack_ops))
 		return 0;
 
+	smack_rule_cache = KMEM_CACHE(smack_rule, 0);
+	if (!smack_rule_cache)
+		return -ENOMEM;
+
 	tsp = new_task_smack(smack_known_floor.smk_known,
 				smack_known_floor.smk_known, GFP_KERNEL);
-	if (tsp == NULL)
+	if (tsp == NULL) {
+		kmem_cache_destroy(smack_rule_cache);
 		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "Smack:  Initializing.\n");
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e8c57f3..c08b1ec 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -217,7 +217,7 @@ static int smk_set_access(struct smack_parsed_rule *srp,
 	}
 
 	if (found == 0) {
-		sp = kzalloc(sizeof(*sp), GFP_KERNEL);
+		sp = kmem_cache_zalloc(smack_rule_cache, GFP_KERNEL);
 		if (sp == NULL) {
 			rc = -ENOMEM;
 			goto out;
-- 
1.7.9.5

