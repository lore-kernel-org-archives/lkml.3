Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaEZQlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:41:49 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:35638 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaEZQlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:41:21 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 2/3] driver core/platform: make .name of struct platform_object a C99 flexible array
Date: Mon, 26 May 2014 18:41:22 +0200
Message-Id: <1401122483-31603-2-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>

The changes made by this patch was originally part of the patch available
in the below link. It was requested that the change to .name was made in
a separate patch.

http://lkml.kernel.org/r/1390817152-30898-1-git-send-email-ydroneaud@opteya.com

It's a pity that 7 bytes are wasted at the end of struct platform_object
in the form of padding after name field: unfortunately this padding is not
used when allocating the memory to hold the name.

By making .name of struct platform_object a C99 flexible array member
(eg. a zero sized array), padding at the end of the structure is removed
making the storage for .dma_mask almost for free.

To handle this change, memory allocation is updated to take care of
allocating an additional byte for the NUL terminating character.

Built on Debian jessie, using GCC 4.8, for ARM and x86_64 architectures,
the size of the object file and the data structure layout are updated
as follows, produced with commands:

$ size drivers/base/platform.o
$ pahole drivers/base/platform.o \
	--recursive		 \
	--class_name device,pdev_archdata,platform_device,platform_object

-- size+pahole_3.15-rc6_ARM
++ size+pahole_3.15-rc6_ARM+
@@ -2,7 +2,7 @@
    text	   data	    bss	    dec	    hex	filename
-   6482	   1008	      8	   7498	   1d4a	drivers/base/platform.o
+   6486	   1008	      8	   7502	   1d4e	drivers/base/platform.o

@@ -91,15 +91,10 @@ struct platform_object {
 	/* XXX last struct has 4 bytes of padding */

 	/* --- cacheline 12 boundary (768 bytes) was 40 bytes ago --- */
-	char                       name[1];             /*   808     1 */
+	u64                        dma_mask;            /*   808     8 */
+	char                       name[0];             /*   816     0 */

-	/* XXX 7 bytes hole, try to pack */

-	u64                        dma_mask;            /*   816     8 */

-	/* size: 824, cachelines: 13, members: 3 */
-	/* sum members: 817, holes: 1, sum holes: 7 */
+	/* size: 816, cachelines: 13, members: 3 */
 	/* paddings: 1, sum paddings: 4 */
-	/* last cacheline: 56 bytes */
+	/* last cacheline: 48 bytes */
 };

(Note that on x86 the size command didn't show any difference)

-- size+pahole_3.15-rc6_x86_64
++ size+pahole_3.15-rc6_x86_64+
@@ -93,13 +93,10 @@ struct platform_device {
 struct platform_object {
 	struct platform_device     pdev;                /*     0  1440 */
 	/* --- cacheline 22 boundary (1408 bytes) was 32 bytes ago --- */
-	char                       name[1];             /*  1440     1 */
+	u64                        dma_mask;            /*  1440     8 */
+	char                       name[0];             /*  1448     0 */

-	/* XXX 7 bytes hole, try to pack */

-	u64                        dma_mask;            /*  1448     8 */

-	/* size: 1456, cachelines: 23, members: 3 */
-	/* sum members: 1449, holes: 1, sum holes: 7 */
-	/* last cacheline: 48 bytes */
+	/* size: 1448, cachelines: 23, members: 3 */
+	/* last cacheline: 40 bytes */
 };

Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
[Emil: split the original patch, updated changelog and
 generated new data structure layout info]
Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/base/platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dd1fa07..ba98219 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -165,8 +165,8 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
 
 struct platform_object {
 	struct platform_device pdev;
-	char name[1];
 	u64 dma_mask;
+	char name[];
 };
 
 /**
@@ -210,7 +210,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 {
 	struct platform_object *pa;
 
-	pa = kzalloc(sizeof(struct platform_object) + strlen(name), GFP_KERNEL);
+	pa = kzalloc(sizeof(*pa) + strlen(name) + 1, GFP_KERNEL);
 	if (pa) {
 		strcpy(pa->name, name);
 		pa->pdev.name = pa->name;
-- 
1.7.10.4

