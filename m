Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbbAGBwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:52:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbbAGBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 3.18 47/84] KEYS: Fix stale key registration at error path
Date: Tue,  6 Jan 2015 17:49:50 -0800
Message-Id: <20150107014030.540641224@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/encrypted-keys/encrypted.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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


