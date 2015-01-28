Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620AbbA1E0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:26:11 -0500
Received: from mail.kernel.org ([198.145.29.136]:41333 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965279AbbA1E0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:07 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Hansen <dave@sr71.net>, Fenghua Yu <fenghua.yu@intel.com>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 165/177] x86: Require exact match for 'noxsave' command line option
Date: Wed, 28 Jan 2015 12:10:23 +0800
Message-Id: <1422418236-12852-256-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kernel/cpu/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cf79302..114db0f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -142,6 +142,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 static int __init x86_xsave_setup(char *s)
 {
+	if (strlen(s))
+		return 0;
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	return 1;
-- 
1.9.1

