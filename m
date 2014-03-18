Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbaCRVbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:31:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54531 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749AbaCRVaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:30:16 -0400
Date: Tue, 18 Mar 2014 14:29:45 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-309944be296efbb3ca4737d12ef49d2ba97cbecc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1395094933-14252-12-git-send-email-stefani@seibold.net>
References: <1395094933-14252-12-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Zero-pad the VVAR page
Git-Commit-ID: 309944be296efbb3ca4737d12ef49d2ba97cbecc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  309944be296efbb3ca4737d12ef49d2ba97cbecc
Gitweb:     http://git.kernel.org/tip/309944be296efbb3ca4737d12ef49d2ba97cbecc
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 17 Mar 2014 23:22:11 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Mar 2014 12:52:44 -0700

x86, vdso: Zero-pad the VVAR page

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
Link: http://lkml.kernel.org/r/1395094933-14252-12-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
