Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaCCVa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:30:28 -0500
Received: from www84.your-server.de ([213.133.104.84]:43230 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbaCCVa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:30:27 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [Patch v22 12/12] x86: Zero-pad the VVAR page
Date: Mon,  3 Mar 2014 22:12:23 +0100
Message-Id: <1393881143-3569-13-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393881143-3569-1-git-send-email-stefani@seibold.net>
References: <1393881143-3569-1-git-send-email-stefani@seibold.net>
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

