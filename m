Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3BEWJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3BEWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 32/93] Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()
Date: Tue,  5 Feb 2013 20:06:21 -0200
Message-Id: <1360102042-10732-33-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anderson Lizardo <anderson.lizardo@openbossa.org>

commit 0a9ab9bdb3e891762553f667066190c1d22ad62b upstream.

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

Signed-off-by: Anderson Lizardo <anderson.lizardo@openbossa.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bluetooth/hidp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 2c20d76..217359b 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -949,7 +949,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, 128);
+	strncpy(hid->name, req->name, sizeof(req->name) - 1);
 	strncpy(hid->phys, batostr(&bt_sk(session->ctrl_sock->sk)->src), 64);
 	strncpy(hid->uniq, batostr(&bt_sk(session->ctrl_sock->sk)->dst), 64);
 
-- 
1.7.9.5

