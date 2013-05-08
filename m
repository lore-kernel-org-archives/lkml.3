Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3EHSOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:12 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:32794 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab3EHSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:08 -0400
Date: Thu, 9 May 2013 02:13:59 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] vt: delete unneeded functions
 register_con_driver|take_over_console
Message-ID: <20130508181359.GD12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no place use register_con_driver|take_over_console,
and we can achieve their function with do_register_con_driver|
do_take_over_console easily, so just delete them to reduce code duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c     | 45 ---------------------------------------------
 include/linux/console.h |  2 --
 2 files changed, 47 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index fbd447b..852d470 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3576,26 +3576,6 @@ err:
 	return retval;
 }
 
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
-{
-	int retval;
-
-	console_lock();
-	retval = do_register_con_driver(csw, first, last);
-	console_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(register_con_driver);
 
 /**
  * unregister_con_driver - unregister console driver from console layer
@@ -3677,30 +3657,6 @@ int do_take_over_console(const struct consw *csw, int first, int last, int deflt
 }
 EXPORT_SYMBOL_GPL(do_take_over_console);
 
-/*
- *	If we support more console drivers, this function is used
- *	when a driver wants to take over some existing consoles
- *	and become default driver for newly opened ones.
- *
- *	take_over_console is basically a register followed by unbind
- */
-int take_over_console(const struct consw *csw, int first, int last, int deflt)
-{
-	int err;
-
-	err = register_con_driver(csw, first, last);
-	/*
-	 * If we get an busy error we still want to bind the console driver
-	 * and return success, as we may have unbound the console driver
-	 * but not unregistered it.
-	 */
-	if (err == -EBUSY)
-		err = 0;
-	if (!err)
-		bind_con_driver(csw, first, last, deflt);
-
-	return err;
-}
 
 /*
  * give_up_console is a wrapper to unregister_con_driver. It will only
@@ -4264,6 +4220,5 @@ EXPORT_SYMBOL(console_blanked);
 EXPORT_SYMBOL(vc_cons);
 EXPORT_SYMBOL(global_cursor_default);
 #ifndef VT_SINGLE_DRIVER
-EXPORT_SYMBOL(take_over_console);
 EXPORT_SYMBOL(give_up_console);
 #endif
diff --git a/include/linux/console.h b/include/linux/console.h
index 29680a8..c2b2d45 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -75,10 +75,8 @@ extern const struct consw newport_con;	/* SGI Newport console  */
 extern const struct consw prom_con;	/* SPARC PROM console */
 
 int con_is_bound(const struct consw *csw);
-int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int do_unregister_con_driver(const struct consw *csw);
-int take_over_console(const struct consw *sw, int first, int last, int deflt);
 int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
 #ifdef CONFIG_HW_CONSOLE
-- 
1.7.12.4.dirty
