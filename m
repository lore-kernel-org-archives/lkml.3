Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaBEUGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:55166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaBEUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 128/213] Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()
Date: Wed, 5 Feb 2014 15:01:23 -0500
Message-ID: <1391630568-49251-129-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anderson Lizardo <anderson.lizardo@openbossa.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/hidp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 280529ad9274..a01808691565 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -790,7 +790,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, 128);
+	strncpy(hid->name, req->name, sizeof(req->name) - 1);
 	strncpy(hid->phys, batostr(&src), 64);
 	strncpy(hid->uniq, batostr(&dst), 64);
 
-- 
1.8.5.2

