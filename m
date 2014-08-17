Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaHQRey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:34:54 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:54808 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbaHQRbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:32 -0400
Message-Id: <20140817173036.491289559@linux.com>
Date: Sun, 17 Aug 2014 12:30:46 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 23/35] [PATCH 23/36] s390: cio driver &__get_cpu_var replacements
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0023-s390-cio-driver-__get_cpu_var-replacements.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ptr() instead of &__get_cpu_var()

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 drivers/s390/cio/ccwreq.c     | 2 +-
 drivers/s390/cio/chsc_sch.c   | 2 +-
 drivers/s390/cio/cio.c        | 6 +++---
 drivers/s390/cio/device_fsm.c | 4 ++--
 drivers/s390/cio/eadm_sch.c   | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

Index: linux/drivers/s390/cio/ccwreq.c
===================================================================
--- linux.orig/drivers/s390/cio/ccwreq.c
+++ linux/drivers/s390/cio/ccwreq.c
@@ -252,7 +252,7 @@ static void ccwreq_log_status(struct ccw
  */
 void ccw_request_handler(struct ccw_device *cdev)
 {
-	struct irb *irb = &__get_cpu_var(cio_irb);
+	struct irb *irb = this_cpu_ptr(&cio_irb);
 	struct ccw_request *req = &cdev->private->req;
 	enum io_status status;
 	int rc = -EOPNOTSUPP;
Index: linux/drivers/s390/cio/chsc_sch.c
===================================================================
--- linux.orig/drivers/s390/cio/chsc_sch.c
+++ linux/drivers/s390/cio/chsc_sch.c
@@ -58,7 +58,7 @@ static void chsc_subchannel_irq(struct s
 {
 	struct chsc_private *private = dev_get_drvdata(&sch->dev);
 	struct chsc_request *request = private->request;
-	struct irb *irb = &__get_cpu_var(cio_irb);
+	struct irb *irb = this_cpu_ptr(&cio_irb);
 
 	CHSC_LOG(4, "irb");
 	CHSC_LOG_HEX(4, irb, sizeof(*irb));
Index: linux/drivers/s390/cio/cio.c
===================================================================
--- linux.orig/drivers/s390/cio/cio.c
+++ linux/drivers/s390/cio/cio.c
@@ -563,7 +563,7 @@ static irqreturn_t do_cio_interrupt(int
 
 	__this_cpu_write(s390_idle.nohz_delay, 1);
 	tpi_info = (struct tpi_info *) &get_irq_regs()->int_code;
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(&cio_irb);
 	sch = (struct subchannel *)(unsigned long) tpi_info->intparm;
 	if (!sch) {
 		/* Clear pending interrupt condition. */
@@ -613,7 +613,7 @@ void cio_tsch(struct subchannel *sch)
 	struct irb *irb;
 	int irq_context;
 
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(&cio_irb);
 	/* Store interrupt response block to lowcore. */
 	if (tsch(sch->schid, irb) != 0)
 		/* Not status pending or not operational. */
@@ -751,7 +751,7 @@ __clear_io_subchannel_easy(struct subcha
 		struct tpi_info ti;
 
 		if (tpi(&ti)) {
-			tsch(ti.schid, &__get_cpu_var(cio_irb));
+			tsch(ti.schid, this_cpu_ptr(&cio_irb));
 			if (schid_equal(&ti.schid, &schid))
 				return 0;
 		}
Index: linux/drivers/s390/cio/device_fsm.c
===================================================================
--- linux.orig/drivers/s390/cio/device_fsm.c
+++ linux/drivers/s390/cio/device_fsm.c
@@ -739,7 +739,7 @@ ccw_device_irq(struct ccw_device *cdev,
 	struct irb *irb;
 	int is_cmd;
 
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(&cio_irb);
 	is_cmd = !scsw_is_tm(&irb->scsw);
 	/* Check for unsolicited interrupt. */
 	if (!scsw_is_solicited(&irb->scsw)) {
@@ -805,7 +805,7 @@ ccw_device_w4sense(struct ccw_device *cd
 {
 	struct irb *irb;
 
-	irb = &__get_cpu_var(cio_irb);
+	irb = this_cpu_ptr(&cio_irb);
 	/* Check for unsolicited interrupt. */
 	if (scsw_stctl(&irb->scsw) ==
 	    (SCSW_STCTL_STATUS_PEND | SCSW_STCTL_ALERT_STATUS)) {
Index: linux/drivers/s390/cio/eadm_sch.c
===================================================================
--- linux.orig/drivers/s390/cio/eadm_sch.c
+++ linux/drivers/s390/cio/eadm_sch.c
@@ -134,7 +134,7 @@ static void eadm_subchannel_irq(struct s
 {
 	struct eadm_private *private = get_eadm_private(sch);
 	struct eadm_scsw *scsw = &sch->schib.scsw.eadm;
-	struct irb *irb = &__get_cpu_var(cio_irb);
+	struct irb *irb = this_cpu_ptr(&cio_irb);
 	int error = 0;
 
 	EADM_LOG(6, "irq");

