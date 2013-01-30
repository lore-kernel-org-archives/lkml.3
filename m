Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3A3Biz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:38:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3A3Biw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:38:52 -0500
Date: Tue, 29 Jan 2013 17:38:40 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-187a8a73cee295b9407de0d6bfba65471a1f39d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, matt.fleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-20-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-20-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot: Move verify_cpu.S and no_longmode down
Git-Commit-ID: 187a8a73cee295b9407de0d6bfba65471a1f39d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:38:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  187a8a73cee295b9407de0d6bfba65471a1f39d6
Gitweb:     http://git.kernel.org/tip/187a8a73cee295b9407de0d6bfba65471a1f39d6
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:00 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:15 -0800

x86, boot: Move verify_cpu.S and no_longmode down

We need to move some code to 32bit section in following patch:

   x86, boot: Move lldt/ltr out of 64bit code section

but that will push startup_64 down from 0x200.

According to hpa, we can not change startup_64 position and that
is an ABI.

We could move function verify_cpu and no_longmode down, because
verify_cpu is used via function call and no_longmode will not
return, then we don't need to add extra code for jumping back.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-20-git-send-email-yinghai@kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/head_64.S | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c4b171..fb984c0 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -176,14 +176,6 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
-no_longmode:
-	/* This isn't an x86-64 CPU so hang */
-1:
-	hlt
-	jmp     1b
-
-#include "../../kernel/verify_cpu.S"
-
 	/*
 	 * Be careful here startup_64 needs to be at a predictable
 	 * address so I can export it in an ELF header.  Bootloaders
@@ -349,6 +341,15 @@ relocated:
  */
 	jmp	*%rbp
 
+	.code32
+no_longmode:
+	/* This isn't an x86-64 CPU so hang */
+1:
+	hlt
+	jmp     1b
+
+#include "../../kernel/verify_cpu.S"
+
 	.data
 gdt:
 	.word	gdt_end - gdt
