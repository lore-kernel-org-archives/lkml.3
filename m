Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbaJ1Gr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:47:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbaJ1Ds7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:48:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Loic Poulain <loic.poulain@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.14 048/100] Bluetooth: Fix HCI H5 corrupted ack value
Date: Tue, 28 Oct 2014 11:35:33 +0800
Message-Id: <20141028033502.778946246@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@intel.com>

commit 4807b51895dce8aa650ebebc51fa4a795ed6b8b8 upstream.

In this expression: seq = (seq - 1) % 8
seq (u8) is implicitly converted to an int in the arithmetic operation.
So if seq value is 0, operation is ((0 - 1) % 8) => (-1 % 8) => -1.
The new seq value is 0xff which is an invalid ACK value, we expect 0x07.
It leads to frequent dropped ACK and retransmission.
Fix this by using '&' binary operator instead of '%'.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_h5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -237,7 +237,7 @@ static void h5_pkt_cull(struct h5 *h5)
 			break;
 
 		to_remove--;
-		seq = (seq - 1) % 8;
+		seq = (seq - 1) & 0x07;
 	}
 
 	if (seq != h5->rx_ack)


