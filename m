Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaBHIDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:03:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:2453 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaBHICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:02:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471776754"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/17] Kbuild, lto: Set TMPDIR for LTO
Date: Sat,  8 Feb 2014 09:01:16 +0100
Message-Id: <1391846481-31491-12-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile b/Makefile
index 606ef7c..d1189ea 100644
--- a/Makefile
+++ b/Makefile
@@ -407,6 +407,14 @@ export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
 export KBUILD_ARFLAGS
 
+ifdef CONFIG_LTO
+# LTO gcc creates a lot of files in TMPDIR, and with /tmp as tmpfs
+# it's easy to drive the machine OOM. Use the object directory
+# instead
+TMPDIR := ${objtree}
+export TMPDIR
+endif
+
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
 # even be read-only.
-- 
1.8.5.2

