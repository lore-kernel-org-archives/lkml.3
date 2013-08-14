Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab3HNUEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:04:48 -0400
Received: from 8bytes.org ([85.214.48.195]:51394 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923Ab3HNUEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:04:47 -0400
Date: Wed, 14 Aug 2013 22:04:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: integrator: Make sure INTEGRATOR_AP depends on PCI
Message-ID: <20130814200442.GA20372@8bytes.org>
References: <1376509818-22163-1-git-send-email-joro@8bytes.org>
 <20130814195701.GY23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814195701.GY23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 22:04:43 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520be2db20861516367007
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:57:01PM +0100, Russell King - ARM Linux wrote:
> On Wed, Aug 14, 2013 at 09:50:18PM +0200, Joerg Roedel wrote:
> > Add this dependency to the Kconfig file to fix the following
> > build error when CONFIG_INTEGRATOR_AP is set but CONFIG_PCI
> > is not:
> 
> No, integrator does not require PCI, so this needs to be fixed by other
> means, such as finding out how the breakage was introduced, and fixing
> the real cause of this regression.

You are right, just found out that this introduces a recursive
dependency while compiling another config:

arch/arm/Kconfig:1403:error: recursive dependency detected!
arch/arm/Kconfig:1403:	symbol PCI depends on MIGHT_HAVE_PCI
arch/arm/Kconfig:108:	symbol MIGHT_HAVE_PCI is selected by ARCH_INTEGRATOR_AP
arch/arm/mach-integrator/Kconfig:5:	symbol ARCH_INTEGRATOR_AP depends on PCI

So when integrator does not depend on PCI this diff is more appropriate?

diff --git a/arch/arm/mach-integrator/pci_v3.h b/arch/arm/mach-integrator/pci_v3.h
index 755fd29..51738e0 100644
--- a/arch/arm/mach-integrator/pci_v3.h
+++ b/arch/arm/mach-integrator/pci_v3.h
@@ -1,2 +1,9 @@
-/* Simple oneliner include to the PCIv3 early init */
+/* Define PCIv3 early init */
+#ifdef CONFIG_PCI
 extern int pci_v3_early_init(void);
+#else
+static inline int pci_v3_early_init(void)
+{
+	return 0;
+}
+#endif

