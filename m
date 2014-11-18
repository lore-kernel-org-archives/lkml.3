Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbaKROpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:45:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbaKROKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Quinn Tran <quinn.tran@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 112/206] target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE
Date: Tue, 18 Nov 2014 15:07:47 +0100
Message-Id: <63e62ea88d0511922dd69fbee72257ad65c22099.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 334c3364837d..b37371ee9f95 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1856,8 +1856,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto out;
+		goto out;
 	}
 
 	switch (cmd->data_direction) {
-- 
2.1.3

