Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbaLLSjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:39:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:40793 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaLLSjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:39:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="428303313"
Subject: [PATCH 1/2] x86, mpx: update documentation
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 10:38:35 -0800
References: <20141212183834.1F8D01E5@viggo.jf.intel.com>
In-Reply-To: <20141212183834.1F8D01E5@viggo.jf.intel.com>
Message-Id: <20141212183835.8C581B3E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

I was writing some MPX test programs and realized that the
current design makes it tricky.  I did something like:

	bndcfgu |= bnd_dir | BNDCFGU_ENABLE;
	xrstor();
	printf("xrstor done");
	// #BR bounds exception here
	prctl(MPX_ENABLE_MANAGEMENT);

and then compiled the app with "-fcheck-pointer-bounds -mmpx"
to enable MPX instrumentation.

The problem is that there is MPX instrumentation inserted in
to the area of the printf().  The kernel gets a bounds exception
and since management isn't yet enabled, it SIGSEGV's.

Add a bit to the documentation to explain a way around this and
where apps need to be careful.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/Documentation/x86/intel_mpx.txt |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN Documentation/x86/intel_mpx.txt~mpx-doc-update Documentation/x86/intel_mpx.txt
--- a/Documentation/x86/intel_mpx.txt~mpx-doc-update	2014-12-12 10:12:53.179922346 -0800
+++ b/Documentation/x86/intel_mpx.txt	2014-12-12 10:12:53.183922527 -0800
@@ -30,9 +30,15 @@ is how we expect the compiler, applicati
    instrumentation as well as some setup code called early after the app
    starts. New instruction prefixes are noops for old CPUs.
 2) That setup code allocates (virtual) space for the "bounds directory",
-   points the "bndcfgu" register to the directory and notifies the kernel
-   (via the new prctl(PR_MPX_ENABLE_MANAGEMENT)) that the app will be using
-   MPX.
+   points the "bndcfgu" register to the directory (must also set the valid
+   bit) and notifies the kernel (via the new prctl(PR_MPX_ENABLE_MANAGEMENT))
+   that the app will be using MPX.  The app must be careful not to access
+   the bounds tables between the time when it populates "bndcfgu" and
+   when it calls the prctl().  This might be hard to guarantee if the app
+   is compiled with MPX.  You can add "__attribute__((bnd_legacy))" to
+   the function to disable MPX instrumentation to help guarantee this.
+   Also be careful not to call out to any other code which might be
+   MPX-instrumented.
 3) The kernel detects that the CPU has MPX, allows the new prctl() to
    succeed, and notes the location of the bounds directory. Userspace is
    expected to keep the bounds directory at that locationWe note it
_
