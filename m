Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3AMUrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 15:47:48 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43050 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab3AMUrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 15:47:47 -0500
Date: Sun, 13 Jan 2013 21:47:21 +0100
From: =?ISO-8859-2?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>
To: asierra@xes-inc.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] linux-3.7.2-lpc_ich: fix gpio base and control offsets
Message-ID: <20130113214721.7f1f01d7@palee-debian>
X-Mailer: Claws Mail 3.9.0cvs55 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0DKlsC6029387

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

In ICH5 and under the GPIOBASE and GPIOCTRL are 0x58 and 0x5C. This
patch updates lpc_ich.c that supports ICH5 and under GPIO. This patch
fix the "I/O space for GPIO uninitialized" message.
Reference: 252516-001, 252517-028: 82801EB (ICH5), 82801ER (ICH5R)
documents from developer intel com.

Signed-off-by: Pál Agócs <agocs.pal.86@gmail.com>

diffstat :=
 lpc_ich.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

- --- a/drivers/mfd/lpc_ich.c	2013-01-11 18:19:28.000000000 +0100
+++ b/drivers/mfd/lpc_ich.c	2013-01-13 20:56:22.000000000 +0100
@@ -76,7 +76,9 @@
 #define ACPIBASE_GCS_END	0x3414
 
 #define GPIOBASE		0x48
+#define GPIOBASE_ICH5		0x58
 #define GPIOCTRL		0x4C
+#define GPIOCTRL_ICH5		0x5C
 
 #define RCBABASE		0xf0
 
@@ -659,6 +661,20 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_i
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
 
+static u8 gpio_base_offset;
+static u8 gpio_ctrl_offset;
+
+static void set_gpio_offsets(const struct pci_device_id *id)
+{
+	gpio_base_offset = GPIOBASE;
+	gpio_ctrl_offset = GPIOCTRL;
+		
+	if(id->driver_data <= LPC_ICH5) {
+		gpio_base_offset = GPIOBASE_ICH5;
+		gpio_ctrl_offset = GPIOCTRL_ICH5;
+	}
+}
+
 static void lpc_ich_restore_config_space(struct pci_dev *dev)
 {
 	if (lpc_ich_acpi_save >= 0) {
@@ -667,7 +683,7 @@ static void lpc_ich_restore_config_space
 	}
 
 	if (lpc_ich_gpio_save >= 0) {
- -		pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save);
+		pci_write_config_byte(dev, gpio_ctrl_offset, lpc_ich_gpio_save);
 		lpc_ich_gpio_save = -1;
 	}
 }
@@ -685,8 +701,8 @@ static void __devinit lpc_ich_enable_gpi
 {
 	u8 reg_save;
 
- -	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
- -	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
+	pci_read_config_byte(dev, gpio_ctrl_offset, &reg_save);
+	pci_write_config_byte(dev, gpio_ctrl_offset, reg_save | 0x10);
 	lpc_ich_gpio_save = reg_save;
 }
 
@@ -757,7 +773,7 @@ static int __devinit lpc_ich_init_gpio(s
 
 gpe0_done:
 	/* Setup GPIO base register */
- -	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
+	pci_read_config_dword(dev, gpio_base_offset, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
@@ -857,7 +873,8 @@ static int __devinit lpc_ich_probe(struc
 {
 	int ret;
 	bool cell_added = false;
- -
+	set_gpio_offsets(id);
+	
 	ret = lpc_ich_init_wdt(dev, id);
 	if (!ret)
 		cell_added = true;
@@ -871,10 +888,12 @@ static int __devinit lpc_ich_probe(struc
 	 * successfully.
 	 */
 	if (!cell_added) {
+		dev_err(&dev->dev, "probe FAIL\n");
 		lpc_ich_restore_config_space(dev);
 		return -ENODEV;
 	}
 
+	dev_notice(&dev->dev, "probe OK\n");
 	return 0;
 }
 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQ8x1ZAAoJEL9P7b+4cOGHAf4H/0Q8RD9AvOlamLpJnHctjb/n
0+C52aEGexkRMda9Doz6MK4LJegRbpfM3yG60w0hO5rSkZ2P22a+BrpVrDuAyUr3
2OV5mqoRs8eYHM97WTAHJ37gioyC/aDqAJ1nqA2bJ3xxMV9hzAfovRmW7TSzyc7/
x8syAqGjtKTU6XsljBaC1u5p2I6K0Tl6i1EXmpv4jbwa/CkKk7KWr6F+jUkqgtGO
6vUYz87zn11OOEpZwkD0FYzwNnhDOfYgxNjq099WnBpCsPQAZlk9gCpwXl+CpBKp
AFxGzPZZLc15TLW3pjGG35TavRJ5ikS8eQFyw7CwzJfVnHOWZ15UaUGQyo8AQVA=
=oQhb
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
