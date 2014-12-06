Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaLFPN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:13:59 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47791 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752339AbaLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Hansen <dave@sr71.net>, Fenghua Yu <fenghua.yu@intel.com>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 16/66] x86: Require exact match for 'noxsave' command line option
Date: Sat,  6 Dec 2014 16:07:08 +0100
Message-Id: <64d6bef08627721e538f457da75cf43aa64f838b.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2cd3949f702692cf4c5d05b463f19cd706a92dd3 upstream.

We have some very similarly named command-line options:

arch/x86/kernel/cpu/common.c:__setup("noxsave", x86_xsave_setup);
arch/x86/kernel/cpu/common.c:__setup("noxsaveopt", x86_xsaveopt_setup);
arch/x86/kernel/cpu/common.c:__setup("noxsaves", x86_xsaves_setup);

__setup() is designed to match options that take arguments, like
"foo=bar" where you would have:

	__setup("foo", x86_foo_func...);

The problem is that "noxsave" actually _matches_ "noxsaves" in
the same way that "foo" matches "foo=bar".  If you boot an old
kernel that does not know about "noxsaves" with "noxsaves" on the
command line, it will interpret the argument as "noxsave", which
is not what you want at all.

This makes the "noxsave" handler only return success when it finds
an *exact* match.

[ tglx: We really need to make __setup() more robust. ]

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141111220133.FE053984@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/cpu/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d5f63dacf030..00cc6f79615d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -144,6 +144,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 static int __init x86_xsave_setup(char *s)
 {
+	if (strlen(s))
+		return 0;
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	setup_clear_cpu_cap(X86_FEATURE_AVX);
-- 
2.1.3

