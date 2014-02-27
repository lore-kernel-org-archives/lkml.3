Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaB0Vbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:31:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:54470 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaB0Vbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:31:34 -0500
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
Subject: [PATCH v3 02/11] perf: add PMU_FORMAT_RANGE() helper for use by sw-like pmus
Date: Thu, 27 Feb 2014 13:04:55 -0800
Message-Id: <1393535105-7528-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022721-9332-0000-0000-0000033F4A31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PMU_FORMAT_RANGE() and PMU_FORMAT_RANGE_RESERVED() (for reserved
areas) which generate functions to extract the relevent bits from
event->attr.config{,1,2} for use by sw-like pmus where the
'config{,1,2}' values don't map directly to hardware registers.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..3da5081 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -871,4 +871,21 @@ _name##_show(struct device *dev,					\
 									\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
+#define PMU_FORMAT_RANGE(name, attr_var, bit_start, bit_end)		\
+PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);		\
+PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)
+
+#define PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)	\
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
1.9.0

