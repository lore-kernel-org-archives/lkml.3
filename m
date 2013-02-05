Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3BEWJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab3BEWJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Szymon Janc <szymon.janc@tieto.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 31/93] Bluetooth: Fix sending HCI commands after reset
Date: Tue,  5 Feb 2013 20:06:20 -0200
Message-Id: <1360102042-10732-32-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Janc <szymon.janc@tieto.com>

commit dbccd791a3fbbdac12c33834b73beff3984988e9 upstream.

After sending reset command wait for its command complete event before
sending next command. Some chips sends CC event for command received
before reset if reset was send before chip replied with CC.

This is also required by specification that host shall not send
additional HCI commands before receiving CC for reset.

< HCI Command: Reset (0x03|0x0003) plen 0                              [hci0] 18.404612
> HCI Event: Command Complete (0x0e) plen 4                            [hci0] 18.405850
      Write Extended Inquiry Response (0x03|0x0052) ncmd 1
        Status: Success (0x00)
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0      [hci0] 18.406079
> HCI Event: Command Complete (0x0e) plen 4                            [hci0] 18.407864
      Reset (0x03|0x0003) ncmd 1
        Status: Success (0x00)
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0      [hci0] 18.408062
> HCI Event: Command Complete (0x0e) plen 12                           [hci0] 18.408835

Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ad9cae0..843d048 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2393,7 +2393,7 @@ static inline void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *sk
 	if (ev->opcode != HCI_OP_NOP)
 		del_timer(&hdev->cmd_timer);
 
-	if (ev->ncmd) {
+	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags)) {
 		atomic_set(&hdev->cmd_cnt, 1);
 		if (!skb_queue_empty(&hdev->cmd_q))
 			queue_work(hdev->workqueue, &hdev->cmd_work);
-- 
1.7.9.5

