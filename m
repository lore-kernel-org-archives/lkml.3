Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3CATvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:51:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3CATqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Herton R. Krzesinski" <herton.krzesinski@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Douglas Bagnall <douglas@paradise.net.nz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 14/30] media: rc: unlock on error in show_protocols()
Date: Fri,  1 Mar 2013 11:45:35 -0800
Message-Id: <20130301194529.523122840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -775,8 +775,10 @@ static ssize_t show_protocols(struct dev
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


