Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3KTOty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:49:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab3KTOtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:49:49 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Adam Kulagowski <fidor@fidor.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID: kye: fix unresponsive keyboard
Date: Wed, 20 Nov 2013 09:49:42 -0500
Message-Id: <1384958982-23099-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1384958982-23099-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1384958982-23099-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The manticore keyboard requires that all usb EP are opened at least
once to be fully functional. The third EP forwards to the user space
some vendor specific information about the keyboard state, but are useless
currently for the kernel.

Opening them and closing them makes the keyboard responsive again.

Reported-and-tested-by: Adam Kulagowski <fidor@fidor.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, this one was a long shot as I do not have the hardware to actually
spot the exact call which enables the keyboard. Adam told me that just
opening and closing once all the /dev/hidrawX attached to the keyboard makes
the keyboard functional, so, here is the kernel version of this.
Anyway, it just works, so I think we can take this one as well.

Cheers,
Benjamin

 drivers/hid/hid-kye.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 35a4f9c..ecb5ca6 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -421,6 +421,14 @@ static int kye_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			goto enabling_err;
 		}
 		break;
+	case USB_DEVICE_ID_GENIUS_MANTICORE:
+		/*
+		 * The manticore keyboard needs to have all the interfaces
+		 * opened at least once to be fully functional.
+		 */
+		if (hid_hw_open(hdev))
+			hid_hw_close(hdev);
+		break;
 	}
 
 	return 0;
-- 
1.8.3.1

