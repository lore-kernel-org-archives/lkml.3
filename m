Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3GKOZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3GKOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, 709647@bugs.debian.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 14/98] genirq: Fix can_request_irq() for IRQs without an action
Date: Thu, 11 Jul 2013 15:23:44 +0100
Message-Id: <1373552708-15235-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 2779db8d37d4b542d9ca2575f5f178dbeaca6c86 upstream.

Commit 02725e7471b8 ('genirq: Use irq_get/put functions'),
inadvertently changed can_request_irq() to return 0 for IRQs that have
no action.  This causes pcibios_lookup_irq() to select only IRQs that
already have an action with IRQF_SHARED set, or to fail if there are
none.  Change can_request_irq() to return 1 for IRQs that have no
action (if the first two conditions are met).

Reported-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
Tested-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is> (against 3.2)
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: 709647@bugs.debian.org
Link: http://bugs.debian.org/709647
Link: http://lkml.kernel.org/r/1372383630.23847.40.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/irq/manage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b4c6385..a561ed3 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -554,9 +554,9 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 		return 0;
 
 	if (irq_settings_can_request(desc)) {
-		if (desc->action)
-			if (irqflags & desc->action->flags & IRQF_SHARED)
-				canrequest =1;
+		if (!desc->action ||
+		    irqflags & desc->action->flags & IRQF_SHARED)
+			canrequest = 1;
 	}
 	irq_put_desc_unlock(desc, flags);
 	return canrequest;
-- 
1.8.1.2

