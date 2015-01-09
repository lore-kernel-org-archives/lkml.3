Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbbAIKea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:34:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44635 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757524AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 68/78] crypto: af_alg - fix backlog handling
Date: Fri,  9 Jan 2015 11:32:17 +0100
Message-Id: <4f62b27e2776ea102579e9d2fbcc9660b89caa53.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@axis.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7e77bdebff5cb1e9876c561f69710b9ab8fa1f7e upstream.

If a request is backlogged, it's complete() handler will get called
twice: once with -EINPROGRESS, and once with the final error code.

af_alg's complete handler, unlike other users, does not handle the
-EINPROGRESS but instead always completes the completion that recvmsg()
is waiting on.  This can lead to a return to user space while the
request is still pending in the driver.  If userspace closes the sockets
before the requests are handled by the driver, this will lead to
use-after-frees (and potential crashes) in the kernel due to the tfm
having been freed.

The crashes can be easily reproduced (for example) by reducing the max
queue length in cryptod.c and running the following (from
http://www.chronox.de/libkcapi.html) on AES-NI capable hardware:

 $ while true; do kcapi -x 1 -e -c '__ecb-aes-aesni' \
    -k 00000000000000000000000000000000 \
    -p 00000000000000000000000000000000 >/dev/null & done

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 crypto/af_alg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index bf948e134981..6ef6e2ad344e 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -449,6 +449,9 @@ void af_alg_complete(struct crypto_async_request *req, int err)
 {
 	struct af_alg_completion *completion = req->data;
 
+	if (err == -EINPROGRESS)
+		return;
+
 	completion->err = err;
 	complete(&completion->completion);
 }
-- 
2.2.1

