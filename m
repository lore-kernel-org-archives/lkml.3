Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaE1Hjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:39:51 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58655 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaE1Hjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:39:48 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v2 0/5] APEI: Make APEI architecture independent.
Date: Wed, 28 May 2014 09:39:25 +0200
Message-Id: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org>
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
- treat NMI notification as GHES feature - CONFIG_ACPI_APEI_NMI
- reorganize GHES notification type init/deinitialization
  so that we can decide in run time whether NMI is supported or not
- identify architectural boxes and abstract it accordingly (NMI and MCE)
- rework ioremap for both IRQ and NMI context

NMI code is kept in ghes.c file since NMI and IRQ context are tightly coupled.

Note, these patches introduce no functional changes for x86. The NMI notification
feature is selected for x86 by default. Architectures that want to use this
feature should also provide NMI code infrastructure.

V1->V2
- address Borislav comment
- abstract arch-specific calls instead of wrapping into the #ifdef

Tomasz Nowicki (5):
  apei, mce: Factor out APEI architecture specific MCE calls.
  acpi, apei, ghes: Introduce ACPI_APEI_NMI to make NMI error
    notification a GHES feature.
  acpi, apei, ghes: Introduce more generic mechanism to init/deinit
    GHES error notifications.
  apei, ghes, nmi: Factor out NMI arch-specific calls.
  acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI
    context.

 arch/x86/kernel/acpi/Makefile |    1 +
 arch/x86/kernel/acpi/apei.c   |   87 ++++++++++++
 drivers/acpi/apei/Kconfig     |   10 +-
 drivers/acpi/apei/apei-base.c |   32 +++++
 drivers/acpi/apei/ghes.c      |  301 +++++++++++++++++++++++++----------------
 drivers/acpi/apei/hest.c      |   26 +---
 include/acpi/apei.h           |   11 ++
 7 files changed, 328 insertions(+), 140 deletions(-)
 create mode 100644 arch/x86/kernel/acpi/apei.c

-- 
1.7.9.5

