Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3KVXaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:30:22 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41779 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3KVXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:30:16 -0500
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/4] ACPI: Cleanup <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.
Date: Sat, 23 Nov 2013 07:29:08 +0800
Message-Id: <0292f01e89b52e1f6c581fc23684ea2b5f2bb1d8.1385094641.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385094640.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

This patch enfoces <linux/acpi.h> inclusion instead of direct
<acpi/acpi_drivers.h> and <acpi/acpi_bus.h> inclusions.

It's required that <acpi/acpi_bus.h> included prior than
<acpi/acpi_drivers.h> to find declarations for acpi_pci_root.
It is required that <acpi/acpi.h> included prior than <acpi/acpi_drivers.h>
to find declarations for acpi_handle and acpi_notify_handler.

In order to work around this, there are <linux/acpi.h> and <acpi/acpi_bus.h>
inclusions in the <acpi/acpi_drivers.h>.
This messes up the inclusion order in the following style:

  +--<acpi/acpi_drivers.h>
  |
  |  +--<linux/acpi.h>
  |  |
  |  |  +--<acpi/acpi.h> if CONFIG_ACPI=y
  |  |  |
  |  |  +->Included if CONFIG_ACPI=y
  |  |
  |  |  +--<acpi/acpi_bus.h> if CONFIG_ACPI=y
  |  |  |
  |  |  |  +--<acpi/acpi.h> if CONFIG_ACPI=y and CONFIG_ACPI=n
  |  |  |  |
  |  |  |  +->Excluded
  |  |  |
  |  |  +->Included if CONFIG_ACPI=y
  |  |
  |  |  +--<acpi/acpi_drivers.h> if CONFIG_ACPI=y
  |  |  |
  |  |  +->Excluded
  |  |
  |  +->Included if CONFIG_ACPI=y and CONFIG_ACPI=n
  |
  |  +--<acpi/acpi_bus.h>
  |  |
  |  |  +--<acpi/acpi.h> if CONFIG_ACPI=y and CONFIG_ACPI=n
  |  |  |
  |  |  +->Inlcuded if CONFIG_ACPI=n
  |  |
  |  +->Included if CONFIG_ACPI=n
  |
  +->Included if CONFIG_ACPI=y and CONFIG_ACPI=n

              Figure 1.  Current ACPI Headers Inclusion Order

When CONFIG_ACPI is disabled, the result inclusion order of
"#include <acpi/acpi_drivers.h> turns out to be:

  <linux/acpi.h>
  <acpi/acpi.h>
  <acpi/acpi_bus.h>
  <acpi/acpi_drivers.h>

           Figure 2.  ACPI Headers Inclusion Order CONFIG_ACPI=n

When CONFIG_ACPI is enabled, the result inclusion order of
"#include <acpi/acpi_drivers.h> turns out to be:

  <acpi/acpi.h>
  <acpi/acpi_bus.h>
  <linux/acpi.h>
  <acpi/acpi_drivers.h>

           Figure 3.  ACPI Headers Inclusion Order CONFIG_ACPI=n

In order to follow the type dependencies, the best order should be:
  <acpi/acpi.h>
  <acpi/acpi_bus.h>
  <acpi/acpi_drivers.h> or <linux/acpi.h>
  <linux/acpi.h>           <acpi/acpi_drivers.h>

               Figure 4.  Best ACPI Headers Inclusion Order

By investigation, currently <acpi/acpi_drivers.h> are all included for
CONFIG_ACPI=y, thus this is not a real issue but would prevent further
header cleanup work from being achieved.

If we just include <linux/acpi.h> in the <acpi/acpi_drivers.h> and
<acpi/acpi_bus.h> to solve header inclusion order issue, it will easily
form a wrong inclusion order, and a build test would end with the
following error messages:
<stdin>:1220:2: warning: #warning syscall kcmp not implemented [-Wcpp]
<stdin>:1223:2: warning: #warning syscall finit_module not implemented [-Wcpp]
In file included from include/linux/acpi.h:38:0,
                 from include/acpi/acpi_bus.h:30,
                 from drivers/acpi/ac.c:35:
include/acpi/acpi_drivers.h:101:43: warning: 'struct acpi_pci_root' declared inside parameter list [enabled by default]
include/acpi/acpi_drivers.h:101:43: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
In file included from include/acpi/acpi_bus.h:30:0,
                 from drivers/acpi/ac.c:35:
include/linux/acpi.h:272:7: warning: 'struct acpi_device' declared inside parameter list [enabled by default]

So this patch cleans up direct <acpi/acpi_drivers.h> and <acpi/acpi_bus.h>
inclusion by replacing them with <linux/acpi.h> inclusion and removing
<linux/acpi.h> and <acpi/acpi_bus.h> inclusion from the
<acpi/acpi_drivers.h> so that the inclusion order is:

  <acpi/acpi.h>
  <acpi/acpi_bus.h>
  <acpi/acpi_drivers.h>
  <linux/acpi.h>

           Figure 5.  ACPI Headers Inclusion Order CONFIG_ACPI=n

This matches best known ACPI header inclusion order in the Figure 4.

Note that, in some files that already include <linux/acpi.h>, this patch
deletes <acpi/acpi_drivers.h> and <acpi/acpi_bus.h> for them.  If
<linux/acpi.h> inclusion is after original <acpi/acpi_drivers.h> and
<acpi/acpi_bus.h> inclusions, it is moved up so that other ACPI header
files are able to find the definitions of the ACPICA types.

Currently <acpi/acpi_bus.h> is used to put prototypes that are referencing
ACPICA defined types.  As such types are not safe for "#ifndef CONFIG_ACPI"
code blocks, <linux/acpi.h> includes this file with "#ifdef CONFIG_ACPI"
protections.  Directly including <acpi/acpi_bus.h> should only apply to
ACPI dependent code while such code can also include <linux/acpi.h>.  This
patch tries to replace <acpi/acpi_bus.h> inclusions with <linux/acpi.h>
inclusions or delete <acpi/acpi_bus.h> inclusions if there is already
<linux/acpi.h> included for such files.  When deleting, we carefully put
<linux/acpi.h> inclusions before any other ACPI header file inclusions so
that they are able to find ACPICA defined types.

The actual cleanups are done in the following style:

1. CONFIG_ACPI dependent modules, where <linux/acpi.h> is already included.
   We could simply cleanup them by removing <acpi/acpi_drivers.h> and
   <acpi/acpi_bus.h> inclusion.
2. Not CONFIG_ACPI dependent modules, where <linux/acpi.h> is already
   included.  As there isn't code pieces surrounded by "#ifdef CONFIG_ACPI"
   we can simply cleanup them by removing <acpi/acpi_drivers.h> and
   <acpi/acpi_bus.h>.
3. CONFIG_ACPI dependent modules, where <linux/acpi.h> is not included.  We
   can simply cleanup them by replacing <acpi/acpi_drivers.h> and
   <acpi/acpi_bus.h> with <linux/acpi.h>.
4. CONFIG_ACPI enabled code, but only ACPICA types are referenced, we can
   simply cleanup them by replacing <acpi/acpi_drivers.h> and
   <acpi/acpi_bus.h> with <acpi/acpi.h>.  We carefully protect such
   inclusions with "#ifdef CONFIG_ACPI" undeleted.

Tests are done by enabling the modules listed in this patch, build the
kernel with and without this patch applied.  The build output with static
checkers enabled shows only line number differences.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 arch/ia64/hp/common/aml_nfw.c                        |    3 +--
 arch/x86/kernel/apic/apic_flat_64.c                  |    4 +---
 arch/x86/kernel/apic/io_apic.c                       |    3 ---
 arch/x86/platform/olpc/olpc-xo15-sci.c               |    3 +--
 drivers/acpi/ac.c                                    |    3 +--
 drivers/acpi/acpi_extlog.c                           |    1 -
 drivers/acpi/acpi_pad.c                              |    3 +--
 drivers/acpi/battery.c                               |    3 +--
 drivers/acpi/blacklist.c                             |    1 -
 drivers/acpi/bus.c                                   |    2 --
 drivers/acpi/button.c                                |    3 +--
 drivers/acpi/custom_method.c                         |    2 +-
 drivers/acpi/debugfs.c                               |    2 +-
 drivers/acpi/dock.c                                  |    2 --
 drivers/acpi/ec.c                                    |    3 +--
 drivers/acpi/event.c                                 |    2 +-
 drivers/acpi/fan.c                                   |    3 +--
 drivers/acpi/hed.c                                   |    2 --
 drivers/acpi/numa.c                                  |    1 -
 drivers/acpi/osl.c                                   |    1 -
 drivers/acpi/pci_irq.c                               |    2 --
 drivers/acpi/pci_link.c                              |    3 +--
 drivers/acpi/pci_root.c                              |    2 --
 drivers/acpi/power.c                                 |    3 +--
 drivers/acpi/proc.c                                  |    3 +--
 drivers/acpi/processor_core.c                        |    2 +-
 drivers/acpi/processor_idle.c                        |    1 -
 drivers/acpi/processor_perflib.c                     |    3 +--
 drivers/acpi/processor_thermal.c                     |    3 +--
 drivers/acpi/processor_throttling.c                  |    3 +--
 drivers/acpi/sbshc.c                                 |    3 +--
 drivers/acpi/scan.c                                  |    1 -
 drivers/acpi/sleep.c                                 |    2 --
 drivers/acpi/sysfs.c                                 |    2 +-
 drivers/acpi/thermal.c                               |    3 +--
 drivers/acpi/utils.c                                 |    2 --
 drivers/acpi/video.c                                 |    3 +--
 drivers/acpi/wakeup.c                                |    1 -
 drivers/ata/libata-acpi.c                            |    1 -
 drivers/ata/pata_acpi.c                              |    2 +-
 drivers/char/hpet.c                                  |    1 -
 drivers/char/tpm/tpm_ppi.c                           |    1 -
 drivers/gpu/drm/i915/intel_acpi.c                    |    1 -
 drivers/gpu/drm/nouveau/nouveau_acpi.c               |    2 --
 drivers/gpu/drm/radeon/radeon_acpi.c                 |    2 --
 drivers/hv/vmbus_drv.c                               |    1 -
 drivers/hwmon/acpi_power_meter.c                     |    3 +--
 drivers/hwmon/asus_atk0110.c                         |    3 +--
 drivers/input/misc/atlas_btns.c                      |    2 +-
 drivers/pci/hotplug/acpiphp_ibm.c                    |    1 -
 drivers/pci/hotplug/pciehp.h                         |    1 -
 drivers/pci/ioapic.c                                 |    1 -
 drivers/pci/pci-acpi.c                               |    1 -
 drivers/pci/pci-label.c                              |    1 -
 drivers/platform/x86/acer-wmi.c                      |    1 -
 drivers/platform/x86/asus-laptop.c                   |    3 +--
 drivers/platform/x86/asus-wmi.c                      |    3 +--
 drivers/platform/x86/classmate-laptop.c              |    2 +-
 drivers/platform/x86/dell-wmi-aio.c                  |    1 -
 drivers/platform/x86/dell-wmi.c                      |    1 -
 drivers/platform/x86/eeepc-laptop.c                  |    3 +--
 drivers/platform/x86/eeepc-wmi.c                     |    2 +-
 drivers/platform/x86/hp_accel.c                      |    2 +-
 drivers/platform/x86/ideapad-laptop.c                |    3 +--
 drivers/platform/x86/intel-rst.c                     |    2 +-
 drivers/platform/x86/intel-smartconnect.c            |    2 +-
 drivers/platform/x86/intel_menlow.c                  |    3 +--
 drivers/platform/x86/intel_oaktrail.c                |    2 --
 drivers/platform/x86/mxm-wmi.c                       |    3 +--
 drivers/platform/x86/panasonic-laptop.c              |    3 +--
 drivers/platform/x86/pvpanic.c                       |    3 +--
 drivers/platform/x86/samsung-q10.c                   |    2 +-
 drivers/platform/x86/sony-laptop.c                   |    2 --
 drivers/platform/x86/tc1100-wmi.c                    |    3 +--
 drivers/platform/x86/thinkpad_acpi.c                 |    2 +-
 drivers/platform/x86/toshiba_acpi.c                  |    2 +-
 drivers/platform/x86/toshiba_bluetooth.c             |    3 +--
 drivers/platform/x86/wmi.c                           |    2 --
 drivers/platform/x86/xo15-ebook.c                    |    3 +--
 drivers/pnp/pnpacpi/core.c                           |    1 -
 drivers/pnp/pnpacpi/pnpacpi.h                        |    1 -
 drivers/staging/quickstart/quickstart.c              |    2 +-
 drivers/usb/core/usb-acpi.c                          |    1 -
 drivers/xen/xen-acpi-cpuhotplug.c                    |    2 --
 drivers/xen/xen-acpi-memhotplug.c                    |    1 -
 drivers/xen/xen-acpi-pad.c                           |    3 +--
 drivers/xen/xen-acpi-processor.c                     |    3 +--
 include/acpi/acpi_bus.h                              |    1 -
 include/acpi/acpi_drivers.h                          |    2 --
 include/linux/pci_hotplug.h                          |    2 +-
 tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c |    3 +--
 91 files changed, 51 insertions(+), 142 deletions(-)

diff --git a/arch/ia64/hp/common/aml_nfw.c b/arch/ia64/hp/common/aml_nfw.c
index 916ffe7..84715fc 100644
--- a/arch/ia64/hp/common/aml_nfw.c
+++ b/arch/ia64/hp/common/aml_nfw.c
@@ -23,8 +23,7 @@
  */
 
 #include <linux/module.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <asm/sal.h>
 
 MODULE_AUTHOR("Bjorn Helgaas <bjorn.helgaas@hp.com>");
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 00c77cf..ccbf857 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -21,9 +21,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
-#ifdef CONFIG_ACPI
-#include <acpi/acpi_bus.h>
-#endif
+#include <linux/acpi.h>
 
 static struct apic apic_physflat;
 static struct apic apic_flat;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e63a5bd..4d67a75 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -37,9 +37,6 @@
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
-#ifdef CONFIG_ACPI
-#include <acpi/acpi_bus.h>
-#endif
 #include <linux/bootmem.h>
 #include <linux/dmar.h>
 #include <linux/hpet.h>
diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 649a12b..08e350e 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -15,8 +15,7 @@
 #include <linux/power_supply.h>
 #include <linux/olpc-ec.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <asm/olpc.h>
 
 #define DRV_NAME			"olpc-xo15-sci"
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 8711e37..8095943 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -32,8 +32,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index a6869e1..2635a01 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -9,7 +9,6 @@
 
 #include <linux/module.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <linux/cper.h>
 #include <linux/ratelimit.h>
 #include <asm/cpu.h>
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index fc6008f..65610c0 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -28,8 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/clockchips.h>
 #include <linux/slab.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <asm/mwait.h>
 
 #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fbf1ace..e90ef8b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -36,8 +36,7 @@
 #include <linux/suspend.h>
 #include <asm/unaligned.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/power_supply.h>
 
 #define PREFIX "ACPI: "
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 078c4f7..05ee8f6 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -30,7 +30,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <linux/dmi.h>
 
 #include "internal.h"
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index bba9b72..cfea1c5 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -37,8 +37,6 @@
 #include <asm/mpspec.h>
 #endif
 #include <linux/pci.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 #include <acpi/apei.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index c971929..9e3a6cb 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -31,8 +31,7 @@
 #include <linux/seq_file.h>
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <acpi/button.h>
 
 #define PREFIX "ACPI: "
diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index 12b62f2..c68e724 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -7,7 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #include "internal.h"
 
diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
index b55d6a2..6b1919f 100644
--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -5,7 +5,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("debugfs");
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index dcd73cc..9ab9e78 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -32,8 +32,6 @@
 #include <linux/jiffies.h>
 #include <linux/stddef.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ba5b56d..1bd3de4 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -40,8 +40,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <asm/io.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/dmi.h>
 
 #include "internal.h"
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index cae3b38..ef2d730 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -12,7 +12,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/gfp.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index ba3da88..1fb6290 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -29,8 +29,7 @@
 #include <linux/types.h>
 #include <asm/uaccess.h>
 #include <linux/thermal.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index 13b1d39..aafe3ca 100644
--- a/drivers/acpi/hed.c
+++ b/drivers/acpi/hed.c
@@ -25,8 +25,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 #include <acpi/hed.h>
 
 static struct acpi_device_id acpi_hed_ids[] = {
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index a2343a1..9e6816e 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -29,7 +29,6 @@
 #include <linux/errno.h>
 #include <linux/acpi.h>
 #include <linux/numa.h>
-#include <acpi/acpi_bus.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 54a20ff..8507034 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -50,7 +50,6 @@
 #include <asm/uaccess.h>
 
 #include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <acpi/processor.h>
 #include "internal.h"
 
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 41c5e1b..52d45ea 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -37,8 +37,6 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 2652a61..cc5feb9 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -40,8 +40,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 20360e4..dadd0f50 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -35,8 +35,6 @@
 #include <linux/pci-aspm.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 #include <acpi/apei.h>
 
 #include "internal.h"
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index c2ad391..ad7da68 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -42,8 +42,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/sysfs.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include "sleep.h"
 #include "internal.h"
 
diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index 6a5b152..56d30fe 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -5,8 +5,7 @@
 #include <linux/bcd.h>
 #include <asm/uaccess.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #include "sleep.h"
 
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index b3171f3..ad88410 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -11,7 +11,7 @@
 #include <linux/dmi.h>
 #include <linux/slab.h>
 
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <acpi/processor.h>
 
 #include "internal.h"
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 644516d..a1087d8 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -46,7 +46,6 @@
 #include <asm/apic.h>
 #endif
 
-#include <acpi/acpi_bus.h>
 #include <acpi/processor.h>
 
 #define PREFIX "ACPI: "
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 60a7c28..df63370 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -36,8 +36,7 @@
 #include <asm/cpufeature.h>
 #endif
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <acpi/processor.h>
 
 #define PREFIX "ACPI: "
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index d1d2e7f..4af89f9 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -33,9 +33,8 @@
 
 #include <asm/uaccess.h>
 
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 #include <acpi/processor.h>
-#include <acpi/acpi_drivers.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index e7dd2c1..a9de919 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -36,8 +36,7 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <acpi/processor.h>
 
 #define PREFIX "ACPI: "
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index b78bc60..26e5b50 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -8,8 +8,7 @@
  * the Free Software Foundation version 2.
  */
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index fd39459..8870277 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -12,7 +12,6 @@
 #include <linux/dmi.h>
 #include <linux/nls.h>
 
-#include <acpi/acpi_drivers.h>
 
 #include "internal.h"
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 721e949..281e5fd 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -21,8 +21,6 @@
 
 #include <asm/io.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 
 #include "internal.h"
 #include "sleep.h"
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 6dbc3ca..443dc93 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -5,7 +5,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #include "internal.h"
 
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 0d9f46b..ee4e467 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -43,8 +43,7 @@
 #include <linux/device.h>
 #include <asm/uaccess.h>
 #include <linux/thermal.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define PREFIX "ACPI: "
 
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 6d408bf..1336b91 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -30,8 +30,6 @@
 #include <linux/types.h>
 #include <linux/hardirq.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 
 #include "internal.h"
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 995e91b..772ed29 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -39,8 +39,7 @@
 #include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/dmi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/suspend.h>
 #include <acpi/video.h>
 
diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index 7bfbe40..1638401 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -5,7 +5,6 @@
 
 #include <linux/init.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_drivers.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 4372cfa..8e3f8a7 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -20,7 +20,6 @@
 #include <scsi/scsi_device.h>
 #include "libata.h"
 
-#include <acpi/acpi_bus.h>
 
 unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
 module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 73212c9..245609f 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 
 #include <linux/libata.h>
 #include <linux/ata.h>
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 5d9c31d..1538402 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -40,7 +40,6 @@
 #include <asm/div64.h>
 
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <linux/hpet.h>
 
 /*
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 2168d15..98a56c4 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -1,5 +1,4 @@
 #include <linux/acpi.h>
-#include <acpi/acpi_drivers.h>
 #include "tpm.h"
 
 static const u8 tpm_ppi_uuid[] = {
diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index dfff090..7fa3512 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -6,7 +6,6 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/vga_switcheroo.h>
-#include <acpi/acpi_drivers.h>
 
 #include <drm/drmP.h>
 #include "i915_drv.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 95c7404..6763865 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -1,8 +1,6 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
 #include <acpi/video.h>
 #include <acpi/acpi.h>
 #include <linux/mxm-wmi.h>
diff --git a/drivers/gpu/drm/radeon/radeon_acpi.c b/drivers/gpu/drm/radeon/radeon_acpi.c
index 98a9074..f97c34f 100644
--- a/drivers/gpu/drm/radeon/radeon_acpi.c
+++ b/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -25,8 +25,6 @@
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <linux/power_supply.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
 #include <acpi/video.h>
 
 #include <drm/drmP.h>
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 48aad4f..244d9a2 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -30,7 +30,6 @@
 #include <linux/sysctl.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <linux/completion.h>
 #include <linux/hyperv.h>
 #include <linux/kernel_stat.h>
diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 8d40da3..a58a266 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -30,8 +30,7 @@
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/err.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 
 #define ACPI_POWER_METER_NAME		"power_meter"
 ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index dafc63c..9b64d26 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -18,8 +18,7 @@
 #include <linux/err.h>
 
 #include <acpi/acpi.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 
 
 #define ATK_HID "ATK0110"
diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index 5d44023..14833f7 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -29,7 +29,7 @@
 #include <linux/input.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define ACPI_ATLAS_NAME		"Atlas ACPI"
 #define ACPI_ATLAS_CLASS	"Atlas"
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 0d64c41..9b2ccfd 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <acpi/acpi_bus.h>
 #include <linux/sysfs.h>
 #include <linux/kobject.h>
 #include <asm/uaccess.h>
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 541bbe6..f773254 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -164,7 +164,6 @@ static inline const char *slot_name(struct slot *slot)
 
 #ifdef CONFIG_ACPI
 #include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <linux/pci-acpi.h>
 
 void __init pciehp_acpi_slot_detection_init(void);
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 50ce680..2122b2b 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <acpi/acpi_bus.h>
 
 struct ioapic {
 	acpi_handle	handle;
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index f166126..d0e4999 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/pci-aspm.h>
 #include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
 
 #include <linux/pci-acpi.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index d51f45a..dbafcc8 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -29,7 +29,6 @@
 #include <linux/nls.h>
 #include <linux/acpi.h>
 #include <linux/pci-acpi.h>
-#include <acpi/acpi_bus.h>
 #include "pci.h"
 
 #define	DEVICE_LABEL_DSM	0x07
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c9076bd..07eb2c4 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -42,7 +42,6 @@
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 
-#include <acpi/acpi_drivers.h>
 #include <acpi/video.h>
 
 MODULE_AUTHOR("Carlos Corbacho");
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 0e9c169..430b5c3 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -53,8 +53,7 @@
 #include <linux/rfkill.h>
 #include <linux/slab.h>
 #include <linux/dmi.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 
 #define ASUS_LAPTOP_VERSION	"0.42"
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 19c313b..df7ecb9 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -45,8 +45,7 @@
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
 #include <linux/thermal.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <acpi/video.h>
 
 #include "asus-wmi.h"
diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 6dfa8d3..0a16024 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/backlight.h>
 #include <linux/input.h>
 #include <linux/rfkill.h>
diff --git a/drivers/platform/x86/dell-wmi-aio.c b/drivers/platform/x86/dell-wmi-aio.c
index bcf8cc6..dbc97a3 100644
--- a/drivers/platform/x86/dell-wmi-aio.c
+++ b/drivers/platform/x86/dell-wmi-aio.c
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
-#include <acpi/acpi_drivers.h>
 #include <linux/acpi.h>
 #include <linux/string.h>
 
diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index fa9a217..bdf483b 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -32,7 +32,6 @@
 #include <linux/types.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
-#include <acpi/acpi_drivers.h>
 #include <linux/acpi.h>
 #include <linux/string.h>
 #include <linux/dmi.h>
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index aefcc32..cabd567 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -28,8 +28,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/slab.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 #include <linux/uaccess.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index af67e6e..6112933 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -33,7 +33,7 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/dmi.h>
 #include <linux/fb.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 
 #include "asus-wmi.h"
 
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index a8e43cf..aff4d06 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -36,7 +36,7 @@
 #include <linux/uaccess.h>
 #include <linux/leds.h>
 #include <linux/atomic.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include "../../misc/lis3lv02d/lis3lv02d.h"
 
 #define DRIVER_NAME     "hp_accel"
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 6788acc..70b5729 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -26,8 +26,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/rfkill.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
index a2083a9..d45bca3 100644
--- a/drivers/platform/x86/intel-rst.c
+++ b/drivers/platform/x86/intel-rst.c
@@ -20,7 +20,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/platform/x86/intel-smartconnect.c b/drivers/platform/x86/intel-smartconnect.c
index 1838400..04cf5df 100644
--- a/drivers/platform/x86/intel-smartconnect.c
+++ b/drivers/platform/x86/intel-smartconnect.c
@@ -19,7 +19,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
index 11244f8..5d9ab07 100644
--- a/drivers/platform/x86/intel_menlow.c
+++ b/drivers/platform/x86/intel_menlow.c
@@ -38,8 +38,7 @@
 #include <linux/pm.h>
 
 #include <linux/thermal.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_AUTHOR("Thomas Sujith");
 MODULE_AUTHOR("Zhang Rui");
diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
index f6f18cd..8b0d020 100644
--- a/drivers/platform/x86/intel_oaktrail.c
+++ b/drivers/platform/x86/intel_oaktrail.c
@@ -50,8 +50,6 @@
 #include <linux/platform_device.h>
 #include <linux/dmi.h>
 #include <linux/rfkill.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 
 
 #define DRIVER_NAME	"intel_oaktrail"
diff --git a/drivers/platform/x86/mxm-wmi.c b/drivers/platform/x86/mxm-wmi.c
index 0aea63b..3c59c0a 100644
--- a/drivers/platform/x86/mxm-wmi.c
+++ b/drivers/platform/x86/mxm-wmi.c
@@ -20,8 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_AUTHOR("Dave Airlie");
 MODULE_DESCRIPTION("MXM WMI Driver");
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 10d12b2..d3c1782 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -125,8 +125,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 
diff --git a/drivers/platform/x86/pvpanic.c b/drivers/platform/x86/pvpanic.c
index 47ae0c4..c9f6e51 100644
--- a/drivers/platform/x86/pvpanic.c
+++ b/drivers/platform/x86/pvpanic.c
@@ -24,8 +24,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_AUTHOR("Hu Tao <hutao@cn.fujitsu.com>");
 MODULE_DESCRIPTION("pvpanic device driver");
diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
index cae7098..5413f62 100644
--- a/drivers/platform/x86/samsung-q10.c
+++ b/drivers/platform/x86/samsung-q10.c
@@ -15,7 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/backlight.h>
 #include <linux/dmi.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define SAMSUNGQ10_BL_MAX_INTENSITY 7
 
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 47caab0..c46f77a 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -61,8 +61,6 @@
 #include <linux/workqueue.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
-#include <acpi/acpi_drivers.h>
-#include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
 #include <linux/sonypi.h>
 #include <linux/sony-laptop.h>
diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/tc1100-wmi.c
index 9b93fdb..d16193e 100644
--- a/drivers/platform/x86/tc1100-wmi.c
+++ b/drivers/platform/x86/tc1100-wmi.c
@@ -33,8 +33,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/platform_device.h>
 
 #define GUID "C364AC71-36DB-495A-8494-B439D472A505"
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 05e046a..1a773f3 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -84,7 +84,7 @@
 #include <sound/control.h>
 #include <sound/initval.h>
 
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #include <linux/pci_ids.h>
 
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 0cfadb6..886f600 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -57,7 +57,7 @@
 
 #include <asm/uaccess.h>
 
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_AUTHOR("John Belmonte");
 MODULE_DESCRIPTION("Toshiba Laptop ACPI Extras Driver");
diff --git a/drivers/platform/x86/toshiba_bluetooth.c b/drivers/platform/x86/toshiba_bluetooth.c
index 74dd01a..6051963 100644
--- a/drivers/platform/x86/toshiba_bluetooth.c
+++ b/drivers/platform/x86/toshiba_bluetooth.c
@@ -23,8 +23,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@gmail.com>");
 MODULE_DESCRIPTION("Toshiba Laptop ACPI Bluetooth Enable Driver");
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 62e8c22..ba13ade 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -37,8 +37,6 @@
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 
 ACPI_MODULE_NAME("wmi");
 MODULE_AUTHOR("Carlos Corbacho");
diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index 4b1377b..49cbcce 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -18,8 +18,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/input.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 #define MODULE_NAME "xo15-ebook"
 
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 14655a0..e869ba6 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -24,7 +24,6 @@
 #include <linux/pnp.h>
 #include <linux/slab.h>
 #include <linux/mod_devicetable.h>
-#include <acpi/acpi_bus.h>
 
 #include "../base.h"
 #include "pnpacpi.h"
diff --git a/drivers/pnp/pnpacpi/pnpacpi.h b/drivers/pnp/pnpacpi/pnpacpi.h
index 3e60225..051ef96 100644
--- a/drivers/pnp/pnpacpi/pnpacpi.h
+++ b/drivers/pnp/pnpacpi/pnpacpi.h
@@ -1,7 +1,6 @@
 #ifndef ACPI_PNP_H
 #define ACPI_PNP_H
 
-#include <acpi/acpi_bus.h>
 #include <linux/acpi.h>
 #include <linux/pnp.h>
 
diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
index 9f6ebdb..a85c3d6 100644
--- a/drivers/staging/quickstart/quickstart.c
+++ b/drivers/staging/quickstart/quickstart.c
@@ -31,7 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
 
diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 4e243c3..11c6569 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -16,7 +16,6 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/usb/hcd.h>
-#include <acpi/acpi_bus.h>
 
 #include "usb.h"
 
diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuhotplug.c
index 8dae6c1..dbb6406 100644
--- a/drivers/xen/xen-acpi-cpuhotplug.c
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -24,8 +24,6 @@
 #include <linux/cpu.h>
 #include <linux/acpi.h>
 #include <linux/uaccess.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 
 #include <xen/acpi.h>
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memhotplug.c
index 9083f1e..f2872a1 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_drivers.h>
 #include <xen/acpi.h>
 #include <xen/interface/platform.h>
 #include <asm/xen/hypercall.h>
diff --git a/drivers/xen/xen-acpi-pad.c b/drivers/xen/xen-acpi-pad.c
index 59708fd..cd7b8ad 100644
--- a/drivers/xen/xen-acpi-pad.c
+++ b/drivers/xen/xen-acpi-pad.c
@@ -18,8 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <asm/xen/hypercall.h>
 #include <xen/interface/version.h>
 #include <xen/xen-ops.h>
diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 13bc6c3..29b096c 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -28,8 +28,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/syscore_ops.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 #include <acpi/processor.h>
 
 #include <xen/xen.h>
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c602c77..0af9667 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -28,7 +28,6 @@
 
 #include <linux/device.h>
 
-#include <acpi/acpi.h>
 
 /* TBD: Make dynamic */
 #define ACPI_MAX_HANDLES	10
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 1cedfcb..f3f1219 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -26,8 +26,6 @@
 #ifndef __ACPI_DRIVERS_H__
 #define __ACPI_DRIVERS_H__
 
-#include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
 
 #define ACPI_MAX_STRING			80
 
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 430dd96..71294ab 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -176,7 +176,7 @@ struct hotplug_params {
 
 #ifdef CONFIG_ACPI
 #include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 int pci_get_hp_params(struct pci_dev *dev, struct hotplug_params *hpp);
 int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags);
 int acpi_pci_check_ejectable(struct pci_bus *pbus, acpi_handle handle);
diff --git a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
index 66cace6..eafd851 100644
--- a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
+++ b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
@@ -28,8 +28,7 @@
 
 #include <asm/io.h>
 
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
+#include <linux/acpi.h>
 
 static int pm_tmr_ioport = 0;
 
-- 
1.7.10

