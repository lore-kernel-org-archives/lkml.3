Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaGGXyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaGGXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 056/122] Bluetooth: Fix indicating discovery state when canceling inquiry
Date: Mon,  7 Jul 2014 16:56:58 -0700
Message-Id: <20140707235735.955139937@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 50143a433b70e3145bcf8a4a4e54f0c11bdee32b upstream.

When inquiry is canceled through the HCI_Cancel_Inquiry command there is
no Inquiry Complete event generated. Instead, all we get is the command
complete for the HCI_Inquiry_Cancel command. This means that we must
call the hci_discovery_set_state() function from the respective command
complete handler in order to ensure that user space knows the correct
discovery state.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -48,6 +48,10 @@ static void hci_cc_inquiry_cancel(struct
 	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
 	wake_up_bit(&hdev->flags, HCI_INQUIRY);
 
+	hci_dev_lock(hdev);
+	hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+	hci_dev_unlock(hdev);
+
 	hci_conn_check_pending(hdev);
 }
 


