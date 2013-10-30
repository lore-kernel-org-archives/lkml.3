Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3J3Kxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:53:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39509 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3J3Kxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:53:48 -0400
X-AuditID: 85900ec0-d452db9000001514-8c-5270e53a7a43
Subject: [PATCH -tip 2/2] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Uwe =?utf-8?q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>
Date: Wed, 30 Oct 2013 10:53:43 +0000
Message-ID: <20131030105343.7997.5374.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131030105334.7997.750.stgit@kbuild-fedora.novalocal>
References: <20131030105334.7997.750.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prohibit probing on func_ptr_is_kernel_text().
Since the func_ptr_is_kernel_text() is called from
notifier_call_chain() which is called from int3 handler,
probing it may cause double int3 fault and kernel will
reboot.

This happenes when the kernel built with CONFIG_DEBUG_NOTIFIERS=y.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/extable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 832cb28..b3b8b6a 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
+#include <linux/kprobes.h>
 
 #include <asm/sections.h>
 #include <asm/uaccess.h>
@@ -129,7 +130,7 @@ int kernel_text_address(unsigned long addr)
  * pointer is part of the kernel text, we need to do some
  * special dereferencing first.
  */
-int func_ptr_is_kernel_text(void *ptr)
+int __kprobes func_ptr_is_kernel_text(void *ptr)
 {
 	unsigned long addr;
 	addr = (unsigned long) dereference_function_descriptor(ptr);

