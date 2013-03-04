Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3CDNn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:43:27 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59332 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497Ab3CDNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:43:26 -0500
Message-ID: <1362404600.16460.26.camel@x61.thuisdomein>
Subject: [PATCH] [media] m920x: let GCC see 'ret' is used initialized
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Mar 2013 14:43:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Mar 2013 13:43:20.0449 (UTC) FILETIME=[3BBECF10:01CE18DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7543f344e9b06afe86b55a2620f5c11b38bd5642 ("[media] m920x:
factor out a m920x_write_seq() function") building m920x.o triggers this
GCC warning:
    drivers/media/usb/dvb-usb/m920x.c: In function ‘m920x_probe’:
    drivers/media/usb/dvb-usb/m920x.c:91:6: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]

This warning is caused by m920x_write_seq(), which is apparently inlined
into m920x_probe(). It is clear why GCC thinks 'ret' may be used
uninitialized. But in practice the first seq->address will always be
non-zero when this function is called. That means we can change the
while()-do{} loop into a do{}-while() loop. And that suffices to make
GCC see that 'ret' will not be used uninitialized.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only!

 drivers/media/usb/dvb-usb/m920x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 92afeb2..79b31ae 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -68,13 +68,13 @@ static inline int m920x_write_seq(struct usb_device *udev, u8 request,
 				  struct m920x_inits *seq)
 {
 	int ret;
-	while (seq->address) {
+	do {
 		ret = m920x_write(udev, request, seq->data, seq->address);
 		if (ret != 0)
 			return ret;
 
 		seq++;
-	}
+	} while (seq->address);
 
 	return ret;
 }
-- 
1.7.11.7

