Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaDWN6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:58:00 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55980 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaDWN3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:52 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-78-5357c05075a8
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 11/20] ima: added kernel parameter for disabling IMA
Date: Wed, 23 Apr 2014 16:30:29 +0300
Message-id: <50e70cb35c9fe517031db23565828c3e98bfcaf9.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7oBB8KDDWa+FLK49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MqYcGoTW8Enrop57U+YGhg/cXQxcnJICJhITF++mRXCFpO4
	cG89G4gtJLCUUaJjK5DNBWR3Mknse3mJBSTBJqAnsaH5BzuILSLgIrF7Th8TSBGzQA+jxO4/
	i5lBEsJAieZ1R8FsFgFVic2N/5lAbF6BOImfvSfYILYpSCz7shashlPASuJP83R2iM2WEt8n
	TcYpPoGRfwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkGD8soNx8TGrQ4wCHIxKPLwS
	y8OChVgTy4orcw8xSnAwK4nwLlkUHizEm5JYWZValB9fVJqTWnyIkYmDU6qB0YTtdSNHxY7m
	+3tbeFx1CnRf5Oy5sWP32hW3dn77cVGPUzrUpHrn0Zm7jCR2ZvFKbFXa93jh4bwVySppQe9E
	rJd/U68V3/TgoN9x3vxjT5l23M65ZRa2es1a8ycTRWP3VOyOq096ZrVN8k8nl0Cv+zy3Tk7j
	s2EaNUHOe+a91uv+uUX/6ZwKWyWW4oxEQy3mouJEAGQNZpAkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ima_tcb and ima_appraise_tcb are not specified on the kernel command
line, IMA policy remains empty and IMA functionality is disabled.

When policy is loaded from the kernel, IMA becomes enabled without specifying
ima_tcb and ima_appraise_tcb. There should be a possibiliy to disable IMA.
Distributions might want to compile IMA support, but leave for the user
to decide if to enable or disable IMA functionality.

This patch provides kernel parameter 'ima=off' that allows to disable IMA.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c0aaed8..6af4966 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -67,6 +67,15 @@ out:
 }
 __setup("ima_hash=", hash_setup);
 
+static int ima_mode = 1;
+static int __init ima_setup(char *str)
+{
+	if (strncmp(str, "off", 3) == 0)
+		ima_mode = 0;
+	return 1;
+}
+__setup("ima=", ima_setup);
+
 /*
  * ima_rdwr_violation_check
  *
@@ -324,8 +333,9 @@ static int __init init_ima(void)
 	int error;
 
 	hash_setup(CONFIG_IMA_DEFAULT_HASH);
+
 	error = ima_init();
-	if (!error)
+	if (!error && ima_mode)
 		ima_initialized = 1;
 	return error;
 }
-- 
1.8.3.2

