Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbbANHZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:25:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbANHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 3.18 036/150] Bluetooth: Fix controller configuration with HCI_QUIRK_INVALID_BDADDR
Date: Tue, 13 Jan 2015 23:21:47 -0800
Message-Id: <20150114072057.500860034@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 8bfe8442ff20fdc2d965c197103d935a99bd3296 upstream.

When controllers set the HCI_QUIRK_INVALID_BDADDR flag, it is required
by userspace to program a valid public Bluetooth device address into
the controller before it can be used.

After successful address configuration, the internal state changes and
the controller runs the complete initialization procedure. However one
small difference is that this is no longer the HCI_SETUP stage. The
HCI_SETUP stage is only valid during initial controller setup. In this
case the stack runs the initialization as part of the HCI_CONFIG stage.

The controller version information, default name and supported commands
are only stored during HCI_SETUP. While these information are static,
they are not read initially when HCI_QUIRK_INVALID_BDADDR is set. So
when running in HCI_CONFIG state, these information need to be updated
as well.

This especially impacts Bluetooth 4.1 and later controllers using
extended feature pages and second event mask page.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -239,7 +239,8 @@ static void hci_cc_read_local_name(struc
 	if (rp->status)
 		return;
 
-	if (test_bit(HCI_SETUP, &hdev->dev_flags))
+	if (test_bit(HCI_SETUP, &hdev->dev_flags) ||
+	    test_bit(HCI_CONFIG, &hdev->dev_flags))
 		memcpy(hdev->dev_name, rp->name, HCI_MAX_NAME_LENGTH);
 }
 
@@ -494,7 +495,8 @@ static void hci_cc_read_local_version(st
 	if (rp->status)
 		return;
 
-	if (test_bit(HCI_SETUP, &hdev->dev_flags)) {
+	if (test_bit(HCI_SETUP, &hdev->dev_flags) ||
+	    test_bit(HCI_CONFIG, &hdev->dev_flags)) {
 		hdev->hci_ver = rp->hci_ver;
 		hdev->hci_rev = __le16_to_cpu(rp->hci_rev);
 		hdev->lmp_ver = rp->lmp_ver;
@@ -513,7 +515,8 @@ static void hci_cc_read_local_commands(s
 	if (rp->status)
 		return;
 
-	if (test_bit(HCI_SETUP, &hdev->dev_flags))
+	if (test_bit(HCI_SETUP, &hdev->dev_flags) ||
+	    test_bit(HCI_CONFIG, &hdev->dev_flags))
 		memcpy(hdev->commands, rp->commands, sizeof(hdev->commands));
 }
 


