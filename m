Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbaHFTfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:35:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39629 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876AbaHFTft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:35:49 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/7] ARM: kexec: Make .text R/W in machine_kexec
Date: Wed,  6 Aug 2014 12:32:42 -0700
Message-Id: <1407353564-21478-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407353564-21478-1-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Borisov <Nikolay.Borisov@arm.com>

With the introduction of Kees Cook's patch to make the kernel .text
read-only the existing method by which kexec works got broken since it
directly pokes some values in the template code, which resides in the
.text section.

The current patch changes the way those values are inserted so that poking
.text section occurs only in machine_kexec (e.g when we are about to nuke
the old kernel and are beyond the point of return). This allows to use
set_kernel_text_rw() to directly patch the values in the .text section.

I had already sent a patch which achieved this but it was significantly
more complicated, so this is a cleaner/straight-forward approach.

Signed-off-by: Nikolay Borisov <Nikolay.Borisov@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
[collapsed kexec_boot_atags (will.daecon)]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/machine_kexec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 8cf0996aa1a8..fe6f3860ea57 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -29,6 +29,7 @@ extern unsigned long kexec_boot_atags;
 
 static atomic_t waiting_for_crash_ipi;
 
+static unsigned long dt_mem;
 /*
  * Provide a dummy crash_notes definition while crash dump arrives to arm.
  * This prevents breakage of crash_notes attribute in kernel/ksysfs.c.
@@ -64,7 +65,7 @@ int machine_kexec_prepare(struct kimage *image)
 			return err;
 
 		if (be32_to_cpu(header) == OF_DT_HEADER)
-			kexec_boot_atags = current_segment->mem;
+			dt_mem = current_segment->mem;
 	}
 	return 0;
 }
@@ -163,12 +164,13 @@ void machine_kexec(struct kimage *image)
 	reboot_code_buffer = page_address(image->control_code_page);
 
 	/* Prepare parameters for reboot_code_buffer*/
+	set_kernel_text_rw();
 	kexec_start_address = image->start;
 	kexec_indirection_page = page_list;
 	kexec_mach_type = machine_arch_type;
-	if (!kexec_boot_atags)
-		kexec_boot_atags = image->start - KEXEC_ARM_ZIMAGE_OFFSET + KEXEC_ARM_ATAGS_OFFSET;
-
+	kexec_boot_atags = dt_mem ?: kexec_boot_atags = image->start
+				     - KEXEC_ARM_ZIMAGE_OFFSET
+				     + KEXEC_ARM_ATAGS_OFFSET;
 
 	/* copy our kernel relocation code to the control code page */
 	reboot_entry = fncpy(reboot_code_buffer,
-- 
1.9.1

