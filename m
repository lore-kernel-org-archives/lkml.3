Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab3KYOCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:02:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58976 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357Ab3KYNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:48 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Fabian Yamaguchi" <fabs@goesec.de>, "Nico Golde" <nico@ngolde.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.589329362@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 85/87] staging: wlags49_h2: buffer overflow setting
 station name
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/wlags49_h2/wl_priv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -570,6 +570,7 @@ int wvlan_uil_put_info( struct uilreq *u
 	ltv_t                   *pLtv;
 	bool_t                  ltvAllocated = FALSE;
 	ENCSTRCT                sEncryption;
+	size_t			len;
 
 #ifdef USE_WDS
 	hcf_16                  hcfPort  = HCF_PORT_0;
@@ -686,7 +687,8 @@ int wvlan_uil_put_info( struct uilreq *u
 					break;
 				case CFG_CNF_OWN_NAME:
 					memset( lp->StationName, 0, sizeof( lp->StationName ));
-					memcpy( (void *)lp->StationName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					len = min_t(size_t, pLtv->u.u16[0], sizeof(lp->StationName));
+					strlcpy(lp->StationName, &pLtv->u.u8[2], len);
 					pLtv->u.u16[0] = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
 					break;
 				case CFG_CNF_LOAD_BALANCING:
@@ -1800,6 +1802,7 @@ int wvlan_set_station_nickname(struct ne
 {
         struct wl_private *lp = wl_priv(dev);
         unsigned long flags;
+	size_t len;
         int         ret = 0;
 	/*------------------------------------------------------------------------*/
 
@@ -1810,8 +1813,8 @@ int wvlan_set_station_nickname(struct ne
         wl_lock(lp, &flags);
 
         memset( lp->StationName, 0, sizeof( lp->StationName ));
-
-        memcpy( lp->StationName, extra, wrqu->data.length);
+	len = min_t(size_t, wrqu->data.length, sizeof(lp->StationName));
+	strlcpy(lp->StationName, extra, len);
 
         /* Commit the adapter parameters */
         wl_apply( lp );

