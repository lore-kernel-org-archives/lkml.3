Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3JLSLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 14:11:51 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:40459 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab3JLSLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 14:11:50 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 14:11:50 EDT
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] init: fix in-place parameter modification regression
Date: Sat, 12 Oct 2013 20:05:00 +0200
Message-Id: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.652.g0d6e0ce
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 026cee0086fe1df4cf74691cf273062cc769617d
("params: <level>_initcall-like kernel parameters") the __setup
parameter parsing code could modify parameter in the
static_command_line buffer and such modifications were kept. After
that commit such modifications are destroyed during per-initcall level
parameter parsing because the same static_command_line buffer is used
and only parameters for appropriate initcall level are parsed.

That change broke at least parsing "ubd" parameter in the ubd driver
when the COW file is used.

Now the separate buffer is used for per-initcall parameter parsing,
like in parsing early params.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
Hi,

this patch fixes an old Linux 3.4 regression in ubd parameter parsing.
It was previously reported by the David Fernández in the
"ubd option parsing problem when using cow filesystems in kernel 3.4"
thread on user-mode-linux-devel mailing list
(http://marc.info/?t=134009640700003&r=1&w=2).
The bug still exists in the Linux 3.12-rc4.

I've been using a different patch that changed the ubd driver. I just
copied the parsed filename to separate buffer, but I think it's better
to fix generic code.

Maybe the tmp_cmdline should be shared with the parse_early_param().

Regards,
Krzysiek

 init/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 63d3e8f..e5b322a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -742,12 +742,13 @@ static char *initcall_level_names[] __initdata = {
 
 static void __init do_initcall_level(int level)
 {
+	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
 	extern const struct kernel_param __start___param[], __stop___param[];
 	initcall_t *fn;
 
-	strcpy(static_command_line, saved_command_line);
+	strcpy(tmp_cmdline, saved_command_line);
 	parse_args(initcall_level_names[level],
-		   static_command_line, __start___param,
+		   tmp_cmdline, __start___param,
 		   __stop___param - __start___param,
 		   level, level,
 		   &repair_env_string);
-- 
1.8.4.652.g0d6e0ce

