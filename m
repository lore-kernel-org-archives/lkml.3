Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967005AbaFTTeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:34:44 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:42372 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966329AbaFTTcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:32:19 -0400
Message-Id: <20140620193127.502596012@linux.com>
Date: Fri, 20 Jun 2014 14:31:37 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 22/31] s390: cio driver &__get_cpu_var replacements
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_s390_cio
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ptr() instead of &__get_cpu_var()

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/s390/cio/ccwreq.c
===================================================================
--- linux.orig/drivers/s390/cio/ccwreq.c	2014-06-16 09:51:31.857301254 -0500
+++ linux/drivers/s390/cio/ccwreq.c	2014-06-16 09:51:31.853301332 -0500
@@ -252,7 +252,7 @@
  */
 void ccw_request_handler(struct ccw_device *cdev)
 {
-	struct irb *irb = &__get_cpu_var(cio_irb);
+	struct irb *irb = this_cpu_ptr(cio_irb);
 	struct ccw_request *req = &cdev->private->req;
 	enum io_status status;
 	int rc = -EOPNOTSUPP;
Index: linux/drivers/s390/cio/chsc_sch.c
===================================================================
--- linux.orig/drivers/s390/cio/chsc_sch.c	2014-06-16 09:51:31.857301254 -0500
+++ linux/drivers/s390/cio/chsc_sch.c	2014-06-16 09:51:31.857301254 -0500
@@ -58,7 +58,7 @@
 {
 	struct chsc_private *private = dev_get_drvdata(&sch->dev);
 	struct chsc_request *request = private->request;
-	struct irb *irb = &__get_cpu_var(cio_irb);
+	struct irb *irb = this_cpu_ptr(cio_irb);
 
 	CHSC_LOG(4, "irb");
 	CHSC_LOG_HEX(4, irb, sizeof(*irb));
Index: linux/drivers/s390/cio/cio.c
===================================================================
--- linux.orig/drivers/s390/cio/cio.c	2014-06-16 09:51:31.857301254 -0500
+++ linux/drivers/s390/cio/cio.c	2014-06-16 09:51:31.857301254 -0500
@@ -563,7 +563,7 @@
 
 	__this_cpu_write(s390_idle.nohz_delay, 1);
 	tpi_info = (struct tpi_info *) &get_irq_regs()->int_code;
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(cio_irb);
 	sch = (struct subchannel *)(unsigned long) tpi_info->intparm;
 	if (!sch) {
 		/* Clear pending interrupt condition. */
@@ -612,7 +612,7 @@
 	struct irb *irb;
 	int irq_context;
 
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(cio_irb);
 	/* Store interrupt response block to lowcore. */
 	if (tsch(sch->schid, irb) != 0)
 		/* Not status pending or not operational. */
@@ -749,7 +749,7 @@
 		struct tpi_info ti;
 
 		if (tpi(&ti)) {
-			tsch(ti.schid, &__get_cpu_var(cio_irb));
+			tsch(ti.schid, this_cpu_ptr(cio_irb));
 			if (schid_equal(&ti.schid, &schid))
 				return 0;
 		}
Index: linux/drivers/s390/cio/device_fsm.c
===================================================================
--- linux.orig/drivers/s390/cio/device_fsm.c	2014-06-16 09:51:31.857301254 -0500
+++ linux/drivers/s390/cio/device_fsm.c	2014-06-16 09:51:31.857301254 -0500
@@ -739,7 +739,7 @@
 	struct irb *irb;
 	int is_cmd;
 
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(cio_irb);
 	is_cmd = !scsw_is_tm(&irb->scsw);
 	/* Check for unsolicited interrupt. */
 	if (!scsw_is_solicited(&irb->scsw)) {
@@ -805,7 +805,7 @@
 {
 	struct irb *irb;
 
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(cio_irb);
 	/* Check for unsolicited interrupt. */
 	if (scsw_stctl(&irb->scsw) ==
 	    (SCSW_STCTL_STATUS_PEND | SCSW_STCTL_ALERT_STATUS)) {
Index: linux/drivers/s390/cio/eadm_sch.c
===================================================================
--- linux.orig/drivers/s390/cio/eadm_sch.c	2014-06-16 09:51:31.857301254 -0500
+++ linux/drivers/s390/cio/eadm_sch.c	2014-06-16 09:51:31.857301254 -0500
@@ -134,7 +134,7 @@
 {
 	struct eadm_private *private = get_eadm_private(sch);
 	struct eadm_scsw *scsw = &sch->schib.scsw.eadm;
-	struct irb *irb = &__get_cpu_var(cio_irb);
+	struct irb *irb = this_cpu_ptr(cio_irb);
 	int error = 0;
 
 	EADM_LOG(6, "irq");

