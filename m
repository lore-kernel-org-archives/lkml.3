Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbbAUDiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:38:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbAUDh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:37:58 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 4/6] adapt choose_kernel_location to add the kernel virtual address randomzation
Date: Wed, 21 Jan 2015 11:37:15 +0800
Message-Id: <1421811437-2787-5-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For kernel virtual address, need set LOAD_PHYSICAL_ADDR to be the default
offset if randomization failed. Because it will be used to check whether
a relocation handling need be done for x86_64 kaslr.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 32 ++++++++++++++++++--------------
 arch/x86/boot/compressed/misc.c |  6 ++++--
 arch/x86/boot/compressed/misc.h | 20 +++++++++++---------
 3 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 091b118..20a5f23 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -317,12 +317,12 @@ static unsigned long find_random_virt_offset(unsigned long size)
 	return slots_fetch_random();
 }
 
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_size)
+void choose_kernel_location(unsigned char *input,
+			    unsigned long input_size,
+			    unsigned char **output,
+			    unsigned long output_size,
+			    unsigned char **virt_rand_offset)
 {
-	unsigned long choice = (unsigned long)output;
 	unsigned long random;
 
 #ifdef CONFIG_HIBERNATION
@@ -342,17 +342,21 @@ unsigned char *choose_kernel_location(unsigned char *input,
 		       output_size);
 
 	/* Walk e820 and find a random address. */
-	random = find_random_addr(choice, output_size);
-	if (!random) {
+	random = find_random_addr((unsigned long)*output, output_size);
+	if (!random)
 		debug_putstr("KASLR could not find suitable E820 region...\n");
-		goto out;
-	}
-
 	/* Always enforce the minimum. */
-	if (random < choice)
-		goto out;
+	else if (random > (unsigned long)*output)
+		*output = (unsigned char*)random;
+
+
+	random = find_random_virt_offset(output_size);
+	if (!random)
+		debug_putstr("KASLR could not find suitable kernel mapping region...\n");
+	else if (random > LOAD_PHYSICAL_ADDR)
+		*virt_rand_offset = (unsigned char*)random;
 
-	choice = random;
 out:
-	return (unsigned char *)choice;
+	if (!random)
+		*virt_rand_offset = (unsigned char*)LOAD_PHYSICAL_ADDR;
 }
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 324ccb5..acd4db1 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -373,6 +373,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned long output_len,
 				  unsigned long run_size)
 {
+	unsigned char *virt_rand_offset;
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -399,9 +400,10 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_kernel_location(input_data, input_len, output,
+	choose_kernel_location(input_data, input_len, &output,
 					output_len > run_size ? output_len
-							      : run_size);
+							      : run_size,
+					&virt_rand_offset);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 24e3e56..7278bff 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -56,20 +56,22 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* aslr.c */
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_size);
+void choose_kernel_location(unsigned char *input,
+			    unsigned long input_size,
+			    unsigned char **output,
+			    unsigned long output_size,
+			    unsigned char **virt_rand_offset);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
 static inline
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_size)
+void choose_kernel_location(unsigned char *input,
+			    unsigned long input_size,
+			    unsigned char **output,
+			    unsigned long output_size,
+			    unsigned char **virt_rand_offset);
 {
-	return output;
+	return;
 }
 #endif
 
-- 
1.9.3

