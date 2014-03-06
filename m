Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbaCFAEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:04:54 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57402 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbaCFABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:01:52 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v4 02/11] perf: add PMU_FORMAT_RANGE() helper for use by sw-like pmus
Date: Wed,  5 Mar 2014 16:01:01 -0800
Message-Id: <1394064082-6242-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-5806-0000-0000-000024488EFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PMU_FORMAT_RANGE() and PMU_FORMAT_RANGE_RESERVED() (for reserved
areas) which generate functions to extract the relevent bits from
event->attr.config{,1,2} for use by sw-like pmus where the
'config{,1,2}' values don't map directly to hardware registers.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..5c12009 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -871,4 +871,27 @@ _name##_show(struct device *dev,					\
 									\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
+#define format_max(name) FORMAT_MAX_(name)()
+#define FORMAT_MAX_(name) format_##name##_max
+
+#define format_get(name, event) FORMAT_GET_(name)(event)
+#define FORMAT_GET_(name) format_get_##name
+
+#define PMU_FORMAT_RANGE(name, attr_var, bit_start, bit_end)		\
+PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)		\
+PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end)
+
+#define PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)	\
+static u64 FORMAT_MAX_(name)(void)					\
+{									\
+	BUILD_BUG_ON((bit_start > bit_end)				\
+		    || (bit_end >= (sizeof(1ull) * 8)));		\
+	return (((1ull << (bit_end - bit_start)) - 1) << 1) + 1;	\
+}									\
+static u64 FORMAT_GET_(name)(struct perf_event *event)			\
+{									\
+	return (event->attr.attr_var >> (bit_start)) &			\
+		format_max(name);					\
+}
+
 #endif /* _LINUX_PERF_EVENT_H */
-- 
1.9.0

