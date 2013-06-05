Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3FEUOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:14:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35918 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757433Ab3FEUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:14:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MNXS7J-01-9UZ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/2] x86/microcode/amd: allow multiple families' bin files appended together
Date: Wed, 5 Jun 2013 15:13:56 -0500
Message-ID: <1370463236-2115-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
References: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for parsing through multiple families' microcode patch
container binary files appended together when early loading. This is
already supported on Intel.

Reported-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/microcode_amd_early.c |   50 +++++++++++++++++++++++++++------
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
-- 
1.7.9.5


