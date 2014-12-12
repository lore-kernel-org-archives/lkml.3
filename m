Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030913AbaLLQny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:43:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:16939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030714AbaLLQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:43:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="646723210"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] vt: fix locking around vt_bind/vt_unbind
Date: Fri, 12 Dec 2014 18:38:04 +0200
Message-Id: <1418402285-9578-2-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
References: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vt_bind and vt_unbind access at least the con_driver object
and registered_con_driver array without holding the console lock. Fix
this by locking around the whole function in each case.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/tty/vt/vt.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 1862e89..5dd1880 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3312,11 +3312,8 @@ static int vt_bind(struct con_driver *con)
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
@@ -3356,9 +3353,7 @@ static int vt_unbind(struct con_driver *con)
 			deflt = 1;
 
 		if (first != -1) {
-			console_lock();
 			ret = do_unbind_con_driver(csw, first, last, deflt);
-			console_unlock();
 			if (ret != 0)
 				return ret;
 		}
@@ -3388,11 +3383,15 @@ static ssize_t store_bind(struct device *dev, struct device_attribute *attr,
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

