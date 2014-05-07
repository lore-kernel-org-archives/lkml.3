Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaEGTz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:55:28 -0400
Received: from mout.gmx.net ([212.227.15.15]:50470 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaEGTxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:20 -0400
Date: Wed, 7 May 2014 21:36:48 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        andriy.shevchenko@linux.intel.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2] staging: rtl8712: fix potential leak in
 r871x_wx_set_enc_ext()
Message-ID: <20140507213648.7928e994@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Ii5AF00fNkSIGswxQ5g9xwfkNKXV85nkF7aEkXLsAuvp6My5DR+
 wItmM25jUKUWnzYT39vj4CBgwvHHS4+qXUnqlID+Kbh2uzSDev6hka+u7wpoIeUPa4KJ1AE
 xF77qLQSbMUSYO0yr26Fk525/bS/ehsJdyW2OAhPPLWfIIcwvqMmEpAJNBIO2CiPReTbsCI
 g96rO6KPbLcKGkOIK++zg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a potential leak in the error path of r871x_wx_set_enc_ext(). In case the
requested algorithm is not supported by the driver, the function returns
without freeing the already allocated 'param' struct. Move the input
verification to the beginning of the function so that the direct return is
safe. Detected by Coverity - CID 144373.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 23d539d..1eca992 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1801,13 +1801,6 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 	u32 param_len;
 	int ret = 0;
 
-	param_len = sizeof(struct ieee_param) + pext->key_len;
-	param = (struct ieee_param *)_malloc(param_len);
-	if (param == NULL)
-		return -ENOMEM;
-	memset(param, 0, param_len);
-	param->cmd = IEEE_CMD_SET_ENCRYPTION;
-	memset(param->sta_addr, 0xff, ETH_ALEN);
 	switch (pext->alg) {
 	case IW_ENCODE_ALG_NONE:
 		alg_name = "none";
@@ -1824,6 +1817,15 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 	default:
 		return -EINVAL;
 	}
+
+	param_len = sizeof(struct ieee_param) + pext->key_len;
+	param = (struct ieee_param *)_malloc(param_len);
+	if (param == NULL)
+		return -ENOMEM;
+	memset(param, 0, param_len);
+	param->cmd = IEEE_CMD_SET_ENCRYPTION;
+	memset(param->sta_addr, 0xff, ETH_ALEN);
+
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
 	if (pext->ext_flags & IW_ENCODE_EXT_GROUP_KEY)
 		param->u.crypt.set_tx = 0;
-- 
1.9.1

