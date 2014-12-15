Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaLOWQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:16:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:7782 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaLOWQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:16:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,582,1413270000"; 
   d="scan'208";a="624219256"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] vt: fix check for system/busy console drivers when unregistering them
Date: Tue, 16 Dec 2014 00:15:59 +0200
Message-Id: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default console driver (conswitchp) and busy drivers bound to a
console (as reported by con_is_bound()) shouldn't be unregistered.
System console drivers (without the CON_DRIVER_FLAG_MODULE flag) can be
unregistered, provided they are neither default nor busy. The current
code checks for the CON_DRIVER_FLAG_INIT flag but this doesn't make
sense: this flag is set for a driver whenever its associated console's
con_startup() function is called, which first happens when the console
driver is registered (so before the console gets bound) and gets cleared
when the console gets unbound. The purpose of this flag is to show if we
need to call con_startup() on a console before we use it.

Based on the above, do_unregister_con_driver() in its current form will
allow unregistering a console driver only if it was never bound, but
will refuse to unregister one that was bound and later unbound.

Fix this by dropping the CON_DRIVER_FLAG_INIT check, allowing
unregistering of any console driver provided that it's not the default
one and it's not busy.

v2:
- reword the third paragraph to clarify how the fix works (Peter Hurley)
v3:
- unchanged
v4:
- Allow unregistering a system console driver too, needed by i915 to
  unregister vgacon. Update commit description accordingly. (Daniel)

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/tty/vt/vt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f3fbbbc..9c046fb 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3665,8 +3665,7 @@ int do_unregister_con_driver(const struct consw *csw)
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		struct con_driver *con_driver = &registered_con_driver[i];
 
-		if (con_driver->con == csw &&
-		    con_driver->flag & CON_DRIVER_FLAG_INIT) {
+		if (con_driver->con == csw) {
 			vtconsole_deinit_device(con_driver);
 			device_destroy(vtconsole_class,
 				       MKDEV(0, con_driver->node));
-- 
1.8.4

