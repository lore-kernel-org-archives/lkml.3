Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab3GaRbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:31:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3GaRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:31:12 -0400
Date: Wed, 31 Jul 2013 10:30:49 -0700
From: tip-bot for Torsten Kaiser <tipbot@zytor.com>
Message-ID: <tip-d982057f631df04f8d78321084a1a71ca51f3364@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <20130723225823.2e4e7588@googlemail.com>
References: <20130723225823.2e4e7588@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd, microcode:
  Fix error path in apply_microcode_amd()
Git-Commit-ID: d982057f631df04f8d78321084a1a71ca51f3364
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 10:30:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d982057f631df04f8d78321084a1a71ca51f3364
Gitweb:     http://git.kernel.org/tip/d982057f631df04f8d78321084a1a71ca51f3364
Author:     Torsten Kaiser <just.for.lkml@googlemail.com>
AuthorDate: Tue, 23 Jul 2013 22:58:23 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 31 Jul 2013 08:37:14 -0700

x86, amd, microcode: Fix error path in apply_microcode_amd()

Return -1 (like Intels apply_microcode) when the loading fails, also
do not set the active microcode level on failure.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Link: http://lkml.kernel.org/r/20130723225823.2e4e7588@googlemail.com
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 47ebb1d..7a0adb7 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
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
