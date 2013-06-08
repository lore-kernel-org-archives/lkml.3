Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3FHCWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:22:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:18262
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab3FHCWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:22:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MO1YLC-01-6K0-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V3 2/2] x86/microcode/amd: allow multiple families' bin files appended together
Date: Fri, 7 Jun 2013 21:22:20 -0500
Message-ID: <1370658140-5299-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
References: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
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
 arch/x86/kernel/microcode_amd_early.c |   68 +++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index c783248..1ac6e9a 100644
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
@@ -108,18 +114,50 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
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
 
-	eq_id  = find_equiv_id(eq, cpuid_eax(0x00000001));
-	if (!eq_id)
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
+		/* mark where the next microcode container file starts */
+		offset    = data - (u8 *)ucode;
+		*uoffset += offset;
+		*usize   -= offset;
+		ucode     = data;
+	}
+
+	if (!eq_id) {
+		*usize = 0;
 		return;
+	}
 
 	/* find ucode and update if needed */
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
 
 	while (left > 0) {
 		struct microcode_amd *mc;
@@ -132,15 +170,21 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
 		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
 			if (__apply_microcode_amd(mc) == 0) {
-				if (!(*new_rev))
-					*new_rev = mc->hdr.patch_id;
-				break;
+				rev = mc->hdr.patch_id;
+				*new_rev = rev;
 			}
 
 		offset  = header[1] + SECTION_HDR_SIZE;
 		data   += offset;
 		left   -= offset;
 	}
+
+	/* mark where this microcode container file ends */
+	offset  = *usize - (data - (u8 *)ucode);
+	*usize -= offset;
+
+	if (!(*new_rev))
+		*usize = 0;
 }
 
 void __init load_ucode_amd_bsp(void)
-- 
1.7.9.5


