Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaFQPrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:47:51 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:64338 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbaFQPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:47:49 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        <stable@vger.kernel.org>, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
Date: Tue, 17 Jun 2014 17:47:41 +0200
Message-Id: <1403020061-20890-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <EC42AA5D-282F-4536-9E81-101A3A16D767@symbolicsound.com>
References: <EC42AA5D-282F-4536-9E81-101A3A16D767@symbolicsound.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the descriptors do not need any strings and user space sends empty
set of strings, the ffs->stringtabs field remains NULL.  Thus
*ffs->stringtabs in functionfs_bind leads to a NULL pointer
dereferenece.

The bug was introduced by commit [fd7c9a007f: “use usb_string_ids_n()”].

While at it, remove double initialisation of lang local variable in
that function.

ffs->strings_count does not need to be checked in any way since in
the above scenario it will remain zero and usb_string_ids_n() is
a no-operation when colled with 0 argument.

Cc: <stable@vger.kernel.org>  # v2.6.36+
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 74202d6..8598c27 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1483,11 +1483,13 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 	ffs->ep0req->context = ffs;
 
 	lang = ffs->stringtabs;
-	for (lang = ffs->stringtabs; *lang; ++lang) {
-		struct usb_string *str = (*lang)->strings;
-		int id = first_id;
-		for (; str->s; ++id, ++str)
-			str->id = id;
+	if (lang) {
+		for (; *lang; ++lang) {
+			struct usb_string *str = (*lang)->strings;
+			int id = first_id;
+			for (; str->s; ++id, ++str)
+				str->id = id;
+		}
 	}
 
 	ffs->gadget = cdev->gadget;
-- 
2.0.0.526.g5318336

