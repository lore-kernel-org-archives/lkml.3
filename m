Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaHLSZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:25:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58367 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaHLSZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:25:50 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, Rabin Vincent <rabin@rab.in>,
        Liu hua <sdu.liu@huawei.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 4/7] ARM: kexec: Make .text R/W in machine_kexec
Date: Tue, 12 Aug 2014 11:24:26 -0700
Message-Id: <1407867869-5194-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407867869-5194-1-git-send-email-keescook@chromium.org>
References: <1407867869-5194-1-git-send-email-keescook@chromium.org>
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
[kees: collapsed kexec_boot_atags (will.daecon)]
[kees: for bisectability, moved set_kernel_text_rw() to RODATA patch]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/machine_kexec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 8cf0996aa1a8..8f75250cbe30 100644
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
@@ -166,9 +167,8 @@ void machine_kexec(struct kimage *image)
 	kexec_start_address = image->start;
 	kexec_indirection_page = page_list;
 	kexec_mach_type = machine_arch_type;
-	if (!kexec_boot_atags)
-		kexec_boot_atags = image->start - KEXEC_ARM_ZIMAGE_OFFSET + KEXEC_ARM_ATAGS_OFFSET;
-
+	kexec_boot_atags = dt_mem ?: image->start - KEXEC_ARM_ZIMAGE_OFFSET
+				     + KEXEC_ARM_ATAGS_OFFSET;
 
 	/* copy our kernel relocation code to the control code page */
 	reboot_entry = fncpy(reboot_code_buffer,
-- 
1.9.1

