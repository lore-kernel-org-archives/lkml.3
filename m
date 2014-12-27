Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaL0BbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 20:31:02 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:22461 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaL0BbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 20:31:00 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <namhyung@kernel.org>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>
Subject: [PATCH] perf: fix building error in x86_64 when dwarf unwind is on
Date: Sat, 27 Dec 2014 09:26:11 +0800
Message-ID: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.549E0BCF.00E6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 0154596339600f627baaef3d52205edf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When build with 'make ARCH=x86' and dwarf unwind is on, there is a
compiling error:

   CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
   CC       /home/wn/perf/arch/x86/tests/regs_load.o
 arch/x86/tests/regs_load.S: Assembler messages:
 arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
 arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
 make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
 make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
 make: *** [all] Error 2
 ...

Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'. However,
with 'ARCH=x86', the underlying compile may also be x86_64, which causes
mismatching.

This patch fixes it by checking __x86_64__ in both case of
'ARCH=x86_64' and 'ARCH=x86'.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/config/Makefile.arch | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
index 851cd01..303a096 100644
--- a/tools/perf/config/Makefile.arch
+++ b/tools/perf/config/Makefile.arch
@@ -15,6 +15,8 @@ endif
 
 ifeq ($(ARCH),x86_64)
   override ARCH := x86
+endif
+ifeq ($(ARCH),x86)
   IS_X86_64 := 0
   ifeq (, $(findstring m32,$(CFLAGS)))
     IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-- 
1.8.4

