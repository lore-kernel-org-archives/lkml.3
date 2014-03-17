Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaCQW3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:29:04 -0400
Received: from www84.your-server.de ([213.133.104.84]:39208 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaCQW3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:29:01 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        stefani@seibold.net
Subject: [PATCH v23 11/13] x86, vdso: Zero-pad the VVAR page
Date: Mon, 17 Mar 2014 23:22:11 +0100
Message-Id: <1395094933-14252-12-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395094933-14252-1-git-send-email-stefani@seibold.net>
References: <1395094933-14252-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

By coincidence, the VVAR page is at the end of an ELF segment.  As a
result, if it ends up being a partial page, the kernel loader will
leave garbage behind at the end of the vvar page.  Zero-pad it to a
full page to fix this issue.

This has probably been broken since the VVAR page was introduced.
On QEMU, if you dump the run-time contents of the VVAR page, you can
find entertaining strings from seabios left behind.

It's remotely possible that this is a security bug -- conceivably
there's some BIOS out there that leaves something sensitive in the
few K of memory that is exposed to userspace.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/kernel/vmlinux.lds.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1d4897b..49edf2d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -164,6 +164,11 @@ SECTIONS
 #undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
+		/*
+		 * Pad the rest of the page with zeros.  Otherwise the loader
+		 * can leave garbage here.
+		 */
+		. = __vvar_beginning_hack + PAGE_SIZE;
 	} :data
 
        . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
-- 
1.9.0

