Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaLOWQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:16:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:56008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaLOWQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:16:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,582,1413270000"; 
   d="scan'208";a="654417603"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] vt: fix locking around vt_bind/vt_unbind
Date: Tue, 16 Dec 2014 00:16:00 +0200
Message-Id: <1418681761-3709-2-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vt_bind and vt_unbind access at least the con_driver object
and registered_con_driver array without holding the console lock. Fix
this by locking around the whole function in each case.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/vt/vt.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 9c046fb..5d36c23 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3318,11 +3318,8 @@ static int vt_bind(struct con_driver *con)
 		if (first == 0 && last == MAX_NR_CONSOLES -1)
 			deflt = 1;
 
-		if (first != -1) {
-			console_lock();
+		if (first != -1)
 			do_bind_con_driver(csw, first, last, deflt);
-			console_unlock();
-		}
 
 		first = -1;
 		last = -1;
@@ -3362,9 +3359,7 @@ static int vt_unbind(struct con_driver *con)
 			deflt = 1;
 
 		if (first != -1) {
-			console_lock();
 			ret = do_unbind_con_driver(csw, first, last, deflt);
-			console_unlock();
 			if (ret != 0)
 				return ret;
 		}
@@ -3394,11 +3389,15 @@ static ssize_t store_bind(struct device *dev, struct device_attribute *attr,
 	struct con_driver *con = dev_get_drvdata(dev);
 	int bind = simple_strtoul(buf, NULL, 0);
 
+	console_lock();
+
 	if (bind)
 		vt_bind(con);
 	else
 		vt_unbind(con);
 
+	console_unlock();
+
 	return count;
 }
 
-- 
1.8.4

