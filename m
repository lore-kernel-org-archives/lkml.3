Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3BTR5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:57:33 -0500
Received: from li44-10.members.linode.com ([72.14.181.10]:54821 "EHLO
	plausible.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934346Ab3BTR5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:57:30 -0500
Message-ID: <51250E86.1050908@windriver.com>
Date: Wed, 20 Feb 2013 09:57:26 -0800
From: Andy Ross <andy.ross@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3] vt: add init_hide parameter to suppress boot output
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com> <20130220014512.GC31018@kroah.com> <51244B35.8090006@windriver.com>
In-Reply-To: <51244B35.8090006@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When vt.init_hide is set, suppress output on newly created consoles
until an affirmative switch to that console.  This prevents boot
output from displaying (and clobbering splash screens, etc...) without
disabling the console entirely.

Signed-off-by: Andy Ross <andy.ross@windriver.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
  Documentation/kernel-parameters.txt | 8 ++++++++
  drivers/tty/vt/vt.c                 | 7 +++++++
  include/linux/console_struct.h      | 3 ++-
  include/linux/vt.h                  | 2 ++
  kernel/power/console.c              | 2 --
  5 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6c72381..56bd2be 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3149,6 +3149,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
  			            them quite hard to use for exploits but
  			            might break your system.

+	vt.init_hide=	[VT] Hide initial console
+			Format: <bool> (0 = visible (default), 1 = invisible)
+			When set, the console will be invisible initially.
+			This prevents mode switches, buffer clears, and screen
+			display from the console code during boot.  Switching
+			to a console device at runtime using the VT_ACTIVATE
+			ioctl will make its contents visible.
+
  	vt.cur_default=	[VT] Default cursor shape.
  			Format: 0xCCBBAA, where AA, BB, and CC are the same as
  			the parameters of the <Esc>[?A;B;Cc escape sequence;
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 8fd8968..c68322c 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -165,6 +165,9 @@ module_param(global_cursor_default, int, S_IRUGO | S_IWUSR);
  static int cur_default = CUR_DEFAULT;
  module_param(cur_default, int, S_IRUGO | S_IWUSR);

+static bool init_hide;
+module_param(init_hide, bool, S_IRUGO);
+
  /*
   * ignore_poke: don't unblank the screen when things are typed.  This is
   * mainly for the privacy of braille terminal users.
@@ -734,6 +737,7 @@ static void visual_init(struct vc_data *vc, int num, int init)
  	__module_get(vc->vc_sw->owner);
  	vc->vc_num = num;
  	vc->vc_display_fg = &master_display_fg;
+	vc->vc_hidden = init_hide;
  	vc->vc_uni_pagedir_loc = &vc->vc_uni_pagedir;
  	vc->vc_uni_pagedir = 0;
  	vc->vc_hi_font_mask = 0;
@@ -2336,6 +2340,9 @@ static void console_callback(struct work_struct *ignored)
  	if (want_console >= 0) {
  		if (want_console != fg_console &&
  		    vc_cons_allocated(want_console)) {
+			if (want_console != SUSPEND_CONSOLE &&
+					fg_console != SUSPEND_CONSOLE)
+				vc_cons[want_console].d->vc_hidden = 0;
  			hide_cursor(vc_cons[fg_console].d);
  			change_console(vc_cons[want_console].d);
  			/* we only changed when the console had already
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 7f0c329..fc96691 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -91,6 +91,7 @@ struct vc_data {
  	unsigned int	vc_can_do_color	: 1;
  	unsigned int	vc_report_mouse : 2;
  	unsigned char	vc_utf		: 1;	/* Unicode UTF-8 encoding */
+	unsigned int    vc_hidden	: 1;    /* Set by vt.init_hide */
  	unsigned char	vc_utf_count;
  		 int	vc_utf_char;
  	unsigned int	vc_tab_stop[8];		/* Tab stops. 256 columns. */
@@ -134,6 +135,6 @@ extern void vc_SAK(struct work_struct *work);

  #define CUR_DEFAULT CUR_UNDERLINE

-#define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp)
+#define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp && !conp->vc_hidden)

  #endif /* _LINUX_CONSOLE_STRUCT_H */
diff --git a/include/linux/vt.h b/include/linux/vt.h
index b186e04..0dc3e89 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -11,6 +11,8 @@
  #define VT_UPDATE		0x0004 /* A bigger update occurred */
  #define VT_PREWRITE		0x0005 /* A char is about to be written to the console */

+#define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
+
  #ifdef CONFIG_VT_CONSOLE

  extern int vt_kmsg_redirect(int new);
diff --git a/kernel/power/console.c b/kernel/power/console.c
index b1dc456..b74bdb8 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -10,8 +10,6 @@
  #include <linux/module.h>
  #include "power.h"

-#define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
-
  static int orig_fgconsole, orig_kmsg;

  int pm_prepare_console(void)
-- 
1.7.11.7

