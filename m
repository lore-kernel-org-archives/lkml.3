Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3EUP3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:29:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36560 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3EUP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:29:29 -0400
Date: Tue, 21 May 2013 23:29:11 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH]TTY:console: update document console.txt
Message-ID: <20130521152911.GA5971@udknight.homenetwork>
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

Update Documentatin/console/console.txt to
reflect the following changes:

take_over_console|register_con_driver|unregister_con_driver|bind_con_driver
had gone, they had been replace by the new caller hold console lock version,
do_take_over_console|do_register_con_driver|do_unregister_con_driver|do_bind_con_driver.

This patch also fix a place include wrong description about give_up_console.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 Documentation/console/console.txt | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/console/console.txt b/Documentation/console/console.txt
index 926cf1b..f93810d 100644
--- a/Documentation/console/console.txt
+++ b/Documentation/console/console.txt
@@ -12,20 +12,20 @@ The second type has to be explicitly loaded and unloaded. This will be called
 any time with each driver sharing the console with other drivers including
 the system driver. However, modular drivers cannot take over the console
 that is currently occupied by another modular driver. (Exception: Drivers that
-call take_over_console() will succeed in the takeover regardless of the type
+call do_take_over_console() will succeed in the takeover regardless of the type
 of driver occupying the consoles.) They can only take over the console that is
 occupied by the system driver. In the same token, if the modular driver is
 released by the console, the system driver will take over.
 
 Modular drivers, from the programmer's point of view, has to call:
 
-	 take_over_console() - load and bind driver to console layer
-	 give_up_console() - unbind and unload driver
+	 do_take_over_console() - load and bind driver to console layer
+	 give_up_console() - unload driver, it will only work if driver is fully unbond
 
 In newer kernels, the following are also available:
 
-	 register_con_driver()
-	 unregister_con_driver()
+	 do_register_con_driver()
+	 do_unregister_con_driver()
 
 If sysfs is enabled, the contents of /sys/class/vtconsole can be
 examined. This shows the console backends currently registered by the
@@ -94,12 +94,12 @@ for more details).
 Notes for developers:
 =====================
 
-take_over_console() is now broken up into:
+do_take_over_console() is now broken up into:
 
-     register_con_driver()
-     bind_con_driver() - private function
+     do_register_con_driver()
+     do_bind_con_driver() - private function
 
-give_up_console() is a wrapper to unregister_con_driver(), and a driver must
+give_up_console() is a wrapper to do_unregister_con_driver(), and a driver must
 be fully unbound for this call to succeed. con_is_bound() will check if the
 driver is bound or not.
 
@@ -109,10 +109,10 @@ Guidelines for console driver writers:
 In order for binding to and unbinding from the console to properly work,
 console drivers must follow these guidelines:
 
-1. All drivers, except system drivers, must call either register_con_driver()
-   or take_over_console(). register_con_driver() will just add the driver to
+1. All drivers, except system drivers, must call either do_register_con_driver()
+   or do_take_over_console(). do_register_con_driver() will just add the driver to
    the console's internal list. It won't take over the
-   console. take_over_console(), as it name implies, will also take over (or
+   console. do_take_over_console(), as it name implies, will also take over (or
    bind to) the console.
 
 2. All resources allocated during con->con_init() must be released in
@@ -128,10 +128,10 @@ console drivers must follow these guidelines:
    rebind the driver to the console arrives.
 
 4. Upon exit of the driver, ensure that the driver is totally unbound. If the
-   condition is satisfied, then the driver must call unregister_con_driver()
+   condition is satisfied, then the driver must call do_unregister_con_driver()
    or give_up_console().
 
-5. unregister_con_driver() can also be called on conditions which make it
+5. do_unregister_con_driver() can also be called on conditions which make it
    impossible for the driver to service console requests.  This can happen
    with the framebuffer console that suddenly lost all of its drivers.
 
-- 
1.7.12.4.dirty
