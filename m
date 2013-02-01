Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029Ab3BAKsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:48:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:38623 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942Ab3BAKry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:47:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Szymon Janc <szymon.janc@tieto.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 06/15] Bluetooth: Fix sending HCI commands after reset
Date: Fri,  1 Feb 2013 11:48:39 +0100
Message-Id: <20130201104756.932548260@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104756.470588207@linuxfoundation.org>
References: <20130201104756.470588207@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1823,7 +1823,7 @@ static inline void hci_cmd_complete_evt(
 	if (ev->opcode != HCI_OP_NOP)
 		del_timer(&hdev->cmd_timer);
 
-	if (ev->ncmd) {
+	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags)) {
 		atomic_set(&hdev->cmd_cnt, 1);
 		if (!skb_queue_empty(&hdev->cmd_q))
 			tasklet_schedule(&hdev->cmd_task);


