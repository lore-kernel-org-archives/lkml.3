Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbaCDQlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:41:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaCDQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:40:57 -0500
Date: Tue, 4 Mar 2014 08:39:42 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-c866cda47f2c6c8abb929933b7794e9a92d7c924@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org,
        peterz@infradead.org, ashish.kalra@freescale.com,
        benh@kernel.crashing.org, timur@freescale.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, galak@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, ashish.kalra@freescale.com,
        benh@kernel.crashing.org, timur@freescale.com, tglx@linutronix.de
In-Reply-To: <20140223212736.451970660@linutronix.de>
References: <20140223212736.451970660@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] powerpc:eVh_pic: Kill irq_desc abuse
Git-Commit-ID: c866cda47f2c6c8abb929933b7794e9a92d7c924
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c866cda47f2c6c8abb929933b7794e9a92d7c924
Gitweb:     http://git.kernel.org/tip/c866cda47f2c6c8abb929933b7794e9a92d7c924
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:51 +0100

powerpc:eVh_pic: Kill irq_desc abuse

I'm really grumpy about this one. The line:

#include "../../../kernel/irq/settings.h"

should have been an alarm sign for all people who added their SOB to
this trainwreck.

When I cleaned up the mess people made with interrupt descriptors a
few years ago, I warned that I'm going to hunt down new offenders and
treat them with stinking trouts. In this case I'll use frozen shark
for a better educational value.

The whole idiocy which was done there could have been avoided with two
lines of perfectly fine code. And do not complain about the lack of
correct examples in tree.

The solution is simple:

  Remove the brainfart and use the proper functions, which should
  have been used in the first place

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ashish Kalra <ashish.kalra@freescale.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: ppc <linuxppc-dev@lists.ozlabs.org>
Link: http://lkml.kernel.org/r/20140223212736.451970660@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/sysdev/ehv_pic.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index b74085c..2d20f10 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -28,8 +28,6 @@
 #include <asm/ehv_pic.h>
 #include <asm/fsl_hcalls.h>
 
-#include "../../../kernel/irq/settings.h"
-
 static struct ehv_pic *global_ehv_pic;
 static DEFINE_SPINLOCK(ehv_pic_lock);
 
@@ -113,17 +111,13 @@ static unsigned int ehv_pic_type_to_vecpri(unsigned int type)
 int ehv_pic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	unsigned int src = virq_to_hw(d->irq);
-	struct irq_desc *desc = irq_to_desc(d->irq);
 	unsigned int vecpri, vold, vnew, prio, cpu_dest;
 	unsigned long flags;
 
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	irq_settings_clr_level(desc);
-	irq_settings_set_trigger_mask(desc, flow_type);
-	if (flow_type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
-		irq_settings_set_level(desc);
+	irqd_set_trigger_type(d, flow_type);
 
 	vecpri = ehv_pic_type_to_vecpri(flow_type);
 
@@ -144,7 +138,7 @@ int ehv_pic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 	ev_int_set_config(src, vecpri, prio, cpu_dest);
 
 	spin_unlock_irqrestore(&ehv_pic_lock, flags);
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 static struct irq_chip ehv_pic_irq_chip = {
