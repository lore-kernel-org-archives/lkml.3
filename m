Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaJPAwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 20:52:51 -0400
Received: from mailout.micron.com ([137.201.242.129]:33441 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaJPAwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 20:52:50 -0400
From: bpqw <bpqw@micron.com>
To: Marek Vasut <marex@denx.de>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Topic: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Index: AQHP6ADrbICFEEG1rUGWsJLbyrieFJwx3D+w
Date: Thu, 16 Oct 2014 00:52:02 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E6D82@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
 <201410150045.53976.marex@denx.de>
In-Reply-To: <201410150045.53976.marex@denx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21028.000
x-tm-as-result: No--43.433100-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9G0qwvC002288


>Won't $info contain an undefined value in case the newly added condition isn't met ? The old code initialized $info to a certain value always, the new code does not do that.

Hi,Marek Vasut
 Thanks.the $info has been defined before as below:

 info = (void *)id->driver_data;
  
Unless id has not been initialized before.If having the following situation,
current linux codes will not properly match platform device data:

For example:

const struct spi_device_id spi_nor_ids[] = {
......
......
......
	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, 0) },
	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024,  256, 0) },//former right platform point will be overwrote by this data info.
	{ "n25q128a13",  INFO(0x20bb18, 0x1234, 64 * 1024,  512, SECT_4K) },//this is the right platform data,I want to match this data info.
	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
......
......
......
};
EXPORT_SYMBOL_GPL(spi_nor_ids);

Maybe my patch should take into account that ID is NULL,
I want to change my patch following, could you please give me some suggestions:

	struct flash_info *tmpinfo;

	tmpinfo = (void *)jid->driver_data;
	if (id == NULL || tmpinfo->jedec_id != info->jedec_id ||
		 (info->ext_id != 0 && tmpinfo->ext_id != info->ext_id)) {
			dev_warn(dev, "found %s, expected %s\n",
				jid->name, id->name);
			id = jid;
			info = (void *)jid->driver_data;
				}
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
