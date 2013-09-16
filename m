Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3IPShM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:37:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43758 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3IPShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:37:10 -0400
Date: Mon, 16 Sep 2013 21:33:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
 synthetic keyboard
Message-ID: <20130916183319.GM19256@mwanda>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916082110.GN25896@mwanda>
 <3b5096d0190b4440a8e25afbd22ab72d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916150548.GO25896@mwanda>
 <baabf219b12b40de8e17b029e621e079@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916170951.GB20734@core.coreip.homeip.net>
 <3e45f054c6e243eabf2896ab1dcf38d4@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e45f054c6e243eabf2896ab1dcf38d4@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just roll something like the following into your patch.

regards,
dan carpenter

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index 0d4625f..262721b 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -151,15 +151,18 @@ static void hv_kbd_free_device(struct hv_kbd_dev *device)
 }
 
 static void hv_kbd_on_receive(struct hv_device *device,
-				struct vmpacket_descriptor *packet)
+			      struct vmpacket_descriptor *packet, size_t size)
 {
 	struct synth_kbd_msg *msg;
 	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(device);
 	struct synth_kbd_keystroke *ks_msg;
+	int offset;
 	u16 scan_code;
 
-	msg = (struct synth_kbd_msg *)((unsigned long)packet +
-					(packet->offset8 << 3));
+	offset = packet->offset8 << 3;
+	if (offset + sizeof(struct synth_kbd_protocol_response) > size)
+		return;
+	msg = (void *)packet + offset;
 
 	switch (msg->header.type) {
 	case SYNTH_KBD_PROTOCOL_RESPONSE:
@@ -220,7 +223,7 @@ static void hv_kbd_on_channel_callback(void *context)
 				break;
 
 			case VM_PKT_DATA_INBAND:
-				hv_kbd_on_receive(device, desc);
+				hv_kbd_on_receive(device, desc, bytes_recvd);
 				break;
 
 			default:
