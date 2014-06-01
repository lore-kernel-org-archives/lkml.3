Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbaFALb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:31:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55864 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbaFALb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:31:28 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Cort <linuxgeek@gmail.com>,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: rtl871x_mlme.c:  Cleaning up memory leak
Date: Sun,  1 Jun 2014 13:32:20 +0200
Message-Id: <1401622340-13453-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk for memory leak in when something unexpected happens
and the function returns.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8712/rtl871x_mlme.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 3ea99ae..00bbf40 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1249,8 +1249,7 @@ sint r8712_set_key(struct _adapter *adapter,
 		return _FAIL;
 	psetkeyparm = (struct setkey_parm *)_malloc(sizeof(struct setkey_parm));
 	if (psetkeyparm == NULL) {
-		kfree((unsigned char *)pcmd);
-		return _FAIL;
+		goto err_free_pcmd;
 	}
 	memset(psetkeyparm, 0, sizeof(struct setkey_parm));
 	if (psecuritypriv->AuthAlgrthm == 2) { /* 802.1X */
@@ -1275,7 +1274,7 @@ sint r8712_set_key(struct _adapter *adapter,
 		break;
 	case _TKIP_:
 		if (keyid < 1 || keyid > 2)
-			return _FAIL;
+			goto err_free_all;
 		keylen = 16;
 		memcpy(psetkeyparm->key,
 			&psecuritypriv->XGrpKey[keyid - 1], keylen);
@@ -1283,14 +1282,14 @@ sint r8712_set_key(struct _adapter *adapter,
 		break;
 	case _AES_:
 		if (keyid < 1 || keyid > 2)
-			return _FAIL;
+			goto err_free_all;
 		keylen = 16;
 		memcpy(psetkeyparm->key,
 			&psecuritypriv->XGrpKey[keyid - 1], keylen);
 		psetkeyparm->grpkey = 1;
 		break;
 	default:
-		return _FAIL;
+		goto err_free_all;
 	}
 	pcmd->cmdcode = _SetKey_CMD_;
 	pcmd->parmbuf = (u8 *)psetkeyparm;
@@ -1300,6 +1299,13 @@ sint r8712_set_key(struct _adapter *adapter,
 	_init_listhead(&pcmd->list);
 	r8712_enqueue_cmd(pcmdpriv, pcmd);
 	return _SUCCESS;
+
+err_free_all;
+	kfree(psetkeyparm);
+err_free_pcmd:
+	kfree(pcmd);
+
+	return _FAIL;
 }
 
 /* adjust IEs for r8712_joinbss_cmd in WMM */
-- 
1.7.10.4

