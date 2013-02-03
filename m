Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3BCO5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34418 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604Ab3BCO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:58 -0500
Message-Id: <20130203144651.096276020@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 079/128] Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/hidp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index ccd985d..03652f3 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -931,7 +931,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, 128);
+	strncpy(hid->name, req->name, sizeof(req->name) - 1);
 	strncpy(hid->phys, batostr(&bt_sk(session->ctrl_sock->sk)->src), 64);
 	strncpy(hid->uniq, batostr(&bt_sk(session->ctrl_sock->sk)->dst), 64);
 


