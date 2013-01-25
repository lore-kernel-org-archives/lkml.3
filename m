Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3AYP2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:28:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59072 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab3AYP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:28:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [PATCH 1/5] samples/seccomp: be less stupid about cross compiling
Date: Fri, 25 Jan 2013 15:28:27 +0000
Message-Id: <1359127711-19070-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359127711-19070-1-git-send-email-arnd@arndb.de>
References: <1359127711-19070-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Csibt/crt+ozgTv6XrJBpLjVhxOA9hmSqVRzZQ3FJxm
 IT/8J+GqyyGeaJEmb0h2oxs28GbK6gBYFfV/twztR7aogdLue8
 1oT5yYQLG7PWHaTld/X92fAOT8cTpmLwrLOwaZS5bQqNzaYfvX
 Na2Fie68nX89SaSaed3atjZNsrIi0xNsGiv0dPxrNDXUdnmzX2
 N3oixZNnGNozh/0fnjcygwI2s31j3BEmnGHnnVxpqfOMemPZfa
 2HvWnW9nwv2tMx/AncgGK+DPxeMHlYHbIviYu7iR3DGNznZGyZ
 46ENb5wc/GXnWuQi0iocTX2JbmGHTbppBpNx4S2v2YUENOQIiQ
 e6LsoBj2gwimneFPYXrQpxuHYySk04pDm8SuT9mQv
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
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Morris <james.l.morris@oracle.com>
---
 samples/seccomp/Makefile | 2 ++
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
1.8.0

