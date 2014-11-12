Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231AbaKLBoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:44:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862AbaKLBn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Quinn Tran <quinn.tran@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 092/203] target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE
Date: Wed, 12 Nov 2014 10:16:02 +0900
Message-Id: <20141112011546.921813530@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1855,8 +1855,7 @@ static void transport_complete_qf(struct
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto out;
+		goto out;
 	}
 
 	switch (cmd->data_direction) {


