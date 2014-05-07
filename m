Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaEGAvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:51:17 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50047 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaEGAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:51:15 -0400
Message-ID: <53698380.1060006@gmail.com>
Date: Tue, 06 May 2014 17:51:12 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH 1/3] devicetree: set bus type same as parent
References: <536982E3.10303@gmail.com>
In-Reply-To: <536982E3.10303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

This is a somewhat scary patch since it touches a path that is central to
device creation based on the device tree.  It should not be applied without
careful consideration.

I am not sure if this patch is a good idea, even if it does not break
anything.

An issue with the path of SPMI nodes under /sys/bus/... was reported in
https://lkml.org/lkml/2014/4/23/312.  The symptom is that two different
grandchild nodes of the spmi with the same node-name@unit-address will
result in attempting to create duplicate links at
/sys/bus/platform/devices/unit-address.node-name.  It turns out that the
specific example provided might not be an expected configuration for
current hardware, but the reported trap remains an issue.

The common pattern exposed is a driver probe function calling
of_platform_populate() to create child devices.  As the reporting
email noted, the devices are created with dev.bus set to
platform_bus_type.  Thus all devices created via this pattern will
result in a link in /sys/bus/platform/devices/, with the risk that
a name collision will occur.

This patch reduces the scope of possible name collisions to devices
on the same bus type.  This is still not ideal, because a legal
device tree source file can result in run time errors.  In the case
of SPMI nodes, the collisions will occur in /bus/spmi/devices/.

I have not investigated whether other drivers would be negatively impacted
by this change - there are 26 drivers in tree that call of_platform_populate().

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 drivers/of/platform.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/of/platform.c
===================================================================
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -217,7 +217,10 @@ static struct platform_device *of_platfo
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	if (!dev->dev.dma_mask)
 		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
-	dev->dev.bus = &platform_bus_type;
+	if (parent && parent->bus)
+		dev->dev.bus = parent->bus;
+	else
+		dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
 	/* We do not fill the DMA ops for platform devices by default.
