Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3ALVKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:10:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3ALVKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:10:15 -0500
Date: Sat, 12 Jan 2013 13:13:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-Id: <20130112131323.31d2a585.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
References: <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
	<20121121125310.00625f55@pyramind.ukuu.org.uk>
	<CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
	<CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
	<CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
	<CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
	<20121227045301.GB17472@x1.alien8.de>
	<20121228115022.GA28009@S2101-09.ap.freescale.net>
	<20121228124026.GB12918@x1.alien8.de>
	<alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
	<20130112183619.GC10630@liondog.tnic>
	<CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2013 12:51:49 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Jan 12, 2013 at 10:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Mon, Jan 07, 2013 at 10:37:15AM +0100, Jiri Kosina wrote:
> >> Still seeing it with current Linus' tree.
> >>
> >>         Tested-by: Jiri Kosina <jkosina@suse.cz>
> >>
> >> Anyone applying this, please?
> >
> > Yeah, I'm still seeing it in -rc3. Linus, can you pick up Alan's patch
> > from https://patchwork.kernel.org/patch/1757061/ please?
> 
> Christ people.
> 
> I already reported that it DOES NOT EVEN COMPILE. See the other thread
> here on lkml ("Re: 3.8-rc2: EFI framebuffer lock inversion...").
> 
> Alan apparently doesn't care about the patch he wrote to even bother
> fixing that, and the only person who does seem to care enough to carry
> two fixes around (Andrew) apparently doesn't feel that he's
> comfortable forwarding it to me (he's been sending other patches, so
> it's not like Andrew is offline either)..
> 
> I'm not picking up random patches from people who don't care enough
> about those patches to even bother fixing compile errors when
> reportyed and didn't even send them to me to begin with.
> 
> So I'm trusting that Andrew is right, and is waiting for something.
> 

Florian has been taking a month or two's downtime (now expired, I
think) so I've been waiting for him to reappear to process this one for
3.8.

Meanwhile, I guess we could put it into mainline ;) It has been in
-next for a month.



From: Alan Cox <alan@linux.intel.com>
Subject: fb: rework locking to fix lock ordering on takeover

Adjust the console layer to allow a take over call where the caller
already holds the locks.  Make the fb layer lock in order.

This is partly a band aid, the fb layer is terminally confused about the
locking rules it uses for its notifiers it seems.

[akpm@linux-foundation.org: remove stray non-ascii char, tidy comment]
[akpm@linux-foundation.org: export do_take_over_console()]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt.c           |   91 ++++++++++++++++++++++++--------
 drivers/video/console/fbcon.c |   30 ++++++++++
 drivers/video/fbmem.c         |    5 -
 drivers/video/fbsysfs.c       |    3 +
 include/linux/console.h       |    1 
 5 files changed, 104 insertions(+), 26 deletions(-)

diff -puN drivers/tty/vt/vt.c~fb-rework-locking-to-fix-lock-ordering-on-takeover drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~fb-rework-locking-to-fix-lock-ordering-on-takeover
+++ a/drivers/tty/vt/vt.c
@@ -2987,7 +2987,7 @@ int __init vty_init(const struct file_op
 
 static struct class *vtconsole_class;
 
-static int bind_con_driver(const struct consw *csw, int first, int last,
+static int do_bind_con_driver(const struct consw *csw, int first, int last,
 			   int deflt)
 {
 	struct module *owner = csw->owner;
@@ -2998,7 +2998,7 @@ static int bind_con_driver(const struct 
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
+	WARN_CONSOLE_UNLOCKED();
 
 	/* check if driver is registered */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3083,11 +3083,22 @@ static int bind_con_driver(const struct 
 
 	retval = 0;
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 };
 
+
+static int bind_con_driver(const struct consw *csw, int first, int last,
+			   int deflt)
+{
+	int ret;
+
+	console_lock();
+	ret = do_bind_con_driver(csw, first, last, deflt);
+	console_unlock();
+	return ret;
+}
+
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
 {
@@ -3199,9 +3210,9 @@ int unbind_con_driver(const struct consw
 	if (!con_is_bound(csw))
 		con_driver->flag &= ~CON_DRIVER_FLAG_INIT;
 
-	console_unlock();
 	/* ignore return value, binding should not fail */
-	bind_con_driver(defcsw, first, last, deflt);
+	do_bind_con_driver(defcsw, first, last, deflt);
+	console_unlock();
 err:
 	module_put(owner);
 	return retval;
@@ -3492,28 +3503,18 @@ int con_debug_leave(void)
 }
 EXPORT_SYMBOL_GPL(con_debug_leave);
 
-/**
- * register_con_driver - register console driver to console layer
- * @csw: console driver
- * @first: the first console to take over, minimum value is 0
- * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
- *
- * DESCRIPTION: This function registers a console driver which can later
- * bind to a range of consoles specified by @first and @last. It will
- * also initialize the console driver by calling con_startup().
- */
-int register_con_driver(const struct consw *csw, int first, int last)
+static int do_register_con_driver(const struct consw *csw, int first, int last)
 {
 	struct module *owner = csw->owner;
 	struct con_driver *con_driver;
 	const char *desc;
 	int i, retval = 0;
 
+	WARN_CONSOLE_UNLOCKED();
+
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
-
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_driver = &registered_con_driver[i];
 
@@ -3566,10 +3567,29 @@ int register_con_driver(const struct con
 	}
 
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 }
+
+/**
+ * register_con_driver - register console driver to console layer
+ * @csw: console driver
+ * @first: the first console to take over, minimum value is 0
+ * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
+ *
+ * DESCRIPTION: This function registers a console driver which can later
+ * bind to a range of consoles specified by @first and @last. It will
+ * also initialize the console driver by calling con_startup().
+ */
+int register_con_driver(const struct consw *csw, int first, int last)
+{
+	int retval;
+
+	console_lock();
+	retval = do_register_con_driver(csw, first, last);
+	console_unlock();
+	return retval;
+}
 EXPORT_SYMBOL(register_con_driver);
 
 /**
@@ -3625,15 +3645,42 @@ EXPORT_SYMBOL(unregister_con_driver);
  *
  *      take_over_console is basically a register followed by unbind
  */
+int do_take_over_console(const struct consw *csw, int first, int last, int deflt)
+{
+	int err;
+
+	err = do_register_con_driver(csw, first, last);
+	/*
+	 * If we get an busy error we still want to bind the console driver
+	 * and return success, as we may have unbound the console driver
+	_* but not unregistered it.
+	 */
+	if (err == -EBUSY)
+		err = 0;
+	if (!err)
+		do_bind_con_driver(csw, first, last, deflt);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(do_take_over_console);
+
+/*
+ *	If we support more console drivers, this function is used
+ *	when a driver wants to take over some existing consoles
+ *	and become default driver for newly opened ones.
+ *
+ *      take_over_console is basically a register followed by unbind
+ */
 int take_over_console(const struct consw *csw, int first, int last, int deflt)
 {
 	int err;
 
 	err = register_con_driver(csw, first, last);
-	/* if we get an busy error we still want to bind the console driver
+	/*
+	 * If we get an busy error we still want to bind the console driver
 	 * and return success, as we may have unbound the console driver
-	 * but not unregistered it.
-	*/
+	_* but not unregistered it.
+	 */
 	if (err == -EBUSY)
 		err = 0;
 	if (!err)
diff -puN drivers/video/console/fbcon.c~fb-rework-locking-to-fix-lock-ordering-on-takeover drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fb-rework-locking-to-fix-lock-ordering-on-takeover
+++ a/drivers/video/console/fbcon.c
@@ -529,6 +529,34 @@ static int search_for_mapped_con(void)
 	return retval;
 }
 
+static int do_fbcon_takeover(int show_logo)
+{
+	int err, i;
+
+	if (!num_registered_fb)
+		return -ENODEV;
+
+	if (!show_logo)
+		logo_shown = FBCON_LOGO_DONTSHOW;
+
+	for (i = first_fb_vc; i <= last_fb_vc; i++)
+		con2fb_map[i] = info_idx;
+
+	err = do_take_over_console(&fb_con, first_fb_vc, last_fb_vc,
+				fbcon_is_default);
+
+	if (err) {
+		for (i = first_fb_vc; i <= last_fb_vc; i++) {
+			con2fb_map[i] = -1;
+		}
+		info_idx = -1;
+	} else {
+		fbcon_has_console_bind = 1;
+	}
+
+	return err;
+}
+
 static int fbcon_takeover(int show_logo)
 {
 	int err, i;
@@ -3115,7 +3143,7 @@ static int fbcon_fb_registered(struct fb
 		}
 
 		if (info_idx != -1)
-			ret = fbcon_takeover(1);
+			ret = do_fbcon_takeover(1);
 	} else {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			if (con2fb_map_boot[i] == idx)
diff -puN drivers/video/fbmem.c~fb-rework-locking-to-fix-lock-ordering-on-takeover drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-rework-locking-to-fix-lock-ordering-on-takeover
+++ a/drivers/video/fbmem.c
@@ -1650,7 +1650,9 @@ static int do_register_framebuffer(struc
 	event.info = fb_info;
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+        console_lock();
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+        console_unlock();
 	unlock_fb_info(fb_info);
 	return 0;
 }
@@ -1853,11 +1855,8 @@ int fb_new_modelist(struct fb_info *info
 	err = 1;
 
 	if (!list_empty(&info->modelist)) {
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		err = fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
-		unlock_fb_info(info);
 	}
 
 	return err;
diff -puN drivers/video/fbsysfs.c~fb-rework-locking-to-fix-lock-ordering-on-takeover drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~fb-rework-locking-to-fix-lock-ordering-on-takeover
+++ a/drivers/video/fbsysfs.c
@@ -177,6 +177,8 @@ static ssize_t store_modes(struct device
 	if (i * sizeof(struct fb_videomode) != count)
 		return -EINVAL;
 
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	console_lock();
 	list_splice(&fb_info->modelist, &old_list);
 	fb_videomode_to_modelist((const struct fb_videomode *)buf, i,
@@ -188,6 +190,7 @@ static ssize_t store_modes(struct device
 		fb_destroy_modelist(&old_list);
 
 	console_unlock();
+	unlock_fb_info(fb_info);
 
 	return 0;
 }
diff -puN include/linux/console.h~fb-rework-locking-to-fix-lock-ordering-on-takeover include/linux/console.h
--- a/include/linux/console.h~fb-rework-locking-to-fix-lock-ordering-on-takeover
+++ a/include/linux/console.h
@@ -78,6 +78,7 @@ int con_is_bound(const struct consw *csw
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
+int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
 #ifdef CONFIG_HW_CONSOLE
 int con_debug_enter(struct vc_data *vc);
_

