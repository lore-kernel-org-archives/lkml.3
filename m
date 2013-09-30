Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3I3UWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:22:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:40555 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3I3UWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:22:13 -0400
Date: Mon, 30 Sep 2013 22:22:11 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Forest Bond <forest@alittletooquiet.net>, Joe Perches <joe@perches.com>,
        Hema Prathaban <hemaklnce@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: don't leak when returning -EOPNOTSUPP in
 vt6655_hostap_ioctl
Message-ID: <alpine.LNX.2.00.1309302220160.4992@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we always free(param); and remove a redundant "goto out;"
just before we'll hit the label anyway.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6655/hostap.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 8acff44..fdd63b6 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -720,7 +720,6 @@ static int hostap_get_encryption(PSDevice pDevice,
  * Return Value:
  *
  */
-
 int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 {
 	struct viawget_hostapd_param *param;
@@ -755,8 +754,8 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		break;
 	case VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR \n");
-		return -EOPNOTSUPP;
-		break;
+		ret = -EOPNOTSUPP;
+		goto out;
 	case VIAWGET_HOSTAPD_FLUSH:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_FLUSH \n");
 		spin_lock_irq(&pDevice->lock);
@@ -790,40 +789,36 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA \n");
 		ret = hostap_set_flags_sta(pDevice, param);
 		break;
-
 	case VIAWGET_HOSTAPD_MLME:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_MLME \n");
-		return -EOPNOTSUPP;
-
+		ret = -EOPNOTSUPP;
+		goto out;
 	case VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT \n");
 		ret = hostap_set_generic_element(pDevice, param);
 		break;
-
 	case VIAWGET_HOSTAPD_SCAN_REQ:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SCAN_REQ \n");
-		return -EOPNOTSUPP;
-
+		ret = -EOPNOTSUPP;
+		goto out;
 	case VIAWGET_HOSTAPD_STA_CLEAR_STATS:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS \n");
-		return -EOPNOTSUPP;
-
+		ret = -EOPNOTSUPP;
+		goto out;
 	default:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vt6655_hostap_ioctl: unknown cmd=%d\n",
 			(int)param->cmd);
-		return -EOPNOTSUPP;
-		break;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if ((ret == 0) && ap_ioctl) {
 		if (copy_to_user(p->pointer, param, p->length)) {
 			ret = -EFAULT;
-			goto out;
 		}
 	}
 
 out:
 	kfree(param);
-
 	return ret;
 }
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

