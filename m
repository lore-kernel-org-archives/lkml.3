Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaDXK7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:59:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaDXK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:59:08 -0400
Date: Thu, 24 Apr 2014 03:58:40 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-8027197220e02d5cebbbfdff36c2827661fbc692@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, jeremy@goop.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        chrisw@sous-sol.org, tglx@linutronix.de, akataria@vmware.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, jeremy@goop.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de
In-Reply-To: <20140417081719.26341.65542.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081719.26341.65542.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes, x86:
  Prohibit probing on native_set_debugreg()/load_idt()
Git-Commit-ID: 8027197220e02d5cebbbfdff36c2827661fbc692
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8027197220e02d5cebbbfdff36c2827661fbc692
Gitweb:     http://git.kernel.org/tip/8027197220e02d5cebbbfdff36c2827661fbc692
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:17:19 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:02:58 +0200

kprobes, x86: Prohibit probing on native_set_debugreg()/load_idt()

Since the kprobes uses do_debug for single stepping,
functions called from do_debug() before notify_die() must not
be probed.

And also native_load_idt() is called from paranoid_exit when
returning int3, this also must not be probed.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Link: http://lkml.kernel.org/r/20140417081719.26341.65542.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/paravirt.c | 4 +++-
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
