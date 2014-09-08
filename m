Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaIHRr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:47:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45240 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbaIHRry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:54 -0400
X-Sasl-enc: kezXkg8ZhMet4dpiIZtxhdmL3JQvuf1M2z7zCJRIy3Rk 1410197889
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 7/8] x86, microcode, intel: guard against misaligned microcode data
Date: Mon,  8 Sep 2014 14:37:53 -0300
Message-Id: <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full requirements for the memory area which holds the microcode
update binary data can be found in the Intel SDM, vol 3A, section
9.11.6, page 9-34.  They basically boil down to: 16-byte alignment, and
the data area must be entirely mapped if paging is already enabled.

The regular microcode update driver doesn't have to do anything special
to meet these requirements.  For peace of mind, add a check to
WARN_ONCE() when the alignment is (unexpectedly) incorrect, and abort
the microcode update.

However, the early microcode update driver can only expect 4-byte
alignment out of the early initramfs file format (which is actually good
enough for many Intel processors, but unless Intel oficially documents
this, we cannot make use of that fact).  The microcode update data will
not be aligned to a 16-byte boundary unless userspace takes special
steps to ensure it.

Change the early microcode driver to make a temporary copy of a portion
of the microcode header, and move the microcode data backwards
(overwriting the header) to a suitably aligned position, right before
issuing the microcode update WRMSR.

Unfortunately, to keep things simple, this has to be undone right after
the processor finishes the WRMSR.  Therefore, the alignment process will
have to be redone *for every processor core*.  This might end up not
being really noticeable, as the microcode update operation itself is
already extremely expensive in processor cycles.

If the microcode update data is already aligned in the first place, the
alignment process is skipped.  Users of large systems are encouraged to
use updated userspace that ensures 16-byte alignment of the microcode
data file contents inside the early initramfs image.

Add the relevant details to Documentation/x86/early-microcode.txt.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 Documentation/x86/early-microcode.txt       |   10 +++++++++
 arch/x86/kernel/cpu/microcode/intel.c       |    5 +++++
 arch/x86/kernel/cpu/microcode/intel_early.c |   30 +++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/early-microcode.txt b/Documentation/x86/early-microcode.txt
index d62bea6..c4f2ebd 100644
--- a/Documentation/x86/early-microcode.txt
+++ b/Documentation/x86/early-microcode.txt
@@ -14,6 +14,16 @@ during boot time. The microcode file in cpio name space is:
 on Intel: kernel/x86/microcode/GenuineIntel.bin
 on AMD  : kernel/x86/microcode/AuthenticAMD.bin
 
+For Intel processors, the microcode load process will be faster when special
+care is taken to ensure that the kernel/x86/microcode/GenuineIntel.bin file
+*data* inside the cpio archive is aligned to a paragraph (16-byte boundary).
+Standard pax/cpio can be coaxed into doing this by adding a padding file, e.g.
+"kernel/x86/microcode/.padding" with the appropriate size *right before* the
+kernel/x86/microcode/GenuineIntel.bin file.  Beware the required size for the
+padding file as it depends on the behavior of the tool used to create the cpio
+archive.  It is also possible to use a specific tool that appends enough NULs
+_to_ the file name (not _after_ the file name!) to align the file data.
+
 During BSP boot (before SMP starts), if the kernel finds the microcode file in
 the initrd file, it parses the microcode and saves matching microcode in memory.
 If matching microcode is found, it will be uploaded in BSP and later on in all
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 2182cec..40caef1 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -157,6 +157,11 @@ static int apply_microcode_intel(int cpu)
 	if (mc_intel == NULL)
 		return 0;
 
+	/* Intel SDM vol 3A section 9.11.6, page 9-34 */
+	if (WARN_ONCE((unsigned long)(mc_intel->bits) % 16,
+		"microcode data incorrectly aligned"))
+		return -1;
+
 	/*
 	 * Microcode on this CPU might be already up-to-date.  Only apply
 	 * the microcode patch in mc_intel when it is newer than the one
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 92629a8..994c59b 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -662,14 +662,40 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
 
+	char savedbuf[16];
+	void *mcu_data;
+	void *aligned_mcu_data;
+	unsigned int mcu_size = 0;
+
 	mc_intel = uci->mc;
 	if (mc_intel == NULL)
 		return 0;
 
+	mcu_data = mc_intel->bits;
+	aligned_mcu_data = mc_intel->bits;
+
+	/* Intel SDM vol 3A section 9.11.6, page 9-34: */
+	/* WRMSR MSR_IA32_UCODE_WRITE requires 16-byte alignment */
+	if ((unsigned long)(mcu_data) % 16) {
+		/* We have more than 16 bytes worth of microcode header
+		 * just before mc_intel->bits on a version 1 header */
+		BUILD_BUG_ON(offsetof(struct microcode_intel, bits) < 16);
+
+		aligned_mcu_data = (void *)((unsigned long)(mcu_data) & ~15UL);
+		mcu_size = get_datasize(&mc_intel->hdr);
+		memcpy(savedbuf, aligned_mcu_data, sizeof(savedbuf));
+		memmove(aligned_mcu_data, mcu_data, mcu_size);
+	}
+
 	/* write microcode via MSR 0x79 */
 	native_wrmsr(MSR_IA32_UCODE_WRITE,
-	      (unsigned long) mc_intel->bits,
-	      (unsigned long) mc_intel->bits >> 16 >> 16);
+		lower_32_bits((unsigned long)aligned_mcu_data),
+		upper_32_bits((unsigned long)aligned_mcu_data));
+
+	if (mcu_size) {
+		memmove(mcu_data, aligned_mcu_data, mcu_size);
+		memcpy(aligned_mcu_data, savedbuf, sizeof(savedbuf));
+	}
 
 	/* get the current revision from MSR 0x8B */
 	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-- 
1.7.10.4

