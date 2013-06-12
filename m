Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3FLUsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:48:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3FLUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:48:21 -0400
Date: Wed, 12 Jun 2013 13:47:22 -0700
From: tip-bot for Jacob Shin <tipbot@zytor.com>
Message-ID: <tip-cd1c32ca969ebfd65e61312c988223bb14f09c2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1370463236-2115-3-git-send-email-jacob.shin@amd.com>
References: <1370463236-2115-3-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, amd: Allow multiple families'
  bin files appended together
Git-Commit-ID: cd1c32ca969ebfd65e61312c988223bb14f09c2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Jun 2013 13:47:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd1c32ca969ebfd65e61312c988223bb14f09c2e
Gitweb:     http://git.kernel.org/tip/cd1c32ca969ebfd65e61312c988223bb14f09c2e
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Wed, 5 Jun 2013 15:13:56 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Jun 2013 13:56:55 -0700

x86, microcode, amd: Allow multiple families' bin files appended together

Add support for parsing through multiple families' microcode patch
container binary files appended together when early loading. This is
already supported on Intel.

Reported-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1370463236-2115-3-git-send-email-jacob.shin@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd_early.c | 50 +++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 7db1e16..4c593c2 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -87,15 +87,21 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 	struct equiv_cpu_entry *eq;
 	u32 *header;
 	u8  *data;
-	u16 eq_id;
+	u16 eq_id = 0;
 	int offset, left;
-	u32 rev, dummy;
+	u32 rev, eax;
 	u32 *new_rev;
+	unsigned long *uoffset;
+	size_t *usize;
 
 #ifdef CONFIG_X86_32
 	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
+	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
+	usize   = (size_t *)__pa_nodebug(&ucode_size);
 #else
 	new_rev = &ucode_new_rev;
+	uoffset = &ucode_offset;
+	usize   = &ucode_size;
 #endif
 
 	data   = ucode;
@@ -108,18 +114,46 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 	    header[2] == 0)                            /* size */
 		return;
 
-	eq     = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
-	offset = header[2] + CONTAINER_HDR_SZ;
-	data  += offset;
-	left  -= offset;
+	eax = cpuid_eax(0x00000001);
+
+	while (left > 0) {
+		eq = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
+
+		offset = header[2] + CONTAINER_HDR_SZ;
+		data  += offset;
+		left  -= offset;
+
+		eq_id = find_equiv_id(eq, eax);
+		if (eq_id)
+			break;
+
+		/*
+		 * support multiple container files appended together. if this
+		 * one does not have a matching equivalent cpu entry, we fast
+		 * forward to the next container file.
+		 */
+		while (left > 0) {
+			header = (u32 *)data;
+			if (header[0] == UCODE_MAGIC &&
+			    header[1] == UCODE_EQUIV_CPU_TABLE_TYPE)
+				break;
+
+			offset = header[1] + SECTION_HDR_SIZE;
+			data  += offset;
+			left  -= offset;
+		}
+
+		offset = data - (u8 *)ucode;
+		*uoffset += offset;
+		*usize   -= offset;
+	}
 
-	eq_id  = find_equiv_id(eq, cpuid_eax(0x00000001));
 	if (!eq_id)
 		return;
 
 	/* find ucode and update if needed */
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
 
 	while (left > 0) {
 		struct microcode_amd *mc;
