Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaIEOKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:10:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755AbaIEOKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:10:01 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, mingo@redhat.com, whissi@whissi.de, dyoung@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, keescook@chromium.org,
        chaowang@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/4] kaslr: check if the random addr is available
Date: Fri,  5 Sep 2014 22:08:15 +0800
Message-Id: <1409926097-2101-3-git-send-email-bhe@redhat.com>
In-Reply-To: <1409926097-2101-1-git-send-email-bhe@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kaslr enabling can extend the kernel virtual address space
to 1G, next is for modules. So if kernel is loaded to above 1G, system
running will be exceptional, This happened when kexec/kdump load kernel.

So add a check to see if the decompression output region is contained
in 1G.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/misc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7780a5b..d2a0eaa 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -250,6 +250,11 @@ static void handle_relocations(void *output, unsigned long output_len)
 	}
 #endif
 
+	if (max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
+                debug_putstr("Random addr is not allowed. No relocation needed... \n");
+                return;
+        }
+
 	/*
 	 * Calculate the delta between where vmlinux was linked to load
 	 * and where it was actually loaded.
-- 
1.8.5.3

