Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab3HDLKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 07:10:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57391 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab3HDLKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 07:10:09 -0400
X-Sasl-enc: 9JsmEAY00QhrZxvZ8MU2wNHQeFoRDIUzu0JFbP6OKgrS 1375614605
Message-ID: <51FE367E.5020109@ladisch.de>
Date: Sun, 04 Aug 2013 13:09:50 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] vt: make the default color configurable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtual console has (undocumented) module parameters to set the
colors for italic and underlined text, but the default text color was
hardcoded for some reason.  This made it impossible to change the color
for startup messages, or to set the default for new virtual consoles.
Add a module parameter for that, and document the entire bunch.

Any hacker who thinks that a command prompt on a "black screen with
white font" is not supicious enough can now use the kernel parameter
vt.color=10 to get a nice, evil green.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/kernel-parameters.txt |   10 ++++++++++
 drivers/tty/vt/vt.c                 |    4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

Changing the background color looks ugly because the cute penguin logo
is designed for a black background; somebody ought to implement alpha
blending ...

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 15356ac..f6c8b41 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3322,6 +3322,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			            them quite hard to use for exploits but
 			            might break your system.

+	vt.color=	[VT] Default text color.
+			Format: 0xYX, X = foreground, Y = background.
+			Default: 0x07 = light gray on black.
+
 	vt.cur_default=	[VT] Default cursor shape.
 			Format: 0xCCBBAA, where AA, BB, and CC are the same as
 			the parameters of the <Esc>[?A;B;Cc escape sequence;
@@ -3361,6 +3365,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			overridden by individual drivers. 0 will hide
 			cursors, 1 will display them.

+	vt.italic=	[VT] Default color for italic text; 0-15.
+			Default: 2 = green.
+
+	vt.underline=	[VT] Default color for underlined text; 0-15.
+			Default: 3 = cyan.
+
 	watchdog timers	[HW,WDT] For information on watchdog timers,
 			see Documentation/watchdog/watchdog-parameters.txt
 			or other driver-specific files in the
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c677829..8675719 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2809,8 +2809,10 @@ static void con_shutdown(struct tty_struct *tty)
 	console_unlock();
 }

+static int default_color           = 7; /* white */
 static int default_italic_color    = 2; // green (ASCII)
 static int default_underline_color = 3; // cyan (ASCII)
+module_param_named(color, default_color, int, S_IRUGO | S_IWUSR);
 module_param_named(italic, default_italic_color, int, S_IRUGO | S_IWUSR);
 module_param_named(underline, default_underline_color, int, S_IRUGO | S_IWUSR);

@@ -2832,7 +2834,7 @@ static void vc_init(struct vc_data *vc, unsigned int rows,
 		vc->vc_palette[k++] = default_grn[j] ;
 		vc->vc_palette[k++] = default_blu[j] ;
 	}
-	vc->vc_def_color       = 0x07;   /* white */
+	vc->vc_def_color       = default_color;
 	vc->vc_ulcolor         = default_underline_color;
 	vc->vc_itcolor         = default_italic_color;
 	vc->vc_halfcolor       = 0x08;   /* grey */
