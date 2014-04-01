Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaDANuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:50:15 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7117 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbaDANuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:50:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,772,1389740400"; 
   d="scan'208";a="65838561"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alex Dubov <oakad@yahoo.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] memstick: replace del_timer by del_timer_sync
Date: Tue,  1 Apr 2014 15:49:17 +0200
Message-Id: <1396360159-16244-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396360159-16244-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1396360159-16244-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use del_timer_sync to ensure that the timer is stopped on all CPUs before
the driver exits.

This change was suggested by Thomas Gleixner.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier i,t,ex;
@@
struct t i = { .remove = ex, };

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

 drivers/memstick/host/tifm_ms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 7bafa72..bc643d7 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -605,7 +605,7 @@ static void tifm_ms_remove(struct tifm_dev *sock)
 	spin_lock_irqsave(&sock->lock, flags);
 	host->eject = 1;
 	if (host->req) {
-		del_timer(&host->timer);
+		del_timer_sync(&host->timer);
 		writel(TIFM_FIFO_INT_SETALL,
 		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
 		writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);

