Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaDWNnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:43:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8284 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaDWN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:55 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-85-5357c052cec0
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 13/20] ima: replace opencount with bitop
Date: Wed, 23 Apr 2014 16:30:31 +0300
Message-id: <222a8077d845e4097954febc5600147fc68c6582.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7pBB8KDDbraOS1u/d3LbPGu6TeL
	xbr1i5ksLu+aw2bxoecRm8XLXd/YLT6tmMTswO7x4NBmFo+e78kep1cWe7zfd5XNo2/LKkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDKe/HvMXrCDv+Lh6nbmBsabPF2MnBwSAiYSb65cY4WwxSQu
	3FvP1sXIxSEksJRRYs7HF8wQTieTxPUJn5hAqtgE9CQ2NP9gB7FFBFwkds/pYwIpYhboYZTY
	/WcxUAcHh7CAhcSqZj+QGhYBVYnN24+CbeAViJPoXvOJDWKbgsSyL2uZQWxOASuJP83TwWYK
	CVhKfJ80Gaf4BEb+BYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCgvHLDsbFx6wOMQpw
	MCrx8EosDwsWYk0sK67MPcQowcGsJMK7ZFF4sBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGTLO1
	/wxThbdp7LbZfolLoWephwvrjK4u0xyhZe81lEPv/na/evDPc5uwt/kXTjz8sPyYdeg+2Y+z
	DzX5Za9w/5M343Hu2+XXpBjeVLI8sw/jy3vvMnEfwx/R61ueirzOiOhjvr0twfwz94xvLvFt
	kqx/7h3/k6dltNxPb8a2KxuZwiq1/IOeKLEUZyQaajEXFScCAMGTb4ckAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation uses opencount to allow only single writer
to update policy at a time. After policy update 'ima/policy' sysfs
entry is removed which disallow future updates.

Following patches might introduce posibility to update policy multiple
times. Current open count implementation will not be valid.

This patch replaces usage of opencount with busy bit.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_fs.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index da92fcc..71f0d8f 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -288,7 +288,12 @@ static struct dentry *runtime_measurements_count;
 static struct dentry *violations;
 static struct dentry *ima_policy;
 
-static atomic_t policy_opencount = ATOMIC_INIT(1);
+enum ima_fs_flags {
+	IMA_FS_BUSY = 0,
+};
+
+static unsigned long ima_fs_flags;
+
 /*
  * ima_open_policy: sequentialize access to the policy file
  */
@@ -297,9 +302,9 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
 	/* No point in being allowed to open it if you aren't going to write */
 	if (!(filp->f_flags & O_WRONLY))
 		return -EACCES;
-	if (atomic_dec_and_test(&policy_opencount))
-		return 0;
-	return -EBUSY;
+	if (test_and_set_bit(IMA_FS_BUSY, &ima_fs_flags))
+		return -EBUSY;
+	return 0;
 }
 
 /*
@@ -314,12 +319,12 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 	if (!valid_policy) {
 		ima_delete_rules();
 		valid_policy = 1;
-		atomic_set(&policy_opencount, 1);
-		return 0;
+	} else {
+		ima_update_policy();
+		securityfs_remove(ima_policy);
+		ima_policy = NULL;
 	}
-	ima_update_policy();
-	securityfs_remove(ima_policy);
-	ima_policy = NULL;
+	clear_bit(IMA_FS_BUSY, &ima_fs_flags);
 	return 0;
 }
 
-- 
1.8.3.2

