Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3B1MPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:15:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab3B1MNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:13:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,755,1355068800"; 
   d="scan'208";a="6787325"
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
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v13] kvm: notify host when the guest is panicked
Date: Thu, 28 Feb 2013 20:13:11 +0800
Message-Id: <1362053604-5839-1-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
In-Reply-To: <cover.1362051581.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/28 20:12:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/28 20:12:19,
	Serialize complete at 2013/02/28 20:12:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can know the guest is panicked when the guest runs on xen.
But we do not have such feature on kvm.

Another purpose of this feature is: management app(for example:
libvirt) can do auto dump when the guest is panicked. If management
app does not do auto dump, the guest's user can do dump by hand if
he sees the guest is panicked.

We have three solutions to implement this feature:
1. use vmcall
2. use I/O port
3. use virtio-serial.

We have decided to avoid touching hypervisor. The reason why I choose
choose the I/O port is:
1. it is easier to implememt
2. it does not depend any virtual device
3. it can work when starting the kernel

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_para.h      | 26 +++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  2 ++
 arch/x86/kernel/Makefile             |  2 +-
 arch/x86/kernel/kvm.c                | 44 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvm_panic.c          | 32 ++++++++++++++++++++++++++
 kernel/panic.c                       |  4 ++++
 6 files changed, 109 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/kvm_panic.c

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 695399f..deae820 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -133,4 +133,30 @@ static inline void kvm_disable_steal_time(void)
 }
 #endif
 
+/* The bit of supported pv event */
+#define KVM_PV_FEATURE_PANICKED	0
+
+/* The pv event value */
+#define KVM_PV_EVENT_PANICKED	1
+
+static inline unsigned int kvm_arch_pv_features(void)
+{
+	return inl(KVM_PV_EVENT_PORT);
+}
+
+static inline unsigned int kvm_arch_pv_has_feature(unsigned int feature)
+{
+	if (kvm_arch_pv_features() & (1UL << feature))
+		return 1;
+	return 0;
+}
+
+static inline void kvm_arch_pv_send_event(unsigned int event)
+{
+	outl(event, KVM_PV_EVENT_PORT);
+}
+
+bool kvm_arch_pv_event_enabled(void);
+int kvm_arch_pv_event_init(void);
+
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 06fdbd9..c15ef33 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -96,5 +96,7 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+#define KVM_PV_EVENT_PORT	(0x505UL)
+
 
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7bd3bd3..f0629b2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -80,7 +80,7 @@ obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
-obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
+obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o kvm_panic.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b686a90..727ef91 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -73,6 +73,20 @@ static int parse_no_kvmclock_vsyscall(char *arg)
 
 early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
 
+static int pv_event = 1;
+static int parse_no_pv_event(char *arg)
+{
+	pv_event = 0;
+	return 0;
+}
+
+bool kvm_arch_pv_event_enabled(void)
+{
+	return !!pv_event;
+}
+
+early_param("no-pv-event", parse_no_pv_event);
+
 static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 static int has_steal_clock = 0;
@@ -386,6 +400,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
+static int
+kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
+{
+	kvm_arch_pv_send_event(KVM_PV_EVENT_PANICKED);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_pv_panic_nb = {
+	.notifier_call = kvm_pv_panic_notify,
+};
+
 static u64 kvm_steal_clock(int cpu)
 {
 	u64 steal;
@@ -463,6 +488,23 @@ static void __init kvm_apf_trap_init(void)
 	set_intr_gate(14, &async_page_fault);
 }
 
+static void __init kvm_pv_panicked_event_init(void)
+{
+	if (kvm_arch_pv_has_feature(KVM_PV_FEATURE_PANICKED))
+		atomic_notifier_chain_register(&panic_notifier_list,
+			&kvm_pv_panic_nb);
+}
+
+static void enable_pv_event(void)
+{
+	if (pv_event) {
+		if (kvm_arch_pv_event_init())
+			return;
+
+		kvm_pv_panicked_event_init();
+	}
+}
+
 void __init kvm_guest_init(void)
 {
 	int i;
@@ -494,6 +536,8 @@ void __init kvm_guest_init(void)
 #else
 	kvm_guest_cpu_init();
 #endif
+
+	enable_pv_event();
 }
 
 static bool __init kvm_detect(void)
diff --git a/arch/x86/kernel/kvm_panic.c b/arch/x86/kernel/kvm_panic.c
new file mode 100644
index 0000000..3df23b7
--- /dev/null
+++ b/arch/x86/kernel/kvm_panic.c
@@ -0,0 +1,32 @@
+/*
+ * KVM panic notification implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2013, Fujitsu, Inc.
+ *   Authors: Wen Congyang <wency@cn.fujitsu.com>
+ *   Authors: Hu Tao <hutao@cn.fujitsu.com>
+ */
+
+#include <uapi/asm/kvm_para.h>
+#include <linux/ioport.h>
+
+int kvm_arch_pv_event_init(void)
+{
+	if (!request_region(KVM_PV_EVENT_PORT, 4, "KVM_PV_EVENT"))
+		return -1;
+
+	return 0;
+}
diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..06dd477 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/kvm_para.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -132,6 +133,9 @@ void panic(const char *fmt, ...)
 	if (!panic_blink)
 		panic_blink = no_blink;
 
+	if (kvm_arch_pv_event_enabled())
+		panic_timeout = 0;
+
 	if (panic_timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
-- 
1.8.1.4

