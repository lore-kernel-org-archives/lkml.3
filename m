Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3KHCR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3KHCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 86/91] staging: wlags49_h2: buffer overflow setting station name
Date: Thu,  7 Nov 2013 18:15:41 -0800
Message-Id: <1383876946-2396-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b5e2f339865fb443107e5b10603e53bbc92dc054 upstream.

We need to check the length parameter before doing the memcpy().  I've
actually changed it to strlcpy() as well so that it's NUL terminated.

You need CAP_NET_ADMIN to trigger these so it's not the end of the
world.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/wlags49_h2/wl_priv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 87e1e41..0978d9b 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -570,6 +570,7 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 	ltv_t                   *pLtv;
 	bool_t                  ltvAllocated = FALSE;
 	ENCSTRCT                sEncryption;
+	size_t			len;
 
 #ifdef USE_WDS
 	hcf_16                  hcfPort  = HCF_PORT_0;
@@ -686,7 +687,8 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					break;
 				case CFG_CNF_OWN_NAME:
 					memset( lp->StationName, 0, sizeof( lp->StationName ));
-					memcpy( (void *)lp->StationName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					len = min_t(size_t, pLtv->u.u16[0], sizeof(lp->StationName));
+					strlcpy(lp->StationName, &pLtv->u.u8[2], len);
 					pLtv->u.u16[0] = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
 					break;
 				case CFG_CNF_LOAD_BALANCING:
@@ -1800,6 +1802,7 @@ int wvlan_set_station_nickname(struct net_device *dev,
 {
         struct wl_private *lp = wl_priv(dev);
         unsigned long flags;
+	size_t len;
         int         ret = 0;
 	/*------------------------------------------------------------------------*/
 
@@ -1810,8 +1813,8 @@ int wvlan_set_station_nickname(struct net_device *dev,
         wl_lock(lp, &flags);
 
         memset( lp->StationName, 0, sizeof( lp->StationName ));
-
-        memcpy( lp->StationName, extra, wrqu->data.length);
+	len = min_t(size_t, wrqu->data.length, sizeof(lp->StationName));
+	strlcpy(lp->StationName, extra, len);
 
         /* Commit the adapter parameters */
         wl_apply( lp );
-- 
1.8.1.2

