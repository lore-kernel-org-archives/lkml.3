Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbbALSNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:13:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbbALSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 095/216] KEYS: Fix stale key registration at error path
Date: Mon, 12 Jan 2015 18:03:32 +0000
Message-Id: <1421085933-32536-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/keys/encrypted-keys/encrypted.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 5fe443d120af..556c43df6636 100644
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
2.1.4

