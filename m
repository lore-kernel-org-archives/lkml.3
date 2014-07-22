Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaGVWWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:22:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144AbaGVWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 012/116] x86-32, espfix: Remove filter for espfix32 due to race
Date: Tue, 22 Jul 2014 15:20:23 -0700
Message-Id: <1406067727-19683-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/entry_32.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 1d7fdbe..60d03c2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -554,11 +554,6 @@ ENTRY(iret_exc)
 
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
-- 
1.9.1

