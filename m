Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab3HNK4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:56:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3HNKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 18/75] xen/io/ring.h: new macro to detect whether there are too many requests on the ring
Date: Wed, 14 Aug 2013 11:36:07 +0100
Message-Id: <1376476624-10011-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 8d9256906a97c24e97e016482b9be06ea2532b05 upstream.

Backends may need to protect themselves against an insane number of
produced requests stored by a frontend, in case they iterate over
requests until reaching the req_prod value. There can't be more
requests on the ring than the difference between produced requests
and produced (but possibly not yet published) responses.

This is a more strict alternative to a patch previously posted by
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

