Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaIPJxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:53:54 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:58798 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaIPJxx (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 16 Sep 2014 05:53:53 -0400
Message-Id: <541824CE020000780003550B@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 16 Sep 2014 10:53:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: suspicious compiler warning in vdso2c.h
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy

following e6577a7ce9 ("x86, vdso: Move the vvar area before the
vdso text") gcc 4.3.4 tells me

.../arch/x86/vdso/vdso2c.c: In function ‘main’:
.../arch/x86/vdso/vdso2c.h:118: warning: assuming signed overflow does not occur when assuming that (X + c) < X is
always false
.../arch/x86/vdso/vdso2c.h:118: warning: assuming signed overflow does not occur when assuming that (X + c) < X is
always false

apparently because it unrolls the containing loop and finds i ==
sym_vvar_start on the first iteration. I think there was a hidden
dependency before your change on required_syms[] first two
entries matching up with special_pages[]. If that's correct, all
syms[i] within said loop would seem to need replacing by
syms[special_pages[i]] (similarly for required_syms[i] afaict, see
below draft patch), which also is in line with the loop iterating
over the array elements of special_pages[].

Question then of course is - are there any further hidden
dependencies that already got or may eventually get broken?

Jan

--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -109,18 +109,18 @@ static void BITSFUNC(go)(void *raw_addr,
 
 	/* Validate mapping addresses. */
 	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
-		if (!syms[i])
+		if (!syms[special_pages[i]])
 			continue;  /* The mapping isn't used; ignore it. */
 
-		if (syms[i] % 4096)
+		if (syms[special_pages[i]] % 4096)
 			fail("%s must be a multiple of 4096\n",
-			     required_syms[i].name);
-		if (syms[sym_vvar_start] > syms[i] + 4096)
+			     required_syms[special_pages[i]].name);
+		if (syms[sym_vvar_start] > syms[special_pages[i]] + 4096)
 			fail("%s underruns begin_vvar\n",
-			     required_syms[i].name);
-		if (syms[i] + 4096 > 0)
+			     required_syms[special_pages[i]].name);
+		if (syms[special_pages[i]] + 4096 > 0)
 			fail("%s is on the wrong side of the vdso text\n",
-			     required_syms[i].name);
+			     required_syms[special_pages[i]].name);
 	}
 	if (syms[sym_vvar_start] % 4096)
 		fail("vvar_begin must be a multiple of 4096\n");

