Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbbAHPRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:17:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbAHPRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:17:53 -0500
From: Michal Marek <mmarek@suse.cz>
To: drysdale@google.com, nab@linux-iscsi.org
Cc: jkosina@suse.cz, akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: [PATCH] Makefile: include arch/*/include/generated/uapi before .../generated
Date: Thu,  8 Jan 2015 16:16:39 +0100
Message-Id: <1420730199-28579-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <54ADA21B.8010406@suse.cz>
References: <54ADA21B.8010406@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of the uapi directories in v3.7-rc1 moved some of the
generated headers from arch/*/include/generated to the uapi directory,
keeping the #include directives intact. This creates a problem when
bisecting, because the unversioned files are not cleaned automatically
by git and the compiler might include stale headers as a result. Instead
of cleaning them in the Makefiles, promote arch/*/include/generated/uapi
in the search path. Under normal circumstances, there is no overlap
between this uapi subdirectory and its parent, so the include choices
remain the same. We keep arch/*/include/generated/uapi in the
USERINCLUDE variable so that it is usable standalone.

Note that we cannot completely swap the order of the uapi and
kernel-only directories, since the headers in include/uapi/asm-generic
are meant to be wrapped by their include/asm-generic counterparts when
building kernel code.

Reported-by: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Reported-by: David Drysdale <dmd@lurklurk.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index eb4eca5..87f0c05 100644
--- a/Makefile
+++ b/Makefile
@@ -391,6 +391,7 @@ USERINCLUDE    := \
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := \
 		-I$(srctree)/arch/$(hdr-arch)/include \
+		-Iarch/$(hdr-arch)/include/generated/uapi \
 		-Iarch/$(hdr-arch)/include/generated \
 		$(if $(KBUILD_SRC), -I$(srctree)/include) \
 		-Iinclude \
-- 
2.1.2

