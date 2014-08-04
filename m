Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaHDRNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:13:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56483 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.798095690@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 79/94] x86-32, espfix: Remove filter for espfix32 due
 to race
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 arch/x86/kernel/entry_32.S | 5 -----
 1 file changed, 5 deletions(-)

--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -553,11 +553,6 @@ ENTRY(iret_exc)
 
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

