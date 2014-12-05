Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaLEXV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:21:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaLEW4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>, Dave Hansen <dave@sr71.net>,
        Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 06/73] x86: Require exact match for noxsave command line option
Date: Fri,  5 Dec 2014 14:44:12 -0800
Message-Id: <20141205224434.124837280@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/common.c |    2 ++
 1 file changed, 2 insertions(+)

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


