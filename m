Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3APQAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3APQAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 046/222] USB: OHCI: workaround for hardware bug: retired TDs not added to the Done Queue
Date: Wed, 16 Jan 2013 13:54:06 -0200
Message-Id: <1358351822-7675-47-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 50ce5c0683aa83eb161624ea89daa5a9eee0c2ce upstream.

This patch (as1636) is a partial workaround for a hardware bug
affecting OHCI controllers by NVIDIA at least, maybe others too.  When
the controller retires a Transfer Descriptor, it is supposed to add
the TD onto the Done Queue.  But sometimes this doesn't happen, with
the result that ohci-hcd never realizes the corresponding transfer has
finished.  Symptoms can vary; a typical result is that USB audio stops
working after a while.

The patch works around the problem by recognizing that TDs are always
processed in order.  Therefore, if a later TD is found on the Done
Queue than all the earlier TDs for the same endpoint must be finished
as well.

Unfortunately this won't solve the problem in cases where the missing
TD is the last one in the endpoint's queue.  A complete fix would
require a signficant amount of change to the driver.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/ohci-q.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index c5a1ea9..9d00d47 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -1128,6 +1128,25 @@ dl_done_list (struct ohci_hcd *ohci)
 
 	while (td) {
 		struct td	*td_next = td->next_dl_td;
+		struct ed	*ed = td->ed;
+
+		/*
+		 * Some OHCI controllers (NVIDIA for sure, maybe others)
+		 * occasionally forget to add TDs to the done queue.  Since
+		 * TDs for a given endpoint are always processed in order,
+		 * if we find a TD on the donelist then all of its
+		 * predecessors must be finished as well.
+		 */
+		for (;;) {
+			struct td	*td2;
+
+			td2 = list_first_entry(&ed->td_list, struct td,
+					td_list);
+			if (td2 == td)
+				break;
+			takeback_td(ohci, td2);
+		}
+
 		takeback_td(ohci, td);
 		td = td_next;
 	}
-- 
1.7.9.5

