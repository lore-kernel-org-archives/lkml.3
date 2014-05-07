Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaEGTx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:28 -0400
Received: from mout.gmx.net ([212.227.17.22]:63830 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaEGTxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:21 -0400
Date: Wed, 7 May 2014 21:43:37 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, peter.senna@gmail.com,
        linux-kernel@vger.kernel.org, forest@alittletooquiet.net,
        dan.carpenter@oracle.com
Subject: [PATCH v2] staging: vt6656: fix potential leak in
 vt6656_hostap_ioctl()
Message-ID: <20140507214337.14a78a9c@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:m+6QJbNQ6PELtv2LDNxt4ygZDG9nAuDjAKe2eAS+iHSWfM41yk2
 BNI65EwRq5CvfByOLvBoz6jeKIgI4aBKVzWCRB5J1JElgKZmVzt6hh1/jWB/I9Xz3kLJ6S1
 jmL3kUMGaAOfpC18k7Vq0mOMmtt7ZySuJOuHFLDCIk7F29G7aQLm73TA7LJMw4cKYeKkDVc
 lhpskWg770WPw8iN8x/SQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fb841d67 (staging: vt6656: don't leak 'param' in vt6656_hostap_ioctl()
when returning -EOPNOTSUPP) cleaned up direct returns in the ioctl switch
statement that leaked already allocated memory. Fix the same issue for
VIAWGET_HOSTAPD_SCAN_REQ and VIAWGET_HOSTAPD_MLME that are not supported by
this driver. Detected by Coverity - CID 144381.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/vt6656/hostap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 67ba48b..a0d9fff 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -742,7 +742,8 @@ int vt6656_hostap_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 
 	case VIAWGET_HOSTAPD_MLME:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_MLME \n");
-	    return -EOPNOTSUPP;
+	    ret = -EOPNOTSUPP;
+	    goto out;
 
 	case VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT \n");
@@ -751,7 +752,8 @@ int vt6656_hostap_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 
 	case VIAWGET_HOSTAPD_SCAN_REQ:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SCAN_REQ \n");
-	    return -EOPNOTSUPP;
+	    ret = -EOPNOTSUPP;
+	    goto out;
 
 	case VIAWGET_HOSTAPD_STA_CLEAR_STATS:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS \n");
-- 
1.9.1

