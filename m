Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaGMSnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:43:52 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60644 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGMSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:43:28 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/6] samples: use uapiprogs support for seccomp
Date: Sun, 13 Jul 2014 20:42:51 +0200
Message-Id: <1405276974-17323-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
 <1405276974-17323-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce complexity of seccomp Makefile by introducing use of uapiprogs support.
Build testet with i686 only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 samples/Makefile         |  2 +-
 samples/seccomp/Makefile | 48 ++----------------------------------------------
 2 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 7c08028..b4d7d66 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -11,5 +11,5 @@ obj-$(CONFIG_SAMPLES) += rpmsg/
 obj-$(CONFIG_SAMPLES) += kdb/
 
 # user space programs
-obj-$(CONFIG_SAMPLES) += seccomp/
+subdir-$(CONFIG_SAMPLES) += seccomp
 obj-$(CONFIG_SAMPLES) += hidraw/
diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 1b4e4b8..8f11cf4 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -1,48 +1,4 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
+uapiprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
 
-hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
+bpf-fancy-y := bpf-fancy.o bpf-helper.o
 
-HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
-HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
-HOSTCFLAGS_bpf-helper.o += -I$(objtree)/usr/include
-HOSTCFLAGS_bpf-helper.o += -idirafter $(objtree)/include
-bpf-fancy-objs := bpf-fancy.o bpf-helper.o
-
-HOSTCFLAGS_dropper.o += -I$(objtree)/usr/include
-HOSTCFLAGS_dropper.o += -idirafter $(objtree)/include
-dropper-objs := dropper.o
-
-HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
-HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
-bpf-direct-objs := bpf-direct.o
-
-# Try to match the kernel target.
-ifndef CROSS_COMPILE
-ifndef CONFIG_64BIT
-
-# s390 has -m31 flag to build 31 bit binaries
-ifndef CONFIG_S390
-MFLAG = -m32
-else
-MFLAG = -m31
-endif
-
-HOSTCFLAGS_bpf-direct.o += $(MFLAG)
-HOSTCFLAGS_dropper.o += $(MFLAG)
-HOSTCFLAGS_bpf-helper.o += $(MFLAG)
-HOSTCFLAGS_bpf-fancy.o += $(MFLAG)
-HOSTLOADLIBES_bpf-direct += $(MFLAG)
-HOSTLOADLIBES_bpf-fancy += $(MFLAG)
-HOSTLOADLIBES_dropper += $(MFLAG)
-endif
-always := $(hostprogs-y)
-else
-# MIPS system calls are defined based on the -mabi that is passed
-# to the toolchain which may or may not be a valid option
-# for the host toolchain. So disable tests if target architecture
-# is MIPS but the host isn't.
-ifndef CONFIG_MIPS
-always := $(hostprogs-y)
-endif
-endif
-- 
1.9.3

