Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaLOPCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:02:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaLOPB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:01:59 -0500
Date: Mon, 15 Dec 2014 07:01:43 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-010e593b140decdc16bb0c1c754b07b1fccb6999@git.kernel.org>
Cc: mingo@kernel.org, dave.hansen@linux.intel.com, hpa@zytor.com,
        dave@sr71.net, linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: tglx@linutronix.de, dave@sr71.net, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dave.hansen@linux.intel.com, hpa@zytor.com
In-Reply-To: <20141212183835.8C581B3E@viggo.jf.intel.com>
References: <20141212183835.8C581B3E@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86, mpx: Update documentation
Git-Commit-ID: 010e593b140decdc16bb0c1c754b07b1fccb6999
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  010e593b140decdc16bb0c1c754b07b1fccb6999
Gitweb:     http://git.kernel.org/tip/010e593b140decdc16bb0c1c754b07b1fccb6999
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Fri, 12 Dec 2014 10:38:35 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 15 Dec 2014 15:58:57 +0100

x86, mpx: Update documentation

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
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141212183835.8C581B3E@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/x86/intel_mpx.txt | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
index 4472ed2..6ca6e2b 100644
--- a/Documentation/x86/intel_mpx.txt
+++ b/Documentation/x86/intel_mpx.txt
@@ -30,9 +30,15 @@ is how we expect the compiler, application and kernel to work together.
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
