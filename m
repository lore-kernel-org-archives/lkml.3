Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3ITPAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:00:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44896 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3ITPAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:00:49 -0400
Message-ID: <523C62FC.8010907@zytor.com>
Date: Fri, 20 Sep 2013 10:00:12 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Roy Franz <roy.franz@linaro.org>, Adam Borowski <kilobyte@angband.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared function.
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org> <1379391093-27948-10-git-send-email-roy.franz@linaro.org> <20130919034406.GA26385@angband.pl> <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com> <20130920092713.GD4785@console-pimps.org>
In-Reply-To: <20130920092713.GD4785@console-pimps.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/mixed;
 boundary="------------090601060006040708020604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090601060006040708020604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/20/2013 04:27 AM, Matt Fleming wrote:
> On Wed, 18 Sep, at 09:48:44PM, Roy Franz wrote:
>> Would it be acceptable to fix the naming/comments, and convert values
>> above 126 to '?'
>> in the current patchset, and address a more thorough fix in another patch set?
>> The ARM and ARM64 EFI stub patchsets that are mostly complete depend
>> on this one,
>> so getting this merged soon would be helpful.
> 
> Just fixing the function name and comments is enough for this patch
> series. Anything else should be separate.
> 

I just whipped up a patch to do proper UTF-16 to UTF-8 conversion.
Completely untested, of course.

	-hpa


--------------090601060006040708020604
Content-Type: text/x-patch;
 name="0001-efi-Handle-arbitrary-Unicode-characters.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-efi-Handle-arbitrary-Unicode-characters.patch"

>From 7d6cf630c1adbb9787a24c2994230373c2b20a8f Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 20 Sep 2013 09:55:39 -0500
Subject: [PATCH] efi: Handle arbitrary Unicode characters

Instead of truncating UTF-16 assuming all characters is ASCII,
properly convert it to UTF-8.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/eboot.c       |  3 +-
 drivers/firmware/efi/efi-stub-helper.c | 89 ++++++++++++++++++++++++++--------
 2 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index bf56206..aacbe50 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -488,8 +488,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
-	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
-						   &options_size);
+	cmdline_ptr = efi_convert_cmdline(sys_table, image, &options_size);
 	if (!cmdline_ptr)
 		goto fail;
 	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index c91e757..7d4c1a4 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -567,20 +567,72 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 
 	return status;
 }
-/* Convert the unicode UEFI command line to ASCII to pass to kernel.
+
+/*
+ * Get the number of UTF-8 bytes corresponding to an UTF-16 character.
+ * This overestimates for surrogates, but that is okay.
+ */
+static int efi_utf8_bytes(u16 c)
+{
+	return 1 + (c >= 0x80) + (c >= 0x800);
+}
+
+/*
+ * Convert an UTF-16 string, not necessarily null terminated, to UTF-8.
+ */
+static u8 *efi_utf8_to_utf16(u8 *dst, const u16 *src, int n)
+{
+	unsigned int c;
+
+	while (n--) {
+		c = *src++;
+		if (n && c >= 0xd800 && c <= 0xdbff &&
+		    *src >= 0xdc00 && *src <= 0xdfff) {
+			c = 0x10000 + ((c & 0x3ff) << 10) + (*src & 0x3ff);
+			src++;
+			n--;
+		}
+		if (c >= 0xd800 && c <= 0xdfff)
+			c = 0xfffd; /* Unmatched surrogate */
+		if (c < 0x80) {
+			*dst++ = c;
+			continue;
+		}
+		if (c < 0x800) {
+			*dst++ = 0xc0 + (c >> 6);
+			goto t1;
+		}
+		if (c < 0x10000) {
+			*dst++ = 0xe0 + (c >> 12);
+			goto t2;
+		}
+		*dst++ = 0xf0 + (c >> 18);
+		*dst++ = 0x80 + ((c >> 12) & 0x3f);
+	t2:
+		*dst++ = 0x80 + ((c >> 6) & 0x3f);
+	t1:
+		*dst++ = 0x80 + (c & 0x3f);
+	}
+
+	return dst;
+}
+
+/*
+ * Convert the unicode UEFI command line to ASCII to pass to kernel.
  * Size of memory allocated return in *cmd_line_len.
  * Returns NULL on error.
  */
-static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
-				      efi_loaded_image_t *image,
-				      int *cmd_line_len)
+static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+				 efi_loaded_image_t *image,
+				 int *cmd_line_len)
 {
-	u16 *s2;
+	const u16 *s2;
 	u8 *s1 = NULL;
 	unsigned long cmdline_addr = 0;
 	int load_options_size = image->load_options_size / 2; /* ASCII */
-	void *options = image->load_options;
-	int options_size = 0;
+	const void *options = image->load_options;
+	int options_bytes = 0;	/* UTF-8 bytes */
+	int options_chars = 0;	/* UTF-16 chars */
 	efi_status_t status;
 	int i;
 	u16 zero = 0;
@@ -588,40 +640,39 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 	if (options) {
 		s2 = options;
 		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
+			options_bytes += efi_utf8_bytes(*s2);
 			s2++;
-			options_size++;
 		}
+		options_chars = s2 - options;
 	}
 
-	if (options_size == 0) {
-		/* No command line options, so return empty string*/
-		options_size = 1;
+	if (!options_chars) {
+		/* No command line options, so return empty string */
 		options = &zero;
 	}
 
-	options_size++;  /* NUL termination */
+	options_bytes++;	/* NUL termination */
+
 #ifdef CONFIG_ARM
 	/* For ARM, allocate at a high address to avoid reserved
 	 * regions at low addresses that we don't know the specfics of
 	 * at the time we are processing the command line.
 	 */
-	status = efi_high_alloc(sys_table_arg, options_size, 0,
+	status = efi_high_alloc(sys_table_arg, options_bytes, 0,
 			    &cmdline_addr, 0xfffff000);
 #else
-	status = efi_low_alloc(sys_table_arg, options_size, 0,
+	status = efi_low_alloc(sys_table_arg, options_bytes, 0,
 			    &cmdline_addr);
 #endif
 	if (status != EFI_SUCCESS)
 		return NULL;
 
 	s1 = (u8 *)cmdline_addr;
-	s2 = (u16 *)options;
-
-	for (i = 0; i < options_size - 1; i++)
-		*s1++ = *s2++;
+	s2 = (const u16 *)options;
 
+	s1 = efi_utf16_to_utf8(s1, s2, options_chars);
 	*s1 = '\0';
 
-	*cmd_line_len = options_size;
+	*cmd_line_len = options_bytes;
 	return (char *)cmdline_addr;
 }
-- 
1.7.11.7


--------------090601060006040708020604--
