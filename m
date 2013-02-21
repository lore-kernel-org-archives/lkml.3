Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3BUPjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:39:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab3BUPjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:39:22 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDACv2 02/12] edac: add support for error type "Info"
Date: Thu, 21 Feb 2013 12:39:00 -0300
Message-Id: <c15e01abcb59f0483842be231334451fd56adfba.1361459782.git.mchehab@redhat.com>
In-Reply-To: <cover.1361459782.git.mchehab@redhat.com>
References: <cover.1361459782.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPER spec defines a forth type of error: informational
logs. Add support for it at the edac API and at the
trace event interface.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h    | 16 ++++++++++++++++
 include/ras/ras_event.h |  4 +---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index ff18efc..2049b96 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -99,8 +99,24 @@ enum hw_event_mc_err_type {
 	HW_EVENT_ERR_CORRECTED,
 	HW_EVENT_ERR_UNCORRECTED,
 	HW_EVENT_ERR_FATAL,
+	HW_EVENT_ERR_INFO,
 };
 
+static inline char *mc_event_error_type(const unsigned int err_type)
+{
+	switch (err_type) {
+	case HW_EVENT_ERR_CORRECTED:
+		return "Corrected";
+	case HW_EVENT_ERR_UNCORRECTED:
+		return "Uncorrected";
+	case HW_EVENT_ERR_FATAL:
+		return "Fatal";
+	default:
+	case HW_EVENT_ERR_INFO:
+		return "Info";
+	}
+}
+
 /**
  * enum mem_type - memory types. For a more detailed reference, please see
  *			http://en.wikipedia.org/wiki/DRAM
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 260470e..21cdb0b 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -78,9 +78,7 @@ TRACE_EVENT(mc_event,
 
 	TP_printk("%d %s error%s:%s%s on %s (mc:%d location:%d:%d:%d address:0x%08lx grain:%d syndrome:0x%08lx%s%s)",
 		  __entry->error_count,
-		  (__entry->error_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
-			((__entry->error_type == HW_EVENT_ERR_FATAL) ?
-			"Fatal" : "Uncorrected"),
+		  mc_event_error_type(__entry->error_type),
 		  __entry->error_count > 1 ? "s" : "",
 		  ((char *)__get_str(msg))[0] ? " " : "",
 		  __get_str(msg),
-- 
1.8.1.2

