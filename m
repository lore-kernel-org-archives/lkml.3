Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3LTDlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:41:13 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33519 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3LTDlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:41:12 -0500
MIME-Version: 1.0
Date: Fri, 20 Dec 2013 11:41:11 +0800
Message-ID: <CAPgLHd-H27vdFP857hs5CqnQdgT6XSW+CrtoXodMRHPX8f+N3A@mail.gmail.com>
Subject: [PATCH] staging: lustre: fix return value check in capa_hmac()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, tao.peng@emc.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function crypto_alloc_hash() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/lustre/lustre/obdclass/capa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index 68d797b..039232d 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -273,10 +273,10 @@ int capa_hmac(__u8 *hmac, struct lustre_capa *capa, __u8 *key)
 	alg = &capa_hmac_algs[capa_alg(capa)];
 
 	tfm = crypto_alloc_hash(alg->ha_name, 0, 0);
-	if (!tfm) {
+	if (IS_ERR(tfm)) {
 		CERROR("crypto_alloc_tfm failed, check whether your kernel"
 		       "has crypto support!\n");
-		return -ENOMEM;
+		return PTR_ERR(tfm);
 	}
 	keylen = alg->ha_keylen;
 

