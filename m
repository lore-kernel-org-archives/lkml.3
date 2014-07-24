Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934950AbaGXKM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:12:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934483AbaGXJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/128] usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
Date: Thu, 24 Jul 2014 10:45:04 +0100
Message-Id: <1406195177-8656-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Nazarewicz <mina86@mina86.com>

commit f0688c8b81d2ea239c3fb0b848f623b579238d99 upstream.

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

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/f_fs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index b6e9d917221e..84219f656051 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1389,11 +1389,13 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
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
1.9.1

