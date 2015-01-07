Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbbAGCvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:51:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbbAGBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.18 70/84] crypto: af_alg - fix backlog handling
Date: Tue,  6 Jan 2015 17:50:13 -0800
Message-Id: <20150107014031.246741827@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/af_alg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -449,6 +449,9 @@ void af_alg_complete(struct crypto_async
 {
 	struct af_alg_completion *completion = req->data;
 
+	if (err == -EINPROGRESS)
+		return;
+
 	completion->err = err;
 	complete(&completion->completion);
 }


