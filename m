Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab3EFXjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:39:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760372Ab3EFXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tormod Volden <debian.tormod@gmail.com>
Subject: [ 028/104] usb-storage: CY7C68300A chips do not support Cypress ATACB
Date: Mon,  6 May 2013 16:11:47 -0700
Message-Id: <20130506230046.490583354@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tormod Volden <debian.tormod@gmail.com>

commit 671b4b2ba9266cbcfe7210a704e9ea487dcaa988 upstream.

Many cards based on CY7C68300A/B/C use the USB ID 04b4:6830 but only the
B and C variants (EZ-USB AT2LP) support the ATA Command Block
functionality, according to the data sheets. The A variant (EZ-USB AT2)
locks up if ATACB is attempted, until a typical 30 seconds timeout runs
out and a USB reset is performed.

https://bugs.launchpad.net/bugs/428469

It seems that one way to spot a CY7C68300A (at least where the card
manufacturer left Cypress' EEPROM default vaules, against Cypress'
recommendations) is to look at the USB string descriptor indices.

A http://media.digikey.com/pdf/Data%20Sheets/Cypress%20PDFs/CY7C68300A.pdf
B http://www.farnell.com/datasheets/43456.pdf
C http://www.cypress.com/?rID=14189

Note that a CY7C68300B/C chip appears as CY7C68300A if it is running
in Backward Compatibility Mode, and if ATACB would be supported in this
case there is anyway no way to tell which chip it really is.

For 5 years my external USB drive has been locking up for half a minute
when plugged in and ata_id is run by udev, or anytime hdparm or similar
is run on it.

Finally looking at the /correct/ datasheet I think I found the reason. I
am aware the quirk in this patch is a bit hacky, but the hardware
manufacturers haven't made it easy for us.

Signed-off-by: Tormod Volden <debian.tormod@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/cypress_atacb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -248,14 +248,26 @@ static int cypress_probe(struct usb_inte
 {
 	struct us_data *us;
 	int result;
+	struct usb_device *device;
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - cypress_usb_ids) + cypress_unusual_dev_list);
 	if (result)
 		return result;
 
-	us->protocol_name = "Transparent SCSI with Cypress ATACB";
-	us->proto_handler = cypress_atacb_passthrough;
+	/* Among CY7C68300 chips, the A revision does not support Cypress ATACB
+	 * Filter out this revision from EEPROM default descriptor values
+	 */
+	device = interface_to_usbdev(intf);
+	if (device->descriptor.iManufacturer != 0x38 ||
+	    device->descriptor.iProduct != 0x4e ||
+	    device->descriptor.iSerialNumber != 0x64) {
+		us->protocol_name = "Transparent SCSI with Cypress ATACB";
+		us->proto_handler = cypress_atacb_passthrough;
+	} else {
+		us->protocol_name = "Transparent SCSI";
+		us->proto_handler = usb_stor_transparent_scsi_command;
+	}
 
 	result = usb_stor_probe2(us);
 	return result;


