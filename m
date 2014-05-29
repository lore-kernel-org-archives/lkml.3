Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbaE2OS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:18:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59345 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 038/103] USB: usb_wwan: fix handling of missing bulk endpoints
Date: Thu, 29 May 2014 15:48:23 +0200
Message-Id: <f17c4324018727f3cfc767889cd496aac0e7c7e1.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bd73bd8831696f189a479a0712ae95208e513d7e upstream.

Fix regression introduced by commit 8e493ca1767d ("USB: usb_wwan: fix
bulk-urb allocation") by making sure to require both bulk-in and out
endpoints during port probe.

The original option driver (which usb_wwan is based on) was written
under the assumption that either endpoint could be missing, but
evidently this cannot have been tested properly. Specifically, it would
handle opening a device without bulk-in (but would blow up during resume
which was implemented later), but not a missing bulk-out in write()
(although it is handled in some places such as write_room()).

Fortunately (?), the driver also got the test for missing endpoints
wrong so the urbs were in fact always allocated, although they would be
initialised using the wrong endpoint address (0) and any submission of
such an urb would fail.

The commit mentioned above fixed the test for missing endpoints but
thereby exposed the other bugs which would now generate null-pointer
exceptions rather than failed urb submissions.

The regression was introduced in v3.7, but the offending commit was also
marked for stable.

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Tested-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/usb_wwan.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 85365784040b..6fa78361be56 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -470,6 +470,9 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	int err;
 	int i;
 
+	if (!port->bulk_in_size || !port->bulk_out_size)
+		return -ENODEV;
+
 	portdata = kzalloc(sizeof(*portdata), GFP_KERNEL);
 	if (!portdata)
 		return -ENOMEM;
@@ -477,9 +480,6 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	init_usb_anchor(&portdata->delayed);
 
 	for (i = 0; i < N_IN_URB; i++) {
-		if (!port->bulk_in_size)
-			break;
-
 		buffer = (u8 *)__get_free_page(GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error;
@@ -493,9 +493,6 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	}
 
 	for (i = 0; i < N_OUT_URB; i++) {
-		if (!port->bulk_out_size)
-			break;
-
 		buffer = kmalloc(OUT_BUFLEN, GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error2;
-- 
1.9.3

