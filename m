Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbaCUJm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760576AbaCUJmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:42:24 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC V2 3/4] vhost_net: add basic tracepoints for vhost_net
Date: Fri, 21 Mar 2014 17:41:52 +0800
Message-Id: <1395394913-19548-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1395394913-19548-1-git-send-email-jasowang@redhat.com>
References: <1395394913-19548-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help performance analyze and debugging, this patch introduces
tracepoints for vhost_net. Two tracepoints were introduced, packets
sending and receiving.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c       |  5 +++++
 drivers/vhost/net_trace.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 drivers/vhost/net_trace.h

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7353204..8ac83a9 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -30,6 +30,9 @@
 
 #include "vhost.h"
 
+#define CREATE_TRACE_POINTS
+#include "net_trace.h"
+
 static int experimental_zcopytx = 1;
 module_param(experimental_zcopytx, int, 0444);
 MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
@@ -444,6 +447,7 @@ static void handle_tx(struct vhost_net *net)
 		if (err != len)
 			pr_debug("Truncated TX packet: "
 				 " len %d != %zd\n", err, len);
+		trace_vhost_net_tx(zcopy_used, len);
 		if (!zcopy_used)
 			vhost_add_used_and_signal(&net->dev, vq, head, 0);
 		else
@@ -620,6 +624,7 @@ static void handle_rx(struct vhost_net *net)
 			vhost_discard_vq_desc(vq, headcount);
 			continue;
 		}
+		trace_vhost_net_rx(sock_len);
 		if (unlikely(vhost_hlen) &&
 		    memcpy_toiovecend(nvq->hdr, (unsigned char *)&hdr, 0,
 				      vhost_hlen)) {
diff --git a/drivers/vhost/net_trace.h b/drivers/vhost/net_trace.h
new file mode 100644
index 0000000..a99a799
--- /dev/null
+++ b/drivers/vhost/net_trace.h
@@ -0,0 +1,53 @@
+#if !defined(_TRACE_VHOST_NET_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VHOST_NET_H
+
+#include <linux/tracepoint.h>
+#include "vhost.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vhost_net
+
+TRACE_EVENT(vhost_net_tx,
+	TP_PROTO(bool zerocopy, int len),
+	TP_ARGS(zerocopy, len),
+
+	TP_STRUCT__entry(
+		__field(bool, zerocopy)
+		__field(int, len)
+	),
+
+	TP_fast_assign(
+		__entry->zerocopy = zerocopy;
+		__entry->len = len;
+	),
+
+	TP_printk("vhost_net send packet mode %s length %d\n",
+		__entry->zerocopy ? "zerocopy" : "datacopy",
+		__entry->len)
+);
+
+TRACE_EVENT(vhost_net_rx,
+	TP_PROTO(int len),
+	TP_ARGS(len),
+
+	TP_STRUCT__entry(
+		__field(int, len)
+	),
+
+	TP_fast_assign(
+		__entry->len = len;
+	),
+
+	TP_printk("vhost_net receive packet length %d\n",
+		__entry->len)
+);
+
+#endif /* _TRACE_VHOST_NET_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/vhost
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE net_trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.8.3.2

