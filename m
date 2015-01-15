Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbbAOOo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:44:28 -0500
Received: from frv199.fwdcdn.com ([212.42.77.199]:60661 "EHLO
	frv199.fwdcdn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbAOOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:44:27 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 09:44:27 EST
Date: Thu, 15 Jan 2015 16:44:24 +0200
From: Sergey Popov <popov_sergey@ukr.net>
Subject: [patch 1/1] init/main.c: prevent increase of console_loglevel by
 'quiet' kernel parameter (inline now, sorry for previous attachment)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Mailer: mail.ukr.net 5.0
Message-Id: <1421332804.230522034.oqmpkds7@frv35.fwdcdn.com>
X-Reply-Action: template
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: binary
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Popov < popov_sergey@ukr.net >

Prevent increase of console_loglevel by 'quiet'

'quiet' kernel option that follows the 'loglevel=N' should
not blindly overwrite console_loglevel, instead it should
respect and keep lower 'loglevel'.

Signed-off-by: Sergey Popov < popov_sergey@ukr.net >
---
 init/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Some drivers tend to print error messages (ex: 'drm/i810 does not support SMP') to the console 
that we at our company don't want to show to people. We use 'quiet' kernel option to hide kernel decompressing progress and other messages not related to printk. But to hide error messages from drivers we use 'loglevel=3' parameter as well. But when it's _before_ the quiet, then quiet overrides loglevel=3 and set it to be 4.
I think that's a bug, and here's simple solution for it. The only way to live without this patch is to pass 'loglevel=3' after the 'quiet'. This issue is known to the community, but everyone is using workaround (ex: https://wiki.archlinux.org/index.php/Silent_boot ).


diff --git a/init/main.c b/init/main.c
index 61b99376..91fc78b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -211,7 +211,12 @@ static int __init debug_kernel(char *str)
 
 static int __init quiet_kernel(char *str)
 {
-	console_loglevel = CONSOLE_LOGLEVEL_QUIET;
+	/*
+	 * 'quiet' option should not raise console_loglevel, it's only
+	 * allowed to lower it
+	 */
+	if (console_loglevel > CONSOLE_LOGLEVEL_QUIET)
+		console_loglevel = CONSOLE_LOGLEVEL_QUIET;
 	return 0;
 }
 
 
