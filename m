Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab3IBD6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 23:58:53 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63706 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3IBD6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 23:58:51 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v2 0/6] Remove the duplicated _MAT evaluation and simplify _acpi_map_lsapic()
Date: Mon,  2 Sep 2013 11:57:33 +0800
Message-Id: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2: Return specific error value instead of just return -1, and
correct some grammar mistake in changelog.

For cpu hot add, evaluate _MAT or parse MADT will did twice to get
APIC id:
acpi_processor_add()
	acpi_processor_get_info()
		acpi_get_cpuid() will evaluate _MAT or parse MADT;
        acpi_processor_hotadd_init()
                acpi_map_lsapic() will evaluate _MAT again;

This patch set introduces apic_id in struct processor to save parsed
APIC id, and use it to remove the duplicated _MAT evaluation.

Further more, the new logical cpu number will be generated in
acpi_register_lapic(), this can be returned to remove the cpumask
allocation and operation to simplify _acpi_map_lsapic().

There are also some cleanups for the ACPI processor dirver code.


Hanjun Guo (2):
  ACPI / processor: remove unnecessary if (!pr) check
  ACPI / processor: Remove outdated comments

Jiang Liu (4):
  ACPI / processor: Introduce apic_id in struct processor to save
    parsed APIC id
  ACPI / processor: use apic_id and remove duplicated _MAT evaluation
  x86 / ACPI: simplify _acpi_map_lsapic()
  ACPI / processor: remove some dead code in acpi_processor_get_info()

 arch/ia64/kernel/acpi.c       |   38 ++----------------
 arch/x86/include/asm/mpspec.h |    2 +-
 arch/x86/kernel/acpi/boot.c   |   88 +++++++++--------------------------------
 arch/x86/kernel/apic/apic.c   |    8 ++--
 drivers/acpi/acpi_processor.c |   22 +++--------
 drivers/acpi/processor_core.c |   26 +++++++++---
 include/acpi/processor.h      |    3 ++
 include/linux/acpi.h          |    2 +-
 8 files changed, 60 insertions(+), 129 deletions(-)

-- 
1.7.9.5

