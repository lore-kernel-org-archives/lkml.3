Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaJNB2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:28:52 -0400
Received: from mailout.micron.com ([137.201.242.129]:44299 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaJNB2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:28:49 -0400
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Topic: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Index: Ac/mqfhUCcgRvGRwTVWYPE12HvMUJwAo2mng
Date: Tue, 14 Oct 2014 01:26:49 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21020.003
X-TM-AS-Result: No--6.292500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch used to modify the method of spi_nor_scan overwrite platform ID point.

If type of platform data match with the name of spi_nor_ids set,
and JEDEC ID also match with INFO ID of spi_nor_ids set,spi device
ID point(this is before probed according to device name) shouldn't be
overwrote.Otherwise,this point will be overwrote by new spi_nor_ids
set point that probed according to JEDEC ID.

Signed-off-by: bean huo <beanhuo@micron.com>
---
v1-v2:
	add extended ID match judgment.

 drivers/mtd/spi-nor/spi-nor.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index b5ad6be..3bb8077 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -963,16 +963,23 @@ int spi_nor_scan(struct spi_nor *nor, const struct spi_device_id *id,
 			return PTR_ERR(jid);
 		} else if (jid != id) {
 			/*
-			 * JEDEC knows better, so overwrite platform ID. We
-			 * can't trust partitions any longer, but we'll let
-			 * mtd apply them anyway, since some partitions may be
-			 * marked read-only, and we don't want to lose that
-			 * information, even if it's not 100% accurate.
+			 * If type of platform data match with the name of
+			 * spi_nor_ids set,and JEDEC ID also match with
+			 * INFO ID of spi_nor_ids set,shouldn't overwrite
+			 * spi device info point.Otherwise,will overwrite
+			 * it.
 			 */
-			dev_warn(dev, "found %s, expected %s\n",
-				 jid->name, id->name);
-			id = jid;
-			info = (void *)jid->driver_data;
+			struct flash_info *tmpinfo;
+
+			tmpinfo = (void *)jid->driver_data;
+			if (tmpinfo->jedec_id != info->jedec_id ||
+					(info->ext_id != 0 &&
+					 tmpinfo->ext_id != info->ext_id)) {
+				dev_warn(dev, "found %s, expected %s\n",
+						jid->name, id->name);
+				id = jid;
+				info = (void *)jid->driver_data;
+			}
 		}
 	}
 
-- 
1.7.9.5
