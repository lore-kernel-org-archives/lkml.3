Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaDQIRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:17:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40740 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaDQIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:17:28 -0400
Subject: [PATCH -tip v9 06/26] [BUGFIX] x86: Prohibit probing on
 native_set_debugreg/load_idt
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Wright <chrisw@sous-sol.org>, fche@redhat.com, mingo@redhat.com,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alok Kataria <akataria@vmware.com>
Date: Thu, 17 Apr 2014 17:17:19 +0900
Message-ID: <20140417081719.26341.65542.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prohibit probing on native_set_debugreg and native_load_idt.
Since the kprobes uses do_debug for single stepping,
functions called from do_debug before notify_die must not
be probed.
And also native_load_idt is called from paranoid_exit when
returning int3, this also must not be probed.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/paravirt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index e136869..548d25f 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -390,8 +390,10 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.end_context_switch = paravirt_nop,
 };
 
-/* At this point, native_get_debugreg has a real function entry */
+/* At this point, native_get/set_debugreg has real function entries */
 NOKPROBE_SYMBOL(native_get_debugreg);
+NOKPROBE_SYMBOL(native_set_debugreg);
+NOKPROBE_SYMBOL(native_load_idt);
 
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC


