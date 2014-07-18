Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbaGRNKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:22 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17490 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030501AbaGRNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/170] usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
Date: Fri, 18 Jul 2014 14:11:18 +0200
Message-Id: <6e73e2919e887d9ee07e9283db14a13d5001317d.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/f_fs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 44cf775a8627..c3067f4f213a 100644
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
2.0.0

