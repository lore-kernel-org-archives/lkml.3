Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3GZG4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:56:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44082 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3GZG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:56:20 -0400
From: Rui Wang <ruiv.wang@gmail.com>
To: bhelgaas@google.com
Cc: tony.luck@intel.com, chaohong.guo@intel.com, gong.chen@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>
Subject: [RFC 1/3] IO Hook: core functions and Register Override
Date: Fri, 26 Jul 2013 14:51:13 +0800
Message-Id: <1374821475-3196-2-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
References: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a hook in the core h/w access functions in the kernel.
It also introduces Register Override, which is a set of bits defined in RAM
to override the real value of a h/w register. With the hook in place, access
to h/w registers can be redirected to Register Overrides with user-defined
values, so that h/w states can be emulated easily.

A Register Override can be defined in whatever bit-width, identified by its
address, bitmask, initial value and attributs like read-only, read-write,
write-clear, etc., similar to how a hardware register behaves when accessed.

Jump Label is used, so when the hook is disabled (by default), this adds
only a NOP to the core functions, with zero performance penalty.

This is the first step towards the goal of emulating h/w events.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 arch/x86/Kconfig                  |    7 +
 arch/x86/boot/compressed/Makefile |    1 +
 arch/x86/include/asm/io.h         |   58 +++++-
 arch/x86/vdso/Makefile            |    2 +
 drivers/pci/access.c              |  480 +++++++++++++++++++++++++++++++++++++
 include/linux/reg_ovrd.h          |   46 ++++
 6 files changed, 592 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/reg_ovrd.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe120da..b4fb8b1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2329,6 +2329,13 @@ config X86_DMA_REMAP
 	bool
 	depends on STA2X11
 
+config IO_HOOK
+	bool "hook hardware access functions"
+	default y
+	depends on PCI
+	help
+	  Select this to enable hooking hw access functions
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 5ef205c..73b775c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -9,6 +9,7 @@ targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma v
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
+KBUILD_CFLAGS += -DNO_IO_HOOK
 cflags-$(CONFIG_X86_32) := -march=i386
 cflags-$(CONFIG_X86_64) := -mcmodel=small
 KBUILD_CFLAGS += $(cflags-y)
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index d8e8eef..f2c7065 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -40,14 +40,42 @@
 #include <linux/compiler.h>
 #include <asm/page.h>
 
+#if !defined(NO_IO_HOOK) && defined(CONFIG_IO_HOOK)
+#include <linux/jump_label.h>
+
+extern int do_mem_read_ovrd(void *addr, int size, void *val);
+extern int do_mem_write_ovrd(void *addr, int size, void *val);
+extern struct static_key ovrdhw_enabled;
+
+#define mem_read_ovrd(type, addr) \
+{ \
+	type val;\
+	if (static_key_false(&ovrdhw_enabled)			\
+		&& !do_mem_read_ovrd((void *)addr, sizeof(type), &val))\
+		return val;						\
+}
+
+#define mem_write_ovrd(type, addr, val)	\
+{ \
+	if (static_key_false(&ovrdhw_enabled)			\
+		&& !do_mem_write_ovrd((void *)addr, sizeof(type), &val))\
+		return;							\
+}
+#else /* CONFIG_IO_HOOK */
+#define mem_read_ovrd(type, addr)
+#define mem_write_ovrd(type, addr, val)
+#endif /* CONFIG_IO_HOOK */
+
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
-{ type ret; asm volatile("mov" size " %1,%0":reg (ret) \
+{ type ret; mem_read_ovrd(type, addr);	\
+asm volatile("mov" size " %1,%0" : reg(ret) \
 :"m" (*(volatile type __force *)addr) barrier); return ret; }
 
 #define build_mmio_write(name, size, type, reg, barrier) \
 static inline void name(type val, volatile void __iomem *addr) \
-{ asm volatile("mov" size " %0,%1": :reg (val), \
+{ mem_write_ovrd(type, addr, val);	\
+asm volatile("mov" size " %0,%1" : : reg(val), \
 "m" (*(volatile type __force *)addr) barrier); }
 
 build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
@@ -265,9 +293,34 @@ static inline void slow_down_io(void)
 
 #endif
 
+#if !defined(NO_IO_HOOK) && defined(CONFIG_IO_HOOK)
+extern int do_io_write_ovrd(int port, int len, void *value);
+extern int do_io_read_ovrd(int port, int len, void *value);
+
+#define io_write_ovrd(type, value, port)				\
+{									\
+	if (static_key_false(&ovrdhw_enabled)			\
+		&& !do_io_write_ovrd(port, sizeof(type), &value))	\
+		return;							\
+}
+
+#define io_read_ovrd(type, port)					\
+{									\
+	type val;							\
+	if (static_key_false(&ovrdhw_enabled)			\
+		&& !do_io_read_ovrd(port, sizeof(type), &val))	\
+		return val;						\
+}
+
+#else
+#define io_write_ovrd(type, value, port)
+#define io_read_ovrd(type, port)
+#endif
+
 #define BUILDIO(bwl, bw, type)						\
 static inline void out##bwl(unsigned type value, int port)		\
 {									\
+	io_write_ovrd(type, value, port);				\
 	asm volatile("out" #bwl " %" #bw "0, %w1"			\
 		     : : "a"(value), "Nd"(port));			\
 }									\
@@ -275,6 +328,7 @@ static inline void out##bwl(unsigned type value, int port)		\
 static inline unsigned type in##bwl(int port)				\
 {									\
 	unsigned type value;						\
+	io_read_ovrd(type, port);					\
 	asm volatile("in" #bwl " %w1, %" #bw "0"			\
 		     : "=a"(value) : "Nd"(port));			\
 	return value;							\
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..ea7b089c 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -2,6 +2,8 @@
 # Building vDSO images for x86.
 #
 
+KBUILD_CFLAGS += -DNO_IO_HOOK
+
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 1cc2366..fe7b282 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -5,6 +5,8 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/wait.h>
+#include <linux/reg_ovrd.h>
+#include <linux/jump_label.h>
 
 #include "pci.h"
 
@@ -15,6 +17,480 @@
 
 DEFINE_RAW_SPINLOCK(pci_lock);
 
+#ifdef CONFIG_IO_HOOK
+DEFINE_RAW_SPINLOCK(io_hook_lock);
+
+LIST_HEAD(ovrd_io_reg_map);
+LIST_HEAD(ovrd_mem_reg_map);
+LIST_HEAD(ovrd_pci_conf_reg_map);
+
+struct static_key ovrdhw_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(ovrdhw_enabled);
+
+/* len should only be 1, 2, 4, 8 */
+static int mem_read(u64 address, int len, void *data)
+{
+	int ret = 0;
+
+	switch (len) {
+	case 1:
+		*(u8 *)data = *(u8 *)address;
+		break;
+	case 2:
+		*(u16 *)data = *(u16 *)address;
+		break;
+	case 4:
+		*(u32 *)data = *(u32 *)address;
+		break;
+	case 8:
+		*(u64 *)data = *(u64 *)address;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+
+}
+
+static int mem_write(u64 address, int len, void *value)
+{
+	int ret = 0;
+
+	switch (len) {
+	case 1:
+		*(u8 *)address = *(u8 *)value;
+		break;
+	case 2:
+		*(u16 *)address = *(u16 *)value;
+		break;
+	case 4:
+		*(u32 *)address = *(u32 *)value;
+		break;
+	case 8:
+		*(u64 *)address = *(u64 *)value;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+
+}
+
+/* len should only be 1, 2, 4 */
+static int io_read(u64 address, int len, void *data)
+{
+	int ret = 0;
+	u16 port;
+	u8 bvalue;
+	u16 wvalue;
+	u32 lvalue;
+
+
+	port = (u16)address;
+
+	switch (len) {
+	case 1:
+		asm volatile ("inb %w1, %b0" : "=a"(bvalue) : "Nd"(port));
+		*(u8 *)data = bvalue;
+		break;
+	case 2:
+		asm volatile ("inw %w1, %w0" : "=a"(wvalue) : "Nd"(port));
+		*(u16 *)data = wvalue;
+		break;
+	case 4:
+		asm volatile ("inl %w1, %0" : "=a"(lvalue) : "Nd"(port));
+		*(u32 *)data = lvalue;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+
+}
+
+static int io_write(u64 address, int len, void *data)
+{
+	int ret = 0;
+	u8 bvalue;
+	u16 wvalue, port;
+	u32 lvalue;
+
+	port = (u16)address;
+
+	switch (len) {
+	case 1:
+		bvalue = *(u8 *)data;
+		asm volatile ("outb %b0, %w1" : : "a"(bvalue), "Nd"(port));
+		break;
+	case 2:
+		wvalue = *(u16 *)data;
+		asm volatile ("outw %w0, %w1" : : "a"(wvalue), "Nd"(port));
+		break;
+	case 4:
+		lvalue = *(u32 *)data;
+		asm volatile ("outl %0, %w1" : : "a"(lvalue), "Nd"(port));
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+
+}
+
+/* shift left if i>=0, otherwise shift right */
+#define BYTE_SHIFT(value, i) \
+	((i) >= 0 ? (value) << (i)*8 : (value) >> (-i)*8)
+
+int read_ovrd_common(int spaceid, u64 address, int len, void *value,
+		struct pci_bus *bus)
+{
+	struct list_head *ovrd_list;
+	struct reg_ovrd *ovrd_reg;
+	unsigned long lock_flags = 0, flags = 0;
+	u64 faddress, vaddr = 0;
+	u64 data, bit_mask, attrib, val;
+	unsigned int devfn = 0, pos = 0;
+	int i, flength, res, ret;
+
+	ret = -EINVAL;
+
+	if (spaceid == OVRD_SPACE_MEM) {
+		/* in the case of memory, 'address' is virtual */
+		vaddr = address;
+		address = virt_to_phys((void *)address);
+		ovrd_list = &ovrd_mem_reg_map;
+	} else if (spaceid == OVRD_SPACE_IO) {
+		ovrd_list = &ovrd_io_reg_map;
+	} else if (spaceid == OVRD_SPACE_PCICONF) {
+		devfn = PCI_DECODE_DEVFN(address);
+		pos = PCI_DECODE_POS(address);
+		ovrd_list = &ovrd_pci_conf_reg_map;
+	} else {
+		return ret;
+	}
+
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	list_for_each_entry(ovrd_reg, ovrd_list, node) {
+
+		faddress = ovrd_reg->address;
+		flength = ovrd_reg->length;
+		val = ovrd_reg->val;
+		bit_mask = ovrd_reg->bit_mask;
+		attrib = ovrd_reg->attrib;
+
+		if (address >= faddress + flength ||
+			address + len <= faddress) {
+			/* no overlap, skip */
+			continue;
+		}
+
+		raw_spin_unlock_irqrestore(&io_hook_lock,
+			lock_flags);
+
+		/* at least one byte falls into the overridden range */
+		data = 0;
+		ret = 0;
+		if (!(address >= faddress && address+len <= faddress+flength &&
+			bit_mask == (u64)((1<<flength*8) - 1))) {
+			/* partially overridden. Read from HW for real bits */
+
+			if (spaceid == OVRD_SPACE_MEM) {
+				res = mem_read(vaddr, len, &data);
+			} else if (spaceid == OVRD_SPACE_IO) {
+				res = io_read(address, len, &data);
+			} else if (spaceid == OVRD_SPACE_PCICONF) {
+				raw_spin_lock_irqsave(&pci_lock, flags);
+				res = bus->ops->read(bus, devfn, pos, len,
+							(u32 *)&data);
+				raw_spin_unlock_irqrestore(&pci_lock, flags);
+			} else
+				goto out;
+
+			if (res) {
+				/* failed to read from HW, clear the result */
+				data = 0;
+			}
+		}
+
+		for (i = 0; i < len; i++) {
+			if (address+i >= faddress &&
+				address+i < faddress+flength) {
+				int j, k;
+
+				j = address + i - faddress;
+				k = faddress - address;
+				if (flength <= 8) {
+					/* <= 8 bytes, use bit_mask */
+					u64 byte_mask;
+
+					byte_mask =
+						bit_mask & BYTE_SHIFT(0xff, j);
+					data &= ~BYTE_SHIFT(byte_mask, k);
+					data |= BYTE_SHIFT(val & byte_mask, k);
+					if (attrib == OVRD_RC)
+						ovrd_reg->val &= ~byte_mask;
+
+				} else {
+					/* If flength is > 8, this is
+					 * used to override a consecutive
+					 * range of readonly identical
+					 * bytes.
+					 */
+					data |= (val & 0xff) << i*8;
+				}
+			}
+		}
+
+		switch (len) {
+		case 1:
+			*(u8 *)value = (u8)data;
+			break;
+		case 2:
+			*(u16 *)value = (u16)data;
+			break;
+		case 4:
+			*(u32 *)value = (u32)data;
+			break;
+		case 8:
+			*(u64 *)value = data;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+
+		raw_spin_lock_irqsave(&io_hook_lock,
+			lock_flags);
+	}
+
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+out:
+	return ret;
+}
+
+int write_ovrd_common(int spaceid, u64 address, int len, void *data,
+	struct pci_bus *bus)
+{
+	struct list_head *ovrd_list;
+	struct reg_ovrd *ovrd_reg;
+	unsigned long lock_flags = 0, flags = 0;
+	u64 faddress;
+	u64  bit_mask, val, attrib;
+	unsigned int devfn = 0, pos = 0;
+	int i, flength, res, ret;
+	u64 value;
+
+	ret = -EINVAL;
+
+	if (spaceid == OVRD_SPACE_MEM) {
+		ovrd_list = &ovrd_mem_reg_map;
+	} else if (spaceid == OVRD_SPACE_IO) {
+		ovrd_list = &ovrd_io_reg_map;
+	} else if (spaceid == OVRD_SPACE_PCICONF) {
+		devfn = PCI_DECODE_DEVFN(address);
+		pos = PCI_DECODE_POS(address);
+		ovrd_list = &ovrd_pci_conf_reg_map;
+	} else {
+		return ret;
+	}
+
+	raw_spin_lock_irqsave(&io_hook_lock, lock_flags);
+	list_for_each_entry(ovrd_reg, ovrd_list, node) {
+
+		faddress = ovrd_reg->address;
+		flength = ovrd_reg->length;
+		val = ovrd_reg->val;
+		bit_mask = ovrd_reg->bit_mask;
+		attrib = ovrd_reg->attrib;
+		value = *(u64 *)data;
+
+		if (address >= faddress + flength ||
+			address + len <= faddress) {
+			/* no overlap, skip */
+			continue;
+		}
+
+		ret = 0;
+
+		if (!(address >= faddress && address+len <= faddress+flength &&
+			bit_mask == (u64)((1<<flength*8) - 1))) {
+			/* partially overridden. write to HW for real bits */
+			if (spaceid == OVRD_SPACE_MEM) {
+				res = mem_write(address, len, data);
+			} else if (spaceid == OVRD_SPACE_IO) {
+				res = io_write(address, len, data);
+			} else if (spaceid == OVRD_SPACE_PCICONF) {
+				raw_spin_unlock_irqrestore(&io_hook_lock,
+					lock_flags);
+				raw_spin_lock_irqsave(&pci_lock, flags);
+				bus->ops->write(bus, devfn, pos, len,
+							(u32)value);
+				raw_spin_unlock_irqrestore(&pci_lock, flags);
+				raw_spin_lock_irqsave(&io_hook_lock,
+					lock_flags);
+			} else
+				break;
+		}
+
+		for (i = 0; i < len; i++) {
+			if (address+i >= faddress &&
+				address+i < faddress+flength) {
+				int j, k;
+
+				j = address + i - faddress;
+				k = faddress - address;
+				if (flength <= 8) {
+					/* <= 8 bytes, use bit_mask */
+					u64 byte_mask;
+
+					byte_mask =
+						bit_mask & BYTE_SHIFT(0xff, j);
+					if (attrib == OVRD_RW) {
+						ovrd_reg->val &= ~byte_mask;
+						ovrd_reg->val |=
+							BYTE_SHIFT(value, k)
+								& byte_mask;
+					} else if (attrib == OVRD_WC) {
+						ovrd_reg->val &=
+							~(BYTE_SHIFT(value, k)
+							& byte_mask);
+					}
+
+				}
+				/* if flength > 8, must be OVRD_RO */
+			}
+		}
+
+	}
+
+	raw_spin_unlock_irqrestore(&io_hook_lock, lock_flags);
+
+	return ret;
+}
+
+int pci_bus_read_config_ovrd(struct pci_bus *bus, unsigned int devfn,
+		int pos, int len, void *value)
+{
+	u64 address;
+	int ret;
+
+	address = PCI_ENCODE_ADDR(pci_domain_nr(bus), bus->number, devfn, pos);
+
+	ret = read_ovrd_common(OVRD_SPACE_PCICONF, address, len,
+			value, bus);
+	if (!ret)
+		pr_info("read from %x:%x+%x-%x, ret=%x, val=0x%x\n",
+			bus->number, devfn, pos, len, ret, *(u32 *)value);
+	return ret;
+
+}
+
+int pci_bus_write_config_ovrd(struct pci_bus *bus, unsigned int devfn,
+		int pos, int len, u32 value)
+{
+	u64 address;
+	int ret;
+
+	address = PCI_ENCODE_ADDR(pci_domain_nr(bus), bus->number, devfn, pos);
+	ret = write_ovrd_common(OVRD_SPACE_PCICONF, address, len,
+			&value, bus);
+	if (!ret)
+		pr_info("write to %x:%x+%x-%x, ret=0x%x, val=0x%x\n",
+			bus->number, devfn, pos, len, ret, value);
+	return ret;
+
+
+}
+
+int do_mem_read_ovrd(void *addr, int size, void *val)
+{
+	int ret;
+
+	ret = read_ovrd_common(OVRD_SPACE_MEM, (u64)addr, size,
+			val, NULL);
+	if (!ret)
+		pr_info("read from mem %p-%x, ret=0x%x, val=0x%llx\n",
+			addr, size, ret, (*(u64 *)val) & ((1<<size*8)-1));
+
+	return ret;
+
+}
+EXPORT_SYMBOL(do_mem_read_ovrd);
+
+int do_mem_write_ovrd(void *addr, int size, void *val)
+{
+	int ret;
+
+	ret = write_ovrd_common(OVRD_SPACE_MEM, (u64)addr, size,
+			val, NULL);
+	if (!ret)
+		pr_info("write to mem %p-%x, ret=0x%x, val=0x%llx\n",
+			addr, size, ret, (*(u64 *)val) & ((1<<size*8)-1));
+
+	return ret;
+
+}
+EXPORT_SYMBOL(do_mem_write_ovrd);
+
+int do_io_write_ovrd(int port, int len, void *value)
+{
+	int ret;
+
+	ret = write_ovrd_common(OVRD_SPACE_IO, (u64)port, len,
+			value, NULL);
+	if (!ret)
+		pr_info("write to port %x-%x, ret=0x%x, val=0x%x\n",
+			port, len, ret, (*(u32 *)value) & ((1<<len*8)-1));
+	return ret;
+
+}
+EXPORT_SYMBOL(do_io_write_ovrd);
+
+int do_io_read_ovrd(int port, int len, void *value)
+{
+	int ret;
+
+	ret = read_ovrd_common(OVRD_SPACE_IO, (u64)port, len,
+			value, NULL);
+	if (!ret)
+		pr_info("read from port %x-%x, ret=0x%x, val=0x%x\n",
+			port, len, ret, (*(u32 *)value) & ((1<<len*8)-1));
+	return ret;
+
+}
+EXPORT_SYMBOL(do_io_read_ovrd);
+
+#define pci_read_ovrd(bus, devfn, pos, len, value)			\
+{ \
+	if (static_key_false(&ovrdhw_enabled)			\
+		&& !pci_bus_read_config_ovrd(bus, devfn, pos,	\
+		len, value))						\
+		return 0; \
+}
+
+#define pci_write_ovrd(bus, devfn, pos, len, value)			\
+{ \
+	if (static_key_false(&ovrdhw_enabled)			\
+		&& !pci_bus_write_config_ovrd(bus, devfn, pos,	\
+		len, value))						\
+		return 0; \
+}
+
+#else
+
+#define pci_read_ovrd(bus, devfn, pos, len, value)
+#define pci_write_ovrd(bus, devfn, pos, len, value)
+
+#endif	/* CONFIG_IO_HOOK */
+
 /*
  *  Wrappers for all PCI configuration access functions.  They just check
  *  alignment, do locking and call the low-level functions pointed to
@@ -33,6 +509,7 @@ int pci_bus_read_config_##size \
 	unsigned long flags;						\
 	u32 data = 0;							\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
+	pci_read_ovrd(bus, devfn, pos, len, value);			\
 	raw_spin_lock_irqsave(&pci_lock, flags);			\
 	res = bus->ops->read(bus, devfn, pos, len, &data);		\
 	*value = (type)data;						\
@@ -47,6 +524,7 @@ int pci_bus_write_config_##size \
 	int res;							\
 	unsigned long flags;						\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
+	pci_write_ovrd(bus, devfn, pos, len, value)			\
 	raw_spin_lock_irqsave(&pci_lock, flags);			\
 	res = bus->ops->write(bus, devfn, pos, len, value);		\
 	raw_spin_unlock_irqrestore(&pci_lock, flags);		\
@@ -152,6 +630,7 @@ int pci_user_read_config_##size						\
 	u32 data = -1;							\
 	if (PCI_##size##_BAD)						\
 		return -EINVAL;						\
+	pci_read_ovrd(dev->bus, dev->devfn, pos, sizeof(type), (void *)val);\
 	raw_spin_lock_irq(&pci_lock);				\
 	if (unlikely(dev->block_cfg_access))				\
 		pci_wait_cfg(dev);					\
@@ -173,6 +652,7 @@ int pci_user_write_config_##size					\
 	int ret = -EIO;							\
 	if (PCI_##size##_BAD)						\
 		return -EINVAL;						\
+	pci_write_ovrd(dev->bus, dev->devfn, pos, sizeof(type), val);\
 	raw_spin_lock_irq(&pci_lock);				\
 	if (unlikely(dev->block_cfg_access))				\
 		pci_wait_cfg(dev);					\
diff --git a/include/linux/reg_ovrd.h b/include/linux/reg_ovrd.h
new file mode 100644
index 0000000..5f851fe
--- /dev/null
+++ b/include/linux/reg_ovrd.h
@@ -0,0 +1,46 @@
+#ifndef __REG_OVRD_H__
+#define __REG_OVRD_H__
+
+#include <linux/types.h>
+#include <linux/spinlock_types.h>
+
+#define	OVRD_RW	0	/* readwrite */
+#define	OVRD_RO	1	/* readonly */
+#define	OVRD_RC	4	/* read clear */
+#define	OVRD_WC	8	/* write clear */
+
+/*
+ * address - Starting phys address of the h/w register
+ * length - # of bytes to be overridden
+ * val	-  When length <= 8, use (val & bit_mask) as the overridden value.
+	   When length > 8, we're overriding a range of bytes to a single
+	   readonly value. So attrib must be OVRD_RO, and (val & 0xff)
+	   is the contiguous readonly value.
+ * bit_mask - used when length <= 8 to indicate which bits are being overridden.
+	      unused when length > 8
+ * attrib -   when length <=8, is the common attribute of the overridden
+	      bits matching bit_mask. When length > 8, must be OVRD_RO
+ */
+struct reg_ovrd {
+	struct list_head node;
+	u64 address;
+	u64  val;
+	u64  bit_mask;
+	u32 length;
+	u8  attrib;
+};
+
+/* address space id */
+#define	OVRD_SPACE_IO		0
+#define	OVRD_SPACE_MEM		1
+#define	OVRD_SPACE_PCICONF	2
+
+#define	PCI_ENCODE_ADDR(domain, bus, devfn, pos)	\
+		(((u64)(domain))<<32|(bus)<<20|(devfn)<<12|(pos))
+#define PCI_DECODE_POS(x)	((u16)((x) & ((1 << 12) - 1)))
+#define PCI_DECODE_DEVFN(x)	((u8)(((x) >> 12) & 0xff))
+#define PCI_DECODE_BUSN(x)	((u8)(((x) >> 20) & 0xff))
+#define PCI_DECODE_DOMAIN(x)	((u32)((x) >> 32))
+
+
+#endif			/* __REG_OVRD_H__ */
-- 
1.7.5.4

