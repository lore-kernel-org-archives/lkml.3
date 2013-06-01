Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3FAXWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 19:22:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42605 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012Ab3FAXWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 19:22:19 -0400
Message-ID: <1370128938.2098.14.camel@joe-AO722>
Subject: Re: [PATCH] usb: musb: use the new %pa format specifier for
 dma_addr_t
From: Joe Perches <joe@perches.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 01 Jun 2013 16:22:18 -0700
In-Reply-To: <CA+0zTV-LtE0zZRBtOdqRm0bbT10XkGURvmddR6unWU0O0XutWQ@mail.gmail.com>
References: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
	 <1370111350.2098.1.camel@joe-AO722> <20130601190926.GA5541@debian>
	 <1370118685.2098.7.camel@joe-AO722> <51AA6E1F.7080003@infradead.org>
	 <1370124960.2098.9.camel@joe-AO722>
	 <CA+0zTV-LtE0zZRBtOdqRm0bbT10XkGURvmddR6unWU0O0XutWQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-02 at 01:06 +0200, Emil Goode wrote:
> Maybe there should be another format specifier %da and Randy's
> clarifying comment

maybe %pad but I think the whole thing isn't much necessary.
It seems there are a grand total of 3 uses of %pa today.

Maybe:
---
 Documentation/printk-formats.txt |  7 +++++++
 lib/vsprintf.c                   | 19 +++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 3af5ae6..fa48403 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -63,6 +63,13 @@ Physical addresses:
 	resource_size_t) which can vary based on build options, regardless of
 	the width of the CPU data path. Passed by reference.
 
+dma_addr_t addresses:
+
+	%pad	0x01234567 or 0x0123456789abcdef
+
+	For printing a dma_addr_t type which can vary based on build options,
+	regardless of the width of the CPU data path. Passed by reference.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7d84676..b6b8390 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1039,6 +1039,7 @@ int kptr_restrict __read_mostly;
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'ad' For a dma_addr_t type
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1129,12 +1130,22 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return netdev_feature_string(buf, end, ptr, spec);
 		}
 		break;
-	case 'a':
+	case 'a': {
+		unsigned long long val;
 		spec.flags |= SPECIAL | SMALL | ZEROPAD;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
 		spec.base = 16;
-		return number(buf, end,
-			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+		switch (fmt[1]) {
+		case 'd':
+			spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+			val = (unsigned long long)*((dma_addr_t *)ptr);
+			break;
+		default:
+			spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+			val = (unsigned long long)*((phys_addr_t *)ptr);
+			break;
+		}
+		return number(buf, end, val, spec);
+	}
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {


