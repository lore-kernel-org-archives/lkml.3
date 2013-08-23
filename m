Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3HWVZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:25:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3HWVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:25:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 14/15] pmu_bus: convert bus code to use dev_groups
Date: Fri, 23 Aug 2013 14:24:40 -0700
Message-Id: <1377293081-10957-14-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the pmu bus code to use
the correct field.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f86599e8..0417ccae 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6189,6 +6189,7 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
 
 	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
 }
+static DEVICE_ATTR_RO(type);
 
 static ssize_t
 perf_event_mux_interval_ms_show(struct device *dev,
@@ -6233,17 +6234,19 @@ perf_event_mux_interval_ms_store(struct device *dev,
 
 	return count;
 }
+static DEVICE_ATTR_RW(perf_event_mux_interval_ms);
 
-static struct device_attribute pmu_dev_attrs[] = {
-	__ATTR_RO(type),
-	__ATTR_RW(perf_event_mux_interval_ms),
-	__ATTR_NULL,
+static struct attribute *pmu_dev_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_perf_event_mux_interval_ms.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(pmu_dev);
 
 static int pmu_bus_running;
 static struct bus_type pmu_bus = {
 	.name		= "event_source",
-	.dev_attrs	= pmu_dev_attrs,
+	.dev_groups	= pmu_dev_groups,
 };
 
 static void pmu_dev_release(struct device *dev)
-- 
1.8.3.rc0.20.gb99dd2e

