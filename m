Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3KOE4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:56:50 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41506 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3KOE4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:56:33 -0500
X-AuditID: 85900ec0-d272ab9000001514-f4-5285a8f69ad4
Subject: [PATCH -tip RFC v2 20/22] [BUGFIX] kprobes: Prohibit probing on
 func_ptr_is_kernel_text
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Uwe =?utf-8?q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:54:13 +0000
Message-ID: <20131115045413.27580.91113.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
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

