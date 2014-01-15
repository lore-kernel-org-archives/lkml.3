Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaAOVmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:42:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaAOVmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:42:16 -0500
Date: Wed, 15 Jan 2014 16:41:44 -0500
From: Kyle McMartin <kyle@redhat.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com
Subject: [PATCH] aarch64: always map VDSO at worst case alignment
Message-ID: <20140115214144.GF18705@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently on ARM64 with 4K pages set, GDB fails to load the VDSO with
the error "Failed to read a valid object file image from memory" as it
is applying the phdr alignment to the vma, and attempting to read below
where the VDSO is mapped. This is because our segment alignment is 64K
in the ELF headers, but the VDSO only has PAGE_SIZE alignment from
get_unmapped_area.

Work around this by calling vm_unmapped_area directly, and specifying
the worst case alignment (64K) directly.

With this patch applied, I no longer have issues loading the VDSO in
gdb (and no more error message every time I run a program inside it.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -163,7 +163,18 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	vdso_mapping_len = (vdso_pages + 1) << PAGE_SHIFT;
 
 	down_write(&mm->mmap_sem);
-	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
+	{
+		/* the VDSO must be worst-case aligned to 64K */
+		struct vm_unmapped_area_info info =
+			{
+				.flags = 0,
+				.length = vdso_mapping_len,
+				.low_limit = mm->mmap_base,
+				.high_limit = TASK_SIZE,
+				.align_mask = (1 << 16) - 1,
+			};
+		vdso_base = vm_unmapped_area(&info);
+	}
 	if (IS_ERR_VALUE(vdso_base)) {
 		ret = vdso_base;
 		goto up_fail;
