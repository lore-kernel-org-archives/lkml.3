Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaFWBcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:51 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39754 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbaFWBct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:49 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Cheng Shao <cheng_shao@xyratex.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 09/18] staging/lustre/mgc: replace hard-coded MGC_ENQUEUE_LIMIT value
Date: Sun, 22 Jun 2014 21:32:13 -0400
Message-Id: <1403487142-4880-10-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Shao <cheng_shao@xyratex.com>

During client mount, the client will send an LDLM_ENQUEUE request to
MGS with send delay set to MGC_ENQUEUE_LIMIT, which is hard coded to
50 seconds. On the other hand, the interval for pinger is deduced from
obd_timeout. When obd_timeout is configured for a longer period of
time, so does the pinger. We know that connecting to the secondary MGS
node is triggered by the pinger. Now that we have a longer interval,
the pinger will not be able to try the secondary before the
LDLM_ENQUEUE request fails the mount using the same delay limit.

This code change will replace the hard-coded send delay being
mentioned above with a value that is long enough to give the client a
chance to connect to the secondary MGS if exists.

Signed-off-by: Cheng Shao <cheng_shao@xyratex.com>
Reviewed-on: http://review.whamcloud.com/9217
Xyratex-bug-id: MRP-1516
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4582
Reviewed-by: Ryan Haasken <haasken@cray.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/mgc/mgc_request.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index a806aef..28960f9 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -950,7 +950,10 @@ static int mgc_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 }
 
 /* Not sure where this should go... */
-#define  MGC_ENQUEUE_LIMIT 50
+/* This is the timeout value for MGS_CONNECT request plus a ping interval, such
+ * that we can have a chance to try the secondary MGS if any. */
+#define  MGC_ENQUEUE_LIMIT (INITIAL_CONNECT_TIMEOUT + (AT_OFF ? 0 : at_min) \
+				+ PING_INTERVAL)
 #define  MGC_TARGET_REG_LIMIT 10
 #define  MGC_SEND_PARAM_LIMIT 10
 
-- 
1.9.0

