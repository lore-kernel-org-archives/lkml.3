Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaGaNwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:52:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57872 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGaNsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:10 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] staging: comedi: amplc_pci224: omit '!= 0' from logical expressions
Date: Thu, 31 Jul 2014 14:47:45 +0100
Message-Id: <1406814475-5923-9-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since anything non-zero is logically "true", don't bother doing
"not-equal" comparisons with zero, except when testing for an explicit
number 0 (not as a result of bit tests for example).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index f786237..0ac05fb 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -759,13 +759,13 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		break;
 	case TRIG_EXT:
 		/* Force to external trigger 0. */
-		if ((cmd->start_arg & ~CR_FLAGS_MASK) != 0) {
+		if (cmd->start_arg & ~CR_FLAGS_MASK) {
 			cmd->start_arg = COMBINE(cmd->start_arg, 0,
 						 ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* The only flag allowed is CR_EDGE, which is ignored. */
-		if ((cmd->start_arg & CR_FLAGS_MASK & ~CR_EDGE) != 0) {
+		if (cmd->start_arg & CR_FLAGS_MASK & ~CR_EDGE) {
 			cmd->start_arg = COMBINE(cmd->start_arg, 0,
 						 CR_FLAGS_MASK & ~CR_EDGE);
 			err |= -EINVAL;
@@ -785,14 +785,14 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		break;
 	case TRIG_EXT:
 		/* Force to external trigger 0. */
-		if ((cmd->scan_begin_arg & ~CR_FLAGS_MASK) != 0) {
+		if (cmd->scan_begin_arg & ~CR_FLAGS_MASK) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* Only allow flags CR_EDGE and CR_INVERT.  Ignore CR_EDGE. */
-		if ((cmd->scan_begin_arg & CR_FLAGS_MASK &
-		     ~(CR_EDGE | CR_INVERT)) != 0) {
+		if (cmd->scan_begin_arg & CR_FLAGS_MASK &
+		    ~(CR_EDGE | CR_INVERT)) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      CR_FLAGS_MASK &
 						      ~(CR_EDGE | CR_INVERT));
@@ -810,13 +810,13 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		break;
 	case TRIG_EXT:
 		/* Force to external trigger 0. */
-		if ((cmd->stop_arg & ~CR_FLAGS_MASK) != 0) {
+		if (cmd->stop_arg & ~CR_FLAGS_MASK) {
 			cmd->stop_arg = COMBINE(cmd->stop_arg, 0,
 						~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* The only flag allowed is CR_EDGE, which is ignored. */
-		if ((cmd->stop_arg & CR_FLAGS_MASK & ~CR_EDGE) != 0) {
+		if (cmd->stop_arg & CR_FLAGS_MASK & ~CR_EDGE) {
 			cmd->stop_arg = COMBINE(cmd->stop_arg, 0,
 						CR_FLAGS_MASK & ~CR_EDGE);
 		}
@@ -1026,7 +1026,7 @@ static irqreturn_t pci224_interrupt(int irq, void *d)
 		devpriv->intr_running = 1;
 		devpriv->intr_cpuid = THISCPU;
 		spin_unlock_irqrestore(&devpriv->ao_spinlock, flags);
-		if (valid_intstat != 0) {
+		if (valid_intstat) {
 			cmd = &s->async->cmd;
 			if (valid_intstat & PCI224_INTR_EXT) {
 				devpriv->intsce &= ~PCI224_INTR_EXT;
-- 
2.0.0

