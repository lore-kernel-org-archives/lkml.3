Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3AWHUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:20:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3AWHTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:19:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6634050"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 rebased 7/8] allower the user to disable pv event support
Date: Wed, 23 Jan 2013 15:19:28 +0800
Message-Id: <f47a38e12bf8728643b84869292f9f93e104b3aa.1358920534.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1358920534.git.hutao@cn.fujitsu.com>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:39,
	Serialize complete at 2013/01/23 15:18:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 hw/pc_piix.c    | 9 ++++++++-
 qemu-options.hx | 3 ++-
 vl.c            | 4 ++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/hw/pc_piix.c b/hw/pc_piix.c
index fed6ccf..507c98b 100644
--- a/hw/pc_piix.c
+++ b/hw/pc_piix.c
@@ -44,6 +44,7 @@
 #include "exec/memory.h"
 #include "exec/address-spaces.h"
 #include "cpu.h"
+#include "qemu/config-file.h"
 #ifdef CONFIG_XEN
 #  include <xen/hvm/hvm_info_table.h>
 #endif
@@ -86,6 +87,8 @@ static void pc_init1(MemoryRegion *system_memory,
     MemoryRegion *pci_memory;
     MemoryRegion *rom_memory;
     void *fw_cfg = NULL;
+    QemuOptsList *list = qemu_find_opts("machine");
+    bool enable_pv_event = false;
 
     pc_cpus_init(cpu_model);
     pc_acpi_init("acpi-dsdt.aml");
@@ -218,7 +221,11 @@ static void pc_init1(MemoryRegion *system_memory,
         pc_pci_device_init(pci_bus);
     }
 
-    if (kvm_enabled()) {
+    if (list && !QTAILQ_EMPTY(&list->head)) {
+        enable_pv_event = qemu_opt_get_bool(QTAILQ_FIRST(&list->head),
+                                            "enable_pv_event", false);
+    }
+    if (kvm_enabled() && enable_pv_event) {
         kvm_pv_event_init(isa_bus);
     }
 }
diff --git a/qemu-options.hx b/qemu-options.hx
index 4e2b499..7522f4a 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -35,7 +35,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                kernel_irqchip=on|off controls accelerated irqchip support\n"
     "                kvm_shadow_mem=size of KVM shadow MMU\n"
     "                dump-guest-core=on|off include guest memory in a core dump (default=on)\n"
-    "                mem-merge=on|off controls memory merge support (default: on)\n",
+    "                mem-merge=on|off controls memory merge support (default: on)\n"
+    "                enable_pv_event=on|off controls pv event support (default: off)\n",
     QEMU_ARCH_ALL)
 STEXI
 @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
diff --git a/vl.c b/vl.c
index 5aae03f..aa15b23 100644
--- a/vl.c
+++ b/vl.c
@@ -424,6 +424,10 @@ static QemuOptsList qemu_machine_opts = {
             .name = "usb",
             .type = QEMU_OPT_BOOL,
             .help = "Set on/off to enable/disable usb",
+        }, {
+            .name = "enable_pv_event",
+            .type = QEMU_OPT_BOOL,
+            .help = "handle pv event"
         },
         { /* End of list */ }
     },
-- 
1.8.0.1.240.ge8a1f5a

