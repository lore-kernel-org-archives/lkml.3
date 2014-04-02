Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbaDBU3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:29:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42805 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758835AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 09/40] fbmem: really support wildcard video=options for all fbdev drivers
Date: Wed,  2 Apr 2014 22:12:55 +0200
Message-Id: <69031a9df4abbf17c20dbfd728a4b6e817dfaf65.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f5d2b7c28b67d627646b6a0142bc201a7b1516b0 upstream.

Documentation/fb/modedb.txt states that video=option should be
considered a global option. But video_setup and fb_get_options are not
coded that way. Instead its required to boot with video=driver:option to
set a given option in drvier.  This is cumbersome because it requires to
know in advance which driver will be active for a given board/kernel.

The following patch implements the documented catchall for the fbdev
drivers. It is now possible to boot with video=XxY without the need to
know the active driver in advance. The specific case it tries to fix is
syslinux in the SUSE installer which offers a menu to set a display
resolution. Right now this just appends the vga= option the kernel. But
in addition to vga= it should be possible to pass a generic video=XxY
for all framebuffer/drm drivers. With this change forcing a certain
window size of VM displays is now much easier.

Today the video= option is stored in a global fb_mode_option. But
unfortunately only drm uses it.

Note: this change introduces a small memleak if video=option is actually
used because fb_mode_option is const. Most drivers use strsep to get to
individual options. This could be fixed in a followup patch which always
releases the option string in every caller of fb_get_options.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/fbmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index dacaf74256a3..8659eb160b4d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1916,6 +1916,9 @@ int fb_get_options(const char *name, char **option)
 				options = opt + name_len + 1;
 		}
 	}
+	/* No match, pass global option */
+	if (!options && option && fb_mode_option)
+		options = kstrdup(fb_mode_option, GFP_KERNEL);
 	if (options && !strncmp(options, "off", 3))
 		retval = 1;
 
-- 
1.9.1

