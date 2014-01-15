Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaAOMZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:25:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaAOMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:25:41 -0500
Date: Wed, 15 Jan 2014 04:25:23 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-d139336700a5f3a560da235e4dfcd286773025d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1389786735-16751-1-git-send-email-bp@alien8.de>
References: <1389786735-16751-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, cpu, amd:
  Fix a shadowed variable situation
Git-Commit-ID: d139336700a5f3a560da235e4dfcd286773025d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 15 Jan 2014 04:25:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d139336700a5f3a560da235e4dfcd286773025d4
Gitweb:     http://git.kernel.org/tip/d139336700a5f3a560da235e4dfcd286773025d4
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 15 Jan 2014 12:52:15 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 15 Jan 2014 04:21:45 -0800

x86, cpu, amd: Fix a shadowed variable situation

Having u32 and struct cpuinfo_x86 * by the same name is not very smart,
although it was ok in this case due to the limited scope of u32 c and it
being used only once in there.

Fix this.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1389786735-16751-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 39bc78d..e5647ab 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -789,14 +789,10 @@ static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 	}
 
 	/* Handle DTLB 2M and 4M sizes, fall back to L1 if L2 is disabled */
-	if (!((eax >> 16) & mask)) {
-		u32 a, b, c, d;
-
-		cpuid(0x80000005, &a, &b, &c, &d);
-		tlb_lld_2m[ENTRIES] = (a >> 16) & 0xff;
-	} else {
+	if (!((eax >> 16) & mask))
+		tlb_lld_2m[ENTRIES] = (cpuid_eax(0x80000005) >> 16) & 0xff;
+	else
 		tlb_lld_2m[ENTRIES] = (eax >> 16) & mask;
-	}
 
 	/* a 4M entry uses two 2M entries */
 	tlb_lld_4m[ENTRIES] = tlb_lld_2m[ENTRIES] >> 1;
