Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaBKKH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaBKKHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:07:47 -0500
Date: Tue, 11 Feb 2014 18:08:38 +0800
From: Dave Young <dyoung@redhat.com>
To: keescook@chromium.org, hpa@zytor.com, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] disable kaslr in kdump kernel
Message-ID: <20140211100837.GA17202@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


KASLR does not work in kdump kernel because it's too early that mem=exactmap
has not been parsed.

Since KASLR does not make much sense for kdump kernel thus let's disable it
for kdump kernel. To check if it is a kdump kernel I just check the cmdline
param elfcorehdr just like is_kdump_kernel.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 linux-2.6/arch/x86/boot/compressed/aslr.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: dyoung/git/linux-2.6/arch/x86/boot/compressed/aslr.c
===================================================================
--- linux-2.6/arch/x86/boot/compressed/aslr.c
+++ linux-2.6/arch/x86/boot/compressed/aslr.c
@@ -293,6 +293,11 @@ unsigned char *choose_kernel_location(un
 		goto out;
 	}
 
+	if (cmdline_find_option("elfcorehdr", NULL, 0) != -1) {
+		debug_putstr("KASLR disabled...\n");
+		goto out;
+	}
+
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
 		       (unsigned long)output, output_size);
