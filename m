Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaHTSZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:25:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:30738 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaHTSZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,903,1400050800"; 
   d="scan'208";a="470878087"
Subject: [PATCH] firmware: Automatically pull missing FW files
To: linux-firmware@kernel.org
From: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 11:21:45 -0700
Message-ID: <20140820182145.15596.86122.stgit@tstruk-mobl1>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When a binary FW file is not present in the firmware dir then the build
will fail. This patch enables auto-download any missing FW file for both shipped
and external targets.
Generated against linux-next.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 firmware/Makefile |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/firmware/Makefile b/firmware/Makefile
index 5747417..3ad12f6 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -178,10 +178,31 @@ wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
 		include/config/superh32.h include/config/superh64.h \
 		include/config/x86_32.h include/config/x86_64.h)
 
-$(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps)
+FW_URL := git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain
+
+.NOTPARALLEL: get_missing_external $(patsubst %,$(obj)/%.gen.S, $(fw-external-y))
+.NOTPARALLEL: get_missing_shipped $(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y))
+
+get_missing_shipped:
+	@for file in $(fw-shipped-y) $(fw-shipped-m); do \
+		if [ ! -f $(obj)/$$file ]; then \
+			wget $(FW_URL)/$$file -o /dev/null -O $(obj)/$$file; \
+		fi; \
+	done;
+
+get_missing_external:
+	@for file in $(fw-external-y); do \
+		if [ ! -f $(obj)/$$file ]; then \
+			wget $(FW_URL)/$$file -o /dev/null -O $(obj)/$$file; \
+		fi; \
+	done;
+
+$(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps) \
+		get_missing_shipped
 	$(call cmd,fwbin,$(patsubst %.gen.S,%,$@))
+
 $(patsubst %,$(obj)/%.gen.S, $(fw-external-y)): %: $(wordsize_deps) \
-		include/config/extra/firmware/dir.h
+		include/config/extra/firmware/dir.h get_missing_external
 	$(call cmd,fwbin,$(fwabs)/$(patsubst $(obj)/%.gen.S,%,$@))
 
 # The .o files depend on the binaries directly; the .S files don't.

