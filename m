Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbaDWNhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:37:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8289 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaDWNaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:30:00 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-a0-5357c056a6ce
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 19/20] evm: try enable EVM from the kernel
Date: Wed, 23 Apr 2014 16:30:37 +0300
Message-id: <8798ab994b2e4c78c56f9e96c967a6007849620b.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7phB8KDDZqPG1nc+ruX2eJd028W
	i3XrFzNZXN41h83iQ88jNouXu76xW3xaMYnZgd3jwaHNLB4935M9Tq8s9ni/7yqbR9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGVsPvGdseCPQMWmvyuZGhj/8HYxcnJICJhI9Mz6wAhhi0lc
	uLeerYuRi0NIYCmjxOuHu5ggnE4miVfNx5hAqtgE9CQ2NP9gB7FFBFwkds/pAytiFuhhlNj9
	ZzEzSEJYwEqiZ80zsAYWAVWJLV1XweK8AnES87eeYYZYpyCx7MtaMJsTqP5P83SwoUIClhLf
	J03GKT6BkX8BI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBw/LKDcfExq0OMAhyMSjy8
	EsvDgoVYE8uKK3MPMUpwMCuJ8C5ZFB4sxJuSWFmVWpQfX1Sak1p8iJGJg1OqgZGzq1PFoF3E
	es2lpMA3k2M3rLpl/fKkxhq2r7xhh+7/2/aqq/GK3qcrfQJaOV8Mj6T0WpwojFinYieVWdSk
	ksz1ge3E7Oz40nrfZSdvbd+pwl0lwns05JfqUyHLzoR/fIe17zcnnmcOWBk9d7+58vvfL3Pb
	yn6dlg1PinyTG3j9xZM7XRaCzUosxRmJhlrMRcWJAAG9qX8lAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EVM key might be initialzed in the kernel by kernel module
using HW specific way. For example such method would suite
devices with ARM Trust Zone technology.

This patch tries enable EVM by checking if evm-key already
exists in the kernel keyring.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/evm_crypto.c |  5 +++++
 security/integrity/evm/evm_main.c   |  2 ++
 security/integrity/evm/evm_secfs.c  | 10 +++-------
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 5396769..f79ebf5 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -258,5 +258,10 @@ out:
 	memset(ekp->decrypted_data, 0, ekp->decrypted_datalen);
 	up_read(&evm_key->sem);
 	key_put(evm_key);
+	if (!rc) {
+		evm_initialized = 1;
+		pr_info("initialized\n");
+	} else
+		pr_err("initialization failed\n");
 	return rc;
 }
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index ad5e641..d2c06d3 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -463,6 +463,8 @@ static int __init init_evm(void)
 		goto err;
 	}
 
+	evm_init_key();
+
 	return 0;
 err:
 	return error;
diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index 4c81ef6..d7b5d11 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -62,7 +62,7 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	char temp[80];
-	int i, error;
+	int i;
 
 	if (!capable(CAP_SYS_ADMIN) || evm_initialized ||
 		    evm_mode == EVM_MODE_OFF)
@@ -79,12 +79,8 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
 	if ((sscanf(temp, "%d", &i) != 1) || (i != 1))
 		return -EINVAL;
 
-	error = evm_init_key();
-	if (!error) {
-		evm_initialized = 1;
-		pr_info("initialized\n");
-	} else
-		pr_err("initialization failed\n");
+	evm_init_key();
+
 	return count;
 }
 
-- 
1.8.3.2

