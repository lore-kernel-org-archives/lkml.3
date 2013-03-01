Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab3CAUIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:08:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3CATp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 74/77] x86, efi: Allow slash in file path of initrd
Date: Fri,  1 Mar 2013 11:44:59 -0800
Message-Id: <20130301194359.799370204@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit deb94101c4fda22e152c2a311210cf09ae51adf6 upstream.

When initrd file didn't put at the same place with stub kernel, we
need give the file path of initrd, but need use backslash to separate
directory and file. It's not friendly to unix/linux user, and not so
intuitive for bootloader forward paramters to efi stub kernel by
chainloading.

This patch add support to handle_ramdisks for allow slash in file path
of initrd, it convert slash to backlash when parsing path.

In additional, this patch also separates print code of efi_char16_t from
efi_printk, and print out the path/filename of initrd when failed to open
initrd file. It's good for debug and discover typo.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,23 +19,28 @@
 
 static efi_system_table_t *sys_table;
 
+static void efi_char16_printk(efi_char16_t *str)
+{
+	struct efi_simple_text_output_protocol *out;
+
+	out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
+	efi_call_phys2(out->output_string, out, str);
+}
+
 static void efi_printk(char *str)
 {
 	char *s8;
 
 	for (s8 = str; *s8; s8++) {
-		struct efi_simple_text_output_protocol *out;
 		efi_char16_t ch[2] = { 0 };
 
 		ch[0] = *s8;
-		out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
-
 		if (*s8 == '\n') {
 			efi_char16_t nl[2] = { '\r', 0 };
-			efi_call_phys2(out->output_string, out, nl);
+			efi_char16_printk(nl);
 		}
 
-		efi_call_phys2(out->output_string, out, ch);
+		efi_char16_printk(ch);
 	}
 }
 
@@ -709,7 +714,12 @@ static efi_status_t handle_ramdisks(efi_
 			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
 				break;
 
-			*p++ = *str++;
+			if (*str == '/') {
+				*p++ = '\\';
+				*str++;
+			} else {
+				*p++ = *str++;
+			}
 		}
 
 		*p = '\0';
@@ -737,7 +747,9 @@ static efi_status_t handle_ramdisks(efi_
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to open initrd file\n");
+			efi_printk("Failed to open initrd file: ");
+			efi_char16_printk(filename_16);
+			efi_printk("\n");
 			goto close_handles;
 		}
 


