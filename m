Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3IEWvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:51:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51642 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753097Ab3IEWug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:36 -0400
Message-Id: <20130905225034.343366161@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:41 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
Content-Disposition: inline; filename=uv-add-nmi-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For performance reasons, the NMI handler may be disabled to lessen the
performance impact caused by the multiple perf tools running concurently.
If the system nmi command is issued when the UV NMI handler is disabled,
the "Dazed and Confused" messages occur for all cpus.  The NMI handler is
disabled by setting the nmi disabled variable to '1'.  Setting it back to
'0' will re-enable the NMI handler.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 arch/x86/platform/uv/uv_nmi.c |   69 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -73,6 +73,7 @@ static struct uv_hub_nmi_s **uv_hub_nmi_
 DEFINE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_cpu_nmi);
 
+static int uv_nmi_registered;
 static unsigned long nmi_mmr;
 static unsigned long nmi_mmr_clear;
 static unsigned long nmi_mmr_pending;
@@ -130,6 +131,31 @@ module_param_named(ping_count, uv_nmi_pi
 static local64_t uv_nmi_ping_misses;
 module_param_named(ping_misses, uv_nmi_ping_misses, local64, 0644);
 
+static int uv_nmi_disabled;
+static int param_get_disabled(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%u\n", uv_nmi_disabled);
+}
+
+static void uv_nmi_notify_disabled(void);
+static int param_set_disabled(const char *val, const struct kernel_param *kp)
+{
+	int ret = param_set_bint(val, kp);
+
+	if (ret)
+		return ret;
+
+	uv_nmi_notify_disabled();
+	return 0;
+}
+
+static struct kernel_param_ops param_ops_disabled = {
+	.get = param_get_disabled,
+	.set = param_set_disabled,
+};
+#define param_check_disabled(name, p) __param_check(name, p, int)
+module_param_named(disabled, uv_nmi_disabled, disabled, 0644);
+
 /*
  * Following values allow tuning for large systems under heavy loading
  */
@@ -634,6 +660,8 @@ int uv_handle_nmi(unsigned int reason, s
 		atomic_set(&uv_nmi_cpus_in_nmi, -1);
 		atomic_set(&uv_nmi_cpu, -1);
 		atomic_set(&uv_in_nmi, 0);
+		if (uv_nmi_disabled)
+			uv_nmi_notify_disabled();
 	}
 
 	uv_nmi_touch_watchdogs();
@@ -664,11 +692,30 @@ int uv_handle_nmi_ping(unsigned int reas
 
 void uv_register_nmi_notifier(void)
 {
+	if (uv_nmi_registered || uv_nmi_disabled)
+		return;
+
 	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		pr_warn("UV: NMI handler failed to register\n");
 
 	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping"))
 		pr_warn("UV: PING NMI handler failed to register\n");
+
+	uv_nmi_registered = 1;
+	pr_info("UV: NMI handler registered\n");
+}
+
+static void uv_nmi_disabled_msg(void)
+{
+	pr_err("UV: NMI handler disabled, power nmi command will be ignored\n");
+}
+
+static void uv_unregister_nmi_notifier(void)
+{
+	unregister_nmi_handler(NMI_UNKNOWN, "uv");
+	unregister_nmi_handler(NMI_LOCAL, "uvping");
+	uv_nmi_registered = 0;
+	uv_nmi_disabled_msg();
 }
 
 void uv_nmi_init(void)
@@ -688,6 +735,11 @@ void uv_nmi_setup(void)
 	int size = sizeof(void *) * (1 << NODES_SHIFT);
 	int cpu, nid;
 
+	if (uv_nmi_disabled) {
+		uv_nmi_disabled_msg();
+		return;
+	}
+
 	/* Setup hub nmi info */
 	uv_nmi_setup_mmrs();
 	uv_hub_nmi_list = kzalloc(size, GFP_KERNEL);
@@ -709,4 +761,21 @@ void uv_nmi_setup(void)
 	BUG_ON(!uv_nmi_cpu_mask);
 }
 
+static void uv_nmi_notify_disabled(void)
+{
+	if (uv_nmi_disabled) {
+		/* if in nmi, handler will disable when finished */
+		if (atomic_read(&uv_in_nmi))
+			return;
 
+		if (uv_nmi_registered)
+			uv_unregister_nmi_notifier();
+
+	} else {
+		/* nmi control lists not yet allocated? */
+		if (!uv_hub_nmi_list)
+			uv_nmi_setup();
+
+		uv_register_nmi_notifier();
+	}
+}

-- 
