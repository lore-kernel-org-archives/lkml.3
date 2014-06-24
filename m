Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaFXLmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:42:24 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46413 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFXLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:41:37 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org, Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v4 0/3] APEI: Make APEI architecture independent.
Date: Tue, 24 Jun 2014 13:41:32 +0200
Message-Id: <1403610095-5354-1-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

V1->V2
- address Borislav's comment
- abstract arch-specific calls instead of wrapping into the #ifdef

V2->V3
- address Robert's comment
- disable ACPI_APEI_NMI selection so that it is hard selected by arch Kconfig
- rename ACPI_APEI_NMI to ARCH_HAS_ACPI_APEI_NMI

V3->V4
- do not abstract NMI calls for archs which do not support it
- merge some of patches to make review process easier

Tomasz Nowicki (3):
  apei, mce: Factor out APEI architecture specific MCE calls.
  acpi, apei, ghes: Make NMI error notification to be GHES architecture
    extension.
  acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI
    context.

 arch/x86/Kconfig              |    2 +
 arch/x86/kernel/acpi/Makefile |    1 +
 arch/x86/kernel/acpi/apei.c   |   62 +++++++++++++++
 drivers/acpi/apei/Kconfig     |    8 +-
 drivers/acpi/apei/apei-base.c |   13 ++++
 drivers/acpi/apei/ghes.c      |  173 ++++++++++++++++++++++++++---------------
 drivers/acpi/apei/hest.c      |   29 +------
 include/acpi/apei.h           |    4 +
 include/linux/nmi.h           |    4 +
 9 files changed, 204 insertions(+), 92 deletions(-)
 create mode 100644 arch/x86/kernel/acpi/apei.c

-- 
1.7.9.5

