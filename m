Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaBNV2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:28:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:9979 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaBNVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="475474951"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/19] Kbuild, lto: Set TMPDIR for LTO v2
Date: Fri, 14 Feb 2014 22:21:37 +0100
Message-Id: <1392412903-25733-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LTO gcc puts a lot of data into $TMPDIR, essentially another copy
of the object directory to pass the repartitioned object files
to the code generation processes.

TMPDIR defaults to /tmp With /tmp as tmpfs it's easy to drive systems to
out of memory, because they will compete with the already high anonymous
memory consumption of the wpa LTO pass.

When LTO is set always set TMPDIR to the object directory. This could
be slightly slower, but is far safer and eliminates another parameter
the LTO user would need to set manually.

I made it conditional on LTO for now.

v2: Allow user to override (H. Peter Anvin)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile b/Makefile
index 933e1de..23629a9 100644
--- a/Makefile
+++ b/Makefile
@@ -407,6 +407,14 @@ export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
 export KBUILD_ARFLAGS
 
+ifdef CONFIG_LTO
+# LTO gcc creates a lot of files in TMPDIR, and with /tmp as tmpfs
+# it's easy to drive the machine OOM. Use the object directory
+# instead
+TMPDIR ?= ${objtree}
+export TMPDIR
+endif
+
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
 # even be read-only.
-- 
1.8.5.2

