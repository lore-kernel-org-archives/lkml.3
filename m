Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3FRLTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:19:17 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44423 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3FRLTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:19:16 -0400
Date: Tue, 18 Jun 2013 13:19:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] s390 patches for the 3.10-rc6
Message-ID: <20130618111910.GA24526@osiris>
References: <20130613164730.65273fbd@mschwide>
 <CAMuHMdW+C=kQh+0XM1m1W5EPOPYCmq1KoJOKSbT+-VZWdK-9Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW+C=kQh+0XM1m1W5EPOPYCmq1KoJOKSbT+-VZWdK-9Ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061811-8372-0000-0000-000006579A6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:08:51PM +0200, Geert Uytterhoeven wrote:
> On Thu, Jun 13, 2013 at 4:47 PM, Martin Schwidefsky
> allnoconfig:
> 
> arch/s390/kernel/irq.c:315:6: error: expected identifier or '(' before '__asm__'
> http://kisskb.ellerman.id.au/kisskb/buildresult/8987667/
> 
> The function is expanded to:
> 
>     void __asm__ __volatile__("": : :"memory")
>     {
> 
>     }
> 
> include/linux/hardirq.h: # define synchronize_irq(irq)   barrier()
> include/linux/compiler-gcc.h: #define barrier() __asm__
> __volatile__("": : :"memory")
> 
> Turning synchronize_irq() into a static inline function doesn't help as then
> it becomes a redefinition.

We received a patch from Ben which fixes this:

>From 7bf4da5763f30823b4eeb4c82f8499ffe2f475ab Mon Sep 17 00:00:00 2001
From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 14 Jun 2013 01:18:44 +0100
Subject: [PATCH] s390/irq: Only define synchronize_irq() on SMP

In uniprocessor configurations, synchronize_irq() is defined in
<linux/hardirq.h> as a macro, and this function definition fails to
compile.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org # 3.9
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/kernel/irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 408e866..dd3c199 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -312,6 +312,7 @@ void measurement_alert_subclass_unregister(void)
 }
 EXPORT_SYMBOL(measurement_alert_subclass_unregister);
 
+#ifdef CONFIG_SMP
 void synchronize_irq(unsigned int irq)
 {
 	/*
@@ -320,6 +321,7 @@ void synchronize_irq(unsigned int irq)
 	 */
 }
 EXPORT_SYMBOL_GPL(synchronize_irq);
+#endif
 
 #ifndef CONFIG_PCI
 
-- 
1.8.2.2

