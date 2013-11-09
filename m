Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3KIG6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:58:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605Ab3KIGwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 59/94] staging: wlags49_h2: buffer overflow setting station name
Date: Fri,  8 Nov 2013 22:52:05 -0800
Message-Id: <20131109065208.457485433@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlags49_h2/wl_priv.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -570,6 +570,7 @@ int wvlan_uil_put_info(struct uilreq *ur
 	ltv_t                   *pLtv;
 	bool_t                  ltvAllocated = FALSE;
 	ENCSTRCT                sEncryption;
+	size_t			len;
 
 #ifdef USE_WDS
 	hcf_16                  hcfPort  = HCF_PORT_0;
@@ -686,7 +687,8 @@ int wvlan_uil_put_info(struct uilreq *ur
 					break;
 				case CFG_CNF_OWN_NAME:
 					memset(lp->StationName, 0, sizeof(lp->StationName));
-					memcpy((void *)lp->StationName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					len = min_t(size_t, pLtv->u.u16[0], sizeof(lp->StationName));
+					strlcpy(lp->StationName, &pLtv->u.u8[2], len);
 					pLtv->u.u16[0] = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_LOAD_BALANCING:
@@ -1783,6 +1785,7 @@ int wvlan_set_station_nickname(struct ne
 {
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
+	size_t len;
 	int         ret = 0;
 	/*------------------------------------------------------------------------*/
 
@@ -1793,8 +1796,8 @@ int wvlan_set_station_nickname(struct ne
 	wl_lock(lp, &flags);
 
 	memset(lp->StationName, 0, sizeof(lp->StationName));
-
-	memcpy(lp->StationName, extra, wrqu->data.length);
+	len = min_t(size_t, wrqu->data.length, sizeof(lp->StationName));
+	strlcpy(lp->StationName, extra, len);
 
 	/* Commit the adapter parameters */
 	wl_apply(lp);


