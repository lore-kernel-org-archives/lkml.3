Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaG3TXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:23:43 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52561 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaG3TXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:23:41 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 30 Jul 2014 12:23:32 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] efi-bgrt: Add error handling; inform the user when ignoring
 the BGRT
Message-ID: <20140730192331.GA23730@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gracefully handle failures to allocate memory for the image, which might
be arbitrarily large.

efi_bgrt_init can fail in various ways as well, usually because the
BIOS-provided BGRT structure does not match expectations.  Add
appropriate error messages rather than failing silently.

Reported-by: Srihari Vijayaraghavan
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81321
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/platform/efi/efi-bgrt.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index f15103d..d143d21 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -40,20 +40,40 @@ void __init efi_bgrt_init(void)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
+	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
+		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
+		       bgrt_tab->header.length, sizeof(*bgrt_tab));
 		return;
-	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
+	}
+	if (bgrt_tab->version != 1) {
+		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		       bgrt_tab->version);
+		return;
+	}
+	if (bgrt_tab->status != 1) {
+		pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
+		       bgrt_tab->status);
+		return;
+	}
+	if (bgrt_tab->image_type != 0) {
+		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
+		       bgrt_tab->image_type);
 		return;
-	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
+	}
+	if (!bgrt_tab->image_address) {
+		pr_err("Ignoring BGRT: null image address\n");
 		return;
+	}
 
 	image = efi_lookup_mapped_addr(bgrt_tab->image_address);
 	if (!image) {
 		image = early_memremap(bgrt_tab->image_address,
 				       sizeof(bmp_header));
 		ioremapped = true;
-		if (!image)
+		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image header memory\n");
 			return;
+		}
 	}
 
 	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
@@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
 		early_iounmap(image, sizeof(bmp_header));
 	bgrt_image_size = bmp_header.size;
 
-	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
-	if (!bgrt_image)
+	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
+	if (!bgrt_image) {
+		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
+		       bgrt_image_size);
 		return;
+	}
 
 	if (ioremapped) {
 		image = early_memremap(bgrt_tab->image_address,
 				       bmp_header.size);
 		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image memory\n");
 			kfree(bgrt_image);
 			bgrt_image = NULL;
 			return;
-- 
2.0.1

