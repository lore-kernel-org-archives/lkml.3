Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaGOP0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:26:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61940 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaGOP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:26:51 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
Date: Tue, 15 Jul 2014 08:26:41 -0700
Message-Id: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen doesn't call start_secondary.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

espfix still doesn't seem to work on Xen (it goes boom in some way that
I don't understand right now), but initializing all CPUs instead of just
one of them seems like a good start.

ISTM the right fix is probably to shove the espfix logic into
native_iret and to tweak the paravirt logic so that native_iret always
gets invoked.  I suspect that Xen will need its own implementation of
espfix64 in the hypervisor and that, ultimately, someone may want to
stop initializing espfix64 at all on Xen guests.

 arch/x86/xen/smp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7005974..eea9bcc 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -23,6 +23,7 @@
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/cpu.h>
+#include <asm/espfix.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
@@ -85,6 +86,13 @@ static void cpu_bringup(void)
 
 	xen_setup_cpu_clockevents();
 
+	/*
+	 * Enable the espfix hack for this CPU
+	 */
+#ifdef CONFIG_X86_ESPFIX64
+	init_espfix_ap();
+#endif
+
 	notify_cpu_starting(cpu);
 
 	set_cpu_online(cpu, true);
-- 
1.9.3

