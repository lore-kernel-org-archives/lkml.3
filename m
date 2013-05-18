Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab3ERC2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3ERCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:48 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Lq-Sf9WM1fsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=BUtIXEvGtNEA:10 a=pGLkceISAAAA:8 a=danhDmx_AAAA:8 a=lLZmtIKjAAAA:8 a=CBV8Sz_GAAAA:8 a=PW-KNzBFAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=1OrWvrq8L0TdeMSKBIYA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.943878382@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tormod Volden <debian.tormod@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 020/136 ] usb-storage: CY7C68300A chips do not support Cypress ATACB
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0020-usb-storage-CY7C68300A-chips-do-not-support-Cypress-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tormod Volden <debian.tormod@gmail.com>

[ Upstream commit 671b4b2ba9266cbcfe7210a704e9ea487dcaa988 ]

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/storage/cypress_atacb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 5fe451d..c1f6751 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -248,14 +248,26 @@ static int cypress_probe(struct usb_interface *intf,
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
-- 
1.7.10.4


