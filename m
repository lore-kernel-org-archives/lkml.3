Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaINKwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:52:40 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43839 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaINKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:52:39 -0400
Message-ID: <5415737D.2030209@gmail.com>
Date: Sun, 14 Sep 2014 18:52:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] drivers/xen/xenbus/xenbus_client.c: Improve the failure
 processing for __xenbus_switch_state()
References: <54157282.40402@gmail.com>
In-Reply-To: <54157282.40402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When failure occurs, need return failure code instead of 0, or the upper
caller will misunderstand.

Also when retry for EAGAIN reason, better to schedule out for a while,
so can let others have chance to continue their tasks (especially,
their tasks are related EAGAIN under UP kernel).

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/xen/xenbus/xenbus_client.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 620ffd2..fc8699b 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/export.h>
+#include <linux/delay.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/page.h>
 #include <xen/interface/xen.h>
@@ -196,7 +197,7 @@ again:
 	err = xenbus_transaction_start(&xbt);
 	if (err) {
 		xenbus_switch_fatal(dev, depth, err, "starting transaction");
-		return 0;
+		return err;
 	}
 
 	err = xenbus_scanf(xbt, dev->nodename, "state", "%d", &current_state);
@@ -213,13 +214,15 @@ again:
 abort:
 	err = xenbus_transaction_end(xbt, abort);
 	if (err) {
-		if (err == -EAGAIN && !abort)
+		if (err == -EAGAIN && !abort) {
+			msleep(20);
 			goto again;
+		}
 		xenbus_switch_fatal(dev, depth, err, "ending transaction");
 	} else
 		dev->state = state;
 
-	return 0;
+	return err;
 }
 
 /**
-- 
1.9.3

