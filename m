Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaAPXyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:54:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60134 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAPXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:54:07 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/8] perf: add PMU_RANGE_ATTR() helper for use by sw-like pmus
Date: Thu, 16 Jan 2014 15:53:47 -0800
Message-Id: <1389916434-2288-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011623-1542-0000-0000-0000054CECCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PMU_RANGE_ATTR() and PMU_RANGE_RESV() (for reserved areas) which
generate functions to extract the relevent bits from
event->attr.config{,1,2} for use by sw-like pmus where the
'config{,1,2}' values don't map directly to hardware registers.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e069d1..8646e33 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -870,4 +870,21 @@ _name##_show(struct device *dev,					\
 									\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
+#define PMU_RANGE_ATTR(name, attr_var, bit_start, bit_end)		\
+PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);		\
+PMU_RANGE_RESV(name, attr_var, bit_start, bit_end)
+
+#define PMU_RANGE_RESV(name, attr_var, bit_start, bit_end)		\
+static u64 event_get_##name##_max(void)					\
+{									\
+	int bits = (bit_end) - (bit_start) + 1;				\
+	return ((0x1ULL << (bits - 1ULL)) - 1ULL) |			\
+		(0xFULL << (bits - 4ULL));				\
+}									\
+static u64 event_get_##name(struct perf_event *event)			\
+{									\
+	return (event->attr.attr_var >> (bit_start)) &			\
+		event_get_##name##_max();				\
+}
+
 #endif /* _LINUX_PERF_EVENT_H */
-- 
1.8.5.2

