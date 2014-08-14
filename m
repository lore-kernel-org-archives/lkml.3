Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaHNGj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:39:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:49812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaHNGjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:39:55 -0400
Message-ID: <1407998386.5490.62.camel@pasglop>
Subject: [RFC PATCH] ipmi/of: Don't use unavailable interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Aug 2014 16:39:46 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an IPMI controller is used by the firmware and as such marked with
a reserved status, we shouldn't use it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Not tested, found by inspection as we are investigating how to plumb
IPMI on one of our future platforms. Our FW uses the device-tree for
its own internal use and tags stuff that it reserves for itself using
the "status" property. This is likely to be the case of our BT interface.

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 5d66568..4fc8931 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2658,6 +2658,9 @@ static int ipmi_probe(struct platform_device *dev)
 	if (!match)
 		return -EINVAL;
 
+	if (!of_device_is_available(np))
+		return -EINVAL;
+
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
 		dev_warn(&dev->dev, PFX "invalid address from OF\n");


