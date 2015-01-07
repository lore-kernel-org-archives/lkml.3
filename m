Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbbAGHbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:31:22 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:42054 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbbAGHbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:31:19 -0500
From: Olliver Schinagl <oliver+list@schinagl.nl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Cc: Olliver Schinagl <oliver@schinagl.nl>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] input: make use of the input_set_capability helper
Date: Wed,  7 Jan 2015 08:31:06 +0100
Message-Id: <1420615866-3528-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

Almost all of the speaker drivers under input manipulate the ev bits
directly, which is not needed, as there is a helper available.

This patch makes use of the helper for the speaker drivers.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 drivers/input/misc/cm109.c         | 4 ++--
 drivers/input/misc/ixp4xx-beeper.c | 5 ++---
 drivers/input/misc/m68kspkr.c      | 5 ++---
 drivers/input/misc/pcspkr.c        | 5 ++---
 drivers/input/misc/pwm-beeper.c    | 5 +----
 drivers/input/misc/sparcspkr.c     | 6 ++----
 6 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 9365535..8e41070 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -767,10 +767,10 @@ static int cm109_usb_probe(struct usb_interface *intf,
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(dev->keymap);
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_SND);
-	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
+	input_set_capability(input_dev, EV_SND, SND_BELL | SND_TONE);
 
 	/* register available key events */
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	for (i = 0; i < KEYMAP_SIZE; i++) {
 		unsigned short k = keymap(i);
 		dev->keymap[i] = k;
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 1fe149f..befccd0 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -105,11 +105,10 @@ static int ixp4xx_spkr_probe(struct platform_device *dev)
 	input_dev->id.product = 0x0001;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &dev->dev;
-
-	input_dev->evbit[0] = BIT_MASK(EV_SND);
-	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	input_dev->event = ixp4xx_spkr_event;
 
+	input_set_capability(input_dev, EV_SND, SND_BELL | SND_TONE);
+
 	err = gpio_request(dev->id, "ixp4-beeper");
 	if (err)
 		goto err_free_device;
diff --git a/drivers/input/misc/m68kspkr.c b/drivers/input/misc/m68kspkr.c
index 312d636..721f1dc 100644
--- a/drivers/input/misc/m68kspkr.c
+++ b/drivers/input/misc/m68kspkr.c
@@ -64,11 +64,10 @@ static int m68kspkr_probe(struct platform_device *dev)
 	input_dev->id.product = 0x0001;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &dev->dev;
-
-	input_dev->evbit[0] = BIT_MASK(EV_SND);
-	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	input_dev->event = m68kspkr_event;
 
+	input_set_capability(input_dev, EV_SND, SND_BELL | SND_TONE);
+
 	err = input_register_device(input_dev);
 	if (err) {
 		input_free_device(input_dev);
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 72b1fc3..5374a01 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -78,11 +78,10 @@ static int pcspkr_probe(struct platform_device *dev)
 	pcspkr_dev->id.product = 0x0001;
 	pcspkr_dev->id.version = 0x0100;
 	pcspkr_dev->dev.parent = &dev->dev;
-
-	pcspkr_dev->evbit[0] = BIT_MASK(EV_SND);
-	pcspkr_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	pcspkr_dev->event = pcspkr_event;
 
+	input_set_capability(pcspr_dev, ENV_SND, SND_BELL | SND_TONE);
+
 	err = input_register_device(pcspkr_dev);
 	if (err) {
 		input_free_device(pcspkr_dev);
diff --git a/drivers/input/misc/pwm-beeper.c b/drivers/input/misc/pwm-beeper.c
index a28ee70..e8facbd 100644
--- a/drivers/input/misc/pwm-beeper.c
+++ b/drivers/input/misc/pwm-beeper.c
@@ -102,12 +102,9 @@ static int pwm_beeper_probe(struct platform_device *pdev)
 	beeper->input->id.vendor = 0x001f;
 	beeper->input->id.product = 0x0001;
 	beeper->input->id.version = 0x0100;
-
-	beeper->input->evbit[0] = BIT(EV_SND);
-	beeper->input->sndbit[0] = BIT(SND_TONE) | BIT(SND_BELL);
-
 	beeper->input->event = pwm_beeper_event;
 
+	input_set_capability(beeper->input, EV_SND, SND_TONE | SND_BELL);
 	input_set_drvdata(beeper->input, beeper);
 
 	error = input_register_device(beeper->input);
diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index 54116e5..7b55c97 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -156,12 +156,10 @@ static int sparcspkr_probe(struct device *dev)
 	input_dev->id.product = 0x0001;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = dev;
-
-	input_dev->evbit[0] = BIT_MASK(EV_SND);
-	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
-
 	input_dev->event = state->event;
 
+	input_set_capability(input_dev, EV_SND, SND_BELL | SND_TONE);
+
 	error = input_register_device(input_dev);
 	if (error) {
 		input_free_device(input_dev);
-- 
2.1.4

