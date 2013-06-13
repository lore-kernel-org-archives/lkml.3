Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3FMIE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:04:57 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:59889 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3FMIEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:04:53 -0400
Date: Thu, 13 Jun 2013 11:04:42 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130613080442.GA14677@x220>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
	gustavo@padovan.org, linux-bluetooth@vger.kernel.org
References: <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
 <20130610193746.GA30801@amd.pavel.ucw.cz>
 <20130611072245.GA12463@x220>
 <20130611102025.GA5580@x220>
 <20130612112326.GA4237@amd.pavel.ucw.cz>
 <20130613072327.GA12951@x220>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20130613072327.GA12951@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pavel,

On Thu, Jun 13, 2013, Johan Hedberg wrote:
> On Wed, Jun 12, 2013, Pavel Machek wrote:
> > < HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> > > HCI Event: Command Complete (0x0e) plen 68
> >     Read Local Supported Commands (0x04|0x0002) ncmd 1
> >     status 0x00
> >     Commands: ffffffffffff1ffffffffffff30fffff3f
> 
> As I suspected, even though the Delete Stored Link Key command is
> mandatory from Bluetooth version 1.1 onwards (this controller supports
> 2.0) this controller doesn't have it mentioned in its supported commands
> response (counting from 0 it should be bit 7 of octet 6). Therefore, it
> might be possible to just move sending of this problematic command to
> after receiving the supported commands response and making it
> conditional to having its respective bit set in the mask. I'll be
> sending another patch proposal soon.

I just sent a patch to linux-bluetooth for this. It would be nice if you
could revert the previous patch, apply this one instead (also attached
to this email) and let us know if it works fine.

Johan

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Bluetooth-Fix-conditions-for-HCI_Delete_Stored_Link_.patch"

>From b7b3eb3d3cf615d1249dc9387a619f2729cf0d84 Mon Sep 17 00:00:00 2001
From: Johan Hedberg <johan.hedberg@intel.com>
Date: Thu, 13 Jun 2013 10:53:48 +0300
Subject: [PATCH] Bluetooth: Fix conditions for HCI_Delete_Stored_Link_Key

Even though the HCI_Delete_Stored_Link_Key command is mandatory for 1.1
and later controllers some controllers do not seem to support it
properly as was witnessed by one Broadcom based controller:

< HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
    bdaddr 00:00:00:00:00:00 all 1
> HCI Event: Command Complete (0x0e) plen 4
    Delete Stored Link Key (0x03|0x0012) ncmd 1
    status 0x11 deleted 0
    Error: Unsupported Feature or Parameter Value

Luckily this same controller also doesn't list the command in its
supported commands bit mask (counting from 0 bit 7 of octet 6):

< HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
    Read Local Supported Commands (0x04|0x0002) ncmd 1
    status 0x00
    Commands: ffffffffffff1ffffffffffff30fffff3f

Therefore, it makes sense to move sending of HCI_Delete_Stored_Link_Key
to after receiving the supported commands response and to only send it
if its respective bit in the mask is set. The downside of this is that
we no longer send the HCI_Delete_Stored_Link_Key command for Bluetooth
1.1 controllers since HCI_Read_Local_Supported_Command was introduced in
version 1.2, but this is an acceptable penalty as the command in
question shouldn't affect critical behavior.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
---
 net/bluetooth/hci_core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d817c93..d68425c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -341,7 +341,6 @@ static void hci_init1_req(struct hci_request *req, unsigned long opt)
 
 static void bredr_setup(struct hci_request *req)
 {
-	struct hci_cp_delete_stored_link_key cp;
 	__le16 param;
 	__u8 flt_type;
 
@@ -365,10 +364,6 @@ static void bredr_setup(struct hci_request *req)
 	param = __constant_cpu_to_le16(0x7d00);
 	hci_req_add(req, HCI_OP_WRITE_CA_TIMEOUT, 2, &param);
 
-	bacpy(&cp.bdaddr, BDADDR_ANY);
-	cp.delete_all = 0x01;
-	hci_req_add(req, HCI_OP_DELETE_STORED_LINK_KEY, sizeof(cp), &cp);
-
 	/* Read page scan parameters */
 	if (req->hdev->hci_ver > BLUETOOTH_VER_1_1) {
 		hci_req_add(req, HCI_OP_READ_PAGE_SCAN_ACTIVITY, 0, NULL);
@@ -602,6 +597,15 @@ static void hci_init3_req(struct hci_request *req, unsigned long opt)
 	struct hci_dev *hdev = req->hdev;
 	u8 p;
 
+	if (hdev->commands[6] & 0x80) {
+		struct hci_cp_delete_stored_link_key cp;
+
+		bacpy(&cp.bdaddr, BDADDR_ANY);
+		cp.delete_all = 0x01;
+		hci_req_add(req, HCI_OP_DELETE_STORED_LINK_KEY,
+			    sizeof(cp), &cp);
+	}
+
 	if (hdev->commands[5] & 0x10)
 		hci_setup_link_policy(req);
 
-- 
1.7.10.4


--M9NhX3UHpAaciwkO--
