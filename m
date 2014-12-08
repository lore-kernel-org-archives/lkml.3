Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaLHJn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:43:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaLHJn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:43:27 -0500
Date: Mon, 8 Dec 2014 01:43:11 -0800
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-a18a0f6850d4b286a5ebf02cd5b22fe496b86349@git.kernel.org>
Cc: boris.ostrovsky@oracle.com, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: bp@suse.de, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@kernel.org, boris.ostrovsky@oracle.com, hpa@zytor.com
In-Reply-To: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode: Don'
 t initialize microcode code on paravirt
Git-Commit-ID: a18a0f6850d4b286a5ebf02cd5b22fe496b86349
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

Commit-ID:  a18a0f6850d4b286a5ebf02cd5b22fe496b86349
Gitweb:     http://git.kernel.org/tip/a18a0f6850d4b286a5ebf02cd5b22fe496b86349
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Mon, 1 Dec 2014 16:27:44 -0500
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Sat, 6 Dec 2014 12:59:03 +0100

x86, microcode: Don't initialize microcode code on paravirt

Paravirtual guests are not expected to load microcode into processors
and therefore it is not necessary to initialize microcode loading
logic.

In fact, under certain circumstances initializing this logic may cause
the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
macro which does not work in Xen (the code path that leads to this macro
happens during resume when we call mc_bp_resume()->load_ucode_ap()
->check_loader_disabled_ap())

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2ce9051..ebd232d 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -557,7 +557,7 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
-	if (dis_ucode_ldr)
+	if (paravirt_enabled() || dis_ucode_ldr)
 		return 0;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
