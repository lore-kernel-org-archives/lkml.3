Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3GWU63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:58:29 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:41217 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3GWU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:58:28 -0400
Date: Tue, 23 Jul 2013 22:58:23 +0200
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86, AMD: fix error path in apply_microcode_amd()
Message-ID: <20130723225823.2e4e7588@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -1 (like Intels apply_microcode) when the loading fails, also
do not set the active microcode level on failure.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

--- a/arch/x86/kernel/microcode_amd.c	2013-07-23 19:42:16.089517717 +0200
+++ b/arch/x86/kernel/microcode_amd.c	2013-07-23 19:43:30.359517091 +0200
@@ -220,12 +220,13 @@ int apply_microcode_amd(int cpu)
 		return 0;
 	}
 
-	if (__apply_microcode_amd(mc_amd))
+	if (__apply_microcode_amd(mc_amd)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
-	else
-		pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
-			mc_amd->hdr.patch_id);
+		return -1;
+	}
+	pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
+		mc_amd->hdr.patch_id);
 
 	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
 	c->microcode = mc_amd->hdr.patch_id;
