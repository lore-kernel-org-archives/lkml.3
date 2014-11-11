Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaKKMKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:10:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaKKLJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Quinn Tran <quinn.tran@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 015/170] target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE
Date: Tue, 11 Nov 2014 11:06:14 +0000
Message-Id: <1415704129-12709-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <quinn.tran@qlogic.com>

commit 082f58ac4a48d3f5cb4597232cb2ac6823a96f43 upstream.

During temporary resource starvation at lower transport layer, command
is placed on queue full retry path, which expose this problem.  The TCM
queue full handling of SCF_TRANSPORT_TASK_SENSE currently sends the same
cmd twice to lower layer.  The 1st time led to cmd normal free path.
The 2nd time cause Null pointer access.

This regression bug was originally introduced v3.1-rc code in the
following commit:

commit e057f53308a5f071556ee80586b99ee755bf07f5
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Oct 17 13:56:41 2011 -0400

    target: remove the transport_qf_callback se_cmd callback

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fa62fc93e0b..ab610146681d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1877,8 +1877,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto out;
+		goto out;
 	}
 
 	switch (cmd->data_direction) {
-- 
2.1.0

