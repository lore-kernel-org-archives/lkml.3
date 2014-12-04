Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbaLDRZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:25:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaLDRZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:25:24 -0500
From: Takashi Iwai <tiwai@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KEYS: Fix stale key registration at error path
Date: Thu,  4 Dec 2014 18:25:19 +0100
Message-Id: <1417713919-5342-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loading encrypted-keys module, if the last check of
aes_get_sizes() in init_encrypted() fails, the driver just returns an
error without unregistering its key type.  This results in the stale
entry in the list.  In addition to memory leaks, this leads to a kernel
crash when registering a new key type later.

This patch fixes the problem by swapping the calls of aes_get_sizes()
and register_key_type(), and releasing resources properly at the error
paths.

Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=908163
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 security/keys/encrypted-keys/encrypted.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index db9675db1026..7bed4ad7cd76 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -1017,10 +1017,13 @@ static int __init init_encrypted(void)
 	ret = encrypted_shash_alloc();
 	if (ret < 0)
 		return ret;
+	ret = aes_get_sizes();
+	if (ret < 0)
+		goto out;
 	ret = register_key_type(&key_type_encrypted);
 	if (ret < 0)
 		goto out;
-	return aes_get_sizes();
+	return 0;
 out:
 	encrypted_shash_release();
 	return ret;
-- 
2.1.3

