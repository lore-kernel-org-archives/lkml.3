Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaLSGLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:11:42 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36956 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSGLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:11:41 -0500
Message-ID: <5493C185.9020001@huawei.com>
Date: Fri, 19 Dec 2014 14:11:17 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        "Steven Rostedt" <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>
CC: <kpatch@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Christoph Hellwig <hch@infradead.org>, <live-patching@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        zhangdianfang <zhangdianfang@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>, xiexiuqi <xiexiuqi@huawei.com>
Subject: [kpatch] [PATCH] livepatch v7: move x86 specific ftrace handler code
 to arch/x86
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-3-git-send-email-sjenning@redhat.com>
In-Reply-To: <1418752700-14649-3-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The execution flow redirection related implemention in the livepatch
ftrace handler is depended on the specific architecture. This patch
introduces klp_arch_set_pc(like kgdb_arch_set_pc) interface to change
the pt_regs.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 arch/x86/include/asm/livepatch.h |    5 +++++
 kernel/livepatch/core.c          |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index c2ae592..4cdec4e 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -21,6 +21,7 @@
 #define _ASM_X86_LIVEPATCH_H

 #include <linux/module.h>
+#include <linux/ftrace.h>

 #ifdef CONFIG_LIVE_PATCHING
 #ifndef CC_USING_FENTRY
@@ -29,6 +30,10 @@
 extern int klp_write_module_reloc(struct module *mod, unsigned long type,
 				  unsigned long loc, unsigned long value);

+static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->ip = ip;
+}
 #else
 #error Live patching support is disabled; check CONFIG_LIVE_PATCHING
 #endif
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0004a71..c4c04fd 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -271,7 +271,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 {
 	struct klp_func *func = ops->private;

-	regs->ip = (unsigned long)func->new_func;
+	klp_arch_set_pc(regs, (unsigned long)func->new_func);
 }

 static int klp_disable_func(struct klp_func *func)
-- 
1.7.1


