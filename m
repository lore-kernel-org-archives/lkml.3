Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3AXDbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3AXDaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 44/74] target: Release se_cmd when LUN lookup fails for TMR
Date: Thu, 24 Jan 2013 01:26:56 -0200
Message-Id: <1358998046-613-45-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 5a3b6fc0092c5f8dee7820064ee54d2631d48573 upstream.

When transport_lookup_tmr_lun() fails and we return a task management
response from target_complete_tmr_failure(), we need to call
transport_cmd_check_stop_to_fabric() to release the last ref to the
cmd after calling se_tfo->queue_tm_rsp(), or else we will never remove
the failed TMR from the session command list (and we'll end up waiting
forever when trying to tear down the session).

(nab: Fix minor compile breakage)

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_transport.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d6c73e8..047f49a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1614,6 +1614,8 @@ static void target_complete_tmr_failure(struct work_struct *work)
 
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
+
+	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
 /**
-- 
1.7.9.5

