Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaKZXHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:07:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKZXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:07:00 -0500
Date: Wed, 26 Nov 2014 15:05:48 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-489e71db03c76fa74d570133b51abe02b5192450@git.kernel.org>
Cc: gregkh@linuxfoundation.org, benh@kernel.crashing.org, bp@alien8.de,
        tony.luck@intel.com, tglx@linutronix.de, jiang.liu@linux.intel.com,
        rjw@rjwysocki.net, hpa@zytor.com, mingo@kernel.org,
        rdunlap@infradead.org, konrad.wilk@oracle.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, yinghai@kernel.org
Reply-To: tglx@linutronix.de, tony.luck@intel.com, bp@alien8.de,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        yinghai@kernel.org, bhelgaas@google.com, linux-kernel@vger.kernel.org,
        joro@8bytes.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        mingo@kernel.org, hpa@zytor.com, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com
In-Reply-To: <1416894816-23245-2-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-2-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Save destination CPU ID in irq_cfg
Git-Commit-ID: 489e71db03c76fa74d570133b51abe02b5192450
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

Commit-ID:  489e71db03c76fa74d570133b51abe02b5192450
Gitweb:     http://git.kernel.org/tip/489e71db03c76fa74d570133b51abe02b5192450
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:10 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:23 +0100

x86, irq: Save destination CPU ID in irq_cfg

Cache destination CPU APIC ID into struct irq_cfg when assigning vector
for interrupt. Upper layer just needs to read the cached APIC ID instead
of calling apic->cpu_mask_to_apicid_and(), it helps to hide APIC driver
details from IOAPIC/HPET/MSI drivers..

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-2-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h | 1 +
 arch/x86/kernel/apic/vector.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 9662290..b988ddf 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -116,6 +116,7 @@ struct irq_data;
 struct irq_cfg {
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
+	unsigned int		dest_apicid;
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 6cedd79..c724ef6 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -188,6 +188,12 @@ next:
 	}
 	free_cpumask_var(tmp_mask);
 
+	if (!err) {
+		/* cache destination APIC IDs into cfg->dest_apicid */
+		err = apic->cpu_mask_to_apicid_and(mask, cfg->domain,
+						   &cfg->dest_apicid);
+	}
+
 	return err;
 }
 
