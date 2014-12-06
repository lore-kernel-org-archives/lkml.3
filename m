Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaLFPbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:31:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54221 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbaLFPbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:31:51 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86, microcode: Don't initialize microcode code on paravirt
Date: Sat,  6 Dec 2014 16:31:47 +0100
Message-Id: <1417879908-4851-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1417879908-4851-1-git-send-email-bp@alien8.de>
References: <1417879908-4851-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

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
index 2ce9051174e6..ebd232d7de4d 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -557,7 +557,7 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
-	if (dis_ucode_ldr)
+	if (paravirt_enabled() || dis_ucode_ldr)
 		return 0;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
-- 
2.0.0

