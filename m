Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3AYRcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:32:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3AYRcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:32:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] xen/ring: Add a new macro to detect whether there is an overflow in requests and response.
Date: Fri, 25 Jan 2013 12:32:31 -0500
Message-Id: <1359135152-30688-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to exit if the difference between the request
produced (what the frontend tells us) and the requests consumed
(what we have so far processed) is greater than the ring size.

If so, we should terminate the loop as the request produced
is not trusted and it means it is bogus.

Cc: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/interface/io/ring.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
index 75271b9..1114dde 100644
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -188,6 +188,12 @@ struct __name##_back_ring {						\
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Loop termination condition: Is the difference between request produced
+ * and request consumed greater than the ring size. If so, terminate the
+ * loop. */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _cons, _prod)                     \
+    (((_prod) - (_prod)) > RING_SIZE(_r))
+
 #define RING_PUSH_REQUESTS(_r) do {					\
     wmb(); /* back sees requests /before/ updated producer index */	\
     (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
-- 
1.8.0.2

