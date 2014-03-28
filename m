Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaC1R4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:56:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaC1Rai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 05/22] media: cx18: check for allocation failure in cx18_read_eeprom()
Date: Fri, 28 Mar 2014 10:31:57 -0700
Message-Id: <20140328173110.137188670@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e351bf25fa373a3de0be2141b962c5c3c27006a2 upstream.

It upsets static checkers when we don't check for allocation failure.  I
moved the memset() of "tv" earlier so we don't use uninitialized data on
error.
Fixes: 1d212cf0c2d8 ('[media] cx18: struct i2c_client is too big for stack')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx18/cx18-driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -327,13 +327,16 @@ void cx18_read_eeprom(struct cx18 *cx, s
 	struct i2c_client *c;
 	u8 eedata[256];
 
+	memset(tv, 0, sizeof(*tv));
+
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return;
 
 	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
 	c->adapter = &cx->i2c_adap[0];
 	c->addr = 0xa0 >> 1;
 
-	memset(tv, 0, sizeof(*tv));
 	if (tveeprom_read(c, eedata, sizeof(eedata)))
 		goto ret;
 


