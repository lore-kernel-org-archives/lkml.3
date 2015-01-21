Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbbAUDht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:37:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbAUDhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:37:46 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/6] a bug that relocation can not be handled when kernel is loaded above 2G
Date: Wed, 21 Jan 2015 11:37:13 +0800
Message-Id: <1421811437-2787-3-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When process 32 bit relocation a local variable extended is defined
to calculate the physical address of relocs entry. However its data
type is int which is enough for i386, but not for x86_64. That's why
relocation can only be handled when kernel is loaded below 2G,
otherwise a overflow will happen and cause system hang.

Here change it to long as 32 bit inverse relocation processing does,
and this change is safe for i386 relocation handling.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dcc1c53..324ccb5 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -278,7 +278,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * So we work backwards from the end of the decompressed image.
 	 */
 	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
-		int extended = *reloc;
+		long extended = *reloc;
 		extended += map;
 
 		ptr = (unsigned long)extended;
-- 
1.9.3

