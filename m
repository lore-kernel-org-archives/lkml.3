Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaLXRhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:37:06 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39305 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaLXRhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:37:03 -0500
Date: Wed, 24 Dec 2014 19:36:52 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.19-rc1 refuse connection from bluetooth headset
Message-ID: <20141224173652.GA16667@t440s.P-661HNU-DI-F1>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201412241815.12922@pali>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412241815.12922@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Pali,

On Wed, Dec 24, 2014, Pali Rohár wrote:
> now I installed 3.19-rc1 kernel and my bluetooth headset was refused
> to connect automatically. I need to start connection manually from
> laptop (and then it working). Before when I started bluetooth headset
> it automatically connected and I did not have to do anything. Now with
> 3.19-rc1 kernel I need to do connection manually and I see error
> messages in hcidump:
> 
>  $ sudo hcidump 
>  HCI sniffer - Bluetooth packet analyzer ver 2.2
>  device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
>  > HCI Event: Connect Request (0x04) plen 10
>      bdaddr <HEADSET_ADDRESS> class 0x240404 type ACL
>  < HCI Command: Reject Connection Request (0x01|0x000a) plen 7
>      bdaddr <HEADSET_ADDRESS> reason 0x0f
>      Reason: Connection Rejected due to Unacceptable BD_ADDR
>  > HCI Event: Command Status (0x0f) plen 4
>      Reject Connection Request (0x01|0x000a) status 0x00 ncmd 1
>  > HCI Event: Connect Complete (0x03) plen 11
>      status 0x0f handle 34 bdaddr <HEADSET_ADDRESS> type ACL encrypt 0x00
>      Error: Connection Rejected due to Unacceptable BD_ADDR
>  > HCI Event: Connect Request (0x04) plen 10
>      bdaddr <HEADSET_ADDRESS> class 0x240404 type ACL
>  < HCI Command: Reject Connection Request (0x01|0x000a) plen 7
>      bdaddr <HEADSET_ADDRESS> reason 0x0f
>      Reason: Connection Rejected due to Unacceptable BD_ADDR
>  > HCI Event: Command Status (0x0f) plen 4
>      Reject Connection Request (0x01|0x000a) status 0x00 ncmd 1
>  > HCI Event: Connect Complete (0x03) plen 11
>     status 0x0f handle 35 bdaddr <HEADSET_ADDRESS> type ACL encrypt 0x00
>     Error: Connection Rejected due to Unacceptable BD_ADDR
> 
> (real address of my bluetooth headset was replaced by <HEADSET_ADDRESS>)
> 
> Can you inspect why new kernel refuse connection from my bluetooth headset?
> 
> I'm still using bluez 4.98 (which is in Ubuntu 12.04), I did not do any update.

Could you try the attached patch? I think the reason might be the
dependence on the HCI_CONNECTABLE flag that's only set if the page scan
was enabled through mgmt (which wouldn't be the case with BlueZ 4.98).

Johan

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="conn-reject.patch"

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index c03d4b09caa3..898dfd7ceeee 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2197,7 +2197,8 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	if (!test_bit(HCI_CONNECTABLE, &hdev->dev_flags) &&
+	if (test_bit(HCI_MGMT, &hdev->dev_flags) &&
+	    !test_bit(HCI_CONNECTABLE, &hdev->dev_flags) &&
 	    !hci_bdaddr_list_lookup(&hdev->whitelist, &ev->bdaddr,
 				    BDADDR_BREDR)) {
 		    hci_reject_conn(hdev, &ev->bdaddr);

--wac7ysb48OaltWcw--
