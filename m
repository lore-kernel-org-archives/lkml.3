Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3H0BH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3H0BHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 40/74] x86: Dont clear olpc_ofw_header when sentinel is detected
Date: Mon, 26 Aug 2013 18:08:38 -0700
Message-Id: <20130827010432.866722172@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit d55e37bb0f51316e552376ddc0a3fff34ca7108b upstream.

OpenFirmware wasn't quite following the protocol described in boot.txt
and the kernel has detected this through use of the sentinel value
in boot_params. OFW does zero out almost all of the stuff that it should
do, but not the sentinel.

This causes the kernel to clear olpc_ofw_header, which breaks x86 OLPC
support.

OpenFirmware has now been fixed. However, it would be nice if we could
maintain Linux compatibility with old firmware versions. To do that, we just
have to avoid zeroing out olpc_ofw_header.

OFW does not write to any other parts of the header that are being zapped
by the sentinel-detection code, and all users of olpc_ofw_header are
somewhat protected through checking for the OLPC_OFW_SIG magic value
before using it. So this should not cause any problems for anyone.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/20130809221420.618E6FAB03@dev.laptop.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bootparam_utils.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -35,9 +35,9 @@ static void sanitize_boot_params(struct
 	 */
 	if (boot_params->sentinel) {
 		/* fields in boot_params are left uninitialized, clear them */
-		memset(&boot_params->olpc_ofw_header, 0,
+		memset(&boot_params->ext_ramdisk_image, 0,
 		       (char *)&boot_params->efi_info -
-			(char *)&boot_params->olpc_ofw_header);
+			(char *)&boot_params->ext_ramdisk_image);
 		memset(&boot_params->kbd_status, 0,
 		       (char *)&boot_params->hdr -
 		       (char *)&boot_params->kbd_status);


