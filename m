Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbaEXPVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 11:21:55 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46197 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaEXPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 11:21:53 -0400
Date: Sat, 24 May 2014 17:22:00 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: introduce function imx_free_mx3_camera
Message-ID: <20140524152200.GA4666@lianli>
References: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
 <20140522181024.GA20155@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140522181024.GA20155@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Uwe and Greg,

> You'd do a better deed if you picked up
> http://thread.gmane.org/gmane.linux.kernel/1613364/focus=1635995

Since there is nothing wrong with the last version of the patch in
the above thread, I feel strange about picking it up and just splitting
it into two patches. However it would be good to have it applied.

I think the reason why the author didn't resend is that the object file
and data structure layout information in the changelog depend on the
changes to both .name and .dma_mask and by splitting the patch this
information would not apply to any one of the resulting two patches.

Perhaps keeping this information in the changelog is a good reason for
applying the patch as it is?

(I have attached the patch in question)

Best regards,

Emil Goode

--VbJkn9YxBvnuCH5J
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-driver-core-platform-don-t-leak-memory-allocated-for.patch"
Content-Transfer-Encoding: 8bit

>From 66b72cb8eb71974903dd40ed67a34412faf818f0 Mon Sep 17 00:00:00 2001
From: Yann Droneaud <ydroneaud@opteya.com>
Date: Mon, 27 Jan 2014 11:05:52 +0100
Subject: [PATCH] driver core/platform: don't leak memory allocated for
 dma_mask
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 01dcc60a7cb8, platform_device_register_full() is
available to allocate and register a platform device.

If a dma_mask is provided as part of platform_device_info,
platform_device_register_full() allocate memory for a u64 using
kmalloc().

A comment in the code state that "[t]his memory isn't freed when the
device is put".

It's never a good thing to leak memory, but there's only very few
users of platform_device_info's dma_mask, and those are mostly
"static" devices that are not going to be plugged/unplugged often.

So memory leak is not really an issue, but allocating 8 bytes through
kmalloc() seems overkill.

And it's a pity to have to allocate 8 bytes for the dma_mask while up
to 7 bytes are wasted at the end of struct platform_object in the form
of padding after name field: unfortunately this padding is not used
when allocating the memory to hold the name.

To address theses issues, this patch adds dma_mask to platform_object
struct so that it is always allocated for all struct platform_device
allocated through platform_device_alloc() or platform_device_register_full().
And since it's within struct platform_object, dma_mask won't be leaked
anymore when struct platform_device got released. Storage for dma_mask
is added almost for free by removing the padding at the end of struct
platform_object.

Padding at the end of the structure is removed by making name a C99
flexible array member (eg. a zero sized array). To handle this change,
memory allocation is updated to take care of allocating an additional
byte for the NUL terminating character.

No more memory leak, no small allocation, no byte wasted and
a slight reduction in code size.

Built on Fedora 20, using GCC 4.8, for ARM, i386, x86_64 and PPC64
architectures, the size of the object file and the data structure layout
are updated as follow, produced with commands:

  $ size drivers/base/platform.o
  $ pahole drivers/base/platform.o \
           --recursive             \
           --class_name device,pdev_archdata,platform_device,platform_object

  --- size+pahole.next-20140124
  +++ size+pahole.next-20140124+
  @@ -1,5 +1,5 @@
      text    data     bss     dec     hex filename
  -   5616     472      32    6120    17e8 obj-arm/drivers/base/platform.o
  +   5572     472      32    6076    17bc obj-arm/drivers/base/platform.o
   struct device {
           struct device *            parent;               /*     0     4 */
           struct device_private *    p;                    /*     4     4 */
  @@ -77,15 +77,15 @@ struct platform_object {
           /* XXX last struct has 4 bytes of padding */

           /* --- cacheline 6 boundary (384 bytes) --- */
  -        char                       name[1];              /*   384     1 */
  +        u64                        dma_mask;             /*   384     8 */
  +        char                       name[0];              /*   392     0 */

  -        /* size: 392, cachelines: 7, members: 2 */
  -        /* padding: 7 */
  +        /* size: 392, cachelines: 7, members: 3 */
           /* paddings: 1, sum paddings: 4 */
           /* last cacheline: 8 bytes */
   };

      text    data     bss     dec     hex filename
  -   6007     532      32    6571    19ab obj-i386/drivers/base/platform.o
  +   5943     532      32    6507    196b obj-i386/drivers/base/platform.o
   struct device {
           struct device *            parent;               /*     0     4 */
           struct device_private *    p;                    /*     4     4 */
  @@ -161,14 +161,14 @@ struct platform_device {
   struct platform_object {
           struct platform_device     pdev;                 /*     0   392 */
           /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
  -        char                       name[1];              /*   392     1 */
  +        u64                        dma_mask;             /*   392     8 */
  +        char                       name[0];              /*   400     0 */

  -        /* size: 396, cachelines: 7, members: 2 */
  -        /* padding: 3 */
  -        /* last cacheline: 12 bytes */
  +        /* size: 400, cachelines: 7, members: 3 */
  +        /* last cacheline: 16 bytes */
   };

      text    data     bss     dec     hex filename
  -   8851    2112      48   11011    2b03 obj-ppc64/drivers/base/platform.o
  +   8787    2104      48   10939    2abb obj-ppc64/drivers/base/platform.o
   struct device {
           struct device *            parent;               /*     0     8 */
           struct device_private *    p;                    /*     8     8 */
  @@ -256,14 +256,14 @@ struct platform_device {
   struct platform_object {
           struct platform_device     pdev;                 /*     0   728 */
           /* --- cacheline 11 boundary (704 bytes) was 24 bytes ago --- */
  -        char                       name[1];              /*   728     1 */
  +        u64                        dma_mask;             /*   728     8 */
  +        char                       name[0];              /*   736     0 */

  -        /* size: 736, cachelines: 12, members: 2 */
  -        /* padding: 7 */
  +        /* size: 736, cachelines: 12, members: 3 */
           /* last cacheline: 32 bytes */
   };

      text    data     bss     dec     hex filename
  -   7100     960      48    8108    1fac obj-x86_64/drivers/base/platform.o
  +   7020     960      48    8028    1f5c obj-x86_64/drivers/base/platform.o
   struct device {
           struct device *            parent;               /*     0     8 */
           struct device_private *    p;                    /*     8     8 */
  @@ -350,9 +350,9 @@ struct platform_device {
   struct platform_object {
           struct platform_device     pdev;                 /*     0   712 */
           /* --- cacheline 11 boundary (704 bytes) was 8 bytes ago --- */
  -        char                       name[1];              /*   712     1 */
  +        u64                        dma_mask;             /*   712     8 */
  +        char                       name[0];              /*   720     0 */

  -        /* size: 720, cachelines: 12, members: 2 */
  -        /* padding: 7 */
  +        /* size: 720, cachelines: 12, members: 3 */
           /* last cacheline: 16 bytes */
   };

Changes from v3 [1]:
- fixed commit message so that git am doesn't fail.

Changes from v2 [2]:
- move 'dma_mask' to platform_object so that it's always
  allocated and won't leak on release; remove all previously
  added support functions.
- use C99 flexible array member for 'name' to remove padding
  at the end of platform_object.

Changes from v1 [3]:
- remove unneeded kfree() from error path
- add reference to author/commit adding allocation of dmamask

Changes from v0 [4]:
- small rewrite to squeeze the patch to a bare minimal

[1] http://lkml.kernel.org/r/1390771138-28348-1-git-send-email-ydroneaud@opteya.com
    https://patchwork.kernel.org/patch/3540081/

[2] http://lkml.kernel.org/r/1389683909-17495-1-git-send-email-ydroneaud@opteya.com
    https://patchwork.kernel.org/patch/3484411/

[3] http://lkml.kernel.org/r/1389649085-7365-1-git-send-email-ydroneaud@opteya.com
    https://patchwork.kernel.org/patch/3480961/

[4] http://lkml.kernel.org/r/1386886207-2735-1-git-send-email-ydroneaud@opteya.com

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/base/platform.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 5b47210..d19769e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -162,7 +162,8 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
 
 struct platform_object {
 	struct platform_device pdev;
-	char name[1];
+	u64 dma_mask;
+	char name[];
 };
 
 /**
@@ -198,16 +199,20 @@ static void platform_device_release(struct device *dev)
  *
  * Create a platform device object which can have other objects attached
  * to it, and which will have attached objects freed when it is released.
+ *
+ * The associated struct device will be set up so that its dma_mask field
+ * is a valid pointer to an u64. This pointer must not be free'd manually.
  */
 struct platform_device *platform_device_alloc(const char *name, int id)
 {
 	struct platform_object *pa;
 
-	pa = kzalloc(sizeof(struct platform_object) + strlen(name), GFP_KERNEL);
+	pa = kzalloc(sizeof(*pa) + strlen(name) + 1, GFP_KERNEL);
 	if (pa) {
 		strcpy(pa->name, name);
 		pa->pdev.name = pa->name;
 		pa->pdev.id = id;
+		pa->pdev.dev.dma_mask = &pa->dma_mask;
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
 		arch_setup_pdev_archdata(&pa->pdev);
@@ -441,16 +446,9 @@ struct platform_device *platform_device_register_full(
 
 	if (pdevinfo->dma_mask) {
 		/*
-		 * This memory isn't freed when the device is put,
-		 * I don't have a nice idea for that though.  Conceptually
 		 * dma_mask in struct device should not be a pointer.
 		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
 		 */
-		pdev->dev.dma_mask =
-			kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
-		if (!pdev->dev.dma_mask)
-			goto err;
-
 		*pdev->dev.dma_mask = pdevinfo->dma_mask;
 		pdev->dev.coherent_dma_mask = pdevinfo->dma_mask;
 	}
@@ -469,7 +467,6 @@ struct platform_device *platform_device_register_full(
 	if (ret) {
 err:
 		ACPI_COMPANION_SET(&pdev->dev, NULL);
-		kfree(pdev->dev.dma_mask);
 
 err_alloc:
 		platform_device_put(pdev);
-- 
1.7.10.4


--VbJkn9YxBvnuCH5J--
