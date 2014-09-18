Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbaIROBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:01:34 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61294 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaIROBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:01:33 -0400
Message-ID: <541AE5C4.2070409@gmail.com>
Date: Thu, 18 Sep 2014 22:01:40 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3 v2] xen/xenbus: Improve failure processing code for __xenbus_switch_state()
References: <541AE4E9.2040904@gmail.com>
In-Reply-To: <541AE4E9.2040904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When failure occurs, need return failure code instead of 0, or some of
indirect upper callers may misunderstand.

e.g. in "block/xen-blkback/xenbus.c":

    connect() -> xenbus_switch_state() -> __xenbus_switch_state().

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/xen/xenbus/xenbus_client.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index ca74410..642a476 100644
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
@@ -219,7 +220,7 @@ abort:
 	} else
 		dev->state = state;
 
-	return 0;
+	return err;
 }
 
 /**
-- 
1.9.3
