Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab3CGPdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:33:21 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:33883 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366Ab3CGPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:33:20 -0500
From: Andy King <acking@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: gregkh@linuxfoundation.org, pv-drivers@vmware.com,
        Andy King <acking@vmware.com>
Subject: [PATCH] VMCI: Fix process-to-process DRGAMs.
Date: Thu,  7 Mar 2013 07:29:08 -0800
Message-Id: <1362670148-27238-1-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending between processes, we always schedule a work item.  Our work info
struct has the message embedded in the middle, which means that we end up
overwriting subsequent fields when we copy the (variable-length) message into
it.  Move it to the end of the struct.

Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_datagram.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
index ed5c433..f3cdd90 100644
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -42,9 +42,11 @@ struct datagram_entry {
 
 struct delayed_datagram_info {
 	struct datagram_entry *entry;
-	struct vmci_datagram msg;
 	struct work_struct work;
 	bool in_dg_host_queue;
+	/* msg and msg_payload must be together. */
+	struct vmci_datagram msg;
+	u8 msg_payload[];
 };
 
 /* Number of in-flight host->host datagrams */
-- 
1.7.4.1

