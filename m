Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaLVUID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:08:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:37563 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbaLVUIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:08:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="502792152"
Subject: [PATCH 1/2] x86, mpx: explicitly disable 32-bit MPX support on 64-bit kernels
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com, luto@amacapital.net
From: Dave Hansen <dave@sr71.net>
Date: Mon, 22 Dec 2014 12:08:04 -0800
References: <20141222200803.D316DA2A@viggo.jf.intel.com>
In-Reply-To: <20141222200803.D316DA2A@viggo.jf.intel.com>
Message-Id: <20141222200804.18A7A803@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

We had originally planned on submitting MPX support in one patch
set.  We eventually broke it up in to two pieces for easier
review.  One of the features that didn't make the first round
was supporting 32-bit binaries on 64-bit kernels.

Once we split the set up, we never added code to restrict 32-bit
binaries from _using_ MPX on 64-bit kernels.

The 32-bit bounds tables are a different format than the 64-bit
ones.  Without this patch, the kernel will try to read a 32-bit
binary's tables as if they were the 64-bit version.  They will
likely be noticed as being invalid rather quickly and the app
will get killed, but that's kinda mean.

This patch adds an explicit check, and will make a 64-bit kernel
essentially behave as if it has no MPX support when called from
a 32-bit binary.

I intend to remove this check once the mixed binary support is
added.  Those patches are posted if anyone is interested:

	https://lkml.org/lkml/2014/12/12/632

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
---

 b/arch/x86/mm/mpx.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/x86/mm/mpx.c~x86-mpx-explicitly-disable-32-bit-on-64-bit-for-3_19 arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~x86-mpx-explicitly-disable-32-bit-on-64-bit-for-3_19	2014-12-22 12:06:18.308911687 -0800
+++ b/arch/x86/mm/mpx.c	2014-12-22 12:06:18.311911822 -0800
@@ -349,6 +349,12 @@ static __user void *task_get_bounds_dir(
 		return MPX_INVALID_BOUNDS_DIR;
 
 	/*
+	 * 32-bit binaries on 64-bit kernels are currently
+	 * unsupported.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
+		return MPX_INVALID_BOUNDS_DIR;
+	/*
 	 * The bounds directory pointer is stored in a register
 	 * only accessible if we first do an xsave.
 	 */
_
