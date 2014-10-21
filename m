Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaJUPJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:09:38 -0400
Received: from ring0.de ([5.45.105.125]:54015 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbaJUPHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:07:49 -0400
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
Subject: [RFCv2 4/8] [media] si4713: use managed irq request
Date: Tue, 21 Oct 2014 17:07:03 +0200
Message-Id: <1413904027-16767-5-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the usage of managed irq request to
simplify the code slightly.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/radio/si4713/si4713.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index efc5d6b..ebec16d 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1590,7 +1590,7 @@ static int si4713_probe(struct i2c_client *client,
 	sdev->sd.ctrl_handler = hdl;
 
 	if (client->irq) {
-		rval = request_irq(client->irq,
+		rval = devm_request_irq(&client->dev, client->irq,
 			si4713_handler, IRQF_TRIGGER_FALLING,
 			client->name, sdev);
 		if (rval < 0) {
@@ -1605,14 +1605,11 @@ static int si4713_probe(struct i2c_client *client,
 	rval = si4713_initialize(sdev);
 	if (rval < 0) {
 		v4l2_err(&sdev->sd, "Failed to probe device information.\n");
-		goto free_irq;
+		goto free_ctrls;
 	}
 
 	return 0;
 
-free_irq:
-	if (client->irq)
-		free_irq(client->irq, sdev);
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
 exit:
@@ -1628,9 +1625,6 @@ static int si4713_remove(struct i2c_client *client)
 	if (sdev->power_state)
 		si4713_set_power_state(sdev, POWER_DOWN);
 
-	if (client->irq > 0)
-		free_irq(client->irq, sdev);
-
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
-- 
2.1.1

