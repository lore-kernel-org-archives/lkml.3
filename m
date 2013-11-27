Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab3K0CCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:02:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44009 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760732Ab3K0CAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:00:46 -0500
Subject: [PATCH v7 0/3] x86, apic,
 kexec: Add disable_cpu_apic kernel parameter
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Wed, 27 Nov 2013 11:00:42 +0900
Message-ID: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is to allow kdump 2nd kernel to wake up multiple CPUs,
a continueing work from:

  [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
  https://lkml.org/lkml/2013/10/16/300.

At v4, basic design has changed. Now users need to figure out initial
APIC ID of BSP in the 1st kernel and configures kernel parameter for
the 2nd kernel manually using disable_cpu_apicid kernel parameter,
which is newly introduced by this patch set. This design is more
flexible than the previous version in that we no longer have to rely
on ACPI/MP table to get initial APIC ID of BSP.

Sorry, this patch set have not include in-source documentation
requested by Borislav Petkov yet, but I'll post it later separately,
which would be better to focus on documentation reviewing.

ChangeLog

v6 => v7)

- Rebased on top of v3.13-rc1

- Remove a patch that cleans up the code around
  x86_cpu_physical_apicid. Instead, use read_apic_id() directly in
  generic_processor_info(). The clean up removed here will be done in
  different patch set.

v5 => v6)

- Remove use of rdmsr(IA32_APIC_BASE) to initialize
  bsp_physical_apicid since the MSR doesn't work well on some cluster
  systems, suggested by HPA. Also, current users of the variable
  expects the initial apicid reported through MP table only; removing
  the use of the MSR is not problematic.

- Rename bsp_physical_apicid as bios_bsp_physical_apicid to make it
  clear that the apidid contained there is the one reported from some
  BIOS table. Also, initialize it not only by MP table but also by
  ACPI MADT.

- Change message displayed when specified cpu is disabled from:

  ACPI: Disable specified CPU. Processor 0/0x0 ignored.

  to:

  ACPI: Disabling requested cpu. Processor 0/0x0 ignored.

v4 => v5)

- Rebased on top of v3.12

- Introduce bsp_physical_apicid that has the initial APIC ID for the
  processor with BSP flag on IA32_APIC_BASE MSR. Without this,
  boot_cpu_physical_apicid has temporarilly the value around MP table
  related codes, although it's designed to have the initial APIC ID
  for the processor that is doing the boot up. Use the
  bsp_physical_apicid in MP table related codes; no impact on
  semantics at runtime there.

v3 => v4)

- Rebased on top of v3.12-rc6

- Basic design has been changed. Now users need to figure out initial
  APIC ID of BSP in the 1st kernel and configures kernel parameter for
  the 2nd kernel manually using disable_cpu_apic kernel parameter to
  be newly introduced in this patch set. This design is more flexible
  than the previous version in that we no longer have to rely on
  ACPI/MP table to get initial APIC ID of BSP.

v2 => v3)

- Change default value of boot_cpu_is_bsp to true.

- Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
  processor family is larger than or equal to 6 in order to avoid
  invalid opcode exception on processors where MSR_IA32_APICBASE is
  not supported.

v1 => v2)

- Rebased on top of v3.12-rc5.

- Fix linking time error of boot_cpu_is_bsp_init() in case of
  CONFIG_LOCAL_APIC disabled by adding empty static inline function
  instead.

- Fix missing feature check by means of cpu_has_apic macro in
  boot_cpu_is_bsp_init() before calling rdmsr_safe(MSR_IA32_APICBASE).

  NOTE: I've checked local apic-present case only; I don't have any
  x86 processor without local apic.

- Add __init annotation to boot_cpu_is_bsp_init().

Test

- built with and without CONFIG_LOCAL_APIC
- tested x86_64 in case of acpi and MP table
- tested disable_cpu_apicid=<n> to disable both AP and BSP

---

HATAYAMA Daisuke (2):
      x86, apic: Add disable_cpu_apicid kernel parameter
      Documentation, x86, apic, kexec: Add disable_cpu_apicid kernel parameter


 Documentation/kernel-parameters.txt |    9 ++++++
 arch/x86/kernel/apic/apic.c         |   49 +++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

-- 

Thanks.
HATAYAMA, Daisuke
