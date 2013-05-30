Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab3E3ON3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:13:29 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:42909 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab3E3ONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:13:25 -0400
To: alsa-devel@alsa-project.org
Subject: [PATCH] [resend] snd-es1968: Add radio support for MediaForte M56VAP
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 30 May 2013 16:13:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305301613.09234.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for TEA5757 tuner on MediaForte M56VAP sound+modem+radio card.
The GPIO connection type is automatically detected (like snd-fm801 driver).

Also add a safety subsystem vendor check to skip radio detection if vendor
differs from ESS (so we don't touch GPIOs on laptops).

Tested with SF64-PCE2 and M56VAP cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/es1968.c |   73 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index a1f32b5..db08641 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -564,6 +564,7 @@ struct es1968 {
 #ifdef CONFIG_SND_ES1968_RADIO
 	struct v4l2_device v4l2_dev;
 	struct snd_tea575x tea;
+	unsigned int tea575x_tuner;
 #endif
 };
 
@@ -2557,37 +2558,47 @@ static int snd_es1968_input_register(struct es1968 *chip)
 				bits 1=unmask write to given bit */
 #define IO_DIR		8      /* direction register offset from GPIO_DATA
 				bits 0/1=read/write direction */
-/* mask bits for GPIO lines */
-#define STR_DATA	0x0040 /* GPIO6 */
-#define STR_CLK		0x0080 /* GPIO7 */
-#define STR_WREN	0x0100 /* GPIO8 */
-#define STR_MOST	0x0200 /* GPIO9 */
+
+/* GPIO to TEA575x maps */
+struct snd_es1968_tea575x_gpio {
+	u8 data, clk, wren, most;
+	char *name;
+};
+
+static struct snd_es1968_tea575x_gpio snd_es1968_tea575x_gpios[] = {
+	{ .data = 6, .clk = 7, .wren = 8, .most = 9, .name = "SF64-PCE2" },
+	{ .data = 7, .clk = 8, .wren = 6, .most = 10, .name = "M56VAP" },
+};
+
+#define get_tea575x_gpio(chip) \
+	(&snd_es1968_tea575x_gpios[(chip)->tea575x_tuner])
+
 
 static void snd_es1968_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
 {
 	struct es1968 *chip = tea->private_data;
-	unsigned long io = chip->io_port + GPIO_DATA;
+	struct snd_es1968_tea575x_gpio gpio = *get_tea575x_gpio(chip);
 	u16 val = 0;
 
-	val |= (pins & TEA575X_DATA) ? STR_DATA : 0;
-	val |= (pins & TEA575X_CLK)  ? STR_CLK  : 0;
-	val |= (pins & TEA575X_WREN) ? STR_WREN : 0;
+	val |= (pins & TEA575X_DATA) ? (1 << gpio.data) : 0;
+	val |= (pins & TEA575X_CLK)  ? (1 << gpio.clk)  : 0;
+	val |= (pins & TEA575X_WREN) ? (1 << gpio.wren) : 0;
 
-	outw(val, io);
+	outw(val, chip->io_port + GPIO_DATA);
 }
 
 static u8 snd_es1968_tea575x_get_pins(struct snd_tea575x *tea)
 {
 	struct es1968 *chip = tea->private_data;
-	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 val = inw(io);
-	u8 ret;
+	struct snd_es1968_tea575x_gpio gpio = *get_tea575x_gpio(chip);
+	u16 val = inw(chip->io_port + GPIO_DATA);
+	u8 ret = 0;
 
-	ret = 0;
-	if (val & STR_DATA)
+	if (val & (1 << gpio.data))
 		ret |= TEA575X_DATA;
-	if (val & STR_MOST)
+	if (val & (1 << gpio.most))
 		ret |= TEA575X_MOST;
+
 	return ret;
 }
 
@@ -2596,13 +2607,18 @@ static void snd_es1968_tea575x_set_direction(struct snd_tea575x *tea, bool outpu
 	struct es1968 *chip = tea->private_data;
 	unsigned long io = chip->io_port + GPIO_DATA;
 	u16 odir = inw(io + IO_DIR);
+	struct snd_es1968_tea575x_gpio gpio = *get_tea575x_gpio(chip);
 
 	if (output) {
-		outw(~(STR_DATA | STR_CLK | STR_WREN), io + IO_MASK);
-		outw(odir | STR_DATA | STR_CLK | STR_WREN, io + IO_DIR);
+		outw(~((1 << gpio.data) | (1 << gpio.clk) | (1 << gpio.wren)),
+			io + IO_MASK);
+		outw(odir | (1 << gpio.data) | (1 << gpio.clk) | (1 << gpio.wren),
+			io + IO_DIR);
 	} else {
-		outw(~(STR_CLK | STR_WREN | STR_DATA | STR_MOST), io + IO_MASK);
-		outw((odir & ~(STR_DATA | STR_MOST)) | STR_CLK | STR_WREN, io + IO_DIR);
+		outw(~((1 << gpio.clk) | (1 << gpio.wren) | (1 << gpio.data) | (1 << gpio.most)),
+			io + IO_MASK);
+		outw((odir & ~((1 << gpio.data) | (1 << gpio.most)))
+			| (1 << gpio.clk) | (1 << gpio.wren), io + IO_DIR);
 	}
 }
 
@@ -2772,6 +2788,9 @@ static int snd_es1968_create(struct snd_card *card,
 	snd_card_set_dev(card, &pci->dev);
 
 #ifdef CONFIG_SND_ES1968_RADIO
+	/* don't play with GPIOs on laptops */
+	if (chip->pci->subsystem_vendor != 0x125d)
+		goto no_radio;
 	err = v4l2_device_register(&pci->dev, &chip->v4l2_dev);
 	if (err < 0) {
 		snd_es1968_free(chip);
@@ -2781,10 +2800,18 @@ static int snd_es1968_create(struct snd_card *card,
 	chip->tea.private_data = chip;
 	chip->tea.radio_nr = radio_nr;
 	chip->tea.ops = &snd_es1968_tea_ops;
-	strlcpy(chip->tea.card, "SF64-PCE2", sizeof(chip->tea.card));
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
-	if (!snd_tea575x_init(&chip->tea, THIS_MODULE))
-		printk(KERN_INFO "es1968: detected TEA575x radio\n");
+	for (i = 0; i < ARRAY_SIZE(snd_es1968_tea575x_gpios); i++) {
+		chip->tea575x_tuner = i;
+		if (!snd_tea575x_init(&chip->tea, THIS_MODULE)) {
+			snd_printk(KERN_INFO "es1968: detected TEA575x radio type %s\n",
+				   get_tea575x_gpio(chip)->name);
+			strlcpy(chip->tea.card, get_tea575x_gpio(chip)->name,
+				sizeof(chip->tea.card));
+			break;
+		}
+	}
+no_radio:
 #endif
 
 	*chip_ret = chip;
-- 
Ondrej Zary
