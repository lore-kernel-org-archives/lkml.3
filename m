Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab3HZL7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:59:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3HZL7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:59:13 -0400
Date: Mon, 26 Aug 2013 04:58:37 -0700
From: tip-bot for Liu Ping Fan <tipbot@zytor.com>
Message-ID: <tip-25aa2957973d361081ac6c8b6e5a0d9d7a83fef6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, haokexin@gmail.com, pingfank@linux.vnet.ibm.com,
        kernelfans@gmail.com, tglx@linutronix.de, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        haokexin@gmail.com, yinghai@kernel.org, pingfank@linux.vnet.ibm.com,
        kernelfans@gmail.com, tglx@linutronix.de, len.brown@intel.com
In-Reply-To: <1377248327-19633-1-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1377248327-19633-1-git-send-email-pingfank@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/ioapic:
  Check attr against the previous setting when programmed more than once
Git-Commit-ID: 25aa2957973d361081ac6c8b6e5a0d9d7a83fef6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 26 Aug 2013 04:58:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25aa2957973d361081ac6c8b6e5a0d9d7a83fef6
Gitweb:     http://git.kernel.org/tip/25aa2957973d361081ac6c8b6e5a0d9d7a83fef6
Author:     Liu Ping Fan <kernelfans@gmail.com>
AuthorDate: Fri, 23 Aug 2013 16:58:47 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 26 Aug 2013 12:58:00 +0200

x86/ioapic: Check attr against the previous setting when programmed more than once

When programming ioapic pinX more than once, current code
does not check whether the later attr (trigger & polarity) is the
same as the former or not.

This causes broken semantics which can be observed in a qemu q35
machine, where ioapic's ioredtbl[x] can never be set as low-active,
even if the hpet driver registered it.

And hpet driver may share a high-level active IRQ line with other
devices. So in qemu, when hpet-dev asserts low-level as kernel
expects, the kernel has no response.

With this patch, we can observe an ioredtbl[x] set as low-active
for hpet.

Fix it by reporting -EBUSY to the caller, when attr is different.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1377248327-19633-1-git-send-email-pingfank@linux.vnet.ibm.com
[ Made small readability edits to both the changelog and the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/acpi/boot.c    | 5 ++++-
 arch/x86/kernel/apic/io_apic.c | 9 ++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 872a2d2..81aa73b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1120,6 +1120,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	int ioapic;
 	int ioapic_pin;
 	struct io_apic_irq_attr irq_attr;
+	int ret;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1149,7 +1150,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	if (ret < 0)
+		gsi = INT_MIN;
 
 	return gsi;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 260abc2..e63a5bd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3380,12 +3380,15 @@ int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 {
 	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
+	struct IO_APIC_route_entry orig_entry;
 
 	/* Avoid redundant programming */
 	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mpc_ioapic_id(ioapic_idx), pin);
-		return 0;
+		pr_debug("Pin %d-%d already programmed\n", mpc_ioapic_id(ioapic_idx), pin);
+		orig_entry = ioapic_read_entry(attr->ioapic, pin);
+		if (attr->trigger == orig_entry.trigger && attr->polarity == orig_entry.polarity)
+			return 0;
+		return -EBUSY;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
