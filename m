Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3IHM15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:27:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3IHM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:27:03 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=seFBIsdvhlEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=luFN_H5C1WoA:10 a=VwQbUJbxAAAA:8 a=p8bWVRUOP6nYngi37J0A:9 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908122700.229691761@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 08:25:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 04/10] powerpc: 52xx: provide a default in mpc52xx_irqhost_map()
References: <20130908122545.421180629@goodmis.org>
Content-Disposition: inline; filename=0004-powerpc-52xx-provide-a-default-in-mpc52xx_irqhost_ma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

My gcc-4.3.5 fails to compile due to:

|cc1: warnings being treated as errors
|arch/powerpc/platforms/52xx/mpc52xx_pic.c: In function ‘mpc52xx_irqhost_map’:
|arch/powerpc/platforms/52xx/mpc52xx_pic.c:343: error: ‘irqchip’ may be used uninitialized in this function

since commit e34298c ("powerpc: 52xx: nop out unsupported critical
IRQs"). This warning is complete crap since only values 0…3 are possible
which are checked but gcc fails to understand that. I wouldn't care much
but since this is compiled with -Werror I made this patch.
While add it, I replaced the warning from l2irq to l1irq since this is
the number that is evaluated.

Cc: stable-rt@vger.kernel.org # 3.8
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/powerpc/platforms/52xx/mpc52xx_pic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index b89ef65..b69221b 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -373,8 +373,9 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	case MPC52xx_IRQ_L1_PERP: irqchip = &mpc52xx_periph_irqchip; break;
 	case MPC52xx_IRQ_L1_SDMA: irqchip = &mpc52xx_sdma_irqchip; break;
 	case MPC52xx_IRQ_L1_CRIT:
+	default:
 		pr_warn("%s: Critical IRQ #%d is unsupported! Nopping it.\n",
-			__func__, l2irq);
+			__func__, l1irq);
 		irq_set_chip(virq, &no_irq_chip);
 		return 0;
 	}
-- 
1.7.10.4


