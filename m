Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3FYSqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:46:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46464 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3FYSqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:46:17 -0400
Date: Tue, 25 Jun 2013 19:45:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Austin <jonathan.austin@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>, Vinod Koul <vinod.koul@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
Message-ID: <20130625184539.GB2718@n2100.arm.linux.org.uk>
References: <51C97F40.5030101@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C97F40.5030101@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:30:08PM +0100, Jonathan Austin wrote:
> There's a patch making its way to mainline via Russell's tree
> (8d96250700: ARM: mm: Transparent huge page support for LPAE systems)
> that breaks the build of the amba-pl08x driver (drivers/dma/amba-pl08x.c) 
> because the 'get_signal' macro from include/linux/signal.h is now in the
> driver's scope and it clobbers a (previously) valid function call.

Well, here's the change to asm/pgtable.h in that patch:

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 9bcd262..eaedce7 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -24,6 +24,9 @@
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>

+
+#include <asm/tlbflush.h>
+
 #ifdef CONFIG_ARM_LPAE
 #include <asm/pgtable-3level.h>
 #else

And the question is - if that's all that is going on in that file, why
is asm/tlbflush.h being added to it?  What in _that_ file uses anything
from asm/tlbflush.h (nothing apparantly from what I can see)?

So, I'm tempted to kill this change off unless someone can justify why
that addition happened - it looks completely inappropriate to me.
