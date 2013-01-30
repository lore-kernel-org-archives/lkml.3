Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3A3BkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3BkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:40:02 -0500
Date: Tue, 29 Jan 2013 17:39:50 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-d3c433bf9a01b6951286ec2cbf52e3549623d878@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, zamsden@gmail.com, matt.fleming@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, zamsden@gmail.com, matt.fleming@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-21-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-21-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot: Move lldt/ltr out of 64bit code section
Git-Commit-ID: d3c433bf9a01b6951286ec2cbf52e3549623d878
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:39:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3c433bf9a01b6951286ec2cbf52e3549623d878
Gitweb:     http://git.kernel.org/tip/d3c433bf9a01b6951286ec2cbf52e3549623d878
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:01 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:19 -0800

x86, boot: Move lldt/ltr out of 64bit code section

commit 08da5a2ca

    x86_64: Early segment setup for VT

sets up LDT and TR into a valid state in order to speed up boot
decompression under VT.

Those code are put in code64, and it is using GDT that is only
loaded from code32 path.

That breaks booting with 64bit bootloader that does not go through
code32 path and jump to startup_64 directly, and it has different
GDT.

Move those lines into code32 after their GDT is loaded.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-21-git-send-email-yinghai@kernel.org
Cc: Zachary Amsden <zamsden@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/head_64.S | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index fb984c0..5c80b94 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -154,6 +154,12 @@ ENTRY(startup_32)
 	btsl	$_EFER_LME, %eax
 	wrmsr
 
+	/* After gdt is loaded */
+	xorl	%eax, %eax
+	lldt	%ax
+	movl    $0x20, %eax
+	ltr	%ax
+
 	/*
 	 * Setup for the jump to 64bit mode
 	 *
@@ -239,9 +245,6 @@ preferred_addr:
 	movl	%eax, %ss
 	movl	%eax, %fs
 	movl	%eax, %gs
-	lldt	%ax
-	movl    $0x20, %eax
-	ltr	%ax
 
 	/*
 	 * Compute the decompressed kernel start address.  It is where
