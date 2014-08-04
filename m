Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaHDRRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:17:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56456 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michal Nazarewicz" <mina86@mina86.com>,
        "Felipe Balbi" <balbi@ti.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.532055220@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 06/94] usb: gadget: f_fs: fix NULL pointer dereference
 when there are no strings
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_fs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1376,11 +1376,13 @@ static int functionfs_bind(struct ffs_da
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

