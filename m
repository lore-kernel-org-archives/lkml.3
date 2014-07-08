Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaGHVcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:32:36 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:41537 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaGHVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:32:34 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Tony Breeds <tony@bakeyournoodle.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] sh: Also try passing -m4-nofpu for SH2A builds
Date: Tue,  8 Jul 2014 23:32:24 +0200
Message-Id: <1404855144-24439-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling a SH2A kernel (e.g. se7206_defconfig or rsk7203_defconfig)
using sh4-linux-gcc, linking fails with:

net/built-in.o: In function `__sk_run_filter':
net/core/filter.c:566: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/core/filter.c:269: undefined reference to `__fpscr_values'
net/built-in.o:net/core/filter.c:580: more undefined references to `__fpscr_values' follow

This happens because sh4-linux-gcc doesn't support the "-m2a-nofpu", which
is thus filtered out by "$(call cc-option, ...)".

As compiling using sh4-linux-gcc is useful for compile coverage, also try
passing "-m4-nofpu" (which is presumably filtered out when using a real
sh2a-linux toolchain) to disable the generation of FPU instructions and
references to __fpscr_values[].

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/sh/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index d4d16e4be07c..bf5b3f5f4962 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -32,7 +32,8 @@ endif
 
 cflags-$(CONFIG_CPU_SH2)		:= $(call cc-option,-m2,)
 cflags-$(CONFIG_CPU_SH2A)		+= $(call cc-option,-m2a,) \
-					   $(call cc-option,-m2a-nofpu,)
+					   $(call cc-option,-m2a-nofpu,) \
+					   $(call cc-option,-m4-nofpu,)
 cflags-$(CONFIG_CPU_SH3)		:= $(call cc-option,-m3,)
 cflags-$(CONFIG_CPU_SH4)		:= $(call cc-option,-m4,) \
 	$(call cc-option,-mno-implicit-fp,-m4-nofpu)
-- 
1.9.1

