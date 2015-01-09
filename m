Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbbAIBBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 20:01:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:16058 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbbAIBBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 20:01:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="438262232"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
Subject: RE: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
Thread-Topic: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
Thread-Index: AQHQI40vC/jPbCARaECVf0xQIEga65y24g1A
Date: Fri, 9 Jan 2015 01:00:17 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B7326E3282@PGSMSX105.gar.corp.intel.com>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie>
In-Reply-To: <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Subject: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific setup
>
[snippet removed]

>Since the Quark EFI bringup code configures the system to reset on an IMR
Typo: bring-up

>violation, this means that common operations such as mouting an SD based root
Typo: mounting

[snippet removed]

>+config INTEL_GALILEO
>+	bool "Intel Galileo Platform Support"
>+	depends on X86_32 && PCI
>+	select IOSF_MBI
>+	select IMR
>+	---help---
>+	  Intel Galileo platform support. This code is used to tear-down
>+	  BIOS and Grub Isolated Memory Regions used during bootup.
Missing dash. Should be "boot-up".

[snippet removed]

>diff --git a/drivers/platform/x86/intel_galileo.c
>b/drivers/platform/x86/intel_galileo.c
>new file mode 100644
>index 0000000..2a555aa
>--- /dev/null
>+++ b/drivers/platform/x86/intel_galileo.c
>@@ -0,0 +1,175 @@
>+/*
>+ * intel_galileo.c - Intel Galileo platform support.
>+ *
>+ * Copyright(c) 2013 Intel Corporation.
>+ * Copyright(c) 2014 Bryan O'Donoghue <pure.logic@nexus-software.ie>
>+ *
>+ * This platform code provides an entry point to do Galileo specific
>+ * setup. Critically IMRs are policed to ensure the EFI provided memory
Critically --> Critical

>+ * map informing the kernel of it's available memory is consistent with
It's --> its

[snippet removed]

>+
>+enum {
>+	GALILEO_UNKNOWN = 0,
>+	GALILEO_QRK_GEN1,
>+	GALILEO_QRK_GEN2,
>+};
Suggest to drop QRK to kill confusion that it is Quark Gen 1 & 2. 

[snippet removed]

>+#ifdef DEBUG
>+#define SANITY "IMR : sanity error "
>+
>+/**
Per coding style, please just use /* and kill the extra * above and below.

>+ * intel_galileo_imr_sanity
>+ * Verify IMR sanity with some simple tests to verify
>+ * overlap, zero sized allocations
>+ *
>+ * @base: Physical base address of the kernel text section
>+ * @size: Extent of kernel memory to be covered from &_text to
>+&_sinittext
>+ * @return: none
>+ */
>+static void __init
>+intel_galileo_imr_sanity(unsigned long base, unsigned long size) {
>+	/* Test zero zero */
>+	if (imr_add(0, 0, 0, 0, true) == 0)
>+		pr_err(SANITY "zero sized IMR @ 0x00000000\n");

A side-discussion on imr_add():
I would think that we should allow 1KiB IMR setting. Current imr_add() logic
is prohibiting it. So, the 'size' input should be at least 1KiB and imr_add()
internal logic will adjust 'hi' by -1KiB. Please consider ..  
  
>+
>+	/* Test overlap */
>+	if (imr_add(base, size, IMR_NON_SMM, IMR_NON_SMM, true) == 0)
>+		pr_err(SANITY "overlapped IMR @ (0x%08lx - 0x%08lx)\n",
>+		       base, base + size);
>+
>+	/* Try overlap - IMR_ALIGN */
>+	base = base + size - IMR_ALIGN;
>+	if (imr_add(base, size, IMR_NON_SMM, IMR_NON_SMM, true) == 0)
>+		pr_err(SANITY "overlapped IMR @ (0x%08lx - 0x%08lx)\n",
>+		       base, base + size);
>+}
>+#endif
>+
>+/**
>+ * intel_galileo_imr_init
>+ *
>+ * Tear down IMRs used during bootup. BIOS and Grub
boot-up.

>+ * both setup IMRs around compressed kernel, initrd memory
>+ * that need to be removed before the kernel hands out one
>+ * of the IMR encased addresses to a downstream DMA agent
>+ * such as the SD or Ethernet. IMRs on Galileo are setup to
>+ * immediately reset the system on violation - so if you're
>+ * running a root filesystem from SD - you'll need the IMRs
>+ * torn down or you'll find seemingly random resets when using
>+ * your filesystem.
>+ */
>+static void __init intel_galileo_imr_init(void) {
>+	unsigned long base  = virt_to_phys(&_text);
>+	unsigned long size = virt_to_phys(&_sinittext) - base - IMR_ALIGN;
>+	int i, ret;
>+
>+	/* Tear down all existing unlocked IMRs */
>+	for (i = 0; i <= QUARK_X1000_IMR_NUM; i++)
>+		imr_del(i, 0, 0);
>+
>+	/*
>+	 * Setup an IMR around the physical extent of the kernel
>+	 * Non-SMM mode core read/write from/to kernel physical region.
>+	 * IMR locked.
>+	 */
>+	ret = imr_add(base, size, IMR_NON_SMM, IMR_NON_SMM, true);
>+	if (ret)
>+		pr_err("Unable to setup IMR for kernel: (%p - %p)\n",
>+			&_text, &__init_begin);
>+	else
>+		pr_info("IMR protect kernel memory: %ldk (%p - %p)\n",
>+			size >> 10, &_text, &__init_begin);
Perhaps we want to be consistent between using __init_begin & _sinittext?

>+#ifdef DEBUG
>+	intel_galileo_imr_sanity(base, size);
>+#endif
>+}
>+
>+/**
>+ * intel_galileo_init
>+ *
>+ * Identify a Galileo Gen1 or Gen2. If found run code to sanitise the
>+ * kernel memory space of IMRs that are inconsistent with the EFI memory
>map.
>+ */
>+static int __init intel_galileo_init(void) {
>+	int ret = 0, type = GALILEO_UNKNOWN;
type is assigned to either GALILEO_GEN1|2 below anyway.
So, we don't need to declare to UNKNOWN?

[snippet removed]
