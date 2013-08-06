Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3HFCzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 22:55:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15947 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3HFCza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 22:55:30 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ChOqLnwVEs0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_dDIfE-woJIA:10 a=MkxkixzLGcJVl6aIStwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375757728.25420.14.camel@gandalf.local.home>
Subject: [PATCH] printk: Fix return of braille_register_console()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Ming Lei <ming.lei@canonical.com>
Date: Mon, 05 Aug 2013 22:55:28 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of my configs I test with have CONFIG_A11Y_BRAILLE_CONSOLE set.
When I started testing against v3.11-rc4 my console went bonkers. Using
ktest to bisect the issue, it came down to:

commit bbeddf52a "printk: move braille console support into separate
braille.[ch] files"

Looking into the patch I found the problem. It's with the return of
braille_register_console(). As anything other than NULL is considered a
failure.

But for those of us that have CONFIG_A11Y_BRAILLE_CONSOLE set but do not
define a "brl" or "brl=" on the command line, we still may want a
console that those with sight can still use.

Return NULL (success) if "brl" or "brl=" is not on the console line.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/printk/braille.c b/kernel/printk/braille.c
index b51087f..276762f 100644
--- a/kernel/printk/braille.c
+++ b/kernel/printk/braille.c
@@ -19,7 +19,8 @@ char *_braille_console_setup(char **str, char **brl_options)
 			pr_err("need port name after brl=\n");
 		else
 			*((*str)++) = 0;
-	}
+	} else
+		return NULL;
 
 	return *str;
 }


