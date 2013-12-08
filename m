Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3LHE0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 23:26:07 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36184 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3LHE0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 23:26:03 -0500
From: Rui Wang <ruiv.wang@gmail.com>
To: bp@alien8.de
Cc: lance.ortiz@hp.com, bhelgaas@google.com, lance_ortiz@hotmail.com,
        jiang.liu@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com,
        m.chehab@samsung.com, Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH] aerdrv: Fix severity usage in aer trace event
Date: Sun,  8 Dec 2013 12:17:53 +0800
Message-Id: <1386476273-2418-1-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's inconsistency between dmesg and the trace event output.
When dmesg says "severity=Corrected", the trace event says
"severity=Fatal". What happens is that HW_EVENT_ERR_CORRECTED is
defined in edac.h:

enum hw_event_mc_err_type {
        HW_EVENT_ERR_CORRECTED,
        HW_EVENT_ERR_UNCORRECTED,
        HW_EVENT_ERR_FATAL,
        HW_EVENT_ERR_INFO,
};

while aer_print_error() uses aer_error_severity_string[] defined as:

static const char *aer_error_severity_string[] = {
        "Uncorrected (Non-Fatal)",
        "Uncorrected (Fatal)",
        "Corrected"
};

In this case dmesg is correct because info->severity is assigned in
aer_isr_one_error() using the definitions in include/linux/ras.h:

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 include/trace/events/ras.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
index 88b8783..1c875ad 100644
--- a/include/trace/events/ras.h
+++ b/include/trace/events/ras.h
@@ -5,7 +5,7 @@
 #define _TRACE_AER_H
 
 #include <linux/tracepoint.h>
-#include <linux/edac.h>
+#include <linux/aer.h>
 
 
 /*
@@ -63,10 +63,10 @@ TRACE_EVENT(aer_event,
 
 	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
 		__get_str(dev_name),
-		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
-			__entry->severity == HW_EVENT_ERR_FATAL ?
-			"Fatal" : "Uncorrected",
-		__entry->severity == HW_EVENT_ERR_CORRECTED ?
+		__entry->severity == AER_CORRECTABLE ? "Corrected" :
+			__entry->severity == AER_FATAL ?
+			"Fatal" : "Uncorrected, non-fatal",
+		__entry->severity == AER_CORRECTABLE ?
 		__print_flags(__entry->status, "|", aer_correctable_errors) :
 		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
 );
-- 
1.7.5.4

