Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaE1PKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:10:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47906 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaE1PJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:09:58 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 1/4] KEYS: special dot prefixed keyring name bug fix
Date: Wed, 28 May 2014 11:09:41 -0400
Message-Id: <1401289784-31340-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052815-6688-0000-0000-00000226B9DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dot prefixed keyring names are supposed to be reserved for the
kernel, but add_key() calls key_get_type_from_user(), which
incorrectly verifies the 'type' field, not the 'description' field.
This patch verifies the 'description' field isn't dot prefixed,
when creating a new keyring, and removes the dot prefix test in
key_get_type_from_user().

Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/keys/keyctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index cd5bd0c..9e9a762 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -37,8 +37,6 @@ static int key_get_type_from_user(char *type,
 		return ret;
 	if (ret == 0 || ret >= len)
 		return -EINVAL;
-	if (type[0] == '.')
-		return -EPERM;
 	type[len - 1] = '\0';
 	return 0;
 }
@@ -87,6 +85,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 			kfree(description);
 			description = NULL;
 		}
+		if (description[0] == '.') {
+			ret = -EPERM;
+			goto error2;
+		}
 	}
 
 	/* pull the payload in if one was supplied */
-- 
1.8.1.4

