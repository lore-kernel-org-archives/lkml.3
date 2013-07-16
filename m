Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab3GPWPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:15:46 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64516 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3GPWPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:15:44 -0400
MIME-Version: 1.0
Date: Tue, 16 Jul 2013 18:15:42 -0400
Message-ID: <CAOULuOb3-gA36S=xhA_pwLT0vf9Bb973d3Qq40KfsnS15R_qWA@mail.gmail.com>
Subject: [PATCH] BGRT: Don't ioremap if image address is in System RAM (was:
 Re: BGRT Pointer in System RAM)
From: Parag Warudkar <parag.lkml@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 8:00 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> On Mon, Jul 15, 2013 at 7:56 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>> On Mon, Jul 15, 2013 at 7:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>>
>>> We do need to handle the case of a valid pointer into memory that e820
>>> calls system RAM, as well as the case of a valid pointer into memory
>>> reserved for the BIOS or similar, but not the case of an invalid
>>> pointer.
>>
>> Would that be as simple as
>>
>>                      page_is_ram(
>
> Damn shortcuts -
>                         virt_addr = phys_to_virt(image->base_address);
>                         if(page_is_ram(virt_to_page(virt_addr))) {
>                             //direct read from virt addr
>                         }
>
> Would that suffice for the System RAM case or some other MM trickery
> is involved?

Ok, so I played around with it a bit and the following patch works
fine on my system. (I.E. image size is reasonable, cat
/sys/firmware/acpi/bgrt/image > img.bmp generates a valid,
non-distorted bitmap, which it did before too, btw as despite of the
ioremap WARN_ON the ioremap seems to succeed if !(is_ram &&
pfn_valid(pfn) && !PageReserved.)

The patch also includes a check for the status bit - if it's not 1,
the boot image cannot be assumed to be valid per the spec, so we just
ignore it in that case.

This also shouldn't impact other machines unless the page_is_ram check
is wrong - but that's copied straight out of ioremap.c!

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index 7145ec6..c894047 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -16,6 +16,8 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>

+extern int page_is_ram(unsigned long pfn);
+
 struct acpi_table_bgrt *bgrt_tab;
 void *__initdata bgrt_image;
 size_t __initdata bgrt_image_size;
@@ -31,6 +33,7 @@ void __init efi_bgrt_init(void)
  void __iomem *image;
  bool ioremapped = false;
  struct bmp_header bmp_header;
+ int img_addr_in_ram;

  if (acpi_disabled)
  return;
@@ -42,25 +45,36 @@ void __init efi_bgrt_init(void)

  if (bgrt_tab->header.length < sizeof(*bgrt_tab))
  return;
- if (bgrt_tab->version != 1)
+ if (!bgrt_tab->status || bgrt_tab->version != 1)
  return;
  if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
  return;
-
- image = efi_lookup_mapped_addr(bgrt_tab->image_address);
- if (!image) {
- image = ioremap(bgrt_tab->image_address, sizeof(bmp_header));
- ioremapped = true;
- if (!image)
- return;
+ /* Before ioremap check if image address falls in System RAM */
+ img_addr_in_ram = page_is_ram(bgrt_tab->image_address >> PAGE_SHIFT);
+ if (img_addr_in_ram) {
+ pr_info("BGRT: Image Address falls in System RAM");
+ image = phys_to_virt(bgrt_tab->image_address);
+ } else {
+ image = efi_lookup_mapped_addr(bgrt_tab->image_address);
+ if (!image) {
+ image = ioremap(bgrt_tab->image_address,
+ sizeof(bmp_header));
+ ioremapped = true;
+ }
  }

- memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
+ if (!image)
+ return;
+ if (img_addr_in_ram)
+ memcpy(&bmp_header, image, sizeof(bmp_header));
+ else
+ memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
  if (ioremapped)
  iounmap(image);
- bgrt_image_size = bmp_header.size;

+ bgrt_image_size = bmp_header.size;
  bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
+
  if (!bgrt_image)
  return;

@@ -72,8 +86,10 @@ void __init efi_bgrt_init(void)
  return;
  }
  }
-
- memcpy_fromio(bgrt_image, image, bgrt_image_size);
+ if (img_addr_in_ram)
+ memcpy(bgrt_image, image, bgrt_image_size);
+ else
+ memcpy_fromio(bgrt_image, image, bgrt_image_size);
  if (ioremapped)
  iounmap(image);
 }
