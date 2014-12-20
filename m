Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaLTWwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:52:20 -0500
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:41355
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbaLTWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:52:19 -0500
Date: Sat, 20 Dec 2014 22:49:08 +0000
From: dwalker@fifo99.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] printk: add per console loglevel
Message-ID: <20141220224908.GB4466@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds to to the console= command line options allowing the
addition of a per console log level setting.

examples,

	console=ttyS0,ll4
	console=tty0,ll6

This can be used on systems which have multiple serial consoles, but
it's desired for logging to be light on one and heavy on another.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 Documentation/kernel-parameters.txt | 24 ++++++++++++++++++------
 include/linux/console.h             |  1 +
 kernel/printk/console_cmdline.h     |  9 +++++----
 kernel/printk/printk.c              | 37 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4df73da..7e65d5b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -696,30 +696,42 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	console=	[KNL] Output console device and options.
 
-		tty<n>	Use the virtual console device <n>.
+		tty<n>[,llX]	Use the virtual console device <n>.
 
-		ttyS<n>[,options]
-		ttyUSB0[,options]
+		ttyS<n>[,options][,llX]
+		ttyUSB0[,options][,llX]
 			Use the specified serial port.  The options are of
 			the form "bbbbpnf", where "bbbb" is the baud rate,
 			"p" is parity ("n", "o", or "e"), "n" is number of
 			bits, and "f" is flow control ("r" for RTS or
 			omit it).  Default is "9600n8".
 
+			"llX" explained below,
+
 			See Documentation/serial-console.txt for more
 			information.  See
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options][,llX]
+		uart[8250],mmio,<addr>[,options][,llX]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
-		hvc<n>	Use the hypervisor console device <n>. This is for
+
+			"llX" explained below,
+
+		hvc<n>[,llX]
+			Use the hypervisor console device <n>. This is for
 			both Xen and PowerPC hypervisors.
 
+			"llX" is used to define the loglevel per console. The "X"
+			defines the loglevel number for this console. The usage
+			is similar to the "loglevel=" option, and the effect is
+			the same only per console. The "loglevel=" option takes
+			precedence of this option.
+
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
 			console=brl,ttyS0
diff --git a/include/linux/console.h b/include/linux/console.h
index 7571a16..99020d5 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -118,6 +118,7 @@ static inline int con_debug_leave(void)
 
 struct console {
 	char	name[16];
+	int	loglevel;
 	void	(*write)(struct console *, const char *, unsigned);
 	int	(*read)(struct console *, char *, unsigned);
 	struct tty_driver *(*device)(struct console *, int *);
diff --git a/kernel/printk/console_cmdline.h b/kernel/printk/console_cmdline.h
index cbd69d8..6f6f98f 100644
--- a/kernel/printk/console_cmdline.h
+++ b/kernel/printk/console_cmdline.h
@@ -3,11 +3,12 @@
 
 struct console_cmdline
 {
-	char	name[8];			/* Name of the driver	    */
-	int	index;				/* Minor dev. to use	    */
-	char	*options;			/* Options for the driver   */
+	char	name[8];		/* Name of the driver		*/
+	int	index;			/* Minor dev. to use		*/
+	int	loglevel;		/* Log level for this console	*/
+	char	*options;		/* Options for the driver	*/
 #ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	char	*brl_options;			/* Options for braille driver */
+	char	*brl_options;		/* Options for braille driver	*/
 #endif
 };
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 02d6b6d..218d94d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1414,6 +1414,9 @@ static void call_console_drivers(int level, const char *text, size_t len)
 		if (!cpu_online(smp_processor_id()) &&
 		    !(con->flags & CON_ANYTIME))
 			continue;
+		if (con->loglevel && !ignore_loglevel &&
+		    level >= con->loglevel)
+			continue;
 		con->write(con, text, len);
 	}
 }
@@ -1925,6 +1928,33 @@ asmlinkage __visible void early_printk(const char *fmt, ...)
 }
 #endif
 
+
+char *setup_per_console_loglevel(struct console_cmdline *con, char *options)
+{
+	int size = options ? strlen(options) : 0;
+
+	if (size >= 3 &&
+	    options[size - 3] == 'l' &&
+	    options[size - 2] == 'l' &&
+	    options[size - 1] >=  '1' && options[size - 1] <= '9') {
+		con->loglevel = options[size - 1] - '0';
+
+		/* Catch if the user added a comma after some serial console
+		 * options,
+		 * i.e. console=ttyS0,9600n8,ll3
+		 * the first comma is gone at this point, but we need to delete
+		 * the second one.
+		 */
+		if (size > 3 && options[size - 4] == ',')
+			options[size - 4] = 0;
+		else
+			options[size - 3] = 0;
+	} else
+		con->loglevel = 0;
+
+	return options;
+}
+
 static int __add_preferred_console(char *name, int idx, char *options,
 				   char *brl_options)
 {
@@ -1949,12 +1979,15 @@ static int __add_preferred_console(char *name, int idx, char *options,
 	if (!brl_options)
 		selected_console = i;
 	strlcpy(c->name, name, sizeof(c->name));
-	c->options = options;
+
+	c->options = setup_per_console_loglevel(c, options);
+
 	braille_set_options(c, brl_options);
 
 	c->index = idx;
 	return 0;
 }
+
 /*
  * Set up a console.  Called via do_early_param() in init/main.c
  * for each "console=" parameter in the boot command line.
@@ -2478,6 +2511,8 @@ void register_console(struct console *newcon)
 		if (newcon->setup &&
 		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
+
+		newcon->loglevel = c->loglevel;
 		newcon->flags |= CON_ENABLED;
 		newcon->index = c->index;
 		if (i == selected_console) {
-- 
1.9.1

