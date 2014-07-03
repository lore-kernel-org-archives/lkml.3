Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbaGCOfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:35:12 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:45841 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaGCOfJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 3 Jul 2014 10:35:09 -0400
Message-Id: <53B5863B02000078000204D5@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Thu, 03 Jul 2014 15:35:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: fix vDSO build
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on static functions used just once to get inlined (and
subsequently have dead code paths eliminated) is wrong: Compilers are
free to decide whether they do this, regardless of optimization level.
With this not happening for vdso_addr() (observed with gcc 4.1.x), an
unresolved reference to align_vdso_addr() causes the build to fail.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vma.c    |    4 ++++
 1 file changed, 4 insertions(+)

--- 3.16-rc3/arch/x86/vdso/vma.c
+++ 3.16-rc3-x86-vdso-build/arch/x86/vdso/vma.c
@@ -62,6 +62,9 @@ struct linux_binprm;
    Only used for the 64-bit and x32 vdsos. */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
+#ifdef CONFIG_X86_32
+	return 0;
+#else
 	unsigned long addr, end;
 	unsigned offset;
 	end = (start + PMD_SIZE - 1) & PMD_MASK;
@@ -83,6 +86,7 @@ static unsigned long vdso_addr(unsigned
 	addr = align_vdso_addr(addr);
 
 	return addr;
+#endif
 }
 
 static int map_vdso(const struct vdso_image *image, bool calculate_addr)



