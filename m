Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbaGCNVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:21:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:37613 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809AbaGCNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:21:23 -0400
Date: Thu, 3 Jul 2014 09:21:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] modules: Fix build error in moduleloader.h
Message-ID: <20140703092121.082e0366@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu's build bot detected that if moduleloader.h is included in
a C file (used by ftrace and kprobes to access module_alloc() when
available), that it can fail to build if CONFIG_MODULES and
CONFIG_MODULES_USE_ELF_REL is not defined.

This is because there's a printk() that dereferences struct module to
print the name of the module. But as struct module does not exist when
CONFIG_MODULES is not defined we get this error:

   include/linux/moduleloader.h: In function 'apply_relocate':
>> include/linux/moduleloader.h:48:63: error: dereferencing pointer to incomplete type  
     printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
                                                                  ^
Avoid the printk if CONFIG_MODULES is not set.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 560ca53..d9da807 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -45,7 +45,10 @@ static inline int apply_relocate(Elf_Shdr *sechdrs,
 				 unsigned int relsec,
 				 struct module *me)
 {
+/* me->name only exists if modules are enabled */
+#ifdef CONFIG_MODULES
 	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
+#endif
 	return -ENOEXEC;
 }
 #endif
