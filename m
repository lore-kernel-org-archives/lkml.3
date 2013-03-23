Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422856Ab3CWBcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:32:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422831Ab3CWBZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338472"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/29] x86, tsx: Don't abort immediately in __read/write_lock_failed
Date: Fri, 22 Mar 2013 18:25:01 -0700
Message-Id: <1364001923-10796-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

__read/write_lock_failed did execute a PAUSE first thing before
checking the lock. This aborts transactions. Check the lock
state again before executing the pause. This avoids a small
number of extra aborts, and is slightly cheaper too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lib/rwlock.S |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/rwlock.S b/arch/x86/lib/rwlock.S
index 1cad221..9a6bc12 100644
--- a/arch/x86/lib/rwlock.S
+++ b/arch/x86/lib/rwlock.S
@@ -16,10 +16,12 @@ ENTRY(__write_lock_failed)
 	FRAME
 0:	LOCK_PREFIX
 	WRITE_LOCK_ADD($RW_LOCK_BIAS) (%__lock_ptr)
+	cmpl    $WRITE_LOCK_CMP, (%__lock_ptr)
+	je      2f
 1:	rep; nop
 	cmpl	$WRITE_LOCK_CMP, (%__lock_ptr)
 	jne	1b
-	LOCK_PREFIX
+2:	LOCK_PREFIX
 	WRITE_LOCK_SUB($RW_LOCK_BIAS) (%__lock_ptr)
 	jnz	0b
 	ENDFRAME
@@ -32,10 +34,12 @@ ENTRY(__read_lock_failed)
 	FRAME
 0:	LOCK_PREFIX
 	READ_LOCK_SIZE(inc) (%__lock_ptr)
+	READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
+	jns  2f
 1:	rep; nop
 	READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
 	js	1b
-	LOCK_PREFIX
+2:	LOCK_PREFIX
 	READ_LOCK_SIZE(dec) (%__lock_ptr)
 	js	0b
 	ENDFRAME
-- 
1.7.7.6

