Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3FDXIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:08:45 -0400
Received: from 1wt.eu ([62.212.114.60]:35529 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab3FDWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:39 -0400
Message-Id: <20130604172134.330397379@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 097/184] Bluetooth: Fix incorrect strncpy() in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 hidp_setup_hid()

From: Anderson Lizardo <anderson.lizardo@openbossa.org>

The length parameter should be sizeof(req->name) - 1 because there is no
guarantee that string provided by userspace will contain the trailing
'\0'.

Can be easily reproduced by manually setting req->name to 128 non-zero
bytes prior to ioctl(HIDPCONNADD) and checking the device name setup on
input subsystem:

$ cat /sys/devices/pnp0/00\:04/tty/ttyS0/hci0/hci0\:1/input8/name
AAAAAA[...]AAAAAAAAf0:af:f0:af:f0:af

("f0:af:f0:af:f0:af" is the device bluetooth address, taken from "phys"
field in struct hid_device due to overflow.)

Cc: stable@vger.kernel.org
Signed-off-by: Anderson Lizardo <anderson.lizardo@openbossa.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

[backported to 2.6.32 jmm]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bluetooth/hidp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 49d8495..0c2c59d 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -778,7 +778,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, 128);
+	strncpy(hid->name, req->name, sizeof(req->name) - 1);
 	strncpy(hid->phys, batostr(&src), 64);
 	strncpy(hid->uniq, batostr(&dst), 64);
 
-- 
1.7.12.2.21.g234cd45.dirty



