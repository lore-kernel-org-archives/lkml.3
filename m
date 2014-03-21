Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbaCUGjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:39:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53553 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaCUGjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:39:39 -0400
From: behanw@converseincode.com
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH v4] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
Date: Thu, 20 Mar 2014 23:39:32 -0700
Message-Id: <1395383972-20372-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395237113.4142.5.camel@jlt4.sipsolutions.net>
References: <1395237113.4142.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This is the original VLAIS struct.

struct {
	struct aead_request     req;
	u8                      priv[crypto_aead_reqsize(tfm)];
} aead_req;

This patch instead allocates the appropriate amount of memory using an char
array.

The new code can be compiled with both gcc and clang.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
---
 net/mac80211/aes_ccm.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index 7c7df47..71e2abd 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -23,12 +23,12 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 			       u8 *data, size_t data_len, u8 *mic)
 {
 	struct scatterlist assoc, pt, ct[2];
-	struct {
-		struct aead_request	req;
-		u8			priv[crypto_aead_reqsize(tfm)];
-	} aead_req;
 
-	memset(&aead_req, 0, sizeof(aead_req));
+	char aead_req_data[sizeof(struct aead_request) +
+				crypto_aead_reqsize(tfm)]
+				__aligned(__alignof__(struct aead_request));
+	struct aead_request *aead_req = (void *) aead_req_data;
+	memset(aead_req, 0, sizeof(aead_req_data));
 
 	sg_init_one(&pt, data, data_len);
 	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
@@ -36,23 +36,22 @@ void ieee80211_aes_ccm_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 	sg_set_buf(&ct[0], data, data_len);
 	sg_set_buf(&ct[1], mic, IEEE80211_CCMP_MIC_LEN);
 
-	aead_request_set_tfm(&aead_req.req, tfm);
-	aead_request_set_assoc(&aead_req.req, &assoc, assoc.length);
-	aead_request_set_crypt(&aead_req.req, &pt, ct, data_len, b_0);
+	aead_request_set_tfm(aead_req, tfm);
+	aead_request_set_assoc(aead_req, &assoc, assoc.length);
+	aead_request_set_crypt(aead_req, &pt, ct, data_len, b_0);
 
-	crypto_aead_encrypt(&aead_req.req);
+	crypto_aead_encrypt(aead_req);
 }
 
 int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 			      u8 *data, size_t data_len, u8 *mic)
 {
 	struct scatterlist assoc, pt, ct[2];
-	struct {
-		struct aead_request	req;
-		u8			priv[crypto_aead_reqsize(tfm)];
-	} aead_req;
-
-	memset(&aead_req, 0, sizeof(aead_req));
+	char aead_req_data[sizeof(struct aead_request) +
+				crypto_aead_reqsize(tfm)]
+				__aligned(__alignof__(struct aead_request));
+	struct aead_request *aead_req = (void *) aead_req_data;
+	memset(aead_req, 0, sizeof(aead_req_data));
 
 	sg_init_one(&pt, data, data_len);
 	sg_init_one(&assoc, &aad[2], be16_to_cpup((__be16 *)aad));
@@ -60,12 +59,12 @@ int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 	sg_set_buf(&ct[0], data, data_len);
 	sg_set_buf(&ct[1], mic, IEEE80211_CCMP_MIC_LEN);
 
-	aead_request_set_tfm(&aead_req.req, tfm);
-	aead_request_set_assoc(&aead_req.req, &assoc, assoc.length);
-	aead_request_set_crypt(&aead_req.req, ct, &pt,
+	aead_request_set_tfm(aead_req, tfm);
+	aead_request_set_assoc(aead_req, &assoc, assoc.length);
+	aead_request_set_crypt(aead_req, ct, &pt,
 			       data_len + IEEE80211_CCMP_MIC_LEN, b_0);
 
-	return crypto_aead_decrypt(&aead_req.req);
+	return crypto_aead_decrypt(aead_req);
 }
 
 struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[])
-- 
1.8.3.2

