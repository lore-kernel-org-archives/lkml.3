Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbbALSfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:35:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbbALSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rabin Vincent <rabin.vincent@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 203/216] crypto: af_alg - fix backlog handling
Date: Mon, 12 Jan 2015 18:29:41 +0000
Message-Id: <1421087394-2712-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@axis.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/af_alg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6a3ad8011585..1de4beeb25f8 100644
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
2.1.4

