Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaK1VM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:12:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaK1VM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:12:57 -0500
Date: Fri, 28 Nov 2014 13:12:27 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-412fbca8dd3067438a9c8a98853299f58a5597d5@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, bp@suse.de,
        mingo@kernel.org, jiang.liu@linux.intel.com, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, bp@suse.de, tglx@linutronix.de,
        hpa@zytor.com, mingo@kernel.org, jiang.liu@linux.intel.com
In-Reply-To: <54789774.7030704@linux.intel.com>
References: <54789774.7030704@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Repair io_apic_set_affinity
Git-Commit-ID: 412fbca8dd3067438a9c8a98853299f58a5597d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  412fbca8dd3067438a9c8a98853299f58a5597d5
Gitweb:     http://git.kernel.org/tip/412fbca8dd3067438a9c8a98853299f58a5597d5
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Fri, 28 Nov 2014 21:43:02 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Nov 2014 22:09:22 +0100

x86, ioapic: Repair io_apic_set_affinity

Boris reported, that the rework of the ioapic to use cached entry data
broke his older AMD machine.

The cause for this is that the cached entry.dest field is assigned
with SET_APIC_LOGICAL_ID(cfg->desc_apicid). SET_APIC_LOGICAL_ID left
shifts the value by 24. This is obviously wrong as the dest field is
already at the proper bit position, so the extra shift essentially
cleared the dest field.
   
Remove SET_APIC_LOGICAL_ID and assign cfg->desc_apicid directly.

This got introduced in commit bfa644bfa9e3 but only becomes visible
since the conversion to use cached entries in commit fda7c08b1349
'x86, irq: Use cached IOAPIC entry instead of reading from hardware'

Reported-and-tested-by: Borislav Petkov <bp@suse.de>
Fixes: bfa644bfa9e3 'x86, irq: Convert IOAPIC to use hierarchy irqdomain interfaces'
Link: http://lkml.kernel.org/r/54789774.7030704@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5307320..ec193bc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1885,7 +1885,7 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
 		cfg = irqd_cfg(irq_data);
-		data->entry.dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
+		data->entry.dest = cfg->dest_apicid;
 		data->entry.vector = cfg->vector;
 		for_each_irq_pin(entry, data->irq_2_pin)
 			__ioapic_write_entry(entry->apic, entry->pin,
