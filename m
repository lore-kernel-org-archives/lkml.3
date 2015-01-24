Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbbAXBsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:48:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:35234 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbbAXBsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:48:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444444774"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQNaqP6SAFPBFoM0O69savO30RmJzOaRAA
Date: Sat, 24 Jan 2015 01:48:25 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B73270D4C5@PGSMSX105.gar.corp.intel.com>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>
 <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
In-Reply-To: <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, there are 1 serious bug & couple of minor bugs that I caught... please fix

>-----Original Message-----
>From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
>Sent: Wednesday, January 21, 2015 10:46 AM
>To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
>dvhart@infradead.org; andy.shevchenko@gmail.com; Ong, Boon Leong; linux-
>kernel@vger.kernel.org
>Cc: Bryan O'Donoghue
>Subject: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
>
>From V1 comment:
Suggest to add a statement on 3 different types of IMR: General IMR, Host Memory
I/O Boundary IMR & System Management Mode IMR. Then, call out that this patch
is meant to support general IMR type only.

>Intel's Quark X1000 SoC contains a set of registers called Isolated Memory
>Regions. IMRs are accessed over the IOSF mailbox interface. IMRs are areas
>carved out of memory that define read/write access rights to the various
>system agents within the Quark system. For a given agent in the system it is
>possible to specify if that agent may read or write an area of memory
>defined by an IMR with a granularity of 1 KiB.
>
>Quark_SecureBootPRM_330234_001.pdf section 4.5 details the concept of IMRs
>quark-x1000-datasheet.pdf section 12.7.4 details the implementation of IMRs
>in silicon.
>
>eSRAM flush, CPU Snoop, CPU SMM Mode, CPU non-SMM mode, RMU and PCIe
>Virtual
>Channels (VC0 and VC1) can have individual read/write access masks applied
>to them for a given memory region in Quark X1000. This enables IMRs to treat
>each memory transaction type listed above on an individual basis and to
>filter appropriately based on the IMR access mask for the memory region.
>Quark supports eight IMRs.
For CPU Snoop, to add (write-only) 

<snip>

>+
>+/**
>+ * imr_enabled - true if an IMR is enabled false otherwise
>+ *
>+ * Determines if an IMR is enabled based on address range and read/write
>+ * mask. An IMR set with an address range set to zero and a read/write
>+ * access mask set to all is considered to be disabled. An IMR in any
>+ * other state - for example set to zero but without read/write access
>+ * all is considered to be enabled. This definition of disabled is how
>+ * firmware switches off an IMR and is maintained in kernel for
>+ * consistency.
>+ *
>+ * @imr:	pointer to IMR descriptor
>+ * @return:	true if IMR enabled false if disabled
>+ */
>+static int imr_enabled(struct imr_regs *imr)
Do we want to make it inline perhaps since it is 1 liner?

>+{
>+	return (imr->rmask != IMR_READ_ACCESS_ALL ||
>+		imr->wmask != IMR_WRITE_ACCESS_ALL ||
>+		imr_to_phys(imr->addr_lo) ||
>+		imr_to_phys(imr->addr_hi));
>+}
>+


>+/**
>+ * imr_write - write an IMR at a given index.
>+ *
>+ * Requires caller to hold imr mutex
>+ * Note lock bits need to be written independently of address bits
>+ *
>+ * @imr_id:	IMR entry to write
>+ * @imr:	IMR structure representing address and access masks
>+ * @lock:	indicates if the IMR lock bit should be applied
>+ * @return:	0 on success or error code passed from mbi_iosf on failure
>+ */
>+static int imr_write(u32 imr_id, struct imr_regs *imr, bool lock)
>+{
<snip>

>+
>+	/* Lock bit must be set separately to addr_lo address bits */
>+	if (lock) {
>+		imr->addr_lo |= IMR_LOCK;
>+		ret = iosf_mbi_write(QRK_MBI_UNIT_MM,
>QRK_MBI_MM_WRITE,
>+					reg - IMR_LOCK_OFF, imr->addr_lo);
>+	}
>+
A bug ... 
We should take ret from above into consideration and not assume it always ret=0 below

>+	local_irq_restore(flags);
>+	return 0;
>+done:
>+	/*
>+	 * If writing to the IOSF failed then we're in an unknown state,
>+	 * likely a very bad state. An IMR in an invalid state will almost
>+	 * certainly lead to a memory access violation.
>+	 */
>+	local_irq_restore(flags);
>+	WARN(ret, "IOSF-MBI write fail range 0x%08x-0x%08x unreliable\n",
>+		imr_to_phys(imr->addr_lo),
>+		imr_to_phys(imr->addr_hi) + IMR_MASK);
>+
>+	return ret;
>+}
>+
<snip>

>+
>+/**
>+ * imr_fixup_size - account for the IMR_ALIGN bytes that addr_hi appends
>+ *
>+ * IMR addr_hi has a built in offset of plus IMR_ALIGN (0x400) bytes from the
>+ * value in the register. We need to subtract IMR_ALIGN bytes from input sizes
>+ * as a result
>+ *
>+ * @size:	input size bytes
>+ * @return:	reduced size
>+ */
>+static unsigned long imr_fixup_size(unsigned long size)
We can make it inline perhaps since it is 1 liner ?

>+{
>+	return size - IMR_ALIGN;
>+}
>+

>+/**
>+ * imr_address_overlap - detects an address overlap
>+ *
>+ * @addr:	address to check against an existing IMR
>+ * @imr:	imr being checked
>+ * @return:	true for overlap false for no overlap
>+ */
Inline?

>+static int imr_address_overlap(unsigned long addr, struct imr_regs *imr)
>+{
>+	return addr >= imr_to_phys(imr->addr_lo) && addr <=
>imr_to_phys(imr->addr_hi);
>+}


>+
>+/**
>+ * imr_add_range - add an Isolated Memory Region
>+ *
>+ * @base:	physical base address of region aligned to 1KiB
>+ * @size:	physical size of region in bytes must be aligned to 1KiB
>+ * @read_mask:	read access mask
>+ * @write_mask:	write access mask
>+ * @lock:	indicates whether or not to permanently lock this region
>+ * @return:	index of the IMR allocated or negative value indicating error
>+ */
>+int imr_add_range(unsigned long base, unsigned long size,
>+	    unsigned int rmask, unsigned int wmask, bool lock)
>+{
>+	unsigned long end = base + size;
>+	int i;
>+	struct imr_regs imr;
>+	int reg;
>+	int ret;
>+
>+	if (imr_dev.init == false)
>+		return -ENODEV;
>+
>+	ret = imr_check_range(base, size);
>+	if (ret)
>+		return ret;
>+
>+	if (size < IMR_ALIGN)
>+		return -EINVAL;
I believe this is redundant because imr_check_range() has test for (size & IMR_MASK) 
which means if the size is indeed smaller than 0x400, the test will caught it anyway. 

>+
>+	/* Tweak the size value */
>+	size = imr_fixup_size(size);
>+
>+	mutex_lock(&imr_dev.lock);
>+
>+	/*
>+	 * Find a free IMR while checking for an existing overlapping range.
>+	 * Note there's no restriction in silicon to prevent IMR overlaps.
>+	 * For the sake of simplicity and ease in defining/debugging an IMR
>+	 * memory map we exclude IMR overlaps.
>+	 */
>+	reg = -1;
>+	for (i = 0; i < imr_dev.max_imr; i++) {
>+		ret = imr_read(i, &imr);
>+		if (ret)
>+			goto done;
>+
>+		/* Find overlap @ base or end of requested range */
>+		if (imr_enabled(&imr)) {
>+			if (imr_address_overlap(base, &imr)) {
>+				ret = -EINVAL;
>+				goto done;
>+			}
>+			if (imr_address_overlap(end, &imr)) {
>+				ret = -EINVAL;
>+				goto done;
>+			}
>+		} else {
>+			reg = i;
>+		}
>+	}
>+
>+	/* Error out if we have no free IMR entries */
>+	if (reg == -1) {
>+		ret = -ENODEV;
>+		goto done;
>+	}
>+
>+	pr_debug("IMR %d phys 0x%08lx-0x%08lx rmask 0x%08x wmask
>0x%08x\n",
>+		reg, base, end, rmask, wmask);
Do we want to account for the 'size fixup' above on 'end'
>+
>+	/* Allocate IMR */
>+	imr.addr_lo = phys_to_imr(base);
>+	imr.addr_hi = phys_to_imr(end);

The fix-up size above is never factored here ...
'end-size' should be the correct one

>+	imr.rmask = rmask;
>+	imr.wmask = wmask;
>+
>+	ret = imr_write(reg, &imr, lock);
>+
>+done:
>+	mutex_unlock(&imr_dev.lock);
>+	return ret == 0 ? reg : ret;
>+}
>+EXPORT_SYMBOL(imr_add_range);



>+
>+/**
>+ * imr_remove_range - delete an Isolated Memory Region
>+ *
>+ * This function allows you to delete an IMR by it's index specified by reg or
It's --> its

>+ * by address range specified by base and size respectively. If you specify an
>+ * index on it's own the base and size parameters are ignored.
its ..

>+ * imr_remove_range(0, size, base); delete IMR at index 0 base/size ignored
>+ * imr_remove_range(-1, base, size); delete IMR from base to base+size
>+ *
>+ * @reg:	imr index to remove
>+ * @base:	physical base address of region aligned to 4k
It should be 1-KiB. 

>+ * @size:	physical size of region in bytes
Please add " aligned to 1-KiB"

>+ * @return:	-EINVAL on invalid range or out or range id
>+ *		-ENODEV if reg is valid but no IMR exists or is locked
>+ *		0 on success
>+ */
>+int imr_remove_range(int reg, unsigned long base, unsigned long size)
>+{
>+	struct imr_regs imr;
>+	int found = 0, i, ret = 0;
Please make each of the defined variables as individual line here..

>+	unsigned long  max = base + size;
>+
>+	if (imr_dev.init == false)
>+		return -ENODEV;
>+
>+	if (imr_check_range(base, size))
>+		return -EINVAL;
>+
>+	if (reg >= imr_dev.max_imr)
>+		return -EINVAL;
>+
>+	/* Tweak the size value */
>+	size = imr_fixup_size(size);
>+
>+	mutex_lock(&imr_dev.lock);
>+
>+	if (reg >= 0) {
>+		/* If a specific IMR is given try to use it */
>+		ret = imr_read(reg, &imr);
>+		if (ret)
>+			goto done;
>+
>+		if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK) {
>+			ret = -ENODEV;
>+			goto done;
>+		}
>+		found = 1;
>+
>+	} else {
>+		/* Search for match based on address range */
>+		for (i = 0; i < imr_dev.max_imr; i++) {
>+			ret = imr_read(reg, &imr);
A serious bug here.... 'reg' should be 'i' . We enter this branch if reg=-1
Is there a miss in your test case? 

>+			if (ret)
>+				goto done;
>+
>+			if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK)
>+				continue;
>+
>+			if ((imr_to_phys(imr.addr_lo) == base) &&
>+			    (imr_to_phys(imr.addr_hi) == max)) {
I think we need to take care of the size that has been fix-up here ...

>+				found = 1;
>+				reg = i;
>+				break;
>+			}
>+		}
>+	}
>+
>+	if (found == 0) {
>+		ret = -ENODEV;
>+		goto done;
>+	}
>+
>+	/* Tear down the IMR */
>+	imr.addr_lo = 0;
>+	imr.addr_hi = 0;
>+	imr.rmask = IMR_READ_ACCESS_ALL;
>+	imr.wmask = IMR_WRITE_ACCESS_ALL;
>+
>+	ret = imr_write(reg, &imr, false);
>+
>+done:
>+	mutex_unlock(&imr_dev.lock);
>+	return ret;
>+}
>+EXPORT_SYMBOL(imr_remove_range);
>+
>+#ifdef CONFIG_DEBUG_IMR_SELFTEST
<snip>

>+/**
>+ * imr_self_test
>+ *
>+ * Verify IMR self_test with some simple tests to verify overlap,
>+ * zero sized allocations and 1 KiB sized areas.
>+ *
>+ * @base:	physical base address of the kernel text section
>+ * @size:	extent of kernel memory to be covered from &_text to
>&__end_rodata
>+ */
>+static void __init imr_self_test(unsigned long base, unsigned long size)
>+{
>+	const char *fmt_over = "overlapped IMR @ (0x%08lx - 0x%08lx)\n";
>+	int idx;
>+
>+	/* Test zero zero */
>+	idx = imr_add_range(0, 0, 0, 0, false);
>+	imr_self_test_result(idx < 0, "zero sized IMR\n");
>+
>+	/* Test exact overlap */
>+	idx = imr_add_range(base, size, IMR_CPU, IMR_CPU, false);
>+	imr_self_test_result(idx < 0, fmt_over, __va(base), __va(base + size));
>+
>+	/* Test overlap with base inside of existing */
>+	base += size - IMR_ALIGN;
>+	idx = imr_add_range(base, size, IMR_CPU, IMR_CPU, false);
>+	imr_self_test_result(idx < 0, fmt_over, __va(base), __va(base + size));
>+
>+	/* Test overlap with end inside of existing */
>+	base -= size + IMR_ALIGN * 2;
>+	idx = imr_add_range(base, size, IMR_CPU, IMR_CPU, false);
>+	imr_self_test_result(idx < 0, fmt_over, __va(base), __va(base + size));
>+
>+	/* Test 1 KiB works */
>+	idx = imr_add_range(0, IMR_ALIGN, IMR_READ_ACCESS_ALL,
>+			    IMR_WRITE_ACCESS_ALL, false);
>+	imr_self_test_result(idx >= 0, "1KiB IMR @ 0x00000000\n");
>+
>+	/* Tear-tow 1 KiB if previous was successful */
>+	if (idx >= 0) {
>+		idx = imr_remove_range(idx, 0, 0);
>+		imr_self_test_result(idx == 0, "teardown 1KiB @
>0x00000000\n");
>+	}
Ok, since there is a serious bug for imr_remove_range(-1, ... ), please add a test case for that. 

>+}
>+#endif /* CONFIG_DEBUG_IMR_SELFTEST */
>+
>+/**
>+ * imr_fixup_memmap - Tear down IMRs used during bootup.
>+ *
>+ * BIOS and Grub both setup IMRs around compressed kernel, initrd memory
>+ * that need to be removed before the kernel hands out one of the IMR
>+ * encased addresses to a downstream DMA agent such as the SD or Ethernet.
>+ * IMRs on Galileo are setup to immediately reset the system on violation.
>+ * As a result if you're running a root filesystem from SD - you'll need
>+ * the boot-time IMRs torn down or you'll find seemingly random resets when
>+ * using your filesystem.
>+ */
>+static void __init imr_fixup_memmap(void)
>+{
>+	unsigned long base  = virt_to_phys(&_text);
>+	unsigned long size = virt_to_phys(&__end_rodata) - base;
What about the size fixup to be consistent? 
We should not guard more than it is needed ..... 

>+	int i, ret;
Two int declaration line here.

>+
>+	/* Tear down all existing unlocked IMRs */
>+	for (i = 0; i < imr_dev.max_imr; i++)
>+		imr_remove_range(i, 0, 0);
>+
>+	/*
>+	 * Setup a locked IMR around the physical extent of the kernel
>+	 * from the beginning of the .text secton to the end of the
>+	 * .rodata section.
>+	 *
>+	 * This behaviour relies on the kernel .text and .rodata
>+	 * sections being physically contiguous and .rodata ending on 1
>+	 * KiB aligned boundary - such as a page boundary. Linker script
>+	 * The definition of this memory map is in:
>+	 * arch/x86/kernel/vmlinux.lds
>+	 * .text begin = &_stext
>+	 * .rodata end = &__end_rodata - aligned to 4KiB
>+	 */
>+	ret = imr_add_range(base, size, IMR_CPU, IMR_CPU, true);
>+	if (ret < 0)
>+		pr_err("unable to setup IMR for kernel: (%p - %p)\n",
>+			&_text, &__end_rodata);
>+	else
>+		pr_info("protecting kernel .text - .rodata: %ldk (%p - %p)\n",
>+			size / 1024, &_text, &__end_rodata);
>+
>+#ifdef CONFIG_DEBUG_IMR_SELFTEST
>+	/* Run optional self test */
>+	imr_self_test(base, size);
>+#endif
>+}
>+
>+static const struct x86_cpu_id imr_ids[] __initconst = {
>+	{ X86_VENDOR_INTEL, 5, 9 },	/* Intel Quark SoC X1000 */
>+	{}
>+};
>+MODULE_DEVICE_TABLE(x86cpu, imr_ids);
>+
>+/**
>+ * imr_probe - entry point for IMR driver
>+ *
>+ * return: -ENODEV for no IMR support 0 if good to go
>+ */
>+static int __init imr_init(void)
>+{
>+	int ret;
>+
>+	if (!x86_match_cpu(imr_ids) || !iosf_mbi_available())
>+		return -ENODEV;
>+
>+#ifdef CONFIG_DEBUG_FS
>+	ret = imr_debugfs_register();
>+	if (ret != 0)
>+		return ret;
>+#endif
>+
>+	imr_dev.max_imr = QUARK_X1000_IMR_MAX;
>+	imr_dev.reg_base = QUARK_X1000_IMR_REGBASE;
>+
>+	mutex_init(&imr_dev.lock);
>+
>+	imr_dev.init = true;
>+	imr_fixup_memmap();
>+
>+	return 0;
>+}
>+
>+/**
>+ * imr_exit - exit point for IMR code
>+ * Deregisters debugfs, leave IMR state as-is.
>+ *
>+ * return:
>+ */
>+static void __exit imr_exit(void)
>+{
>+#ifdef CONFIG_DEBUG_FS
>+	imr_debugfs_unregister();
>+#endif
>+}
>+
>+module_init(imr_init);
>+module_exit(imr_exit);
>+
>+MODULE_AUTHOR("Bryan O'Donoghue <pure.logic@nexus-software.ie>");
>+MODULE_DESCRIPTION("Intel Isolated Memory Region driver");
>+MODULE_LICENSE("GPL");
>--
>1.9.1

