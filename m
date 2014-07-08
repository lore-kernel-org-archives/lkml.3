Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaGHMrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:47:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaGHMra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:47:30 -0400
From: Michal Marek <mmarek@suse.cz>
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Ronald <ronald645@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] firmware: Create directories for external firmware
Date: Tue,  8 Jul 2014 14:47:19 +0200
Message-Id: <1404823639-6496-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <CAPVoSvSmzRWSJeR9dyBO0qS6-9SWA_d-CjGuQeULGS_MRUY77w@mail.gmail.com>
References: <CAPVoSvSmzRWSJeR9dyBO0qS6-9SWA_d-CjGuQeULGS_MRUY77w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5180d5f4 ("firmware: Simplify directory creation") broke
including firmware specified in CONFIG_EXTRA_FIRMWARE:

  MK_FW   firmware/amd-ucode/microcode_amd.bin.gen.S
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
...
firmware/Makefile:185: recipe for target
'firmware/amd-ucode/microcode_amd.bin.gen.S' failed

It works with O= builds, because the directory is created by
Makefile.build. Create the directory in firmware/Makefile in non-O
builds.

Reported-by: Ronald <ronald645@gmail.com>
Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---

Can you try this patch?

Ronald, can you tell me your full name for the Reported-by: line?

Thanks.
---

 firmware/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/firmware/Makefile b/firmware/Makefile
index 5747417..0862d34 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -219,6 +219,12 @@ $(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep)
 obj-y				 += $(patsubst %,%.gen.o, $(fw-external-y))
 obj-$(CONFIG_FIRMWARE_IN_KERNEL) += $(patsubst %,%.gen.o, $(fw-shipped-y))
 
+ifeq ($(KBUILD_SRC),)
+# Makefile.build only creates subdirectories for O= builds, but external
+# firmware might live outside the kernel source tree
+_dummy := $(foreach d,$(addprefix $(obj)/,$(dir $(fw-external-y))), $(shell [ -d $(d) ] || mkdir -p $(d)))
+endif
+
 # Remove .S files and binaries created from ihex
 # (during 'make clean' .config isn't included so they're all in $(fw-shipped-))
 targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
-- 
1.8.4.5

