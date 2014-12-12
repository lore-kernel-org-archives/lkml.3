Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900AbaLLQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:43:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:16939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030687AbaLLQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:43:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="646723192"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] vt: fix check for system/busy console drivers when unregistering them
Date: Fri, 12 Dec 2014 18:38:03 +0200
Message-Id: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System console drivers (without the CON_DRIVER_FLAG_MODULE flag) and
busy drivers bound to a console (as reported by con_is_bound())
shouldn't be unregistered. The current code checks for the
CON_DRIVER_FLAG_INIT flag but this doesn't really correspond to either
of the above two conditions. CON_DRIVER_FLAG_INIT is set whenever its
associated console's con_startup() function is called, which first
happens when the console driver is registered (so before the console
gets bound) and gets cleared when the console gets unbound. The
purpose of this flag is to show if we need to call con_startup() on a
console before we use it.

Based on the above, do_unregister_con_driver() in its current form will
incorrectly allow unregistering a console driver only if it was never
bound, but will refuse to unregister one that was bound and later
unbound. It will also allow unregistering a system console driver.

Fix this by checking for CON_DRIVER_FLAG_MODULE to refuse unregistering
a system console driver and relying on the existing con_is_bound() check
earlier in the function to refuse unregistering a busy console driver.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/tty/vt/vt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index b33b00b..1862e89 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3660,7 +3660,7 @@ int do_unregister_con_driver(const struct consw *csw)
 		struct con_driver *con_driver = &registered_con_driver[i];
 
 		if (con_driver->con == csw &&
-		    con_driver->flag & CON_DRIVER_FLAG_INIT) {
+		    con_driver->flag & CON_DRIVER_FLAG_MODULE) {
 			vtconsole_deinit_device(con_driver);
 			device_destroy(vtconsole_class,
 				       MKDEV(0, con_driver->node));
-- 
1.8.4

