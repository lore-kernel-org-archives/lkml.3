Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934568AbaE2Fb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:31:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbaE2EfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 039/140] USB: usb_wwan: fix handling of missing bulk endpoints
Date: Wed, 28 May 2014 21:32:58 -0700
Message-Id: <20140529043054.397194187@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb_wwan.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -466,6 +466,9 @@ int usb_wwan_port_probe(struct usb_seria
 	int err;
 	int i;
 
+	if (!port->bulk_in_size || !port->bulk_out_size)
+		return -ENODEV;
+
 	portdata = kzalloc(sizeof(*portdata), GFP_KERNEL);
 	if (!portdata)
 		return -ENOMEM;
@@ -473,9 +476,6 @@ int usb_wwan_port_probe(struct usb_seria
 	init_usb_anchor(&portdata->delayed);
 
 	for (i = 0; i < N_IN_URB; i++) {
-		if (!port->bulk_in_size)
-			break;
-
 		buffer = (u8 *)__get_free_page(GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error;
@@ -489,9 +489,6 @@ int usb_wwan_port_probe(struct usb_seria
 	}
 
 	for (i = 0; i < N_OUT_URB; i++) {
-		if (!port->bulk_out_size)
-			break;
-
 		buffer = kmalloc(OUT_BUFLEN, GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error2;


