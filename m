Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3FOCCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:02:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:43120 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3FOCCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:02:51 -0400
Message-ID: <1371261741.21896.20.camel@pasglop>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rojhalat Ibrahim <imr@rtschenk.de>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Sat, 15 Jun 2013 12:02:21 +1000
In-Reply-To: <1371243967.9844.338.camel@gandalf.local.home>
References: <1626500.7WAVXjfS9F@pcimr>
	 <20130614122800.GL5146@linux.vnet.ibm.com> <1645938.As0LR1yeVd@pcimr>
	 <1371243967.9844.338.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> thing is, when I type on the console, it makes progress. Anyway, it
> seems that powerpc has an issue with irq_work(). I'll try to get some
> time either tonight or next week to figure it out.

Does this help ?

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 5cbcf4d..ea185e0 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(void)
 	 * in case we also had a rollover while hard disabled
 	 */
 	local_paca->irq_happened &= ~PACA_IRQ_DEC;
-	if (decrementer_check_overflow())
+	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
 		return 0x900;
 
 	/* Finally check if an external interrupt happened */

Cheers,
Ben.


