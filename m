Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbaJUPHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:07:49 -0400
Received: from ring0.de ([5.45.105.125]:54001 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbaJUPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:07:46 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [RFCv2 3/8] [media] si4713: use managed memory allocation
Date: Tue, 21 Oct 2014 17:07:02 +0200
Message-Id: <1413904027-16767-4-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the usage of managed memory allocation to
simplify the code slightly.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/radio/si4713/si4713.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index e560a7e..efc5d6b 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1450,7 +1450,7 @@ static int si4713_probe(struct i2c_client *client,
 	struct v4l2_ctrl_handler *hdl;
 	int rval, i;
 
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	sdev = devm_kzalloc(&client->dev, sizeof(*sdev), GFP_KERNEL);
 	if (!sdev) {
 		dev_err(&client->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
@@ -1467,7 +1467,7 @@ static int si4713_probe(struct i2c_client *client,
 	} else {
 		rval = PTR_ERR(sdev->gpio_reset);
 		dev_err(&client->dev, "Failed to request gpio: %d\n", rval);
-		goto free_sdev;
+		goto exit;
 	}
 
 	sdev->vdd = devm_regulator_get_optional(&client->dev, "vdd");
@@ -1615,8 +1615,6 @@ free_irq:
 		free_irq(client->irq, sdev);
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
-free_sdev:
-	kfree(sdev);
 exit:
 	return rval;
 }
@@ -1635,7 +1633,6 @@ static int si4713_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	kfree(sdev);
 
 	return 0;
 }
-- 
2.1.1

