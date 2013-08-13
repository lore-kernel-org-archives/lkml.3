Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3HMQet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:34:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab3HMQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:49 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=cjJL6sPJKBMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JCCeRsOg_wYA:10 a=8T59DR07AAAA:8 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=yz15SL50AAAA:8 a=yOO1sCyRjF-NnpRy-KIA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=lRpidcsg3_6cL91h:21 a=jgXysl7eqkaRl7lu:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155835.439750743@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>,
        Ben Hutchings <ben@decadent.org.uk>, <709647@bugs.debian.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [75/88] genirq: Fix can_request_irq() for IRQs without an action
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0075-genirq-Fix-can_request_irq-for-IRQs-without-an-actio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 2779db8d37d4b542d9ca2575f5f178dbeaca6c86 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/irq/manage.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..50a0a66 100644
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
1.7.10.4


