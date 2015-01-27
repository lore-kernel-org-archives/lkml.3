Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbbA0VR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:17:27 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:34999 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935AbbA0VRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:17:22 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH 2/3] MIPS: Add CDMM bus support
Date: Tue, 27 Jan 2015 21:16:40 +0000
Message-ID: <1422393401-13543-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
References: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MIPS Common Device Mapped Memory (CDMM) support in the form of a bus
in the standard Linux device model. Each device attached via CDMM is
discoverable via an 8-bit type identifier and may contain a number of
blocks of memory mapped registers in the CDMM region. IRQs are expected
to be handled separately.

Due to the per-cpu (per-VPE for MT cores) nature of the CDMM devices,
all the driver callbacks take place from workqueues which are run on the
right CPU for the device in question, so that the driver doesn't need to
be as concerned about which CPU it is running on. Callbacks also exist
for when CPUs are taken offline, so that any per-CPU resources used by
the driver can be disabled so they don't get forcefully migrated. CDMM
devices are created as children of the CPU device they are attached to.

Any existing CDMM configuration by the bootloader will be inherited,
however platforms wishing to enable CDMM should implement the weak
mips_cdmm_phys_base() function (see asm/cdmm.h) so that the bus driver
knows where it should put the CDMM region in the physical address space
if the bootloader hasn't already enabled it.

A mips_cdmm_early_probe() function is also provided to allow early boot
or particularly low level code to set up the CDMM region and probe for a
specific device type, for example early console or KGDB IO drivers for
the EJTAG Fast Debug Channel (FDC) CDMM device.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/cdmm.h      |  87 +++++
 drivers/bus/Kconfig               |  13 +
 drivers/bus/Makefile              |   1 +
 drivers/bus/mips_cdmm.c           | 710 ++++++++++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h   |   8 +
 scripts/mod/devicetable-offsets.c |   3 +
 scripts/mod/file2alias.c          |  16 +
 7 files changed, 838 insertions(+)
 create mode 100644 arch/mips/include/asm/cdmm.h
 create mode 100644 drivers/bus/mips_cdmm.c

diff --git a/arch/mips/include/asm/cdmm.h b/arch/mips/include/asm/cdmm.h
new file mode 100644
index 000000000000..a1ab6c45f68d
--- /dev/null
+++ b/arch/mips/include/asm/cdmm.h
@@ -0,0 +1,87 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2014 Imagination Technologies Ltd.
+ */
+#ifndef __ASM_CDMM_H
+#define __ASM_CDMM_H
+
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+
+/**
+ * struct mips_cdmm_device - Represents a single device on a CDMM bus.
+ * @dev:	Driver model device object.
+ * @cpu:	CPU which can access this device.
+ * @res:	MMIO resource.
+ * @type:	Device type identifier.
+ * @rev:	Device revision number.
+ */
+struct mips_cdmm_device {
+	struct device		dev;
+	unsigned int		cpu;
+	struct resource		res;
+	unsigned int		type;
+	unsigned int		rev;
+};
+
+/**
+ * struct mips_cdmm_driver - Represents a driver for a CDMM device.
+ * @drv:	Driver model driver object.
+ * @probe	Callback for probing newly discovered devices.
+ * @remove:	Callback to remove the device.
+ * @shutdown:	Callback on system shutdown.
+ * @cpu_down:	Callback when the parent CPU is going down.
+ *		Any CPU pinned threads/timers should be disabled.
+ * @cpu_up:	Callback when the parent CPU is coming back up again.
+ *		CPU pinned threads/timers can be restarted.
+ * @id_table:	Table for CDMM IDs to match against.
+ */
+struct mips_cdmm_driver {
+	struct device_driver	drv;
+	int			(*probe)(struct mips_cdmm_device *);
+	int			(*remove)(struct mips_cdmm_device *);
+	void			(*shutdown)(struct mips_cdmm_device *);
+	int			(*cpu_down)(struct mips_cdmm_device *);
+	int			(*cpu_up)(struct mips_cdmm_device *);
+	const struct mips_cdmm_device_id *id_table;
+};
+
+/**
+ * mips_cdmm_phys_base() - Choose a physical base address for CDMM region.
+ *
+ * Picking a suitable physical address at which to map the CDMM region is
+ * platform specific, so this weak function can be defined by platform code to
+ * pick a suitable value if none is configured by the bootloader.
+ *
+ * This address must be 32kB aligned, and the region occupies a maximum of 32kB
+ * of physical address space which must not be used for anything else.
+ *
+ * Returns:	Physical base address for CDMM region, or 0 on failure.
+ */
+phys_addr_t __weak mips_cdmm_phys_base(void);
+
+extern struct bus_type mips_cdmm_bustype;
+void __iomem *mips_cdmm_early_probe(unsigned int dev_type);
+
+#define to_mips_cdmm_device(d)	container_of(d, struct mips_cdmm_device, dev)
+
+#define mips_cdmm_get_drvdata(d)	dev_get_drvdata(&d->dev)
+#define mips_cdmm_set_drvdata(d,p)	dev_set_drvdata(&d->dev, p)
+
+int mips_cdmm_driver_register(struct mips_cdmm_driver *);
+void mips_cdmm_driver_unregister(struct mips_cdmm_driver *);
+
+/*
+ * module_mips_cdmm_driver() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_mips_cdmm_driver(__mips_cdmm_driver) \
+	module_driver(__mips_cdmm_driver, mips_cdmm_driver_register, \
+			mips_cdmm_driver_unregister)
+
+#endif /* __ASM_CDMM_H */
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index b99729e36860..f1938d3fa0a8 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -20,6 +20,19 @@ config IMX_WEIM
 	  The WEIM(Wireless External Interface Module) works like a bus.
 	  You can attach many different devices on it, such as NOR, onenand.
 
+config MIPS_CDMM
+	bool "MIPS Common Device Mapped Memory (CDMM) Driver"
+	depends on CPU_MIPSR2
+	help
+	  Driver needed for the MIPS Common Device Mapped Memory bus in MIPS
+	  cores. This bus is for per-CPU tightly coupled devices such as the
+	  Fast Debug Channel (FDC).
+
+	  For this to work, either your bootloader needs to enable the CDMM
+	  region at an unused physical address on the boot CPU, or else your
+	  platform code needs to implement mips_cdmm_phys_base() (see
+	  asm/cdmm.h).
+
 config MVEBU_MBUS
 	bool
 	depends on PLAT_ORION
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 2973c18cbcc2..807dd17ef2f8 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_BRCMSTB_GISB_ARB)	+= brcmstb_gisb.o
 obj-$(CONFIG_IMX_WEIM)	+= imx-weim.o
+obj-$(CONFIG_MIPS_CDMM) += mips_cdmm.o
 obj-$(CONFIG_MVEBU_MBUS) += mvebu-mbus.o
 obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
 
diff --git a/drivers/bus/mips_cdmm.c b/drivers/bus/mips_cdmm.c
new file mode 100644
index 000000000000..2afd3e39a860
--- /dev/null
+++ b/drivers/bus/mips_cdmm.c
@@ -0,0 +1,710 @@
+/*
+ * Bus driver for MIPS Common Device Mapped Memory (CDMM).
+ *
+ * Copyright (C) 2014-2015 Imagination Technologies Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/atomic.h>
+#include <linux/err.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <asm/cdmm.h>
+#include <asm/hazards.h>
+#include <asm/mipsregs.h>
+
+/* Access control and status register fields */
+#define CDMM_ACSR_DEVTYPE_SHIFT	24
+#define CDMM_ACSR_DEVTYPE	(255ul << CDMM_ACSR_DEVTYPE_SHIFT)
+#define CDMM_ACSR_DEVSIZE_SHIFT	16
+#define CDMM_ACSR_DEVSIZE	(31ul << CDMM_ACSR_DEVSIZE_SHIFT)
+#define CDMM_ACSR_DEVREV_SHIFT	12
+#define CDMM_ACSR_DEVREV	(15ul << CDMM_ACSR_DEVREV_SHIFT)
+#define CDMM_ACSR_UW		(1ul << 3)
+#define CDMM_ACSR_UR		(1ul << 2)
+#define CDMM_ACSR_SW		(1ul << 1)
+#define CDMM_ACSR_SR		(1ul << 0)
+
+/* Each block of device registers is 64 bytes */
+#define CDMM_DRB_SIZE		64
+
+#define to_mips_cdmm_driver(d)	container_of(d, struct mips_cdmm_driver, drv)
+
+/* Default physical base address */
+static phys_addr_t mips_cdmm_default_base;
+
+/* Bus operations */
+
+static const struct mips_cdmm_device_id *
+mips_cdmm_lookup(const struct mips_cdmm_device_id *table,
+		 struct mips_cdmm_device *dev)
+{
+	int ret = 0;
+
+	for (; table->type; ++table) {
+		ret = (dev->type == table->type);
+		if (ret)
+			break;
+	}
+
+	return ret ? table : NULL;
+}
+
+static int mips_cdmm_match(struct device *dev, struct device_driver *drv)
+{
+	struct mips_cdmm_device *cdev = to_mips_cdmm_device(dev);
+	struct mips_cdmm_driver *cdrv = to_mips_cdmm_driver(drv);
+
+	return mips_cdmm_lookup(cdrv->id_table, cdev) != NULL;
+}
+
+static int mips_cdmm_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct mips_cdmm_device *cdev = to_mips_cdmm_device(dev);
+	int retval = 0;
+
+	retval = add_uevent_var(env, "CDMM_CPU=%u", cdev->cpu);
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "CDMM_TYPE=0x%02x", cdev->type);
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "CDMM_REV=%u", cdev->rev);
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "MODALIAS=mipscdmm:t%02X", cdev->type);
+	return retval;
+}
+
+/* Device attributes */
+
+#define mips_cdmm_attr_func(name,fmt,arg...)				\
+static ssize_t name##_show(struct device *_dev,				\
+			   struct device_attribute *attr, char *buf)	\
+{									\
+	struct mips_cdmm_device *dev = to_mips_cdmm_device(_dev);	\
+	return sprintf(buf, fmt, arg);					\
+}
+
+mips_cdmm_attr_func(cpu, "%u\n", dev->cpu);
+mips_cdmm_attr_func(type, "0x%02x\n", dev->type);
+mips_cdmm_attr_func(revision, "%u\n", dev->rev);
+mips_cdmm_attr_func(resource, "\t%016llx\t%016llx\t%016lx\n",
+	 (unsigned long long)dev->res.start, (unsigned long long)dev->res.end,
+	 dev->res.flags);
+
+static struct device_attribute mips_cdmm_dev_attrs[] = {
+	__ATTR_RO(cpu),
+	__ATTR_RO(type),
+	__ATTR_RO(revision),
+	__ATTR_RO(resource),
+	__ATTR_NULL,
+};
+
+struct bus_type mips_cdmm_bustype = {
+	.name		= "cdmm",
+	.dev_attrs	= mips_cdmm_dev_attrs,
+	.match		= mips_cdmm_match,
+	.uevent		= mips_cdmm_uevent,
+};
+EXPORT_SYMBOL_GPL(mips_cdmm_bustype);
+
+/*
+ * Standard driver callback helpers.
+ *
+ * All the CDMM driver callbacks need to be executed on the appropriate CPU from
+ * workqueues. For the standard driver callbacks we need a work function
+ * (mips_cdmm_{void,int}_work()) to do the actual call from the right CPU, and a
+ * wrapper function (generated with BUILD_PERCPU_HELPER) to arrange for the work
+ * function to be called on that CPU.
+ */
+
+/**
+ * struct mips_cdmm_work_dev - Data for per-device call work.
+ * @fn:		CDMM driver callback function to call for the device.
+ * @dev:	CDMM device to pass to @fn.
+ */
+struct mips_cdmm_work_dev {
+	void			*fn;
+	struct mips_cdmm_device *dev;
+};
+
+/**
+ * mips_cdmm_void_work() - Call a void returning CDMM driver callback.
+ * @data:	struct mips_cdmm_work_dev pointer.
+ *
+ * A work_on_cpu() callback function to call an arbitrary CDMM driver callback
+ * function which doesn't return a value.
+ */
+static long mips_cdmm_void_work(void *data)
+{
+	struct mips_cdmm_work_dev *work = data;
+	void (*fn)(struct mips_cdmm_device *) = work->fn;
+
+	fn(work->dev);
+	return 0;
+}
+
+/**
+ * mips_cdmm_int_work() - Call an int returning CDMM driver callback.
+ * @data:	struct mips_cdmm_work_dev pointer.
+ *
+ * A work_on_cpu() callback function to call an arbitrary CDMM driver callback
+ * function which returns an int.
+ */
+static long mips_cdmm_int_work(void *data)
+{
+	struct mips_cdmm_work_dev *work = data;
+	int (*fn)(struct mips_cdmm_device *) = work->fn;
+
+	return fn(work->dev);
+}
+
+#define _BUILD_RET_void
+#define _BUILD_RET_int	return
+
+/**
+ * BUILD_PERCPU_HELPER() - Helper to call a CDMM driver callback on right CPU.
+ * @_ret:	Return type (void or int).
+ * @_name:	Name of CDMM driver callback function.
+ *
+ * Generates a specific device callback function to call a CDMM driver callback
+ * function on the appropriate CPU for the device, and if applicable return the
+ * result.
+ */
+#define BUILD_PERCPU_HELPER(_ret, _name)				\
+static _ret mips_cdmm_##_name(struct device *dev)			\
+{									\
+	struct mips_cdmm_device *cdev = to_mips_cdmm_device(dev);	\
+	struct mips_cdmm_driver *cdrv = to_mips_cdmm_driver(dev->driver); \
+	struct mips_cdmm_work_dev work = {				\
+		.fn	= cdrv->_name,					\
+		.dev	= cdev,						\
+	};								\
+									\
+	_BUILD_RET_##_ret work_on_cpu(cdev->cpu,			\
+				      mips_cdmm_##_ret##_work, &work);	\
+}
+
+/* Driver callback functions */
+BUILD_PERCPU_HELPER(int, probe)     /* int mips_cdmm_probe(struct device) */
+BUILD_PERCPU_HELPER(int, remove)    /* int mips_cdmm_remove(struct device) */
+BUILD_PERCPU_HELPER(void, shutdown) /* void mips_cdmm_shutdown(struct device) */
+
+
+/* Driver registration */
+
+/**
+ * mips_cdmm_driver_register() - Register a CDMM driver.
+ * @drv:	CDMM driver information.
+ *
+ * Register a CDMM driver with the CDMM subsystem. The driver will be informed
+ * of matching devices which are discovered.
+ *
+ * Returns:	0 on success.
+ */
+int mips_cdmm_driver_register(struct mips_cdmm_driver *drv)
+{
+	drv->drv.bus = &mips_cdmm_bustype;
+
+	if (drv->probe)
+		drv->drv.probe = mips_cdmm_probe;
+	if (drv->remove)
+		drv->drv.remove = mips_cdmm_remove;
+	if (drv->shutdown)
+		drv->drv.shutdown = mips_cdmm_shutdown;
+
+	return driver_register(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(mips_cdmm_driver_register);
+
+/**
+ * mips_cdmm_driver_unregister() - Unregister a CDMM driver.
+ * @drv:	CDMM driver information.
+ *
+ * Unregister a CDMM driver from the CDMM subsystem.
+ */
+void mips_cdmm_driver_unregister(struct mips_cdmm_driver *drv)
+{
+	driver_unregister(&drv->drv);
+}
+EXPORT_SYMBOL_GPL(mips_cdmm_driver_unregister);
+
+
+/* CDMM initialisation and bus discovery */
+
+/**
+ * struct mips_cdmm_bus - Info about CDMM bus.
+ * @phys:		Physical address at which it is mapped.
+ * @regs:		Virtual address where registers can be accessed.
+ * @drbs:		Total number of DRBs.
+ * @drbs_reserved:	Number of DRBs reserved.
+ * @discovered:		Whether the devices on the bus have been discovered yet.
+ * @offline:		Whether the CDMM bus is going offline (or very early
+ *			coming back online), in which case it should be
+ *			reconfigured each time.
+ */
+struct mips_cdmm_bus {
+	phys_addr_t	 phys;
+	void __iomem	*regs;
+	unsigned int	 drbs;
+	unsigned int	 drbs_reserved;
+	bool		 discovered;
+	bool		 offline;
+};
+
+static struct mips_cdmm_bus mips_cdmm_boot_bus;
+static DEFINE_PER_CPU(struct mips_cdmm_bus *, mips_cdmm_buses);
+static atomic_t mips_cdmm_next_id = ATOMIC_INIT(-1);
+
+/**
+ * mips_cdmm_get_bus() - Get the per-CPU CDMM bus information.
+ *
+ * Get information about the per-CPU CDMM bus, if the bus is present.
+ *
+ * The caller must prevent migration to another CPU, either by disabling
+ * pre-emption or by running from a pinned kernel thread.
+ *
+ * Returns:	Pointer to CDMM bus information for the current CPU.
+ *		May return ERR_PTR(-errno) in case of error, so check with
+ *		IS_ERR().
+ */
+static struct mips_cdmm_bus *mips_cdmm_get_bus(void)
+{
+	struct mips_cdmm_bus *bus, **bus_p;
+	unsigned long flags;
+	unsigned int cpu;
+
+	if (!cpu_has_cdmm)
+		return ERR_PTR(-ENODEV);
+
+	cpu = smp_processor_id();
+	/* Avoid early use of per-cpu primitives before initialised */
+	if (cpu == 0)
+		return &mips_cdmm_boot_bus;
+
+	/* Get bus pointer */
+	bus_p = per_cpu_ptr(&mips_cdmm_buses, cpu);
+	local_irq_save(flags);
+	bus = *bus_p;
+	/* Attempt allocation if NULL */
+	if (unlikely(!bus)) {
+		bus = kzalloc(sizeof(*bus), GFP_ATOMIC);
+		if (unlikely(!bus))
+			bus = ERR_PTR(-ENOMEM);
+		else
+			*bus_p = bus;
+	}
+	local_irq_restore(flags);
+	return bus;
+}
+
+/**
+ * mips_cdmm_cur_base() - Find current physical base address of CDMM region.
+ *
+ * Returns:	Physical base address of CDMM region according to cdmmbase CP0
+ *		register, or 0 if the CDMM region is disabled.
+ */
+static phys_addr_t mips_cdmm_cur_base(void)
+{
+	unsigned long cdmmbase = read_c0_cdmmbase();
+	if (!(cdmmbase & MIPS_CDMMBASE_EN))
+		return 0;
+
+	return (cdmmbase >> MIPS_CDMMBASE_ADDR_SHIFT)
+		<< MIPS_CDMMBASE_ADDR_START;
+}
+
+/**
+ * mips_cdmm_setup() - Ensure the CDMM bus is initialised and usable.
+ * @bus:	Pointer to bus information for current CPU.
+ *		IS_ERR(bus) is checked, so no need for caller to check.
+ *
+ * The caller must prevent migration to another CPU, either by disabling
+ * pre-emption or by running from a pinned kernel thread.
+ *
+ * Returns	0 on success, -errno on failure.
+ */
+static int mips_cdmm_setup(struct mips_cdmm_bus *bus)
+{
+	unsigned long cdmmbase, flags;
+	int ret = 0;
+
+	if (IS_ERR(bus))
+		return PTR_ERR(bus);
+
+	local_irq_save(flags);
+	/* Don't set up bus a second time unless marked offline */
+	if (bus->offline) {
+		/* If CDMM region is still set up, nothing to do */
+		if (bus->phys == mips_cdmm_cur_base())
+			goto out;
+		/*
+		 * The CDMM region isn't set up as expected, so it needs
+		 * reconfiguring, but then we can stop checking it.
+		 */
+		bus->offline = false;
+	} else if (bus->phys > 1) {
+		goto out;
+	}
+
+	/* If the CDMM region is already configured, inherit that setup */
+	if (!bus->phys)
+		bus->phys = mips_cdmm_cur_base();
+	/* Otherwise, ask platform code for suggestions */
+	if (!bus->phys && mips_cdmm_phys_base)
+		bus->phys = mips_cdmm_phys_base();
+	/* Otherwise, copy what other CPUs have done */
+	if (!bus->phys)
+		bus->phys = mips_cdmm_default_base;
+	/* Otherwise, complain once */
+	if (!bus->phys) {
+		bus->phys = 1;
+		/*
+		 * If you hit this, either your bootloader needs to set up the
+		 * CDMM on the boot CPU, or else you need to implement
+		 * mips_cdmm_phys_base() for your platform (see asm/cdmm.h).
+		 */
+		pr_err("cdmm%u: Failed to choose a physical base\n",
+		       smp_processor_id());
+	}
+	/* Already complained? */
+	if (bus->phys == 1) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	/* Record our success for other CPUs to copy */
+	mips_cdmm_default_base = bus->phys;
+
+	pr_debug("cdmm%u: Enabling CDMM region at %pa\n",
+		 smp_processor_id(), &bus->phys);
+
+	/* Enable CDMM */
+	cdmmbase = read_c0_cdmmbase();
+	cdmmbase &= (1ul << MIPS_CDMMBASE_ADDR_SHIFT) - 1;
+	cdmmbase |= (bus->phys >> MIPS_CDMMBASE_ADDR_START)
+			<< MIPS_CDMMBASE_ADDR_SHIFT;
+	cdmmbase |= MIPS_CDMMBASE_EN;
+	write_c0_cdmmbase(cdmmbase);
+	tlbw_use_hazard();
+
+	bus->regs = (void __iomem *)CKSEG1ADDR(bus->phys);
+	bus->drbs = 1 + ((cdmmbase & MIPS_CDMMBASE_SIZE) >>
+			 MIPS_CDMMBASE_SIZE_SHIFT);
+	bus->drbs_reserved = !!(cdmmbase & MIPS_CDMMBASE_CI);
+
+out:
+	local_irq_restore(flags);
+	return ret;
+}
+
+/**
+ * mips_cdmm_early_probe() - Minimally probe for a specific device on CDMM.
+ * @dev_type:	CDMM type code to look for.
+ *
+ * Minimally configure the in-CPU Common Device Mapped Memory (CDMM) and look
+ * for a specific device. This can be used to find a device very early in boot
+ * for example to configure an early FDC console device.
+ *
+ * The caller must prevent migration to another CPU, either by disabling
+ * pre-emption or by running from a pinned kernel thread.
+ *
+ * Returns:	MMIO pointer to device memory. The caller can read the ACSR
+ *		register to find more information about the device (such as the
+ *		version number or the number of blocks).
+ *		May return IOMEM_ERR_PTR(-errno) in case of error, so check with
+ *		IS_ERR().
+ */
+void __iomem *mips_cdmm_early_probe(unsigned int dev_type)
+{
+	struct mips_cdmm_bus *bus;
+	void __iomem *cdmm;
+	u32 acsr;
+	unsigned int drb, type, size;
+	int err;
+
+	if (WARN_ON(!dev_type))
+		return IOMEM_ERR_PTR(-ENODEV);
+
+	bus = mips_cdmm_get_bus();
+	err = mips_cdmm_setup(bus);
+	if (err)
+		return IOMEM_ERR_PTR(err);
+
+	/* Skip the first block if it's reserved for more registers */
+	drb = bus->drbs_reserved;
+	cdmm = bus->regs;
+
+	/* Look for a specific device type */
+	for (; drb < bus->drbs; drb += size + 1) {
+		acsr = readl(cdmm + drb * CDMM_DRB_SIZE);
+		type = (acsr & CDMM_ACSR_DEVTYPE) >> CDMM_ACSR_DEVTYPE_SHIFT;
+		if (type == dev_type)
+			return cdmm + drb * CDMM_DRB_SIZE;
+		size = (acsr & CDMM_ACSR_DEVSIZE) >> CDMM_ACSR_DEVSIZE_SHIFT;
+	}
+
+	return IOMEM_ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(mips_cdmm_early_probe);
+
+/**
+ * mips_cdmm_release() - Release a removed CDMM device.
+ * @dev:	Device object
+ *
+ * Clean up the struct mips_cdmm_device for an unused CDMM device. This is
+ * called automatically by the driver core when a device is removed.
+ */
+static void mips_cdmm_release(struct device *dev)
+{
+	struct mips_cdmm_device *cdev = to_mips_cdmm_device(dev);
+
+	kfree(cdev);
+}
+
+/**
+ * mips_cdmm_bus_discover() - Discover the devices on the CDMM bus.
+ * @bus:	CDMM bus information, must already be set up.
+ */
+static void mips_cdmm_bus_discover(struct mips_cdmm_bus *bus)
+{
+	void __iomem *cdmm;
+	u32 acsr;
+	unsigned int drb, type, size, rev;
+	struct mips_cdmm_device *dev;
+	unsigned int cpu = smp_processor_id();
+	int ret = 0;
+	int id = 0;
+
+	/* Skip the first block if it's reserved for more registers */
+	drb = bus->drbs_reserved;
+	cdmm = bus->regs;
+
+	/* Discover devices */
+	bus->discovered = true;
+	pr_info("cdmm%u discovery (%u blocks)\n", cpu, bus->drbs);
+	for (; drb < bus->drbs; drb += size + 1) {
+		acsr = readl(cdmm + drb * CDMM_DRB_SIZE);
+		type = (acsr & CDMM_ACSR_DEVTYPE) >> CDMM_ACSR_DEVTYPE_SHIFT;
+		size = (acsr & CDMM_ACSR_DEVSIZE) >> CDMM_ACSR_DEVSIZE_SHIFT;
+		rev  = (acsr & CDMM_ACSR_DEVREV)  >> CDMM_ACSR_DEVREV_SHIFT;
+
+		if (!type)
+			continue;
+
+		pr_info("cdmm%u-%u: @%u (%#x..%#x), type 0x%02x, rev %u\n",
+			cpu, id, drb, drb * CDMM_DRB_SIZE,
+			(drb + size + 1) * CDMM_DRB_SIZE - 1,
+			type, rev);
+
+		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+		if (!dev)
+			break;
+
+		dev->cpu = cpu;
+		dev->res.start = bus->phys + drb * CDMM_DRB_SIZE;
+		dev->res.end = bus->phys +
+				(drb + size + 1) * CDMM_DRB_SIZE - 1;
+		dev->res.flags = IORESOURCE_MEM;
+		dev->type = type;
+		dev->rev = rev;
+		dev->dev.parent = get_cpu_device(cpu);
+		dev->dev.bus = &mips_cdmm_bustype;
+		dev->dev.id = atomic_inc_return(&mips_cdmm_next_id);
+		dev->dev.release = mips_cdmm_release;
+
+		dev_set_name(&dev->dev, "cdmm%u-%u", cpu, id);
+		++id;
+		ret = device_register(&dev->dev);
+		if (ret) {
+			put_device(&dev->dev);
+			kfree(dev);
+		}
+	}
+}
+
+
+/*
+ * CPU hotplug and initialisation
+ *
+ * All the CDMM driver callbacks need to be executed on the appropriate CPU from
+ * workqueues. For the CPU callbacks, they need to be called for all devices on
+ * that CPU, so the work function calls bus_for_each_dev, using a helper
+ * (generated with BUILD_PERDEV_HELPER) to call the driver callback if the
+ * device's CPU matches.
+ */
+
+/**
+ * BUILD_PERDEV_HELPER() - Helper to call a CDMM driver callback if CPU matches.
+ * @_name:	Name of CDMM driver callback function.
+ *
+ * Generates a bus_for_each_dev callback function to call a specific CDMM driver
+ * callback function for the device if the device's CPU matches that pointed to
+ * by the data argument.
+ *
+ * This is used for informing drivers for all devices on a given CPU of some
+ * event (such as the CPU going online/offline).
+ *
+ * It is expected to already be called from the appropriate CPU.
+ */
+#define BUILD_PERDEV_HELPER(_name)					\
+static int mips_cdmm_##_name##_helper(struct device *dev, void *data)	\
+{									\
+	struct mips_cdmm_device *cdev = to_mips_cdmm_device(dev);	\
+	struct mips_cdmm_driver *cdrv;					\
+	unsigned int cpu = *(unsigned int*)data;			\
+									\
+	if (cdev->cpu != cpu || !dev->driver)				\
+		return 0;						\
+									\
+	cdrv = to_mips_cdmm_driver(dev->driver); 			\
+	if (!cdrv->_name)						\
+		return 0;						\
+	return cdrv->_name(cdev);					\
+}
+
+/* bus_for_each_dev callback helper functions */
+BUILD_PERDEV_HELPER(cpu_down)       /* int mips_cdmm_cpu_down_helper(...) */
+BUILD_PERDEV_HELPER(cpu_up)         /* int mips_cdmm_cpu_up_helper(...) */
+
+/**
+ * mips_cdmm_bus_down() - Tear down the CDMM bus.
+ * @data:	Pointer to unsigned int CPU number.
+ *
+ * This work_on_cpu callback function is executed on a given CPU to call the
+ * CDMM driver cpu_down callback for all devices on that CPU.
+ */
+static long mips_cdmm_bus_down(void *data)
+{
+	struct mips_cdmm_bus *bus;
+	long ret;
+
+	/* Inform all the devices on the bus */
+	ret = bus_for_each_dev(&mips_cdmm_bustype, NULL, data,
+			       mips_cdmm_cpu_down_helper);
+
+	/*
+	 * While bus is offline, each use of it should reconfigure it just in
+	 * case it is first use when coming back online again.
+	 */
+	bus = mips_cdmm_get_bus();
+	if (!IS_ERR(bus))
+		bus->offline = true;
+
+	return ret;
+}
+
+/**
+ * mips_cdmm_bus_up() - Bring up the CDMM bus.
+ * @data:	Pointer to unsigned int CPU number.
+ *
+ * This work_on_cpu callback function is executed on a given CPU to discover
+ * CDMM devices on that CPU, or to call the CDMM driver cpu_up callback for all
+ * devices already discovered on that CPU.
+ *
+ * It is used during initialisation and when CPUs are brought online.
+ */
+static long mips_cdmm_bus_up(void *data)
+{
+	struct mips_cdmm_bus *bus;
+	long ret;
+
+	bus = mips_cdmm_get_bus();
+	ret = mips_cdmm_setup(bus);
+	if (ret)
+		return ret;
+
+	/* Bus now set up, so we can drop the offline flag if still set */
+	bus->offline = false;
+
+	if (!bus->discovered)
+		mips_cdmm_bus_discover(bus);
+	else
+		/* Inform all the devices on the bus */
+		ret = bus_for_each_dev(&mips_cdmm_bustype, NULL, data,
+				       mips_cdmm_cpu_up_helper);
+
+	return ret;
+}
+
+/**
+ * mips_cdmm_cpu_notify() - Take action when a CPU is going online or offline.
+ * @nb:		CPU notifier block .
+ * @action:	Event that has taken place (CPU_*).
+ * @data:	CPU number.
+ *
+ * This notifier is used to keep the CDMM buses updated as CPUs are offlined and
+ * onlined. When CPUs go offline or come back online, so does their CDMM bus, so
+ * devices must be informed. Also when CPUs come online for the first time the
+ * devices on the CDMM bus need discovering.
+ *
+ * Returns:	NOTIFY_OK if event was used.
+ *		NOTIFY_DONE if we didn't care.
+ */
+static int mips_cdmm_cpu_notify(struct notifier_block *nb,
+				unsigned long action, void *data)
+{
+	unsigned int cpu = (unsigned int)data;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		work_on_cpu(cpu, mips_cdmm_bus_up, &cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		work_on_cpu(cpu, mips_cdmm_bus_down, &cpu);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mips_cdmm_cpu_nb = {
+	.notifier_call = mips_cdmm_cpu_notify,
+};
+
+/**
+ * mips_cdmm_init() - Initialise CDMM bus.
+ *
+ * Initialise CDMM bus, discover CDMM devices for online CPUs, and arrange for
+ * hotplug notifications so the CDMM drivers can be kept up to date.
+ */
+static int __init mips_cdmm_init(void)
+{
+	unsigned int cpu;
+	int ret;
+
+	/* Register the bus */
+	ret = bus_register(&mips_cdmm_bustype);
+	if (ret)
+		return ret;
+
+	/* We want to be notified about new CPUs */
+	ret = register_cpu_notifier(&mips_cdmm_cpu_nb);
+	if (ret) {
+		pr_warn("cdmm: Failed to register CPU notifier\n");
+		goto out;
+	}
+
+	/* Discover devices on CDMM of online CPUs */
+	for_each_online_cpu(cpu)
+		work_on_cpu(cpu, mips_cdmm_bus_up, &cpu);
+
+	return 0;
+out:
+	bus_unregister(&mips_cdmm_bustype);
+	return ret;
+}
+subsys_initcall(mips_cdmm_init);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 745def862580..7c23e30bf077 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -551,6 +551,14 @@ struct amba_id {
 	void			*data;
 };
 
+/**
+ * struct mips_cdmm_device_id - identifies devices in MIPS CDMM bus
+ * @type:	Device type identifier.
+ */
+struct mips_cdmm_device_id {
+	__u8	type;
+};
+
 /*
  * Match x86 CPUs for CPU specific drivers.
  * See documentation of "x86_match_cpu" for details.
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index f282516acc7b..fce36d0f6898 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -168,6 +168,9 @@ int main(void)
 	DEVID_FIELD(amba_id, id);
 	DEVID_FIELD(amba_id, mask);
 
+	DEVID(mips_cdmm_device_id);
+	DEVID_FIELD(mips_cdmm_device_id, type);
+
 	DEVID(x86_cpu_id);
 	DEVID_FIELD(x86_cpu_id, feature);
 	DEVID_FIELD(x86_cpu_id, family);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index e614ef689eee..78691d51a479 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1109,6 +1109,22 @@ static int do_amba_entry(const char *filename,
 }
 ADD_TO_DEVTABLE("amba", amba_id, do_amba_entry);
 
+/*
+ * looks like: "mipscdmm:tN"
+ *
+ * N is exactly 2 digits, where each is an upper-case hex digit, or
+ *	a ? or [] pattern matching exactly one digit.
+ */
+static int do_mips_cdmm_entry(const char *filename,
+			      void *symval, char *alias)
+{
+	DEF_FIELD(symval, mips_cdmm_device_id, type);
+
+	sprintf(alias, "mipscdmm:t%02X*", type);
+	return 1;
+}
+ADD_TO_DEVTABLE("mipscdmm", mips_cdmm_device_id, do_mips_cdmm_entry);
+
 /* LOOKS like cpu:type:x86,venVVVVfamFFFFmodMMMM:feature:*,FEAT,*
  * All fields are numbers. It would be nicer to use strings for vendor
  * and feature, but getting those out of the build system here is too
-- 
2.0.5

