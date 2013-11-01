Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3KALZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:25:42 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33605 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab3KALZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:25:40 -0400
Subject: [PATCH -tip v2 3/3] [BUGFIX] kprobes: Prohibit probing on
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
Date: Fri, 01 Nov 2013 11:25:37 +0000
Message-ID: <20131101112537.14657.88496.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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
 kernel/extable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 832cb28..022fb25 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -129,7 +129,7 @@ int kernel_text_address(unsigned long addr)
  * pointer is part of the kernel text, we need to do some
  * special dereferencing first.
  */
-int func_ptr_is_kernel_text(void *ptr)
+int nokprobe func_ptr_is_kernel_text(void *ptr)
 {
 	unsigned long addr;
 	addr = (unsigned long) dereference_function_descriptor(ptr);


