Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaI1SCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 14:02:09 -0400
Received: from hofr.at ([212.69.189.236]:42888 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbaI1SCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 14:02:07 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2014 14:02:06 EDT
Date: Sun, 28 Sep 2014 19:55:13 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michael Elizabeth Chastain <mec@shout.net>,
        Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>,
        Sam Ravnborg <sam@ravnborg.org>, Jan Engelhardt <jengelh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] description and restrictions of _shipped
Message-ID: <20140928175513.GA5517@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a section on handling of _shipped files
and their limitations.

While it is not actually the right place to rant about binary
modules, it probably would also be bad not to clearly state that
this option is not preferred.

This patch is against 3.17.0-rc6

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 Documentation/kbuild/makefiles.txt |  138 +++++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 764f599..0c72ef2 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -19,6 +19,7 @@ This document describes the Linux kernel Makefiles.
 	   --- 3.10 Special Rules
 	   --- 3.11 $(CC) support functions
 	   --- 3.12 $(LD) support functions
+	   --- 3.13 _shipped binary blobs
 
 	=== 4 Host Program support
 	   --- 4.1 Simple Host Program
@@ -595,6 +596,143 @@ more details, with real examples.
 		LDFLAGS_vmlinux += $(call ld-option, -X)
 
 
+--- 3.13 _shipped binary blobs
+
+	There are hardly any technical reasons for binary kernel modules - but
+	sometimes there may be marketing reasons and generally there are only
+	management reasons for binary modules (because someone "up there"
+       simply does not get it...) - if you do have to go for binary modules
+       - at least do it correctly.
+
+	To generate the binary blob you would run the normal make process with
+	the hello_fun.c present in the directory. After the build the
+	hello_fun.o would be renamed to hello_fun.o_shipped. The module
+	source tree is then delivered to the user with the skeleton .c file
+	and the pre-built .o_shipped file.
+
+	This hello world builds with a binary blob. The Makefile shows that
+       hello_fun.o is needed to build simple_hello
+
+	Example:
+		simple_hello-objs :=    hello.o
+		simple_hello-objs +=    hello_fun.o
+		obj-m   := simple_hello.o
+
+	If a file of that name with the extension _shipped is found it is used
+	rather than generating the respective .o file from source (in this case
+	hello_fun.o_shipped)
+
+	with hello.c containing the skeleton code
+
+	Example:
+		<snip>
+		int hello_fun(void);
+
+		static int __init hello_init(void)
+		{
+			int ret = -1;
+
+			ret = hello_fun();
+			pr_info("hello_fun returned %d\n", ret);
+			return 0;
+		}
+		<snip>
+
+	make would now build the simple_hello.o from the hello.c source
+	and link in the hello_fun.o_shipped.
+
+	Such a binary only module has a number of restrictions:
+
+	* You can't use kernel functions in the binary blob - the binary
+	  blob has to be your intellectual property. Lets say you "invented"
+	  an algorithm for an even faster FFT than FFTW - then you can code
+	  that into a function that should not be using any kernel functions
+	  and call it from the skeleton module. The binary blob should have
+	  no kernel version dependencies.
+
+	* A skeleton module needs to be provided (like the hello.c in this
+	  directory) that calls the binary blob function (hello_fun()) in
+	  the example. But other than that requires that this binary blob
+	  may not restrict the ability to recompile the kernel module for
+	  a different kernel version for the same hardware architecture.
+
+	* The license must clearly identify that it is proprietary (that
+	  is your kernel will be marked as tainted by loading this module).
+
+	* You are not allowed to use any symbols that were exported for GPL
+	  us only (with EXPORT_SYMBOL_GPL()).
+
+	* The skeleton module can not be treated as binary or licensed under
+	  a non kernel license compliant module by you as it is clearly derived
+	  work based on the kernel functions provided by the Linux developer
+	  community.
+
+	* if your kernel that has the binary module loaded oopses - please
+	  don't bother the kernel developers with your problem - they will
+	  (if they are polite) ignore you or (if they are less polite)....
+
+	* Do not post questions pertaining to binary modules to the Linux Kernel
+	  Mailing List (LKML) or any of the other lists on vger.kernel.org.
+
+	rand1:~/hello_binary# make -C /home/hofrat/linux-stable/ M=$PWD clean
+	make: Entering directory `/home/hofrat/linux-stable'
+	  CLEAN   /home/hofrat/hello_binary/.tmp_versions
+	  CLEAN   /home/hofrat/hello_binary/Module.symvers
+	make: Leaving directory `/home/hofrat/linux-stable'
+	rand1:~/hello_binary# rm hello_fun.o_shipped
+	rand1:~/hello_binary# make -C /home/hofrat/linux-stable/ M=$PWD modules
+	make: Entering directory `/home/hofrat/linux-stable'
+	  CC [M]  /home/hofrat/hello_binary/hello.o
+	  CC [M]  /home/hofrat/hello_binary/hello_fun.o
+	  LD [M]  /home/hofrat/hello_binary/simple_hello.o
+	  Building modules, stage 2.
+	  MODPOST 1 modules
+	  CC      /home/hofrat/hello_binary/simple_hello.mod.o
+	  LD [M]  /home/hofrat/hello_binary/simple_hello.ko
+	make: Leaving directory `/home/hofrat/linux-stable'
+
+
+	After building all the .o files move the .o intended for
+	binary release to .o_shieped.
+
+	rand1:~/hello_binary# mv hello_fun.o hello_fun.o_shipped
+
+	Subsequent rebuilds of the module will be using the .o_shipped
+	even if the corresponding .c file is still present.
+
+	rand1:~/hello_binary# make -C /home/hofrat/linux-stable/ M=$PWD clean
+ 	make: Entering directory `/home/hofrat/linux-stable'
+	  CLEAN   /home/hofrat/hello_binary/.tmp_versions
+	  CLEAN   /home/hofrat/hello_binary/Module.symvers
+	make: Leaving directory `/home/hofrat/linux-stable'
+	rand1:~/hello_binary# make -C /home/hofrat/linux-stable/ M=$PWD modules
+	make: Entering directory `/home/hofrat/linux-stable'
+	  CC [M]  /home/hofrat/hello_binary/hello.o
+	  SHIPPED /home/hofrat/hello_binary/hello_fun.o
+	  LD [M]  /home/hofrat/hello_binary/simple_hello.o
+	  Building modules, stage 2.
+ 	  MODPOST 1 modules
+	  CC      /home/hofrat/hello_binary/simple_hello.mod.o
+	  LD [M]  /home/hofrat/hello_binary/simple_hello.ko
+	make: Leaving directory `/home/hofrat/linux-stable'
+
+	If you need to use a binary kernel module - make sure that the way
+	you do it is legal - we can't give legal advice here - we only can
+	give you some basic pointers - please contact the FSF or the kernel
+	developers to make sure you are doing it in the right way.
+	In addition, you may wish to consult a lawyer who is specialized in
+	copyright law and known to have insight into Linux kernel development
+
+	That said - remember - binary modules are:
+
+	* annoying for the user as it will impact the system behavior without
+	  the ability to debug or even analyze causes properly
+	* an irritation to the community
+	* technically not a sensible solution
+	* simply the wrong solution in 99.99% of the cases
+
+	...so don't do it
+
 === 4 Host Program support
 
 Kbuild supports building executables on the host for use during the
@@ -1423,10 +1559,10 @@ Original version made by Michael Elizabeth Chastain, <mailto:mec@shout.net>
 Updates by Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>
 Updates by Sam Ravnborg <sam@ravnborg.org>
 Language QA by Jan Engelhardt <jengelh@gmx.de>
+Kbuild support for shipped files Nicholas Mc Guire <der.herr@hofr.at>
 
 === 11 TODO
 
-- Describe how kbuild supports shipped files with _shipped.
 - Generating offset header files.
 - Add more variables to section 7?
 
-- 
1.7.10.4

