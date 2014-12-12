Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbaLLGWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:22:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51775 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759467AbaLLGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Quinn Tran" <quinn.tran@qlogic.com>,
        "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Saurav Kashyap" <saurav.kashyap@qlogic.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.276583896@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 041/164] target: Fix queue full status NULL pointer
 for SCF_TRANSPORT_TASK_SENSE
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3147,8 +3147,7 @@ static void transport_complete_qf(struct
 
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto out;
+		goto out;
 	}
 
 	switch (cmd->data_direction) {

