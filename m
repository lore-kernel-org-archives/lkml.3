Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3BFWGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:06:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3920 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3BFWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:06:33 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=TOFAIFlZzLYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Kq2jaWyG-zMA:10 a=VwQbUJbxAAAA:8 a=5GsgiXXBMyPZXWBjK_kA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130206220632.329615743@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Feb 2013 17:06:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 1/5] drivers-tty-pl011-irq-disable-madness.patch
References: <20130206220608.862416001@goodmis.org>
Content-Disposition: inline; filename=0001-drivers-tty-pl011-irq-disable-madness.patch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/amba-pl011.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 7cbb367..40356ae 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1754,13 +1754,19 @@ pl011_console_write(struct console *co, const char *s, unsigned int count)
 
 	clk_enable(uap->clk);
 
-	local_irq_save(flags);
+	/*
+	 * local_irq_save(flags);
+	 *
+	 * This local_irq_save() is nonsense. If we come in via sysrq
+	 * handling then interrupts are already disabled. Aside of
+	 * that the port.sysrq check is racy on SMP regardless.
+	*/
 	if (uap->port.sysrq)
 		locked = 0;
 	else if (oops_in_progress)
-		locked = spin_trylock(&uap->port.lock);
+		locked = spin_trylock_irqsave(&uap->port.lock, flags);
 	else
-		spin_lock(&uap->port.lock);
+		spin_lock_irqsave(&uap->port.lock, flags);
 
 	/*
 	 *	First save the CR then disable the interrupts
@@ -1782,8 +1788,7 @@ pl011_console_write(struct console *co, const char *s, unsigned int count)
 	writew(old_cr, uap->port.membase + UART011_CR);
 
 	if (locked)
-		spin_unlock(&uap->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&uap->port.lock, flags);
 
 	clk_disable(uap->clk);
 }
-- 
1.7.10.4


