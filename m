Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaFXOmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:42:21 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49006 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaFXOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:07 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH v6 1/6] KEYS: special dot prefixed keyring name bug fix
Date: Tue, 24 Jun 2014 10:40:47 -0400
Message-Id: <1403620852-16476-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-0928-0000-0000-000002EC22D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dot prefixed keyring names are supposed to be reserved for the
kernel, but add_key() calls key_get_type_from_user(), which
incorrectly verifies the 'type' field, not the 'description' field.
This patch verifies the 'description' field isn't dot prefixed,
when creating a new keyring, and removes the dot prefix test in
key_get_type_from_user().

Changelog v6:
- whitespace and other cleanup

Changelog v5:
- Only prevent userspace from creating a dot prefixed keyring, not
  regular keys  - Dmitry

Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/keys/keyctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index cd5bd0c..8a8c233 100644
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
@@ -86,6 +84,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 		if (!*description) {
 			kfree(description);
 			description = NULL;
+		} else if ((description[0] == '.') &&
+			   (strncmp(type, "keyring", 7) == 0)) {
+			ret = -EPERM;
+			goto error2;
 		}
 	}
 
-- 
1.8.1.4

