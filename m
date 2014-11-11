Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaKKWCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:02:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:37597 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaKKWCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:02:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="620803692"
Subject: [PATCH 2/2] x86: require exact match for "noxsave" command line option
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        fenghua.yu@intel.com, x86@kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Tue, 11 Nov 2014 14:01:33 -0800
References: <20141111220131.D86EE670@viggo.jf.intel.com>
In-Reply-To: <20141111220131.D86EE670@viggo.jf.intel.com>
Message-Id: <20141111220133.FE053984@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

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

We should try and get this patch in to as many old kernels as
possible.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org

---

 b/arch/x86/kernel/cpu/common.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/cpu/common.c~mpx-xsave-setup-exact arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~mpx-xsave-setup-exact	2014-11-11 14:00:19.061376676 -0800
+++ b/arch/x86/kernel/cpu/common.c	2014-11-11 14:00:19.063376767 -0800
@@ -146,6 +146,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 static int __init x86_xsave_setup(char *s)
 {
+	if (strlen(s))
+		return 0;
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
_
