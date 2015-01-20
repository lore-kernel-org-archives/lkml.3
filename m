Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbbATDSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:18:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:36494 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbbATDSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:18:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/3] x86: drop EISA support from x86_32 builds
Date: Mon, 19 Jan 2015 22:18:18 -0500
Message-ID: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we deleted MCA bus support close to three years ago, Linus ack'd
it and said "Maybe we could some day remove EISA support too.." [1]

For the older arch who are frozen in time (from a hardware perspective)
they might not be ready/willing to drop EISA support yet.  However that
does not mean that we can't start dropping on a per arch basis for where
it really makes sense to do so.  Quoting from the 3rd patch here:

   The Kconfig text says it all, with "The EISA bus saw limited use
   between 1988 and 1995 when it was made obsolete by the PCI bus."

   That means typically 486/586 CPUs in the 33-166MHz range, and
   8-64MB of installed RAM in typical EISA machines of that era.
   With the additional cost, they were also typically rare, and not
   getting widescale deployment.

   Given that it is 20 years on since its demise, and the above specs
   might seem just barely acceptable for a wireless router today, lets
   stop forcing everyone to build EISA infrastructure and assoc. drivers
   during their routine build coverage testing for no value whatsoever.

   We'd already removed some obsolete 10Mbit EISA network drivers in
   commit bca94cffabf5c9f2399da34eab00bd534bf3735b ("drivers/net: delete
   8390 based EISA drivers") over two years ago for the same reason.

   If we don't immediately expire EISA completely, we can at least limit
   its impact and support/testing overhead to the arch like alpha and
   parisc that are essentially frozen in time from a hardware perspective.

In doing this, we see that we essentially had two EISA/ELCR (Edge/Level
Control Register) functions, and so we rename the remaining one to not
have EISA mentioned in its name (since it really is not EISA specific).

We also dip into the EISA code itself, since there was a Kconfig option
in there that was specific to a single 486 VESA local bus hardware
configuration that won't be found outside of the x86 architecture.

Finally, we clobber all x86 specific blocks of code that were within the
CONFIG_EISA ifdef, and drop the x86 Kconfig block that pulled it into
the x86_32 builds to complete the process.

Overall, we shed some lines of code, and exposure to some Kconfig
variations, which is a small win, even if might be a hopeless battle.

Paul.

[1] https://lkml.org/lkml/2012/5/17/278

---

Paul Gortmaker (3):
  x86: renane eisa_set_level_irq to elcr_set_level_irq
  x86: delete EISA_VLB_PRIMING Kconfig option and code
  x86: drop support for 1995 era EISA based platforms

 Documentation/eisa.txt         |  4 ++--
 arch/x86/Kconfig               | 18 --------------
 arch/x86/include/asm/hw_irq.h  |  3 +--
 arch/x86/include/asm/mpspec.h  |  4 ----
 arch/x86/kernel/acpi/boot.c    |  8 +------
 arch/x86/kernel/apic/io_apic.c | 54 ------------------------------------------
 arch/x86/kernel/mpparse.c      | 11 +--------
 arch/x86/kernel/traps.c        | 13 ----------
 arch/x86/pci/irq.c             | 13 +++++-----
 drivers/acpi/pci_irq.c         |  2 +-
 drivers/eisa/Kconfig           | 10 --------
 drivers/eisa/eisa-bus.c        | 10 --------
 drivers/eisa/virtual_root.c    |  2 +-
 13 files changed, 14 insertions(+), 138 deletions(-)

-- 
2.2.1

