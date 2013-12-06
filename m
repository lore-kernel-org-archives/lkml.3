Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab3LFOFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:05:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab3LFNBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/272] HID: appleir: force input to be set
Date: Fri,  6 Dec 2013 12:55:57 +0000
Message-Id: <1386334761-25517-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 3d18bd41a82fac69c82e1725c7beea25b17a0190 upstream.

Some weird remotes are not correctly creating the input device. Their
report descriptor starts with:
0x06, 0x00, 0xff,              // Usage Page (Vendor Defined Page 1)  0
0xa1, 0x01,                    // Collection (Application)            3

whereas others (which are correctly handled) start with:
0x05, 0x0c,                    // Usage Page (Consumer Devices)       0
0x09, 0x01,                    // Usage (Consumer Control)            2
0xa1, 0x01,                    // Collection (Application)            4

The rest of the report descriptor is the same.

Adding the quirk HID_QUIRK_HIDINPUT_FORCE forces hid-input to allocate
the inputs, and everything should be ok.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Tested-by: James Henstridge <james.henstridge@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-appleir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
index a42e6a3..0e6a42d 100644
--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -297,6 +297,9 @@ static int appleir_probe(struct hid_device *hid, const struct hid_device_id *id)
 
 	appleir->hid = hid;
 
+	/* force input as some remotes bypass the input registration */
+	hid->quirks |= HID_QUIRK_HIDINPUT_FORCE;
+
 	spin_lock_init(&appleir->lock);
 	setup_timer(&appleir->key_up_timer,
 		    key_up_tick, (unsigned long) appleir);
-- 
1.8.3.2

