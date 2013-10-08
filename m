Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3JHUhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3JHUhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:37:48 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: add PAGE_ALIGNED_DATA to linker script
Date: Tue,  8 Oct 2013 16:37:39 -0400
Message-Id: <1381264659-11132-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arm64 linker script doesn't use the PAGE_ALIGNED_DATA macro which
leads to a ".data..page_aligned" section being placed between the end
of .data and start of .bss:

 % readelf -e vmlinux
   ...
 Section to Segment mapping:
  Segment Sections...
   00     .head.text .text .text.init .rodata __ksymtab __ksymtab_gpl \
          __ksymtab_strings __param __modver __ex_table .notes \
          .init.text .init.data .data..percpu .data .data..page_aligned .bss

This causes problems for the EFI stub which may have to relocate the
kernel image based on stext and _edata symbols.

This patch adds PAGE_ALIGNED_DATA() to the linker script inside the
the .data section.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index f8ab9d8..e441556 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -110,6 +110,7 @@ SECTIONS
 		 */
 		INIT_TASK_DATA(THREAD_SIZE)
 		NOSAVE_DATA
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
 		CACHELINE_ALIGNED_DATA(64)
 		READ_MOSTLY_DATA(64)
 
-- 
1.8.3.1

