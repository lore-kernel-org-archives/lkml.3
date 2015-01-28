Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548AbbA2CiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965450AbbA2CiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 090/139] KEYS: Fix stale key registration at error path
Date: Wed, 28 Jan 2015 14:20:33 -0800
Message-Id: <1422483682-15393-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b26bdde5bb27f3f900e25a95e33a0c476c8c2c48 upstream.

When loading encrypted-keys module, if the last check of
aes_get_sizes() in init_encrypted() fails, the driver just returns an
error without unregistering its key type.  This results in the stale
entry in the list.  In addition to memory leaks, this leads to a kernel
crash when registering a new key type later.

This patch fixes the problem by swapping the calls of aes_get_sizes()
and register_key_type(), and releasing resources properly at the error
paths.

Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=908163
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/keys/encrypted-keys/encrypted.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 9e1e005..c4c8df4 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -1018,10 +1018,13 @@ static int __init init_encrypted(void)
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
1.9.1

