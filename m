Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3FKKUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:20:38 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:46201 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3FKKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:20:36 -0400
Date: Tue, 11 Jun 2013 13:20:25 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130611102025.GA5580@x220>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
	gustavo@padovan.org, linux-bluetooth@vger.kernel.org
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
 <20130610193746.GA30801@amd.pavel.ucw.cz>
 <20130611072245.GA12463@x220>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20130611072245.GA12463@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pavel,

On Tue, Jun 11, 2013, Johan Hedberg wrote:
> On Mon, Jun 10, 2013, Pavel Machek wrote:
> > < HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> >     bdaddr 00:00:00:00:00:00 all 1
> > > HCI Event: Command Complete (0x0e) plen 4
> >     Delete Stored Link Key (0x03|0x0012) ncmd 1
> >     status 0x11 deleted 0
> >     Error: Unsupported Feature or Parameter Value
> 
> Here's the cause of your issue. It's not one of the recently added HCI
> commands but one that's been around for quite some time. I just checked
> and it's even there in kernel 3.9, so I'm surprised that you're saying
> this is a regression since that version. Are you completely sure about
> it?

Could you try if the attached patch helps? It modifies the HCI request
state tracking to allow flagging certain HCI commands as non-critical
and just ignores their failures.

If the patch helps, could you still provide a HCI trace (both plain text
and btsnoop format) of a successful "hciconfig hci0 up"? It might help
create a simpler patch for this issue.

Johan

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="del_link_keys.patch"

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 10eb9b3..2ee2520 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -265,6 +265,7 @@ typedef void (*hci_req_complete_t)(struct hci_dev *hdev, u8 status);
 
 struct hci_req_ctrl {
 	bool			start;
+	bool			ignore_status;
 	u8			event;
 	hci_req_complete_t	complete;
 };
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 7cb6d36..f1d7500 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1084,7 +1084,7 @@ int hci_req_run(struct hci_request *req, hci_req_complete_t complete);
 void hci_req_add(struct hci_request *req, u16 opcode, u32 plen,
 		 const void *param);
 void hci_req_add_ev(struct hci_request *req, u16 opcode, u32 plen,
-		    const void *param, u8 event);
+		    const void *param, u8 event, bool ignore_status);
 void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status);
 
 struct sk_buff *__hci_cmd_sync(struct hci_dev *hdev, u16 opcode, u32 plen,
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d817c93..c3d5056 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -145,7 +145,7 @@ struct sk_buff *__hci_cmd_sync_ev(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	hci_req_init(&req, hdev);
 
-	hci_req_add_ev(&req, opcode, plen, param, event);
+	hci_req_add_ev(&req, opcode, plen, param, event, false);
 
 	hdev->req_status = HCI_REQ_PEND;
 
@@ -367,7 +367,8 @@ static void bredr_setup(struct hci_request *req)
 
 	bacpy(&cp.bdaddr, BDADDR_ANY);
 	cp.delete_all = 0x01;
-	hci_req_add(req, HCI_OP_DELETE_STORED_LINK_KEY, sizeof(cp), &cp);
+	hci_req_add_ev(req, HCI_OP_DELETE_STORED_LINK_KEY, sizeof(cp), &cp,
+		       0, true);
 
 	/* Read page scan parameters */
 	if (req->hdev->hci_ver > BLUETOOTH_VER_1_1) {
@@ -2669,7 +2670,7 @@ int hci_send_cmd(struct hci_dev *hdev, __u16 opcode, __u32 plen,
 
 /* Queue a command to an asynchronous HCI request */
 void hci_req_add_ev(struct hci_request *req, u16 opcode, u32 plen,
-		    const void *param, u8 event)
+		    const void *param, u8 event, bool ignore_status)
 {
 	struct hci_dev *hdev = req->hdev;
 	struct sk_buff *skb;
@@ -2694,6 +2695,7 @@ void hci_req_add_ev(struct hci_request *req, u16 opcode, u32 plen,
 		bt_cb(skb)->req.start = true;
 
 	bt_cb(skb)->req.event = event;
+	bt_cb(skb)->req.ignore_status = ignore_status;
 
 	skb_queue_tail(&req->cmd_q, skb);
 }
@@ -2701,7 +2703,7 @@ void hci_req_add_ev(struct hci_request *req, u16 opcode, u32 plen,
 void hci_req_add(struct hci_request *req, u16 opcode, u32 plen,
 		 const void *param)
 {
-	hci_req_add_ev(req, opcode, plen, param, 0);
+	hci_req_add_ev(req, opcode, plen, param, 0, false);
 }
 
 /* Get data from the previously sent command */
@@ -3425,6 +3427,10 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status)
 		return;
 	}
 
+	/* Check for commands whose failures aren't critical */
+	if (bt_cb(hdev->sent_cmd)->req.ignore_status)
+		status = 0;
+
 	/* If the command succeeded and there's still more commands in
 	 * this request the request is not yet complete.
 	 */

--G4iJoqBmSsgzjUCe--
