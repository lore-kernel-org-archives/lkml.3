Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3JKGrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:47:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:49010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3JKGrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:47:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="415283369"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Extended H/W error log driver
Date: Fri, 11 Oct 2013 02:32:38 -0400
Message-Id: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/8] ACPI, APEI, CPER: Fix status check during error printing
[PATCH 2/8] ACPI, CPER: Update cper info
[PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
[PATCH 4/8] DMI: Parse memory device (type 17) in SMBIOS
[PATCH 5/8] ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
[PATCH 6/8] ACPI, APEI, CPER: Enhance memory reporting capability
[PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output format
[PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver

This patch series adds an enhanced MCA event logging driver provided by Intel.
Please refer to this link: htpp://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html

Certain usages such as Predictive Failure Analysis (PFA) require more
information about the error than what can be described in processor
machine check banks. Most server processors log additional information
about the error in processor uncore registers. Since the addresses
and layout of these registers vary widely from one processor to another,
system software cannot readily make use of them. To complicate matters
further, some of the additionalerror information cannot be constructed
without detailed knowledge about platform topology. This enhanced MCA
logging driver allows firmware to provide additional error information
to MCE/CMCI handler and thus addresses this gap.

After applying this patch series, when a memory corrected error happens,
we can get following information:

dmesg output:

[56005.785917] {3}Hardware error detected on CPU0
[56005.785959] {3}event severity: corrected
[56005.785975] {3}sub_event[0], severity: corrected
[56005.785977] {3}section_type: memory error
[56005.785981] {3}physical_address: 0x0000000851fe0000
[56005.786027] {3}DIMM location: Memriser1 CHANNEL A DIMM 0
[56005.786154] {4}Hardware error detected on CPU0
[56005.786159] {4}event severity: corrected
[56005.786162] {4}sub_event[0], severity: corrected
[56005.786166] {4}section_type: memory error


trace output:

# tracer: nop
#
# entries-in-buffer/entries-written: 4/4   #P:120
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
...
...
          <idle>-0     [000] d.h. 56068.488759: extlog_mem_event: 3 corrected errors:unknown on Memriser1 CHANNEL A DIMM 0(FRU: 00000000-0000-0000-0000-000000000000  physical addr: 0x0000000851fe0000 node: 0 card: 0 module: 0 rank: 0 bank: 0 row: 28927 column: 1296)
          <idle>-0     [000] d.h. 56068.488834: extlog_mem_event: 4 corrected errors:unknown
...
...

dmesg output are shrank to only keep the most important data. The trace
output will contain most of data. Not sure if all fields are meaningful
to users. Some fields like FRU ID/FRU TEXT depends on BIOS manufactor.
So welcome to add comments for what is needed or not.

