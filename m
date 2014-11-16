Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaKPMfD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:35:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbaKPMed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:34:33 -0500
Date: Sun, 16 Nov 2014 04:34:22 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-f9017963878933fc1d8fff85a9365a0d29104565@git.kernel.org>
Cc: fenghua.yu@intel.com, torvalds@linux-foundation.org,
        dave.hansen@linux.intel.com, mingo@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, fenghua.yu@intel.com, torvalds@linux-foundation.org,
        dave.hansen@linux.intel.com
In-Reply-To: <20141111220133.FE053984@viggo.jf.intel.com>
References: <20141111220133.FE053984@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Require exact match for "noxsave"
  command line option
Git-Commit-ID: f9017963878933fc1d8fff85a9365a0d29104565
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

Commit-ID:  f9017963878933fc1d8fff85a9365a0d29104565
Gitweb:     http://git.kernel.org/tip/f9017963878933fc1d8fff85a9365a0d29104565
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Tue, 11 Nov 2014 14:01:33 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:30:40 +0100

x86: Require exact match for "noxsave" command line option

We have some very similarly named command-line options:

  arch/x86/kernel/cpu/common.c:__setup("noxsave", x86_xsave_setup);
  arch/x86/kernel/cpu/common.c:__setup("noxsaveopt", x86_xsaveopt_setup);
  arch/x86/kernel/cpu/common.c:__setup("noxsaves", x86_xsaves_setup);

__setup() is designed to match options that take arguments, like
"foo=bar" where you would have:

	__setup("foo", x86_foo_func...);

The problem is that "noxsave" actually _matches_ "noxsaves" in
the same way that "foo" matches "foo=bar".  If you boot an old
kernel that does not know about "noxsaves" with "noxsaves" on
the command line, it will interpret the argument as "noxsave",
which is not what you want at all.

This makes the "noxsave" handler only return success when it
finds an *exact* match.

We should try and get this patch in to as many old kernels as
possible.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141111220133.FE053984@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c..cfa9b5b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -146,6 +146,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 static int __init x86_xsave_setup(char *s)
 {
+	if (strlen(s))
+		return 0;
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
