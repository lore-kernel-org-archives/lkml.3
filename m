Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaB0SwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:52:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:50621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaB0SwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:52:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: [PATCH v3] atm: nicstar: remove interruptible_sleep_on_timeout
Date: Thu, 27 Feb 2014 19:51:54 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de> <1393412516-3762435-11-git-send-email-arnd@arndb.de> <20140226.110603.1107468127601575254.davem@davemloft.net>
In-Reply-To: <20140226.110603.1107468127601575254.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402271951.54970.arnd@arndb.de>
X-Provags-ID: V02:K0:yaLzWTXik7dFQytCwfnHRKeBz6YHbC4VEzWAwaJF/3p
 8Tieyce2w5DqNndiaB9UPGsgvK7BLYkXZgq3O/QH+GqxLFbvlC
 JXM64odYRMv0+jjuCo3vDibtnij0rRMjCFrOpXEiXf2AAiYEoF
 S2VpCLoZG5vi+9j7bGgRzfrK+0dnhSXjIx4wNCjNpGgmnloMOA
 7jSnEztwtbpY81wcqxpwlrYgHYRliIzIua0yJHdRwHvDgzsl37
 nL4uk/kyqldW5UGJ5NESslWQHs7qGcFNc2uajxPqSKWYfOLXpi
 qD4J84PToOXr/zoP2ZfHrYTMCNSjUuIC+j+/l6v4JKw3px/bre
 RDYyPSA2CofzfsCKlxgQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to finally kill off interruptible_sleep_on_timeout.
the two uses in the nicstar driver can be trivially replaced
with wait_event_interruptible_lock_irq_timeout, which prevents the
wake-up race and is able to check the buffer state with scq->lock
held.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
---
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 9587e95..8cce153 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -1739,10 +1739,10 @@ static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe * tbd,
 		}
 
 		scq->full = 1;
-		spin_unlock_irqrestore(&scq->lock, flags);
-		interruptible_sleep_on_timeout(&scq->scqfull_waitq,
-					       SCQFULL_TIMEOUT);
-		spin_lock_irqsave(&scq->lock, flags);
+		wait_event_interruptible_lock_irq_timeout(scq->scqfull_waitq,
+							  scq->tail != scq->next,
+							  scq->lock,
+							  SCQFULL_TIMEOUT);
 
 		if (scq->full) {
 			spin_unlock_irqrestore(&scq->lock, flags);
@@ -1789,10 +1789,10 @@ static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe * tbd,
 			scq->full = 1;
 			if (has_run++)
 				break;
-			spin_unlock_irqrestore(&scq->lock, flags);
-			interruptible_sleep_on_timeout(&scq->scqfull_waitq,
-						       SCQFULL_TIMEOUT);
-			spin_lock_irqsave(&scq->lock, flags);
+			wait_event_interruptible_lock_irq_timeout(scq->scqfull_waitq,
+								  scq->tail != scq->next,
+								  scq->lock,
+								  SCQFULL_TIMEOUT);
 		}
 
 		if (!scq->full) {
