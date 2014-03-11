Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaCKXwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:52:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63168 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaCKXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:52:42 -0400
Date: Wed, 12 Mar 2014 00:53:30 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, sfr@canb.auug.org.au, hpa@zytor.com
Subject: [PATCH v2] perf/x86/uncore: fix compilation warning in
 snb_uncore_imc_init_box()
Message-ID: <20140311235329.GA28624@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a compilation problem (unused variable) with the
new SNB/IVB/HSW uncore IMC code.

In V2, we simplify the fix as suggested by Peter Zjilstra.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 3e5b240..d614f6b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1722,15 +1722,16 @@ static struct attribute_group snb_uncore_imc_format_group = {
 static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
-	u32 addr_lo, addr_hi;
+	int where = SNB_UNCORE_PCI_IMC_BAR_OFFSET;
+	u32 pci_dword;
 	resource_size_t addr;
 
-	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_lo);
-	addr = addr_lo;
+	pci_read_config_dword(pdev, where, &pci_dword);
+	addr = pci_dword;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
-	addr = ((resource_size_t)addr_hi << 32) | addr_lo;
+	  pci_read_config_dword(pdev, where + 4, &pci_dword);
+	  addr |= ((resource_size_t)pci_dword << 32);
 #endif
 
 	addr &= ~(PAGE_SIZE - 1);
