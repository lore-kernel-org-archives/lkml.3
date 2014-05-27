Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaE0IG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:06:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:15206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaE0IGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538015970"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V3 01/37] x86, irq: update high address field when updating affinity for MSI IRQ
Date: Tue, 27 May 2014 16:07:36 +0800
Message-Id: <1401178092-1228-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If x2apic is enabled, the MSI high address field should also be aslo
updated when setting affinity for MSI IRQ, otherwise the MSI IRQ may
target wrong APIC IDs.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9d0a9795a0f8..2de992501a1b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3007,6 +3007,10 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	__get_cached_msi_msg(data->msi_desc, &msg);
 
+	msg.address_hi = MSI_ADDR_BASE_HI;
+	if (x2apic_enabled())
+		msg.address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
+
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-- 
1.7.10.4

