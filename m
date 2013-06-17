Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3FQTrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:47:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19240 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3FQTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:47:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/io/ring.h: new macro to detect whether there are too many requests on the ring
Date: Mon, 17 Jun 2013 15:47:33 -0400
Message-Id: <1371498454-2116-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371498454-2116-1-git-send-email-konrad.wilk@oracle.com>
References: <1371498454-2116-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

Backends may need to protect themselves against an insane number of
produced requests stored by a frontend, in case they iterate over
requests until reaching the req_prod value. There can't be more
requests on the ring than the difference between produced requests
and produced (but possibly not yet published) responses.

This is a more strict alternative to a patch previously posted by
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/interface/io/ring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
index 75271b9..7d28aff 100644
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -188,6 +188,11 @@ struct __name##_back_ring {						\
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Ill-behaved frontend determination: Can there be this many requests? */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod)               \
+    (((_prod) - (_r)->rsp_prod_pvt) > RING_SIZE(_r))
+
+
 #define RING_PUSH_REQUESTS(_r) do {					\
     wmb(); /* back sees requests /before/ updated producer index */	\
     (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
-- 
1.8.1.4

