Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3GXOGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:06:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45854 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308Ab3GXOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, 709647@bugs.debian.org,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Bjarni Ingi Gislason <bjarniig@rhi.hi.is> (against 3.2),
        "Bjarni Ingi Gislason" <bjarniig@rhi.hi.is>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.164449618@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [49/85] genirq: Fix can_request_irq() for IRQs without an action
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 kernel/irq/manage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -539,9 +539,9 @@ int can_request_irq(unsigned int irq, un
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

