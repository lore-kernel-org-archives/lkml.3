Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbbAVUNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:13:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbAVUNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:13:01 -0500
Date: Thu, 22 Jan 2015 12:12:39 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-814564a0a1d2faee11ff9de43245d78cb79c85ac@git.kernel.org>
Cc: mingo@kernel.org, dave.hansen@linux.intel.com, dave@sr71.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        luto@amacapital.net
Reply-To: tglx@linutronix.de, luto@amacapital.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, dave@sr71.net,
        mingo@kernel.org, dave.hansen@linux.intel.com
In-Reply-To: <20150108223020.9E9AA511@viggo.jf.intel.com>
References: <20150108223020.9E9AA511@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mpx:
  Explicitly disable 32-bit MPX support on 64-bit kernels
Git-Commit-ID: 814564a0a1d2faee11ff9de43245d78cb79c85ac
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

Commit-ID:  814564a0a1d2faee11ff9de43245d78cb79c85ac
Gitweb:     http://git.kernel.org/tip/814564a0a1d2faee11ff9de43245d78cb79c85ac
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 8 Jan 2015 14:30:20 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 21:11:06 +0100

x86, mpx: Explicitly disable 32-bit MPX support on 64-bit kernels

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

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20150108223020.9E9AA511@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/mpx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index 67ebf57..c439ec4 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -349,6 +349,12 @@ static __user void *task_get_bounds_dir(struct task_struct *tsk)
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
