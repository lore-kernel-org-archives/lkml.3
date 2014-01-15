Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaAOVgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:36:07 -0500
Received: from mail1.windriver.com ([147.11.146.13]:45000 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAOVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:36:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Weinberger <richard@nod.at>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v2] drivers/tty/hvc: don't use module_init in non-modular hyp. console code
Date: Wed, 15 Jan 2014 16:35:43 -0500
Message-ID: <1389821743-25081-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HVC_OPAL/RTAS/UDBG/XEN options are all bool, and hence their support
is either present or absent.  It will never be modular, so using
module_init as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- it will remain at level 6 in initcall ordering.

Also the __exitcall functions have been outright deleted since
they are only ever of interest to UML, and UML will never be
using any of this code.

Cc: Richard Weinberger <richard@nod.at>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: unchanged; just added xen guys to Cc list, as hvc_xen isnt
 hooked into the MAINTAINERS file as of yet, so I forgot them.]

diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
index 6496872e2e47..b01659bd4f7c 100644
--- a/drivers/tty/hvc/hvc_opal.c
+++ b/drivers/tty/hvc/hvc_opal.c
@@ -255,13 +255,7 @@ static int __init hvc_opal_init(void)
 	/* Register as a vio device to receive callbacks */
 	return platform_driver_register(&hvc_opal_driver);
 }
-module_init(hvc_opal_init);
-
-static void __exit hvc_opal_exit(void)
-{
-	platform_driver_unregister(&hvc_opal_driver);
-}
-module_exit(hvc_opal_exit);
+device_initcall(hvc_opal_init);
 
 static void udbg_opal_putc(char c)
 {
diff --git a/drivers/tty/hvc/hvc_rtas.c b/drivers/tty/hvc/hvc_rtas.c
index 0069bb86ba49..08c87920b74a 100644
--- a/drivers/tty/hvc/hvc_rtas.c
+++ b/drivers/tty/hvc/hvc_rtas.c
@@ -102,17 +102,7 @@ static int __init hvc_rtas_init(void)
 
 	return 0;
 }
-module_init(hvc_rtas_init);
-
-/* This will tear down the tty portion of the driver */
-static void __exit hvc_rtas_exit(void)
-{
-	/* Really the fun isn't over until the worker thread breaks down and
-	 * the tty cleans up */
-	if (hvc_rtas_dev)
-		hvc_remove(hvc_rtas_dev);
-}
-module_exit(hvc_rtas_exit);
+device_initcall(hvc_rtas_init);
 
 /* This will happen prior to module init.  There is no tty at this time? */
 static int __init hvc_rtas_console_init(void)
diff --git a/drivers/tty/hvc/hvc_udbg.c b/drivers/tty/hvc/hvc_udbg.c
index 72228276fe31..9cf573d06a29 100644
--- a/drivers/tty/hvc/hvc_udbg.c
+++ b/drivers/tty/hvc/hvc_udbg.c
@@ -80,14 +80,7 @@ static int __init hvc_udbg_init(void)
 
 	return 0;
 }
-module_init(hvc_udbg_init);
-
-static void __exit hvc_udbg_exit(void)
-{
-	if (hvc_udbg_dev)
-		hvc_remove(hvc_udbg_dev);
-}
-module_exit(hvc_udbg_exit);
+device_initcall(hvc_udbg_init);
 
 static int __init hvc_udbg_console_init(void)
 {
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 636c9baad7a5..2dc2831840ca 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -561,18 +561,7 @@ static int __init xen_hvc_init(void)
 #endif
 	return r;
 }
-
-static void __exit xen_hvc_fini(void)
-{
-	struct xencons_info *entry, *next;
-
-	if (list_empty(&xenconsoles))
-			return;
-
-	list_for_each_entry_safe(entry, next, &xenconsoles, list) {
-		xen_console_remove(entry);
-	}
-}
+device_initcall(xen_hvc_init);
 
 static int xen_cons_init(void)
 {
@@ -598,10 +587,6 @@ static int xen_cons_init(void)
 	hvc_instantiate(HVC_COOKIE, 0, ops);
 	return 0;
 }
-
-
-module_init(xen_hvc_init);
-module_exit(xen_hvc_fini);
 console_initcall(xen_cons_init);
 
 #ifdef CONFIG_EARLY_PRINTK
-- 
1.8.5.2

