Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaCZVgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:36:15 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7931 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756270AbaCZVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:35:12 -0400
X-IronPort-AV: E=Sophos;i="4.97,737,1389740400"; 
   d="scan'208";a="64902688"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jean-Paul Roubelat <jpr@f6fbb.org>
Cc: kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] yam: replace del_timer by del_timer_sync
Date: Wed, 26 Mar 2014 22:33:45 +0100
Message-Id: <1395869625-15209-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use del_timer_sync to ensure that the timer is stopped on all CPUs before
the driver exists.

This change was suggested by Thomas Gleixner

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
declarer name module_exit;
identifier ex;
@@

module_exit(ex);

@@
identifier r.ex;
@@

ex(...) {
  <...
- del_timer
+ del_timer_sync
    (...)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/net/hamradio/yam.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 61dd244..8190165 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1184,7 +1184,7 @@ static void __exit yam_cleanup_driver(void)
 	struct yam_mcs *p;
 	int i;
 
-	del_timer(&yam_timer);
+	del_timer_sync(&yam_timer);
 	for (i = 0; i < NR_PORTS; i++) {
 		struct net_device *dev = yam_devs[i];
 		if (dev) {

