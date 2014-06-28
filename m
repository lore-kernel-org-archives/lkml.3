Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbaF1RxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:53:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaF1Rwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.15 106/139] x86-32, espfix: Remove filter for espfix32 due to race
Date: Sat, 28 Jun 2014 10:47:47 -0700
Message-Id: <20140628174610.260994003@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 246f2d2ee1d715e1077fc47d61c394569c8ee692 upstream.

It is not safe to use LAR to filter when to go down the espfix path,
because the LDT is per-process (rather than per-thread) and another
thread might change the descriptors behind our back.  Fortunately it
is always *safe* (if a bit slow) to go down the espfix path, and a
32-bit LDT stack segment is extremely rare.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/entry_32.S |    5 -----
 1 file changed, 5 deletions(-)

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


