Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbbAIKkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:23 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44593 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757492AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 50/78] KEYS: Fix stale key registration at error path
Date: Fri,  9 Jan 2015 11:31:59 +0100
Message-Id: <d9135d9e6aa11beb51b98342efb1a87987269622.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 security/keys/encrypted-keys/encrypted.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 9e1e005c7596..c4c8df4b214d 100644
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
2.2.1

