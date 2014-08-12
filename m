Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaHLNoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:44:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaHLNoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:44:00 -0400
From: jgross@suse.com
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] Make bind_interdomain_evtchn_to_irq() public
Date: Tue, 12 Aug 2014 15:43:44 +0200
Message-Id: <1407851024-18936-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

bind_interdomain_evtchn_to_irq() is currently a private function. It is used
only by bind_interdomain_evtchn_to_irqhandler() to register an irq-handler for
an event channel.

By making it public it is possible to use e.g. threaded interrupts with
interdomain event channels.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/events/events_base.c | 5 +++--
 include/xen/events.h             | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c919d3d..0230aff 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -900,8 +900,8 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 	return irq;
 }
 
-static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
-					  unsigned int remote_port)
+int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
+				   unsigned int remote_port)
 {
 	struct evtchn_bind_interdomain bind_interdomain;
 	int err;
@@ -914,6 +914,7 @@ static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
 
 	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
 }
+EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq);
 
 static int find_virq(unsigned int virq, unsigned int cpu)
 {
diff --git a/include/xen/events.h b/include/xen/events.h
index 8bee7a7..5321cd9 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -28,6 +28,8 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 			   unsigned long irqflags,
 			   const char *devname,
 			   void *dev_id);
+int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
+				   unsigned int remote_port);
 int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
 					  unsigned int remote_port,
 					  irq_handler_t handler,
-- 
1.8.4.5

