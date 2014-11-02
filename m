Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaKBRcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:32:33 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60536 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKBRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:32:30 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:32:20 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 04/10] x86: paravirt: Wrap initialization of set_iopl_mask
 in a macro
Message-ID: <d50798c4b4860edfed4f95e34b7ffac3e6622aaf.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow making set_iopl_mask optional later.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/include/asm/paravirt_types.h | 1 +
 arch/x86/kernel/paravirt.c            | 2 +-
 arch/x86/xen/enlighten.c              | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..3caf2a8 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -143,6 +143,7 @@ struct pv_cpu_ops {
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
+#define INIT_SET_IOPL_MASK(f) .set_iopl_mask = f,
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 548d25f..e7969d4 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -383,7 +383,7 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.iret = native_iret,
 	.swapgs = native_swapgs,
 
-	.set_iopl_mask = native_set_iopl_mask,
+	INIT_SET_IOPL_MASK(native_set_iopl_mask)
 	.io_delay = native_io_delay,
 
 	.start_context_switch = paravirt_nop,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1a3f044..8ad0778 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -912,7 +912,7 @@ static void xen_load_sp0(struct tss_struct *tss,
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
-static void xen_set_iopl_mask(unsigned mask)
+static void __maybe_unused xen_set_iopl_mask(unsigned mask)
 {
 	struct physdev_set_iopl set_iopl;
 
@@ -1279,7 +1279,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.write_idt_entry = xen_write_idt_entry,
 	.load_sp0 = xen_load_sp0,
 
-	.set_iopl_mask = xen_set_iopl_mask,
+	INIT_SET_IOPL_MASK(xen_set_iopl_mask)
 	.io_delay = xen_io_delay,
 
 	/* Xen takes care of %gs when switching to usermode for us */
-- 
2.1.1

