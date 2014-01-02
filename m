Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaABMJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:09:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaABMJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:09:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH, RFC 17/30] atm: nicstar: remove interruptible_sleep_on_timeout
Date: Thu,  2 Jan 2014 13:07:41 +0100
Message-Id: <1388664474-1710039-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:SSqHKrnsw9oVhEmwVmLPd6G1Shs20Hfl/tY0X4dpvpQ
 GDMC0hP9Xdxj+Q2a4EIflrMO0gzS/j1gl+2LXiPIwWUklJc3n8
 haP35hTt8EWZgwhOdt+yt+24leomAXjQB/dVsMSVuTDTeOkg0i
 1A6LSdsFjKqBXaYKqOkElrNgQ3un7zcusavT5r026u0Og4aBjm
 /Np332FXHWyR6lCXH95ZwYGMzPU3G/4TmCUpCTAigt+Vy2RCBS
 xLDGqoxyBT7d/BkGl9nUKO5dkIHBGLhxwW5NUZQgyMZOyxZ1B9
 zrAJoqw3sYEZm+xAut32JRggVa89Ikkr0ew6RuVywTrLpo1/Af
 G4iD42twq2DFnhRxpr7twBcRM9IJs2M1oemB8wXd+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to finally kill off interruptible_sleep_on_timeout.
the two uses in the nicstar driver can be trivially replaced
with wait_event_interruptible_lock_irq_timeout, which prevents the
wake-up race and is able to check the buffer state with scq->lock
held.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 drivers/atm/nicstar.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 5aca5f4..3c079eb 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -1739,10 +1739,9 @@ static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe * tbd,
 		}
 
 		scq->full = 1;
-		spin_unlock_irqrestore(&scq->lock, flags);
-		interruptible_sleep_on_timeout(&scq->scqfull_waitq,
-					       SCQFULL_TIMEOUT);
-		spin_lock_irqsave(&scq->lock, flags);
+		wait_event_interruptible_lock_irq_timeout(scq->scqfull_waitq,
+				scq->tail != scq->next, scq->lock,
+				SCQFULL_TIMEOUT);
 
 		if (scq->full) {
 			spin_unlock_irqrestore(&scq->lock, flags);
@@ -1789,10 +1788,10 @@ static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe * tbd,
 			scq->full = 1;
 			if (has_run++)
 				break;
-			spin_unlock_irqrestore(&scq->lock, flags);
-			interruptible_sleep_on_timeout(&scq->scqfull_waitq,
+			wait_event_interruptible_lock_irq_timeout(scq->scqfull_waitq,
+						       scq->tail != scq->next,
+						       scq->lock,
 						       SCQFULL_TIMEOUT);
-			spin_lock_irqsave(&scq->lock, flags);
 		}
 
 		if (!scq->full) {
-- 
1.8.3.2

