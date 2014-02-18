Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaBRWq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaBRWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathan Lynch <nathan_lynch@mentor.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.10 10/26] arm64: vdso: fix coarse clock handling
Date: Tue, 18 Feb 2014 14:47:06 -0800
Message-Id: <20140218224530.700724664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan_lynch@mentor.com>

commit 069b918623e1510e58dacf178905a72c3baa3ae4 upstream.

When __kernel_clock_gettime is called with a CLOCK_MONOTONIC_COARSE or
CLOCK_REALTIME_COARSE clock id, it returns incorrectly to whatever the
caller has placed in x2 ("ret x2" to return from the fast path).  Fix
this by saving x30/LR to x2 only in code that will call
__do_get_tspec, restoring x30 afterward, and using a plain "ret" to
return from the routine.

Also: while the resulting tv_nsec value for CLOCK_REALTIME and
CLOCK_MONOTONIC must be computed using intermediate values that are
left-shifted by cs_shift (x12, set by __do_get_tspec), the results for
coarse clocks should be calculated using unshifted values
(xtime_coarse_nsec is in units of actual nanoseconds).  The current
code shifts intermediate values by x12 unconditionally, but x12 is
uninitialized when servicing a coarse clock.  Fix this by setting x12
to 0 once we know we are dealing with a coarse clock id.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/vdso/gettimeofday.S |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/vdso/gettimeofday.S
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -103,6 +103,8 @@ ENTRY(__kernel_clock_gettime)
 	bl	__do_get_tspec
 	seqcnt_check w9, 1b
 
+	mov	x30, x2
+
 	cmp	w0, #CLOCK_MONOTONIC
 	b.ne	6f
 
@@ -118,6 +120,9 @@ ENTRY(__kernel_clock_gettime)
 	ccmp	w0, #CLOCK_MONOTONIC_COARSE, #0x4, ne
 	b.ne	8f
 
+	/* xtime_coarse_nsec is already right-shifted */
+	mov	x12, #0
+
 	/* Get coarse timespec. */
 	adr	vdso_data, _vdso_data
 3:	seqcnt_acquire
@@ -156,7 +161,7 @@ ENTRY(__kernel_clock_gettime)
 	lsr	x11, x11, x12
 	stp	x10, x11, [x1, #TSPEC_TV_SEC]
 	mov	x0, xzr
-	ret	x2
+	ret
 7:
 	mov	x30, x2
 8:	/* Syscall fallback. */


