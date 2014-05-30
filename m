Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbaE3PLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:11:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbaE3PLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:11:05 -0400
Date: Fri, 30 May 2014 08:10:53 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-b6f42a4a3c886bd18baf319d433a841ac9942c02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-4-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-4-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves:
  Add a kernel parameter noxsaves to disable xsaves/xrstors
Git-Commit-ID: b6f42a4a3c886bd18baf319d433a841ac9942c02
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

Commit-ID:  b6f42a4a3c886bd18baf319d433a841ac9942c02
Gitweb:     http://git.kernel.org/tip/b6f42a4a3c886bd18baf319d433a841ac9942c02
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:31 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:24:52 -0700

x86/xsaves: Add a kernel parameter noxsaves to disable xsaves/xrstors

This patch adds a kernel parameter noxsaves to disable xsaves/xrstors feature.
The kernel will fall back to use xsaveopt and xrstor to save and restor
xstates. By using this parameter, xsave area occupies more memory because
standard form of xsave area in xsaveopt/xrstor occupies more memory than
compacted form of xsave area.

This patch adds a description of the kernel parameter noxsaveopt in doc.
The code to support the parameter noxsaveopt has been in the kernel before.
This patch just adds the description of this parameter in the doc.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-4-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt | 15 +++++++++++++++
 arch/x86/kernel/cpu/common.c        |  8 ++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 30a8ad0d..0ebd952 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2124,6 +2124,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
 
+	noxsaveopt	[X86] Disables xsaveopt used in saving x86 extended
+			register states. The kernel will fall back to use
+			xsave to save the states. By using this parameter,
+			performance of saving the states is degraded because
+			xsave doesn't support modified optimization while
+			xsaveopt supports it on xsaveopt enabled systems.
+
+	noxsaves	[X86] Disables xsaves and xrstors used in saving and
+			restoring x86 extended register state in compacted
+			form of xsave area. The kernel will fall back to use
+			xsaveopt and xrstor to save and restore the states
+			in standard form of xsave area. By using this
+			parameter, xsave area per process might occupy more
+			memory on xsaves enabled systems.
+
 	eagerfpu=	[X86]
 			on	enable eager fpu restore
 			off	disable eager fpu restore
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7c4b97..cdc9585 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -146,6 +146,7 @@ static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 	setup_clear_cpu_cap(X86_FEATURE_AVX);
 	setup_clear_cpu_cap(X86_FEATURE_AVX2);
 	return 1;
@@ -159,6 +160,13 @@ static int __init x86_xsaveopt_setup(char *s)
 }
 __setup("noxsaveopt", x86_xsaveopt_setup);
 
+static int __init x86_xsaves_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
+	return 1;
+}
+__setup("noxsaves", x86_xsaves_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override = -1;
 static int disable_x86_serial_nr = 1;
