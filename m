Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3KNIim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:38:42 -0500
Received: from mail.abilis.ch ([195.70.19.74]:17197 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3KNIik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:38:40 -0500
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Pavel Roskin <proski@gnu.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 1/2] init/Kconfig: add option to disable kernel compression
Date: Thu, 14 Nov 2013 09:38:15 +0100
Message-Id: <1384418296-10374-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20131114083247.GB9687@ab42.lan>
References: <20131114083247.GB9687@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ARC users say they can boot faster with without kernel compression.
This probably depends on things like the FLASH chip they use etc.

Until now, kernel compression can only be disabled by removing "select
HAVE_<compression>" lines from the architecture Kconfig.  So add the
Kconfig logic to permit disabling of kernel compression.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 arch/arc/Kconfig |  2 ++
 init/Kconfig     | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 91dbb27..3991f03 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -21,6 +21,8 @@ config ARC
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IOREMAP_PROT
+	select HAVE_KERNEL_UNCOMPRESSED
+	select HAVE_KERNEL_GZIP
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_MEMBLOCK
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..b1a6f92 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -97,6 +97,9 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config HAVE_KERNEL_UNCOMPRESSED
+        bool
+
 config HAVE_KERNEL_GZIP
 	bool
 
@@ -118,7 +121,6 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -137,6 +139,14 @@ choice
 
 	  If in doubt, select 'gzip'
 
+config KERNEL_UNCOMPRESSED
+	bool "No compression"
+	depends on HAVE_KERNEL_UNCOMPRESSED || ! ( HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4 )
+	help
+	  No compression at all. The kernel is huge but the compression and
+	  decompression times are zero.
+	  This is usually not what you want.
+
 config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
-- 
1.8.4

