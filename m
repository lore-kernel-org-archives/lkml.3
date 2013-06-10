Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3FJQB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:01:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20932 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3FJQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:01:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org
Subject: [v5 1/2] xen/ring: Add a new macro to detect whether there is an overflow in requests and response.
Date: Mon, 10 Jun 2013 12:01:45 -0400
Message-Id: <1370880106-7606-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370880106-7606-1-git-send-email-konrad.wilk@oracle.com>
References: <1370880106-7606-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to exit if the difference between the request
produced (what the frontend tells us) and the requests consumed
(what we have so far processed) is greater than the ring size.

If so, we should terminate the loop as the request produced
is not trusted and it means it is bogus.

Cc: stable@vger.kernel.org
[v1: Make the macro do the ring thing, swap arguments around to
match the comment]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/interface/io/ring.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
index 75271b9..94aa885 100644
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -188,6 +188,12 @@ struct __name##_back_ring {						\
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Loop termination condition: Is the difference between request produced
+ * and request consumed greater than the ring size. If so, terminate the
+ * loop. */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod, _cons)                    \
+    (((_prod) - (_cons)) > RING_SIZE(_r))
+
 #define RING_PUSH_REQUESTS(_r) do {					\
     wmb(); /* back sees requests /before/ updated producer index */	\
     (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
-- 
1.8.1.4

