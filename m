Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3KTE0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:26:23 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60106 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3KTEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:43 -0500
Subject: [PATCH -tip v3 20/23] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        Uwe =?utf-8?q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:38 +0000
Message-ID: <20131120042238.15296.41605.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prohibit probing on func_ptr_is_kernel_text() by adding
it to the kprobe_blacklist.

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
 kernel/extable.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/extable.c b/kernel/extable.c
index 832cb28..885c877 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
+#include <linux/kprobes.h>
 
 #include <asm/sections.h>
 #include <asm/uaccess.h>
@@ -137,3 +138,4 @@ int func_ptr_is_kernel_text(void *ptr)
 		return 1;
 	return is_module_text_address(addr);
 }
+NOKPROBE_SYMBOL(func_ptr_is_kernel_text);


