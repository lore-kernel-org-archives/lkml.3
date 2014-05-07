Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaEGT41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:56:27 -0400
Received: from mout.gmx.net ([212.227.17.21]:49436 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaEGTxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:20 -0400
Date: Wed, 7 May 2014 21:42:27 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com, mguzik@redhat.com,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: [PATCH v3] staging: rtl8188eu: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140507214227.621a814d@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Tr/PrH1ytErR/titjpeWQDAKEMLTC2sAU/C9QYQrpZrSYJXjEYg
 taeodfaUROvhEK6+sZtzSwYXg4azTBMVl6Flk07h5yQN/gfmD87Cqe0qHdel6aZ9orUvr9a
 HEGIKJQPZYKClQxiWtzkJeWxJ9b7gXfP/AY4Rl0v3xIAPWIyVdYddFvRi4zMsh3NPVoVyKX
 NEYJVt83uqB3gii5E2M3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a potential leak in the error path of function update_bcn_wps_ie().
Move the affected input verification to the beginning of the function so
that it may return directly without leaking already allocated memory.
Detected by Coverity - CID 1077718.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v3: Resend after v2 failed to apply

  * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
    Remove 'u8 *pbuf' from struct recv_buf)
  * fixed mua: no multipart, 7bit text/plain us-ascii

v2: Added change suggested by Mateusz Guzik for the rtl8723au variant:

    Move the check before allocating the memory instead of freeing the
    resource afterwards in the error path.

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8188eu/core/rtw_ap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index ff74d0d..85fda61 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -1306,6 +1306,10 @@ static void update_bcn_wps_ie(struct adapter *padapter)
 
 	DBG_88E("%s\n", __func__);
 
+	pwps_ie_src = pmlmepriv->wps_beacon_ie;
+	if (pwps_ie_src == NULL)
+		return;
+
 	pwps_ie = rtw_get_wps_ie(ie+_FIXED_IE_LENGTH_, ielen-_FIXED_IE_LENGTH_, NULL, &wps_ielen);
 
 	if (pwps_ie == NULL || wps_ielen == 0)
@@ -1323,10 +1327,6 @@ static void update_bcn_wps_ie(struct adapter *padapter)
 			memcpy(pbackup_remainder_ie, premainder_ie, remainder_ielen);
 	}
 
-	pwps_ie_src = pmlmepriv->wps_beacon_ie;
-	if (pwps_ie_src == NULL)
-		return;
-
 	wps_ielen = (uint)pwps_ie_src[1];/* to get ie data len */
 	if ((wps_offset+wps_ielen+2+remainder_ielen) <= MAX_IE_SZ) {
 		memcpy(pwps_ie, pwps_ie_src, wps_ielen+2);
-- 
1.9.1

