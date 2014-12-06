Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaLFRy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:54:58 -0500
Received: from 1wt.eu ([62.212.114.60]:40706 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaLFRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:55 -0500
Message-Id: <20141206174148.631937314@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 05/25] x86-32, espfix: Remove filter for espfix32 due to race
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
(cherry picked from 3.2 commit 6806fa8b6795aba9be8742a8f598f60eed26f875)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/entry_32.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 8b5370c..db7dbe7 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -571,11 +571,6 @@ ENTRY(iret_exc)
 
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
1.7.12.2.21.g234cd45.dirty



