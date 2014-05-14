Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaENOAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:00:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:42078 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaENOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:00:48 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2] bluetooth: don't include local processing of HCI commands in the command timeout
Date: Wed, 14 May 2014 16:00:24 +0200
Message-Id: <1400076025-5103-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume the timeout for processing HCI commands was originally intended to
detect hung bluetooth devices and should not include the time needed locally
to handle the response to an HCI command. That is important because the time
needed locally (by the kernel or even userland) to process responses to HCI
commands varies a lot between systems and HCI commands. That's even more true
since many actions to HCI command responses are handled inside works which
might be delayed quiet some time, depending on the actual system load.

So stop the timeout as soon as a response to an HCI command was received.

This fixes various problems which resulted in HCI command timeouts and an
afterwards non-working bluetooth stack, especially on slower systems like
some ARM devices.

Drawback is that in-kernel problems like deadlocks aren't detected by HCI
command timeouts anymore, but such problems should be detected and handled
by other means and not by a timeout where it is hard to specify a value
reasonable for all possible systems (-configurations, -loads).

Furthermore, if the timeout includes local processing of HCI command
responses, in-kernel errors like hung tasks might be masked by the
timeout, because the hung task would be killed by the timeout before
the hung task would be detected (by other means).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 net/bluetooth/hci_event.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 15010a2..94c2dc0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2338,6 +2338,9 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	opcode = __le16_to_cpu(ev->opcode);
 
+	if (opcode != HCI_OP_NOP)
+		del_timer(&hdev->cmd_timer);
+
 	switch (opcode) {
 	case HCI_OP_INQUIRY_CANCEL:
 		hci_cc_inquiry_cancel(hdev, skb);
@@ -2584,9 +2587,6 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		break;
 	}
 
-	if (opcode != HCI_OP_NOP)
-		del_timer(&hdev->cmd_timer);
-
 	hci_req_cmd_complete(hdev, opcode, status);
 
 	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags)) {
@@ -2605,6 +2605,9 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	opcode = __le16_to_cpu(ev->opcode);
 
+	if (opcode != HCI_OP_NOP)
+		del_timer(&hdev->cmd_timer);
+
 	switch (opcode) {
 	case HCI_OP_INQUIRY:
 		hci_cs_inquiry(hdev, ev->status);
@@ -2675,9 +2678,6 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		break;
 	}
 
-	if (opcode != HCI_OP_NOP)
-		del_timer(&hdev->cmd_timer);
-
 	if (ev->status ||
 	    (hdev->sent_cmd && !bt_cb(hdev->sent_cmd)->req.event))
 		hci_req_cmd_complete(hdev, opcode, ev->status);
-- 
1.8.3.1

