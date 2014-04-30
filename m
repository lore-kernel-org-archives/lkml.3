Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965167AbaD3VTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:19:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbaD3VTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:19:33 -0400
Date: Wed, 30 Apr 2014 14:19:10 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-246f2d2ee1d715e1077fc47d61c394569c8ee692@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/espfix] x86-32, espfix:
  Remove filter for espfix32 due to race
Git-Commit-ID: 246f2d2ee1d715e1077fc47d61c394569c8ee692
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

Commit-ID:  246f2d2ee1d715e1077fc47d61c394569c8ee692
Gitweb:     http://git.kernel.org/tip/246f2d2ee1d715e1077fc47d61c394569c8ee692
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 30 Apr 2014 14:03:25 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 30 Apr 2014 14:14:49 -0700

x86-32, espfix: Remove filter for espfix32 due to race

It is not safe to use LAR to filter when to go down the espfix path,
because the LDT is per-process (rather than per-thread) and another
thread might change the descriptors behind our back.  Fortunately it
is always *safe* (if a bit slow) to go down the espfix path, and a
32-bit LDT stack segment is extremely rare.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux.intel.com
Cc: <stable@vger.kernel.org> # consider after upstream merge
---
 arch/x86/kernel/entry_32.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..2780b8f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -551,11 +551,6 @@ ENTRY(iret_exc)
 
 	CFI_RESTORE_STATE
 ldt_ss:
-	larl PT_OLDSS(%esp), %eax
-	jnz restore_nocheck
-	testl $0x00400000, %eax		# returning to 32bit stack?
-	jnz restore_nocheck		# allright, normal return
-
 #ifdef CONFIG_PARAVIRT
 	/*
 	 * The kernel can't run on a non-flat stack if paravirt mode
