Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3AURVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:21:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3AURRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [PATCH 14/15] samples/seccomp: be less stupid about cross compiling
Date: Mon, 21 Jan 2013 17:16:07 +0000
Message-Id: <1358788568-11137-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:bz5MEDaE5cFCRcootqhtm0c6UiBIII2qUA4+t1jZo11
 2LlkdAyeAjSAYvMa1xSfzXjnTdG3w2JoUmjbzirJ0qGz+h1JIt
 FzpVqpt7x7r/Zytq6QdrjYFYhMume3VJr7pRO1ShRPpocFUNte
 1THV8yFZOo/Csi0gtBJQf2gCL607LG90qKC1PneVQbMCbaVExc
 28rwNYKWmoNhp7CSyhog13fnvjMn6hIw1+xCJsQ4F4xtVHEKQQ
 5+5dtXgs3jZp5nAo8nuGEpeXlBBD5ee2XtRK4JsXbT4okBppXe
 sC6JVr6tRE3j5uuJ6VZp/NVSj46odRp6AX69zuGQ7cbzVZo+Py
 2H6J89uRhEMCuwJXL9NSdfItKHNV5OZHqDvPO7F8I
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seccomp filters are currently built for the build
host, not for the machine that they are going to run
on, but they are also built for with the -m32 flag
if the kernel is built for a 32 bit machine, both
of which seems rather odd.

It broke allyesconfig on my machine, which is x86-64, but
building for 32 bit ARM, with this error message:

In file included from /usr/include/stdio.h:28:0,
                 from samples/seccomp/bpf-fancy.c:15:
/usr/include/features.h:324:26: fatal error: bits/predefs.h: No such file or directory

because there are no 32 bit libc headers installed on
this machine. We should really be building all the
samples for the target machine rather than the build
host, but since the infrastructure for that appears
to be missing right now, let's be a little bit smarter
and not pass the '-m32' flag to the HOSTCC when cross-
compiling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: James Morris <james.l.morris@oracle.com>
---
 samples/seccomp/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index bbbd276..7203e66 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -19,6 +19,7 @@ bpf-direct-objs := bpf-direct.o
 
 # Try to match the kernel target.
 ifndef CONFIG_64BIT
+ifndef CROSS_COMPILE
 
 # s390 has -m31 flag to build 31 bit binaries
 ifndef CONFIG_S390
@@ -35,6 +36,7 @@ HOSTLOADLIBES_bpf-direct += $(MFLAG)
 HOSTLOADLIBES_bpf-fancy += $(MFLAG)
 HOSTLOADLIBES_dropper += $(MFLAG)
 endif
+endif
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
-- 
1.7.10.4

