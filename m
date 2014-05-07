Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbaEGTzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:55:31 -0400
Received: from mout.gmx.net ([212.227.17.21]:50901 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaEGTxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:20 -0400
Date: Wed, 7 May 2014 21:40:41 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, linuxgeek@gmail.com,
        alexandre.f.demers@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8712: fix potential leaks in r8712_set_key()
Message-ID: <20140507214041.7809c595@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:GSTsmqUoLGon4NoOWpR1T9dWK2k4dmDkRjDF6w1zYwxwhFA9wLX
 u5Y5/NpOYUhV2ehns140Zo/kNjDjjRaR0dNonjqNBY27rAc9j39f0tT1DnUQRdrpNThsgmy
 DrQKpxcCxkTq605id5jrJvDnCQFfIIKzcdu8sVnYAK6VGAhRq5T7HncWQfJlL4gNapqEFml
 2NNkoMwGfHOeuQKXimDSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix potential leaks in the error paths of r8712_set_key(). In case the
algorithm specific checks fail, the function returns without enqueuing
or freeing the already allocated command and parameter structs. Use a
centralized exit path and make sure that all memory is freed correctly.
Detected by Coverity - CID 144370, 144371.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8712/rtl871x_mlme.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 3ea99ae..23fd8c1 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1243,14 +1243,15 @@ sint r8712_set_key(struct _adapter *adapter,
 	struct cmd_obj *pcmd;
 	struct setkey_parm *psetkeyparm;
 	u8 keylen;
+	sint ret = _SUCCESS;
 
 	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
 	if (pcmd == NULL)
 		return _FAIL;
 	psetkeyparm = (struct setkey_parm *)_malloc(sizeof(struct setkey_parm));
 	if (psetkeyparm == NULL) {
-		kfree((unsigned char *)pcmd);
-		return _FAIL;
+		ret = _FAIL;
+		goto err_free_cmd;
 	}
 	memset(psetkeyparm, 0, sizeof(struct setkey_parm));
 	if (psecuritypriv->AuthAlgrthm == 2) { /* 802.1X */
@@ -1274,23 +1275,28 @@ sint r8712_set_key(struct _adapter *adapter,
 			psecuritypriv->DefKey[keyid].skey, keylen);
 		break;
 	case _TKIP_:
-		if (keyid < 1 || keyid > 2)
-			return _FAIL;
+		if (keyid < 1 || keyid > 2) {
+			ret = _FAIL;
+			goto err_free_parm;
+		}
 		keylen = 16;
 		memcpy(psetkeyparm->key,
 			&psecuritypriv->XGrpKey[keyid - 1], keylen);
 		psetkeyparm->grpkey = 1;
 		break;
 	case _AES_:
-		if (keyid < 1 || keyid > 2)
-			return _FAIL;
+		if (keyid < 1 || keyid > 2) {
+			ret = _FAIL;
+			goto err_free_parm;
+		}
 		keylen = 16;
 		memcpy(psetkeyparm->key,
 			&psecuritypriv->XGrpKey[keyid - 1], keylen);
 		psetkeyparm->grpkey = 1;
 		break;
 	default:
-		return _FAIL;
+		ret = _FAIL;
+		goto err_free_parm;
 	}
 	pcmd->cmdcode = _SetKey_CMD_;
 	pcmd->parmbuf = (u8 *)psetkeyparm;
@@ -1299,7 +1305,13 @@ sint r8712_set_key(struct _adapter *adapter,
 	pcmd->rspsz = 0;
 	_init_listhead(&pcmd->list);
 	r8712_enqueue_cmd(pcmdpriv, pcmd);
-	return _SUCCESS;
+	return ret;
+
+err_free_parm:
+	kfree(psetkeyparm);
+err_free_cmd:
+	kfree(pcmd);
+	return ret;
 }
 
 /* adjust IEs for r8712_joinbss_cmd in WMM */
-- 
1.9.1

