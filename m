Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3KNQyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:54:11 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50533 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3KNQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:53 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ned Bass <bass6@llnl.gov>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 22/39] staging/lustre/mdc: document mdc_rpc_lock
Date: Fri, 15 Nov 2013 00:32:45 +0800
Message-Id: <1384446782-13741-23-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ned Bass <bass6@llnl.gov>

As this lock can be a bottleneck, clarifying why it is needed may be
helpful to those working on client performance.

Lustre-change: http://review.whamcloud.com/6593
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3443
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_mdc.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/lustre_mdc.h b/drivers/staging/lustre/lustre/include/lustre_mdc.h
index 1900025..3bb2f83 100644
--- a/drivers/staging/lustre/lustre/include/lustre_mdc.h
+++ b/drivers/staging/lustre/lustre/include/lustre_mdc.h
@@ -67,9 +67,27 @@ struct obd_export;
 struct ptlrpc_request;
 struct obd_device;
 
+/**
+ * Serializes in-flight MDT-modifying RPC requests to preserve idempotency.
+ *
+ * This mutex is used to implement execute-once semantics on the MDT.
+ * The MDT stores the last transaction ID and result for every client in
+ * its last_rcvd file. If the client doesn't get a reply, it can safely
+ * resend the request and the MDT will reconstruct the reply being aware
+ * that the request has already been executed. Without this lock,
+ * execution status of concurrent in-flight requests would be
+ * overwritten.
+ *
+ * This design limits the extent to which we can keep a full pipeline of
+ * in-flight requests from a single client.  This limitation could be
+ * overcome by allowing multiple slots per client in the last_rcvd file.
+ */
 struct mdc_rpc_lock {
+	/** Lock protecting in-flight RPC concurrency. */
 	struct mutex		rpcl_mutex;
+	/** Intent associated with currently executing request. */
 	struct lookup_intent	*rpcl_it;
+	/** Used for MDS/RPC load testing purposes. */
 	int			rpcl_fakes;
 };
 
-- 
1.7.9.5

