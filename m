Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3CDDm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60863 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab3CDDmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:49 -0500
Message-Id: <20130304033721.050183480@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:24 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Herton R. Krzesinski" <herton.krzesinski@canonical.com>,
        Douglas Bagnall <douglas@paradise.net.nz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 137/153] [media] rc: unlock on error in show_protocols()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 30ebc5e44d057a1619ad63fe32c8c1670c37c4b8 upstream.

We recently introduced a new return -ENODEV in this function but we need
to unlock before returning.

[mchehab@redhat.com: found two patches with the same fix. Merged SOB's/acks into one patch]
Acked-by: Herton R. Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/rc/rc-main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -777,8 +777,10 @@ static ssize_t show_protocols(struct dev
 	} else if (dev->raw) {
 		enabled = dev->raw->enabled_protocols;
 		allowed = ir_raw_get_allowed_protocols();
-	} else
+	} else {
+		mutex_unlock(&dev->lock);
 		return -ENODEV;
+	}
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,


