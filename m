Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab3FSPO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:14:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61423 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934876Ab3FSPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:13:56 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-44-51c1cab3c834
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/4] security: smack: add kmem_cache for smack_rule allocations
Date: Wed, 19 Jun 2013 17:13:34 +0200
Message-id: <1371654816-20772-4-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
References: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xoO7mUwcDDXbPlbK4t+0Xm8XZpjfs
	Fpd3zWGz+NDziM1i7ZG77BZvJ61gtpjX/pLVgd2jb8sqRo+j+xexeXzeJBfAHMVlk5Kak1mW
	WqRvl8CV0dj6nalghXDFk+U7WBsYv/N3MXJySAiYSGy9sJodwhaTuHBvPVsXIxeHkMB0RomN
	J3uYIJwuJok3D58wgVSxAXUcW/KZEcQWEdCUODYdooNZYBujRMeLqWBFwgL+Eg9+nWDuYuTg
	YBFQlXjdpAcS5hXwkJj75TALxDZ5iaf3+9hAbE4BT4nr59+BzRQCqll8dR3rBEbeBYwMqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCQ+iZ1A7GlQ0WhxgFOBiVeHgbVh4IFGJNLCuuzD3E
	KMHBrCTCu/TowUAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwc
	nFINjEpbeY33NocEbN+Swnhow9rthsEMLV+5xax3pGT8OZuy7pHIh4LfJ6JKT5myzShZaiX+
	L8FlVbx4+yn1DsG1X3/3bTD5+uvKvu1KL38EMkjPm7q1VPuK27PXh1bMTBHnjg94eOqdHYud
	06X4y1dunP397sQCL27vDanTrvnMOCmV5sslJP5H31+JpTgj0VCLuag4EQBn5XWzHQIAAA==
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
index 34d146b..4615242 100644
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

