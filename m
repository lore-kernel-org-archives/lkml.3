Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaCBE1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 23:27:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38144 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaCBE1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 23:27:46 -0500
Date: Sat, 1 Mar 2014 20:27:26 -0800
Message-Id: <201403020427.s224RQoY015305@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.14-rc5
Cc: Eugene Surovegin <surovegin@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to e290e8c59dbc2a15088d868170d799f763202fef:

  x86, kaslr: add missed "static" declarations (2014-02-25 16:59:29 -0800)

The VMCOREINFO patch I'll pushing for this release to avoid having a
release with kASLR and but without that information.

I was hoping to include the FPU patches from Suresh, but ran into a
problem (see other thread); will try to make them happen next week.

	-hpa

----------------------------------------------------------------
Eugene Surovegin (1):
      x86, kaslr: export offset in VMCOREINFO ELF notes

Kees Cook (1):
      x86, kaslr: add missed "static" declarations

 arch/x86/boot/compressed/aslr.c    | 9 +++++----
 arch/x86/kernel/machine_kexec_64.c | 2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 90a21f430117..4dbf967da50d 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -111,7 +111,7 @@ struct mem_vector {
 };
 
 #define MEM_AVOID_MAX 5
-struct mem_vector mem_avoid[MEM_AVOID_MAX];
+static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
 {
@@ -180,7 +180,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 }
 
 /* Does this memory vector overlap a known avoided area? */
-bool mem_avoid_overlap(struct mem_vector *img)
+static bool mem_avoid_overlap(struct mem_vector *img)
 {
 	int i;
 
@@ -192,8 +192,9 @@ bool mem_avoid_overlap(struct mem_vector *img)
 	return false;
 }
 
-unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET / CONFIG_PHYSICAL_ALIGN];
-unsigned long slot_max = 0;
+static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
+			   CONFIG_PHYSICAL_ALIGN];
+static unsigned long slot_max;
 
 static void slots_append(unsigned long addr)
 {
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4eabc160696f..679cef0791cd 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -279,5 +279,7 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
+	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
+			      (unsigned long)&_text - __START_KERNEL);
 }
 
