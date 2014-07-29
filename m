Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaG2Vxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:53:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:1207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaG2Vxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,759,1400050800"; 
   d="scan'208";a="462866070"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>, bp@alien8.de,
        rjw@rjwysocki.net
Subject: [GIT PULL] Eliminate APEI Kconfig x86 dependency
Date: Tue, 29 Jul 2014 14:53:34 -0700
Message-Id: <53d817de129091e8d3@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-apei

for you to fetch changes up to 594c7255dce7a13cac50cf2470cc56e2c3b0494e:

  acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI context. (2014-07-22 15:05:06 -0700)

----------------------------------------------------------------
APEI is currently implemented so that it depends on x86 hardware.
The primary dependency is that GHES uses the x86 NMI for hardware
error notification and MCE for memory error handling. These patches
remove that dependency.

Other APEI features such as error reporting via external IRQ, error
serialization, or error injection, do not require changes to use them
on non-x86 architectures.

The following patch set eliminates the APEI Kconfig x86 dependency
by making these changes:
- treat NMI notification as GHES architecture - HAVE_ACPI_APEI_NMI
- group and wrap around #ifdef CONFIG_HAVE_ACPI_APEI_NMI code which
  is used only for NMI path
- identify architectural boxes and abstract it accordingly (tlb flush and MCE)
- rework ioremap for both IRQ and NMI context

NMI code is kept in ghes.c file since NMI and IRQ context are tightly coupled.

Note, these patches introduce no functional changes for x86. The NMI notification
feature is hard selected for x86. Architectures that want to use this
feature should also provide NMI code infrastructure.

----------------------------------------------------------------
Tomasz Nowicki (3):
      apei, mce: Factor out APEI architecture specific MCE calls.
      acpi, apei, ghes: Make NMI error notification to be GHES architecture extension.
      acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI context.

 arch/x86/Kconfig              |   2 +
 arch/x86/kernel/acpi/Makefile |   1 +
 arch/x86/kernel/acpi/apei.c   |  62 +++++++++++++++
 drivers/acpi/apei/Kconfig     |   8 +-
 drivers/acpi/apei/apei-base.c |  13 ++++
 drivers/acpi/apei/ghes.c      | 173 +++++++++++++++++++++++++++---------------
 drivers/acpi/apei/hest.c      |  29 +------
 include/acpi/apei.h           |   4 +
 include/linux/nmi.h           |   4 +
 9 files changed, 204 insertions(+), 92 deletions(-)
 create mode 100644 arch/x86/kernel/acpi/apei.c
