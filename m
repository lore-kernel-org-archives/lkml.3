Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaEGT5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:57:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:62754 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaEGTxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:11 -0400
Date: Wed, 7 May 2014 21:39:02 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: dan.carpenter@oracle.com, mcgrof@do-not-panic.com,
        gregkh@linuxfoundation.org, oat.elena@gmail.com,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org
Subject: [PATCH v3] staging: rtl8188eu: fix potential leak in rtw_set_key()
Message-ID: <20140507213902.50f6b292@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Kk7aCeYT/pAyt0WdyO0U2ThDjg7aST20Q7wnBQ/3vrqo+0+csK5
 QdR/N6sxv5m/QNRQfwE4MEnw6NcnMOwVK4WiNsQYgoJ8DYnfthNomRpHc+VoNLyMmGbzKKM
 TBJAJVsy0BXPx+il0t1AeV1iu5S6lcawfbVmbSCqH94njvt8iOsj1DnEAbokT2fO5ChgoVK
 OWCrAs/2Lqa4NSfQAt5oA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a potential leak in the error path of rtw_set_key(). In case the requested
algorithm is not supported by the driver, the function returns without
enqueuing or freeing the already allocated command and parameter structs. Use
a centralized exit path and make sure that all memory is freed correctly.
Detected by Coverity - CID 1077716, 1077717.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v3: Resend after v2 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

v2: Added changes requested by Dan Carpenter:

   * Just return directly where no cleanup is needed.
   * Prefer naming labels by the labeled action rather than the goto location.

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 769d4dd..155282e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1727,15 +1727,13 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 	int	res = _SUCCESS;
 
 	pcmd = (struct	cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
-	if (pcmd == NULL) {
-		res = _FAIL;  /* try again */
-		goto exit;
-	}
+	if (pcmd == NULL)
+		return _FAIL;  /* try again */
+
 	psetkeyparm = (struct setkey_parm *)rtw_zmalloc(sizeof(struct setkey_parm));
 	if (psetkeyparm == NULL) {
-		kfree(pcmd);
 		res = _FAIL;
-		goto exit;
+		goto err_free_cmd;
 	}
 
 	_rtw_memset(psetkeyparm, 0, sizeof(struct setkey_parm));
@@ -1784,7 +1782,7 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 			 ("\n rtw_set_key:psecuritypriv->dot11PrivacyAlgrthm=%x (must be 1 or 2 or 4 or 5)\n",
 			 psecuritypriv->dot11PrivacyAlgrthm));
 		res = _FAIL;
-		goto exit;
+		goto err_free_parm;
 	}
 	pcmd->cmdcode = _SetKey_CMD_;
 	pcmd->parmbuf = (u8 *)psetkeyparm;
@@ -1793,7 +1791,12 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 	pcmd->rspsz = 0;
 	_rtw_init_listhead(&pcmd->list);
 	res = rtw_enqueue_cmd(pcmdpriv, pcmd);
-exit:
+	return res;
+
+err_free_parm:
+	kfree(psetkeyparm);
+err_free_cmd:
+	kfree(pcmd);
 	return res;
 }
 
-- 
1.9.1

