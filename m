Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3EUFPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 01:15:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55730 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3EUFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 01:15:34 -0400
Date: Tue, 21 May 2013 13:15:12 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] TTY:vt: convert remain take_over_console's users to
 do_take_over_console
Message-ID: <20130521051511.GA11435@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact:
1:convert all remain take_over_console to do_take_over_console
2:update take_over_console to do_take_over_console in comment

Commit dc9641895abb ("vt: delete unneeded functions
register_con_driver|take_over_console") delete take_over_console,
but forget to convert remain take_over_console's users to new API
do_take_over_console, this patch fix it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 Sorry for my mistake, I believe I do the full
 kernel source find|grep, but the reality is I 
 forget  take_over_console.
 
 I will send the patch to update DOC tonight.
 arch/alpha/kernel/console.c             |  4 +++-
 arch/alpha/kernel/process.c             |  4 +++-
 arch/mips/pci/pci-bcm1480.c             |  4 +++-
 arch/mips/pci/pci-sb1250.c              |  4 +++-
 arch/parisc/kernel/setup.c              |  2 +-
 drivers/tty/vt/vt.c                     |  2 +-
 drivers/usb/misc/sisusbvga/sisusb_con.c | 18 +++++++++++-------
 drivers/video/console/fbcon.c           |  2 +-
 drivers/video/console/mdacon.c          |  8 ++++++--
 drivers/video/console/newport_con.c     |  9 ++++++---
 drivers/video/console/sticon.c          |  6 +++++-
 11 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/arch/alpha/kernel/console.c b/arch/alpha/kernel/console.c
index da711e3..6a61dee 100644
--- a/arch/alpha/kernel/console.c
+++ b/arch/alpha/kernel/console.c
@@ -61,7 +61,9 @@ locate_and_init_vga(void *(*sel_func)(void *, void *))
 
 	/* Set the VGA hose and init the new console. */
 	pci_vga_hose = hose;
-	take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
+	console_lock();
+	do_take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
+	console_unlock();
 }
 
 void __init
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index ab80a80..f2360a7 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -117,7 +117,9 @@ common_shutdown_1(void *generic_ptr)
 		if (in_interrupt())
 			irq_exit();
 		/* This has the effect of resetting the VGA video origin.  */
-		take_over_console(&dummy_con, 0, MAX_NR_CONSOLES-1, 1);
+		console_lock();
+		do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES-1, 1);
+		console_unlock();
 #endif
 		pci_restore_srm_config();
 		set_hae(srm_hae);
diff --git a/arch/mips/pci/pci-bcm1480.c b/arch/mips/pci/pci-bcm1480.c
index e2e69e1..44dd5aa 100644
--- a/arch/mips/pci/pci-bcm1480.c
+++ b/arch/mips/pci/pci-bcm1480.c
@@ -257,7 +257,9 @@ static int __init bcm1480_pcibios_init(void)
 	register_pci_controller(&bcm1480_controller);
 
 #ifdef CONFIG_VGA_CONSOLE
-	take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
+	console_lock();
+	do_take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
+	console_unlock();
 #endif
 	return 0;
 }
diff --git a/arch/mips/pci/pci-sb1250.c b/arch/mips/pci/pci-sb1250.c
index cdefcc4..fc634ae 100644
--- a/arch/mips/pci/pci-sb1250.c
+++ b/arch/mips/pci/pci-sb1250.c
@@ -283,7 +283,9 @@ static int __init sb1250_pcibios_init(void)
 	register_pci_controller(&sb1250_controller);
 
 #ifdef CONFIG_VGA_CONSOLE
-	take_over_console(&vga_con, 0, MAX_NR_CONSOLES - 1, 1);
+	console_lock();
+	do_take_over_console(&vga_con, 0, MAX_NR_CONSOLES - 1, 1);
+	console_unlock();
 #endif
 	return 0;
 }
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index 76b63e7..60c1ae6 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -155,7 +155,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 #if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
-	conswitchp = &dummy_con;	/* we use take_over_console() later ! */
+	conswitchp = &dummy_con;	/* we use do_take_over_console() later ! */
 #endif
 
 }
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 405e1c9..d4ba2ba 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3592,7 +3592,7 @@ EXPORT_SYMBOL_GPL(do_unregister_con_driver);
  *	when a driver wants to take over some existing consoles
  *	and become default driver for newly opened ones.
  *
- *	take_over_console is basically a register followed by unbind
+ *	do_take_over_console is basically a register followed by unbind
  */
 int do_take_over_console(const struct consw *csw, int first, int last, int deflt)
 {
diff --git a/drivers/usb/misc/sisusbvga/sisusb_con.c b/drivers/usb/misc/sisusbvga/sisusb_con.c
index 411e605..a638c4e 100644
--- a/drivers/usb/misc/sisusbvga/sisusb_con.c
+++ b/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -208,7 +208,7 @@ sisusbcon_init(struct vc_data *c, int init)
 	struct sisusb_usb_data *sisusb;
 	int cols, rows;
 
-	/* This is called by take_over_console(),
+	/* This is called by do_take_over_console(),
 	 * ie by us/under our control. It is
 	 * only called after text mode and fonts
 	 * are set up/restored.
@@ -273,7 +273,7 @@ sisusbcon_deinit(struct vc_data *c)
 	struct sisusb_usb_data *sisusb;
 	int i;
 
-	/* This is called by take_over_console()
+	/* This is called by do_take_over_console()
 	 * and others, ie not under our control.
 	 */
 
@@ -1490,8 +1490,9 @@ sisusb_console_init(struct sisusb_usb_data *sisusb, int first, int last)
 	mutex_unlock(&sisusb->lock);
 
 	/* Now grab the desired console(s) */
-	ret = take_over_console(&sisusb_con, first - 1, last - 1, 0);
-
+	console_lock();
+	ret = do_take_over_console(&sisusb_con, first - 1, last - 1, 0);
+	console_unlock();
 	if (!ret)
 		sisusb->haveconsole = 1;
 	else {
@@ -1535,11 +1536,14 @@ sisusb_console_exit(struct sisusb_usb_data *sisusb)
 
 	if (sisusb->haveconsole) {
 		for (i = 0; i < MAX_NR_CONSOLES; i++)
-			if (sisusb->havethisconsole[i])
-				take_over_console(&sisusb_dummy_con, i, i, 0);
+			if (sisusb->havethisconsole[i]) {
+				console_lock();
+				do_take_over_console(&sisusb_dummy_con, i, i, 0);
+				console_unlock();
 				/* At this point, con_deinit for all our
-				 * consoles is executed by take_over_console().
+				 * consoles is executed by do_take_over_console().
 				 */
+			}
 		sisusb->haveconsole = 0;
 	}
 
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index a09c667..d55b337 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -873,7 +873,7 @@ static int set_con2fb_map(int unit, int newidx, int user)
 /*
  *  Low Level Operations
  */
-/* NOTE: fbcon cannot be __init: it may be called from take_over_console later */
+/* NOTE: fbcon cannot be __init: it may be called from do_take_over_console later */
 static int var_to_display(struct display *disp,
 			  struct fb_var_screeninfo *var,
 			  struct fb_info *info)
diff --git a/drivers/video/console/mdacon.c b/drivers/video/console/mdacon.c
index 0b67866..296e945 100644
--- a/drivers/video/console/mdacon.c
+++ b/drivers/video/console/mdacon.c
@@ -585,10 +585,14 @@ static const struct consw mda_con = {
 
 int __init mda_console_init(void)
 {
+	int err;
+
 	if (mda_first_vc > mda_last_vc)
 		return 1;
-
-	return take_over_console(&mda_con, mda_first_vc-1, mda_last_vc-1, 0);
+	console_lock();
+	err = do_take_over_console(&mda_con, mda_first_vc-1, mda_last_vc-1, 0);
+	console_unlock();
+	return err;
 }
 
 static void __exit mda_console_exit(void)
diff --git a/drivers/video/console/newport_con.c b/drivers/video/console/newport_con.c
index b05afd0..a6ab929 100644
--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -297,7 +297,7 @@ static void newport_exit(void)
 		newport_set_def_font(i, NULL);
 }
 
-/* Can't be __init, take_over_console may call it later */
+/* Can't be __init, do_take_over_console may call it later */
 static const char *newport_startup(void)
 {
 	int i;
@@ -746,6 +746,7 @@ static int newport_probe(struct gio_device *dev,
 			 const struct gio_device_id *id)
 {
 	unsigned long newport_addr;
+	int err;
 
 	if (!dev->resource.start)
 		return -EINVAL;
@@ -759,8 +760,10 @@ static int newport_probe(struct gio_device *dev,
 
 	npregs = (struct newport_regs *)/* ioremap cannot fail */
 		ioremap(newport_addr, sizeof(struct newport_regs));
-
-	return take_over_console(&newport_con, 0, MAX_NR_CONSOLES - 1, 1);
+	console_lock();
+	err = do_take_over_console(&newport_con, 0, MAX_NR_CONSOLES - 1, 1);
+	console_unlock();
+	return err;
 }
 
 static void newport_remove(struct gio_device *dev)
diff --git a/drivers/video/console/sticon.c b/drivers/video/console/sticon.c
index 491c1c1..5f65ca3 100644
--- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -372,6 +372,7 @@ static const struct consw sti_con = {
 
 static int __init sticonsole_init(void)
 {
+    int err;
     /* already initialized ? */
     if (sticon_sti)
 	 return 0;
@@ -382,7 +383,10 @@ static int __init sticonsole_init(void)
 
     if (conswitchp == &dummy_con) {
 	printk(KERN_INFO "sticon: Initializing STI text console.\n");
-	return take_over_console(&sti_con, 0, MAX_NR_CONSOLES - 1, 1);
+	console_lock();
+	err = do_take_over_console(&sti_con, 0, MAX_NR_CONSOLES - 1, 1);
+	console_unlock();
+	return err;
     }
     return 0;
 }
-- 
1.7.12.4.dirty
