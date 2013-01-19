Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3ASTPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 14:15:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3ASTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 14:15:40 -0500
Date: Sat, 19 Jan 2013 11:15:17 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-021ef050fc092d5638e69868d126c18006ea7296@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <50FA0661.2060400@linux.intel.com>
References: <50FA0661.2060400@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Start out cr0 clean,
  disable paging before modifying cr3/4
Git-Commit-ID: 021ef050fc092d5638e69868d126c18006ea7296
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 19 Jan 2013 11:15:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  021ef050fc092d5638e69868d126c18006ea7296
Gitweb:     http://git.kernel.org/tip/021ef050fc092d5638e69868d126c18006ea7296
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sat, 19 Jan 2013 10:29:37 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 19 Jan 2013 11:01:22 -0800

x86-32: Start out cr0 clean, disable paging before modifying cr3/4

Patch

  5a5a51db78e x86-32: Start out eflags and cr4 clean

... made x86-32 match x86-64 in that we initialize %eflags and %cr4
from scratch.  This broke OLPC XO-1.5, because the XO enters the
kernel with paging enabled, which the kernel doesn't expect.

Since we no longer support 386 (the source of most of the variability
in %cr0 configuration), we can simply match further x86-64 and
initialize %cr0 to a fixed value -- the one variable part remaining in
%cr0 is for FPU control, but all that is handled later on in
initialization; in particular, configuring %cr0 as if the FPU is
present until proven otherwise is correct and necessary for the probe
to work.

To deal with the XO case sanely, explicitly disable paging in %cr0
before we muck with %cr3, %cr4 or EFER -- those operations are
inherently unsafe with paging enabled.

NOTE: There is still a lot of 386-related junk in head_32.S which we
can and should get rid of, however, this is intended as a minimal fix
whereas the cleanup can be deferred to the next merge window.

Reported-by: Andres Salomon <dilinger@queued.net>
Tested-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/50FA0661.2060400@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8e7f655..c8932c7 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -300,6 +300,12 @@ ENTRY(startup_32_smp)
 	leal -__PAGE_OFFSET(%ecx),%esp
 
 default_entry:
+#define CR0_STATE	(X86_CR0_PE | X86_CR0_MP | X86_CR0_ET | \
+			 X86_CR0_NE | X86_CR0_WP | X86_CR0_AM | \
+			 X86_CR0_PG)
+	movl $(CR0_STATE & ~X86_CR0_PG),%eax
+	movl %eax,%cr0
+
 /*
  *	New page tables may be in 4Mbyte page mode and may
  *	be using the global pages. 
@@ -364,8 +370,7 @@ default_entry:
  */
 	movl $pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
-	movl %cr0,%eax
-	orl  $X86_CR0_PG,%eax
+	movl $CR0_STATE,%eax
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
 1:
