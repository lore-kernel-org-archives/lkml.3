Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3F1K7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:59:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3F1K7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:59:02 -0400
Date: Fri, 28 Jun 2013 03:58:33 -0700
From: tip-bot for Ben Hutchings <tipbot@zytor.com>
Message-ID: <tip-2779db8d37d4b542d9ca2575f5f178dbeaca6c86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bjarniig@rhi.hi.is, tglx@linutronix.de, ben@decadent.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bjarniig@rhi.hi.is, ben@decadent.org.uk
In-Reply-To: <1372383630.23847.40.camel@deadeye.wl.decadent.org.uk>
References: <1372383630.23847.40.camel@deadeye.wl.decadent.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Fix can_request_irq()
  for IRQs without an action
Git-Commit-ID: 2779db8d37d4b542d9ca2575f5f178dbeaca6c86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 03:58:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2779db8d37d4b542d9ca2575f5f178dbeaca6c86
Gitweb:     http://git.kernel.org/tip/2779db8d37d4b542d9ca2575f5f178dbeaca6c86
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Fri, 28 Jun 2013 02:40:30 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 12:56:03 +0200

genirq: Fix can_request_irq() for IRQs without an action

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
Cc: stable@vger.kernel.org # 2.6.39+
Link: http://bugs.debian.org/709647
Link: http://lkml.kernel.org/r/1372383630.23847.40.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e16caa8..514bcfd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -555,9 +555,9 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
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
