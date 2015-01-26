Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbbAZFHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:07:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:37360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbbAZFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:07:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,466,1418112000"; 
   d="scan'208,223";a="517487224"
Message-ID: <54C5CB77.4000109@linux.intel.com>
Date: Mon, 26 Jan 2015 13:07:03 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, len.brown@intel.com, pavel@ucw.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM/Trace: get rid of synchronous resume limit during PM trace
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f9c841d1f943d81b5ab0aac7483e794a7f966296 Mon Sep 17 00:00:00 2001
From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
Date: Mon, 26 Jan 2015 11:27:08 +0800
Subject: [PATCH] PM/Trace: get rid of synchronous resume limit during PM trace

There are some kind of dependency between devices in some
hardware platforms. So, asynchronous resuming devices may
hang system due to wrong resume order. As a result, should
not fore synchronously resuming devices during tracing
PM events.

Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
---
 drivers/base/power/main.c    |    3 +--
 include/linux/resume-trace.h |    7 -------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9717d5f..5df148b 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -517,8 +517,7 @@ static int device_resume_noirq(struct device *dev, pm_message_t state, bool asyn
 
 static bool is_async(struct device *dev)
 {
-	return dev->power.async_suspend && pm_async_enabled
-		&& !pm_trace_is_enabled();
+	return dev->power.async_suspend && pm_async_enabled;
 }
 
 static void async_resume_noirq(void *data, async_cookie_t cookie)
diff --git a/include/linux/resume-trace.h b/include/linux/resume-trace.h
index f31db23..fd0866e 100644
--- a/include/linux/resume-trace.h
+++ b/include/linux/resume-trace.h
@@ -7,11 +7,6 @@
 
 extern int pm_trace_enabled;
 
-static inline int pm_trace_is_enabled(void)
-{
-       return pm_trace_enabled;
-}
-
 struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(const void *tracedata, unsigned int user);
@@ -24,8 +19,6 @@ extern int show_trace_dev_match(char *buf, size_t size);
 
 #else
 
-static inline int pm_trace_is_enabled(void) { return 0; }
-
 #define TRACE_DEVICE(dev) do { } while (0)
 #define TRACE_RESUME(dev) do { } while (0)
 
-- 1.7.1

