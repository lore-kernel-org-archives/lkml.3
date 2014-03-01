Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaCACR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:27 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42613 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaCACRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:23 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Liang Zhen <liang.zhen@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 11/17] lustre/ptlrpc: rq_commit_cb is called for twice
Date: Fri, 28 Feb 2014 21:16:40 -0500
Message-Id: <1393640206-20286-12-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liang Zhen <liang.zhen@intel.com>

If a ptlrpc_request is already on imp::imp_replay_list, when it's
replayed and replied, after_reply() will call req::rq_commit_cb
for the request, then call it again in ptlrpc_free_committed.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-on: http://review.whamcloud.com/8815
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3618
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index a32b722..b6d831a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -1313,7 +1313,11 @@ static int after_reply(struct ptlrpc_request *req)
 			/** version recovery */
 			ptlrpc_save_versions(req);
 			ptlrpc_retain_replayable_request(req, imp);
-		} else if (req->rq_commit_cb != NULL) {
+		} else if (req->rq_commit_cb != NULL &&
+			   list_empty(&req->rq_replay_list)) {
+			/* NB: don't call rq_commit_cb if it's already on
+			 * rq_replay_list, ptlrpc_free_committed() will call
+			 * it later, see LU-3618 for details */
 			spin_unlock(&imp->imp_lock);
 			req->rq_commit_cb(req);
 			spin_lock(&imp->imp_lock);
-- 
1.8.5.3

