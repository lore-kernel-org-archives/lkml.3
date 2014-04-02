Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaDBU3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:29:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42814 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758837AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/40] s390/time,vdso: fix clock_gettime for CLOCK_MONOTONIC
Date: Wed,  2 Apr 2014 22:13:11 +0200
Message-Id: <b39007aaa046a741031ccd84eb02f54a876fb818.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ca5de58ba746b08c920b2024aaf01aa1500b110d upstream.

With git commit 79c74ecbebf76732f91b82a62ce7fc8a88326962
"s390/time,vdso: convert to the new update_vsyscall interface"
the new update_vsyscall function already does the sum of xtime
and wall_to_monotonic. The old update_vsyscall function only
copied the wall_to_monotonic offset. The vdso code needs to be
modified to take this into consideration.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/kernel/vdso32/clock_gettime.S | 9 ++-------
 arch/s390/kernel/vdso64/clock_gettime.S | 6 ++----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index 5be8e472f57d..65fc3979c2f1 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -46,18 +46,13 @@ __kernel_clock_gettime:
 	jnm	3f
 	a	%r0,__VDSO_TK_MULT(%r5)
 3:	alr	%r0,%r2
-	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
-	al	%r1,__VDSO_XTIME_NSEC+4(%r5)
-	brc	12,4f
-	ahi	%r0,1
-4:	al	%r0,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic.nsec */
+	al	%r0,__VDSO_WTOM_NSEC(%r5)
 	al	%r1,__VDSO_WTOM_NSEC+4(%r5)
 	brc	12,5f
 	ahi	%r0,1
 5:	l	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
 	srdl	%r0,0(%r2)			/*  >> tk->shift */
-	l	%r2,__VDSO_XTIME_SEC+4(%r5)
-	al	%r2,__VDSO_WTOM_SEC+4(%r5)
+	l	%r2,__VDSO_WTOM_SEC+4(%r5)
 	cl	%r4,__VDSO_UPD_COUNT+4(%r5)	/* check update counter */
 	jne	1b
 	basr	%r5,0
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index 0add1072ba30..c09cda31c894 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -35,13 +35,11 @@ __kernel_clock_gettime:
 	jnz	0b
 	stck	48(%r15)			/* Store TOD clock */
 	lgf	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
-	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* tk->xtime_sec */
-	alg	%r0,__VDSO_WTOM_SEC(%r5)	/*  + wall_to_monotonic.sec */
+	lg	%r0,__VDSO_WTOM_SEC(%r5)
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
-	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
-	alg	%r1,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic.nsec */
+	alg	%r1,__VDSO_WTOM_NSEC(%r5)
 	srlg	%r1,%r1,0(%r2)			/*  >> tk->shift */
 	clg	%r4,__VDSO_UPD_COUNT(%r5)	/* check update counter */
 	jne	0b
-- 
1.9.1

