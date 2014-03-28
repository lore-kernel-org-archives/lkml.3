Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaC2P0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:26:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60582 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaC2P0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:26:46 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 17/29] ktap: add Makefile for kernel module(kernel/trace/ktap/Makefile)
Date: Fri, 28 Mar 2014 10:45:12 -0400
Message-Id: <1396017924-7754-18-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Makefile compiles kernel module and generate ktapvm.ko.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 kernel/trace/ktap/Makefile | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 kernel/trace/ktap/Makefile

diff --git a/kernel/trace/ktap/Makefile b/kernel/trace/ktap/Makefile
new file mode 100644
index 0000000..6168ac2
--- /dev/null
+++ b/kernel/trace/ktap/Makefile
@@ -0,0 +1,50 @@
+# Define amalg to enable amalgamation build, This compiles the ktapvm as
+# one huge C file and allows GCC to generate faster and shorter code. Also,
+# this requires lots of memory during the build.
+# Recommend to use amalgmation build as default.
+amalg = 1
+
+# Do not instrument the tracer itself:
+ifdef CONFIG_FUNCTION_TRACER
+ORIG_CFLAGS := $(KBUILD_CFLAGS)
+KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
+endif
+
+all: mod
+
+KTAP_LIBS = -lpthread
+
+LIB_OBJS += lib_base.o lib_kdebug.o lib_timer.o lib_ansi.o lib_table.o \
+		lib_net.o
+
+ifndef amalg
+RUNTIME_OBJS += ktap.o kp_bcread.o kp_obj.o kp_str.o kp_mempool.o \
+		kp_tab.o kp_vm.o kp_transport.o kp_events.o $(LIB_OBJS)
+else
+RUNTIME_OBJS += amalg.o
+endif
+
+obj-m		+= ktapvm.o
+ktapvm-y	:= $(RUNTIME_OBJS)
+
+KVERSION ?= $(shell uname -r)
+KERNEL_SRC ?= /lib/modules/$(KVERSION)/build
+PWD := $(shell pwd)
+mod:
+	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) modules
+
+modules_install:
+	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) modules_install
+
+load:
+	insmod ktapvm.ko
+
+unload:
+	rmmod ktapvm
+
+reload:
+	make unload; make load
+
+clean:
+	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) clean
+
-- 
1.8.1.4

