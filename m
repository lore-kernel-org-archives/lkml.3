Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3LBUj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:39:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3LBTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.10 148/173] media: cx18: struct i2c_client is too big for stack
Date: Mon,  2 Dec 2013 11:12:11 -0800
Message-Id: <20131202191200.388805325@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 1d212cf0c2d89adf3d0a6d62d729076f49f087dc upstream.

	drivers/media/pci/cx18/cx18-driver.c: In function 'cx18_read_eeprom':
	drivers/media/pci/cx18/cx18-driver.c:357:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
That happens because the routine allocates 256 bytes for an eeprom buffer, plus
the size of struct i2c_client, with is big.
Change the logic to dynamically allocate/deallocate space for struct i2c_client,
instead of  using the stack.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx18/cx18-driver.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -324,23 +324,24 @@ static void cx18_eeprom_dump(struct cx18
 /* Hauppauge card? get values from tveeprom */
 void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
 {
-	struct i2c_client c;
+	struct i2c_client *c;
 	u8 eedata[256];
 
-	memset(&c, 0, sizeof(c));
-	strlcpy(c.name, "cx18 tveeprom tmp", sizeof(c.name));
-	c.adapter = &cx->i2c_adap[0];
-	c.addr = 0xA0 >> 1;
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+
+	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
+	c->adapter = &cx->i2c_adap[0];
+	c->addr = 0xa0 >> 1;
 
 	memset(tv, 0, sizeof(*tv));
-	if (tveeprom_read(&c, eedata, sizeof(eedata)))
-		return;
+	if (tveeprom_read(c, eedata, sizeof(eedata)))
+		goto ret;
 
 	switch (cx->card->type) {
 	case CX18_CARD_HVR_1600_ESMT:
 	case CX18_CARD_HVR_1600_SAMSUNG:
 	case CX18_CARD_HVR_1600_S5H1411:
-		tveeprom_hauppauge_analog(&c, tv, eedata);
+		tveeprom_hauppauge_analog(c, tv, eedata);
 		break;
 	case CX18_CARD_YUAN_MPC718:
 	case CX18_CARD_GOTVIEW_PCI_DVD3:
@@ -354,6 +355,9 @@ void cx18_read_eeprom(struct cx18 *cx, s
 		cx18_eeprom_dump(cx, eedata, sizeof(eedata));
 		break;
 	}
+
+ret:
+	kfree(c);
 }
 
 static void cx18_process_eeprom(struct cx18 *cx)


