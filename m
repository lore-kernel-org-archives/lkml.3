Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab3JPPLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:11:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:2983 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab3JPPLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417781859"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] Extended H/W error log driver
Date: Wed, 16 Oct 2013 10:55:57 -0400
Message-Id: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2 1/9] ACPI, APEI, CPER: Fix status check during error printing
[PATCH v2 2/9] ACPI, CPER: Update cper info
[PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
[PATCH v2 4/9] ACPI, x86: Extended error log driver for x86 platform
[PATCH v2 5/9] DMI: Parse memory device (type 17) in SMBIOS
[PATCH v2 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
[PATCH v2 7/9] ACPI, APEI, CPER: Enhance memory reporting capability
[PATCH v2 8/9] ACPI, APEI, CPER: Cleanup CPER memory error output format
[PATCH v2 9/9] ACPI / trace: Add trace interface for eMCA driver

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

[  949.545817] {1}Hardware error detected on CPU15
[  949.549786] {1}event severity: corrected
[  949.549786] {1} Error 0, type: corrected
[  949.549786] {1}  section_type: memory error
[  949.549786] {1}  physical_address: 0x0000001057eb0000
[  949.549786] {1}  DIMM location: Memriser3 CHANNEL A DIMM 0
[  949.549786] {1}Above error has been corrected by h/w and require no further action
[  949.549786] mce: [Hardware Error]: Machine check events logged
[ 1010.902124] {2}Hardware error detected on CPU15
[ 1010.906064] {2}event severity: corrected
[ 1010.906064] {2} Error 0, type: corrected
[ 1010.906064] {2}  section_type: memory error
[ 1010.906064] {2}  physical_address: 0x0000001057eb0000
[ 1010.906064] {2}  DIMM location: Memriser3 CHANNEL A DIMM 0
[ 1010.906064] {2}Above error has been corrected by h/w and require no further action
[ 1010.906064] mce: [Hardware Error]: Machine check events logged




trace output:

# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:120
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
          <idle>-0     [015] d.h.   951.584641: extlog_mem_event: 1 corrected error: unknown on Memriser3 CHANNEL A DIMM 0 (FRU: 00000000-0000-0000-0000-000000000000  physical addr: 0x0000001057eb0000 node: 1 card: 0 module: 0 rank: 0 bank: 0 row: 28917 column: 1400)
          <idle>-0     [015] d.h.  1013.008596: extlog_mem_event: 2 corrected errors: unknown on Memriser3 CHANNEL A DIMM 0 (FRU: 00000000-0000-0000-0000-000000000000  physical addr: 0x0000001057eb0000 node: 1 card: 0 module: 0 rank: 0 bank: 0 row: 28917 column: 1400)


dmesg output format has been updated based on the suggestion from Boris.
For trace output format we still need further discussion. In the last
patch(support trace interface) I have to reserve previous Kconfig format
because I find once I put trace_event interface in the module, it will
not work. I will paste another trace patch(it only works when acpi_extlog is
builtin) for your answer.
