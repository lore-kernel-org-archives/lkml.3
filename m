Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3FDWl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:28 -0400
Received: from 1wt.eu ([62.212.114.60]:35216 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab3FDWlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:11 -0400
Message-Id: <20130604172132.218543802@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 046/184] x86, ioapic: initialize nr_ioapic_registers early in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 mp_register_ioapic()

From: Suresh Siddha <suresh.b.siddha@intel.com>

Lin Bao reported that one of the HP platforms failed to boot
2.6.32 kernel, when the BIOS enabled interrupt-remapping and
x2apic before handing over the control to the Linux kernel.

During boot, Linux kernel masks all the interrupt sources
(8259, IO-APIC RTE's), setup the interrupt-remapping hardware
with the OS controlled table and unmasks the 8259 interrupts
but not the IO-APIC RTE's (as the newly setup interrupt-remapping
table and the IO-APIC RTE's are not yet programmed by the kernel).

Shortly after this, IO-APIC RTE's and the interrupt-remapping table
entries are programmed based on the ACPI tables etc. So the
expectation is that any interrupt during this window will be dropped
and not see the intermediate configuration.

In the reported problematic case, BIOS has configured the IO-APIC
in virtual wire-B mode. Between the window of the kernel setting up
new interrupt-remapping table  and the IO-APIC RTE's are properly
configured, an interrupt gets routed by the IO-APIC RTE (setup
by the virtual wire-B configuration) and sees the empty
interrupt-remapping table entry, resulting in vt-d fault causing
the platform to generate NMI. And the OS panics on this unexpected NMI.

This problem doesn't happen with more recent kernels and closer
look at the 2.6.32 kernel shows that the code which masks
the IO-APIC RTE's is not working as expected as the nr_ioapic_registers
for each IO-APIC is not yet initialized at this point. In the later
kernels we initialize nr_ioapic_registers much before and
everything works as expected.

For 2.6.[32..34] kernels, fix this issue by initializing
nr_ioapic_registers early in mp_register_ioapic()

[ Relevant upstream commit info:
  commit 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
  Author: Eric W. Biederman <ebiederm@xmission.com>
  Date:   Tue Mar 30 01:07:12 2010 -0700

    x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.

  As the upstream commit depends on quite a few prior commits
  and some followup fixes in the mainline, we just picked
  the smallest relevant hunk for fixing the issue at hand.
  Problematic platform uses ACPI for IO-APIC, VT-d enumeration etc
  and this hunk only touches the ACPI based platforms.

  nr_ioapic_reigsters initialization in enable_IO_APIC() is still
  retained, so that other configurations like legacy MPS table based
  enumeration etc works with no change.
]

Reported-and-tested-by: Zhang, Lin-Bao <linbao.zhang@hp.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/apic/io_apic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8928d97..d256bc3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4262,6 +4262,7 @@ static int bad_ioapic(unsigned long address)
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
+	int entries;
 
 	if (bad_ioapic(address))
 		return;
@@ -4280,10 +4281,14 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
+	entries = io_apic_get_redir_entries(idx);
 	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
+	mp_gsi_routing[idx].gsi_end = gsi_base + entries;
 
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries + 1;
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
 	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
-- 
1.7.12.2.21.g234cd45.dirty



