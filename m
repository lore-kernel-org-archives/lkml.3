Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaCJJXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:23:32 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52379 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCJJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:23:30 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH] crypto: avoid module request when lookup crypto larval of template
Date: Mon, 10 Mar 2014 17:22:51 +0800
Message-Id: <1394443371-12181-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocate crypto algorithms, e.g. crypto_alloc_shash(), using
template model will run into the path that call module_request().
But there have no any module alias that match with the template name.

e.g.
Enable the module_request tracing event then run "modprobe tcrypt
mode=10" to test, it produces module_request event:
[...]
        modprobe-4965  [000] ....   123.504690: module_request: ecb(aes)
wait=1 call_site=crypto_larval_lookup
        modprobe-4965  [002] ....   123.506826: module_request:
ecb(aes)-all wait=1 call_site=crypto_larval_lookup
 cryptomgr_probe-4970  [003] ....   123.509007: module_request: ecb
wait=1 call_site=crypto_lookup_template

Here should not call module_request() for ecb(aes) because the template
name doesn't match with any driver's alias.

This patch add the name checking in crypto_larval_lookup() to
filter out the template before request kernel module.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 crypto/api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index a2b39c5..9aac892 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -215,7 +215,7 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 	type &= mask;
 
 	alg = crypto_alg_lookup(name, type, mask);
-	if (!alg) {
+	if (!alg && !strchr(name, '(')) {
 		request_module("%s", name);
 
 		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask &
-- 
1.6.4.2

