Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaGHA4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:56:15 -0400
Received: from ozlabs.org ([103.22.144.67]:41183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaGHA4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:56:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] modules: Fix build error in moduleloader.h
In-Reply-To: <20140703092121.082e0366@gandalf.local.home>
References: <20140703092121.082e0366@gandalf.local.home>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 08 Jul 2014 09:10:09 +0930
Message-ID: <87wqbo7n6u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> Fengguang Wu's build bot detected that if moduleloader.h is included in
> a C file (used by ftrace and kprobes to access module_alloc() when
> available), that it can fail to build if CONFIG_MODULES and
> CONFIG_MODULES_USE_ELF_REL is not defined.
>
> This is because there's a printk() that dereferences struct module to
> print the name of the module. But as struct module does not exist when
> CONFIG_MODULES is not defined we get this error:

First, we have module_name() for exactly this.

Second, there are two places like this: you hit
CONFIG_MODULES_USE_ELF_REL and not CONFIG_MODULES_USE_ELF_RELA.

(We could uninline them, and put them in module.c, but I think having
them in the header is nice and self-documenting.)

So does this work for you?

Thanks,
Rusty.
PS.  Masami Hiramatsu, your review should have caught the second case,
     at least :(

Subject: modules: Fix build error in moduleloader.h

Fengguang Wu's build bot detected that if moduleloader.h is included in
a C file (used by ftrace and kprobes to access module_alloc() when
available), that it can fail to build if CONFIG_MODULES and
CONFIG_MODULES_USE_ELF_REL is not defined.

This is because there's a printk() that dereferences struct module to
print the name of the module. But as struct module does not exist when
CONFIG_MODULES is not defined we get this error:

   include/linux/moduleloader.h: In function 'apply_relocate':
>> include/linux/moduleloader.h:48:63: error: dereferencing pointer to
>> incomplete type  
     printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
								  ^
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Based-on-the-true-story-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 560ca53a75fa..7eeb9bbfb816 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -45,7 +45,8 @@ static inline int apply_relocate(Elf_Shdr *sechdrs,
 				 unsigned int relsec,
 				 struct module *me)
 {
-	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
+	printk(KERN_ERR "module %s: REL relocation unsupported\n",
+	       module_name(me));
 	return -ENOEXEC;
 }
 #endif
@@ -67,7 +68,8 @@ static inline int apply_relocate_add(Elf_Shdr *sechdrs,
 				     unsigned int relsec,
 				     struct module *me)
 {
-	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
+	printk(KERN_ERR "module %s: REL relocation unsupported\n",
+	       module_name(me));
 	return -ENOEXEC;
 }
 #endif
